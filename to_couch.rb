require 'rubygems'
require 'couchrest'

# note: this might require Ruby 1.9 (or you might need to supply the Array#each_slice function, which should be simple to implement if your ruby doesn't have it)

# hacked up in about 10 minutes by Chris Anderson - @jchris


DB = CouchRest::database!("windy-city")
SLICE_SIZE = 1000

["users", "posts", "answers", "comments"].each do |set|
  puts "loading #{set} into ruby"
  file = open(File.join(File.dirname(__FILE__), "data", "#{set}.json")).read
  items = JSON.parse(file)[set].map do |item|
    item["type"] = set
    item
  end
  puts "loading #{set} into CouchDB -- #{items.length} documents in slices of #{SLICE_SIZE}"
  items.each_slice(SLICE_SIZE) do |slice|
    DB.bulk_save(slice)
    putc "."
  end
  puts "done with #{set}"
end

