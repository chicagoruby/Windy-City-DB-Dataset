require 'rubygems'
require 'yajl'

gem 'redis', '=1.0.7'
require 'redis'

redis = Redis.new

users = Yajl::Parser.parse(File.read(File.expand_path(File.dirname(__FILE__) + '/../data/users.json')))
users["users"].each do |user|
  id = user["Id"]
  redis.set("users:#{id}:DisplayName", user["DisplayName"])
  redis.sadd("users", id)
end

posts = Yajl::Parser.parse(File.read(File.expand_path(File.dirname(__FILE__) + '/../data/posts.json')))
posts["posts"].each do |post|
  id = post["Id"]
  
  redis.set("posts:#{id}:Body", post["Body"])
  redis.set("posts:#{id}:CreationDate", post["CreationDate"])
  redis.set("posts:#{id}:OwnerUserId", post["OwnerUserId"])
  post["Tags"].each do |tag|
    redis.sadd("posts:#{id}:Tags", tag)
    redis.sadd("tags:#{tag}", id)
    redis.sadd("tags", tag)
  end
  
  redis.sadd("user:#{post["OwnerUserId"]}:Posts", id)
  redis.sadd("posts", id)
end

answers = Yajl::Parser.parse(File.read(File.expand_path(File.dirname(__FILE__) + '/../data/answers.json')))
answers["answers"].each do |answer|
  id = answer["Id"]
  
  redis.set("posts:#{id}:Body", answer["Body"])
  redis.set("posts:#{id}:CreationDate", answer["CreationDate"])
  redis.set("posts:#{id}:OwnerUserId", answer["OwnerUserId"])
  redis.set("posts:#{id}:ParentId", answer["ParentId"])
  answer["Tags"].each do |tag|
    redis.sadd("posts:#{id}:Tags", tag)
    redis.sadd("tags:#{tag}", id)
    redis.sadd("tags", tag)
  end

  redis.sadd("users:#{answer["OwnerUserId"]}:Answers", id)
  redis.sadd("posts:#{answer["ParentId"]}:Answers", id)
  redis.sadd("answers", id)
end

comments = Yajl::Parser.parse(File.read(File.expand_path(File.dirname(__FILE__) + '/../data/comments.json')))
comments["comments"].each do |comment|
  id = comment["Id"]
  
  redis.set("posts:#{id}:Body", comment["Body"])
  redis.set("posts:#{id}:CreationDate", comment["CreationDate"])
  redis.set("posts:#{id}:UserId", comment["UserId"])
  redis.set("posts:#{id}:PostId", comment["PostId"])

  redis.sadd("users:#{comment["UserId"]}:Comments", id)
  redis.sadd("posts:#{comment["PostId"]}:Comments", id)
  redis.sadd("comments", id)
end