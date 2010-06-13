-------------------------------
 WindyCityDB Lab Info for Riak
-------------------------------

--------------
 INSTALLATION
--------------

Installation for OS/X is simple using the prebuilt packages here:

(64-bit) http://downloads.basho.com/riak/riak-0.11/riak-0.11.0-osx-x86_64.tar.gz
(32-bit) http://downloads.basho.com/riak/riak-0.11/riak-0.11.0-osx-i386.tar.gz

1. Download and unpack the tarball.

2. Edit the etc/app.config file, changing references to "127.0.0.1" to
   "0.0.0.0". This will force Riak to bind to all network interfaces.

3. Run "bin/riak start" to start up the Riak node.

Riak shines best when run in a clustered environment on multiple
physical hosts.  If this configuration is possible, follow these
instructions:

1. If you started the Riak node in the previous steps, stop it with
   "bin/riak stop".

2. Edit the etc/vm.args file, changing the name of "riak@127.0.0.1"
   to include the IP of the public interface on the machine. This name
   must be unique across the cluster. Example:
  
     -name riak@10.1.5.37

3. Configure other nodes similarly from the tarball, using their
   public IP addresses in etc/vm.args.

4. Join the other nodes to the first one using the "bin/riak-admin
   join" command.  Example:

     $ bin/riak-admin join riak@10.1.5.37
     Sent join request to 'riak@10.1.5.37'.

More detailed information is available on the wiki:
http://wiki.basho.com/

------------------
 CLIENT LIBRARIES
------------------

Riak has an HTTP interface that is well-documented on this wiki page:
http://wiki.basho.com/display/RIAK/REST+API -- As a result, any
language with an HTTP client can access Riak and perform operations on
it.

Many of our new users favor dynamic languages, so the Ruby, Python,
and Javascript libraries are popular. Installation instructions are below:

Ruby (http://github.com/seancribbs/ripple)

  $ gem install riak-client

Python (http://bitbucket.org/basho/riak-python-client)

  $ python setup.py install

Javascript (http://bitbucket.org/basho/riak-javascript-client) 
[no installation]

For other client libraries see:

  http://wiki.basho.com/display/RIAK/Client+Libraries
  http://wiki.basho.com/display/RIAK/Community-Developed+Libraries+and+Projects

--------------
 LOADING DATA
--------------

After installing the `riak-client`, `yajl`, and `curb` RubyGems, run
the included Ruby script.  It assumes that you will be connecting to
Riak on the same host (localhost/127.0.0.1).  For best performance,
use Ruby 1.9.

  $ ruby load_data.rb

This will be followed by a lot of output about what's being written
into Riak.

(Tested on Ruby 1.9.1 / Mac OS/X 10.6)
