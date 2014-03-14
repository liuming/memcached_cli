require "thor"
require 'dalli'
require_relative "memcached_cli/version"

module MemcachedCli
  class Commands < Thor
    MEMCACHED_COMMANDS = [
      :add, :append, :cas, :decr, :delete, :flush, :flush_all, :get, :get_multi,
      :incr, :prepend, :replace, :reset_stats, :set, :stats, :touch, :version
    ]

    CLIENT = Dalli::Client.new

    MEMCACHED_COMMANDS.each do |command|
      params = Dalli::Client.instance_method(command).parameters
      desc command.to_s, params.reduce([]){|s, (required,name)| s << (required == :req ? name : "[#{name.to_s}]").to_s}.join(' ')
      define_method command do |*params|
        puts CLIENT.send(command, *params)
      end
    end
  end
end
