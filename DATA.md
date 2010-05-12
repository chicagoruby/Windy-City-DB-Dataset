#Data from Stack Overflow#

The dataset consists of all posts in Stack Overflow with the tag 'nosql'.  It has been selected and re-formatted into four files called

*posts
*answers
*comments
*users

in either JSON or XML format.

This data is CC licensed but if you want to use it for anything else please note [use instructions](http://blog.stackoverflow.com/2009/06/stack-overflow-creative-commons-data-dump/) from Stack Overflow.

Posts can be viewed in their origin form with this URL format:   http://stackoverflow.com/questions/2794736   

Each post may have zero or many answers.
Each post and each answer may have zero or many comments.
Each post, answer, and comment has a user ID that may be looked up to find the user's display name.

Text data is HTML-escaped.

#Data Load Scripts#

Please provide a script to load this data into your database.

The script may be in any open-source language you like but please specify anything we need to know to run it.  You may assume that we will install the most recent standard version of the language and nothing else, so let us know if we need to install libraries or anything else.  For example, if you provide a Ruby script we need to know something like "Tested in version 1.8.7, install Nokogiri gem".

Feel free to re-arrange the data in any way you like that shows off the capabilities of your data base.  Please retain the various ID fields in the data even if you don't need them to define the relationships of the data.  That will make it easier for attendees to understand the data and compare it in the other databases and to its original form on Stack Overflow.

##Questions##

E-mail Ginny Hendry at ( contact [at] ghendry [dot] com ) if you have any questions.
