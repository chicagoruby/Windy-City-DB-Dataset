require 'rubygems'
require 'couchrest'

# note: this might require Ruby 1.9 (or you might need to supply the Array#each_slice function, which should be simple to implement if your ruby doesn't have it)

# hacked up in about 10 minutes by Chris Anderson - @jchris
# correction it took me more like 30 once I added the comments and denormalized the usernames.
# but I'm slow at git so it actually took longer. that's life.

DB = CouchRest::database!("windy-city")

puts "loading users into Ruby"

users = JSON.parse(open(File.join(File.dirname(__FILE__), "data", "users.json")).read)["users"]
user_map = {}
users.each do |u|
  user_map[u["Id"]] = u
end

["posts", "answers", "comments"].each do |set|
  puts "loading #{set} into ruby"
  file = open(File.join(File.dirname(__FILE__), "data", "#{set}.json")).read
  items = JSON.parse(file)[set].map do |item|
    item["type"] = set
    if set == "comments"
      item["user"] = user_map[item["UserId"]]
    else
      item["user"] = user_map[item["OwnerUserId"]]
    end
    item
  end
  puts "loading #{set} into CouchDB -- #{items.length} documents"
  DB.bulk_save(items)
  puts "done with #{set}"
end

