puts 'Loading environment.rb'
$verbose = true
$DEBUG = true
PROGRAM_START_TIME = Time.now unless defined? PROGRAM_START_TIME
PROJECT_DIR = File.expand_path(File.dirname(__FILE__))
puts "PROJECT_DIR is #{PROJECT_DIR.inspect}"
SRC_DIR = PROJECT_DIR
