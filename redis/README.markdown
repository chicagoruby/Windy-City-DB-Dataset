# WindyCityDB Dataset Redis

## Redis Install

    # Download/install latest redis stable
    $ curl -O http://redis.googlecode.com/files/redis-1.2.6.tar.gz
    $ tar zxvf redis-1.2.6.tar.gz
    $ cd redis-1.2.6
    $ make
    $ cp ./redis-server ./redis-cli /usr/local/bin
    $ cp ./redis-server ./redis.conf /usr/local/etc
    
    # start the server server
    $ /usr/local/bin/redis /usr/local/etc/redis.conf
    
By default redis will create it's on-disk dump file in the current working directory. Dump files are used to persist data across <tt>redis-server</tt> restarts. To change the location of redis on-disk dump file edit <tt>redis.conf</tt> like so:

    dir /path/to/store/dumpfiles

## Redis Usage

### Basic Usage

    # try getting "test" key
    $ redis-cli GET test
    (nil)
    
    # set "test" key with value "lorem ipsum"
    $ redis-cli test "lorem ipsum"
    
    # get value of "test" key
    $ redis-cli test
    lorem ipsum
    
    # try get list "test_list"
    $ redis-cli test_list
    (nil)
    
    # seed list "test_list"
    # push "2" on to the tail of the list
    $ redis-cli RPUSH 2
    # push "1" on to the head of the list
    $ redis-cli LPUSH 1
    
    # get all of list "test_list"
    $ redis-cli LRANGE test_list 0 1
    1. 1
    2. 2
    

### One way to store an object

    # get unique id for object
    $ redis-cli INCR people:uid:next
    1
    
    # store person object
    # key in format of: [COLLECTION]:[UID]:[ATTRIBUTE]
    $ redis-cli SET people:1:first_name Ryan
    $ redis-cli SET people:1:last_name Briones
    $ redis-cli SET people:1:website "http://ryanbriones.com"
    
    # or more consisely in Redis >1.1
    $ redis-cli MSET people:1:first_name Ryan people:1:last_name Briones people:1:website "http://ryanbriones.com"
    
    # store collection of all people to iterate over later
    # stored as a set since uid should be unique
    $ redis-cli SADD people 1
    
    # is there a person with the uid of X?
    $ redis-cli SISMEMBER people 1
    1
    
    $ redis-cli SISMEMBER people 999
    0
    
    # find all attributes stored for person with uid of 1
    $ redis-cli KEYS "people:1:*"
    
    # give a person 1 some friends
    $ redis-cli SADD people:1:friends 777
    $ redis-cli SADD people:1:friends 888
    $ redis-cli SADD people:1:friends 999
    
    # get all of person 1's friends; sets are not ordered
    $ redis-cli SMEMBERS people:1:friends
    1. 999
    2. 888
    3. 777
    
    # have a running index of friends ordered by when they were added
    # using a sorted set; redis >1.1
    $ redis-cli ZADD people:1:friends_sorted_by_date 1277480602 777
    $ redis-cli ZADD people:1:friends_sorted_by_date 1277480658 888
    $ redis-cli ZADD people:1:friends_sorted_by_date 1277480669 999
    
    # get list of time sorted friends
    $ redis-cli ZRANGE people:1:friends_sorted_by_date 0 -1
    1. 777
    2. 888
    3. 999
    
    # get list of time sorted friends by most recently added
    $ redis-cli SORT people:1:friends_sorted_by_date DESC
    1. 999
    2. 888
    3. 777
    