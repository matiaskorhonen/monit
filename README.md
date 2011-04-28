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

## Compatibility

At the moment the gem is only compatible with Ruby 1.9.2.

## License and copyright

Copyright (c) 2010 - 2011 Matias Korhonen

Licensed under the MIT license, see the LICENSE file for details.
