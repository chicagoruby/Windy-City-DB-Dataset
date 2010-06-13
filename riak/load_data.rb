require 'rubygems'
require 'yajl'
require 'riak'

ActiveSupport::JSON.backend = 'Yajl'

client = Riak::Client.new
 
types = [:answers,:comments,:posts,:users]
@buckets = {}
links = {}
types.each do |type|
  @buckets[type] = client.bucket(type.to_s, :keys => false)
  links[type] = Hash.new {|h,k| h[k] = [] }
end
@buckets[:answers] = @buckets[:posts]

# Load the most dependent stuff first so you can link back later:
# 1) comments
# 2) answers
# 3) posts
# 4) users
def load_data_for(type)
  puts "Loading the #{type} from #{type}.json. This may take a while!"
  raw_data = Yajl::Parser.parse(File.read(File.join("..","data","#{type}.json")))
  bucket = @buckets[type]
  raw_data[type.to_s].each do |item|
    id = item['Id']
    object = bucket.new(id)
    object.data = item
    yield object, item if block_given?
    object.store(:w => 1, :returnbody => false)
    print "."; $stdout.flush
  end
  puts  
end

load_data_for(:comments) do |obj, json|
  user, post = json['UserId'], json['PostId']
  obj.links << Riak::Link.new("/riak/users/#{user}","user")
  obj.links << Riak::Link.new("/riak/posts/#{post}","post")
  links[:users][user] << obj.to_link('comment')
  links[:posts][post] << obj.to_link('comment')
end

load_data_for(:answers) do |obj, json|
  user, post = json['OwnerUserId'], json['ParentId']
  obj.links << Riak::Link.new("/riak/users/#{user}","owner") unless user.blank?
  obj.links << Riak::Link.new("/riak/posts/#{post}","parent")
  obj.links.merge(links[:posts][obj.key])
  links[:users][user] << obj.to_link('answer')
  links[:posts][post] << obj.to_link('answer')
end

load_data_for(:posts) do |obj, json|
  user = json['UserId']
  obj.links << Riak::Link.new("/riak/users/#{user}","owner") unless user.blank?
  obj.links.merge(links[:posts][obj.key])
  links[:users][user] << obj.to_link('question')
end

load_data_for(:users) do |obj, json|
  obj.links.merge(links[:users][obj.key])
end
