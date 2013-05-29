require 'librarian'
require 'fileutils'

class File
  class << self
    alias_method :original_join, :join
  end

  def self.join(*args)
    new_args = args.collect { |questionableEncoding|
      join_encoding_fix(questionableEncoding)
    }
    self.send(:original_join, new_args)
  end

  def self.join_encoding_fix(value)
    if (value.instance_of?(String))
      value = value.encode("UTF-8")
    elsif (value.instance_of?(Array))
      value = value.collect { |subValue|
        join_encoding_fix(subValue)
      }
    end
    value
  end
end

begin
  require 'puppet'
rescue LoadError
  $stderr.puts <<-EOF
Unable to load puppet. Either install it using native packages for your
platform (eg .deb, .rpm, .dmg, etc) or as a gem (gem install puppet).
EOF
  exit 1
end

require 'librarian/puppet/extension'
require 'librarian/puppet/version'

require 'librarian/action/install'

module Librarian
  module Puppet
  end
end
