require "thor"
require 'dalli'
require_relative "memcached_cli/version"

module MemcachedCli
  class Commands < Thor
    MEMCACHED_COMMANDS = [ ]

    CLIENT = Dalli::Client.new

    Dalli::Client.instance_methods(false).each do |command|
      params = Dalli::Client.instance_method(command).parameters
      desc command.to_s, params.reduce([]){|s, (required,name)| s << (required == :req ? name : "[#{name.to_s}]").to_s}.join(' ')
      define_method command do |*params|
        puts CLIENT.send(command, *params)
      end
    end
  end
end
