require "thor"
require 'dalli'
require_relative "memcached_cli/version"

module MemcachedCli
  class Commands < ::Thor
    class_option :servers, type: :string

    CLIENT = Dalli::Client.new

    [
      :add, :append, :decr, :delete, :flush, :flush_all, :get, :get_multi,
      :incr, :prepend, :replace, :reset_stats, :set, :stats, :touch, :version
    ].each do |command|
      params = Dalli::Client.instance_method(command).parameters.reject{|(required,name)| name == :options}
      desc command.to_s, params.reduce([]){|s, (required,name)| s << (required == :req ? name : "[#{name.to_s}]").to_s}.join(' ')
      define_method command do |*params|
        puts CLIENT.send(command, *params)
      end
    end
  end
end
