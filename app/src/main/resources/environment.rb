puts 'environment.rb'
$verbose = true
$DEBUG = true
PROGRAM_START_TIME = Time.now unless defined? PROGRAM_START_TIME

require 'ruboto/stack'

puts "Requiring active_support after #{Time.now - PROGRAM_START_TIME}s"
with_large_stack(:name => 'load active support'){require 'active_support'}

puts "Requiring active_support/dependencies after #{Time.now - PROGRAM_START_TIME}s"
require 'active_support/dependencies'
puts "Required  active_support/dependencies after #{Time.now - PROGRAM_START_TIME}s OK"

puts 'Make Blamable'
java.lang.RuntimeException.class_eval { include ActiveSupport::Dependencies::Blamable }
