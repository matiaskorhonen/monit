Monit Rubygem
=============

A Ruby interface for Monit.

## Installation

Just like any other gem:

    gem install monit

## Usage

    status = Monit::Status.new({ :host => "monit.myserver.com", 
                                 :auth => true, 
                                 :username => "foo", 
                                 :password => "bar" })
    status.get              # => true
    status.platform         # => <Monit::Platform:0x00000003673dd0 ... >
    status.platform.cpu     # => 2
    status.platform.memory  # => 4057712

For more options see the API documentation

## Compatibility and Build Status

[![Build Status](https://secure.travis-ci.org/k33l0r/monit.png)](http://travis-ci.org/k33l0r/monit)

The gem is only compatible with Ruby 1.8.7 and above, including JRuby 1.6+.
For the build status, check [Travis CI][travis].

[travis]: http://travis-ci.org/k33l0r/monit

## License and copyright

Copyright (c) 2010 - 2012 Matias Korhonen & contributors

Licensed under the MIT license, see the LICENSE file for details.
