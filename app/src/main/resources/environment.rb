puts 'Loading environment.rb'
$verbose = true
$DEBUG = true
PROGRAM_START_TIME = Time.now unless defined? PROGRAM_START_TIME
PROJECT_DIR = File.expand_path(File.dirname(__FILE__))
puts "PROJECT_DIR is #{PROJECT_DIR.inspect}"
SRC_DIR = PROJECT_DIR
puts "APK_PATH: #{APK_PATH.inspect}"

module DirGlobPatch
  def [](*patterns, **opts)
    super(*patterns.map{|pattern| pattern.sub('uri:classloader:', APK_PATH)}, **opts)
  end
end

Dir.singleton_class.prepend DirGlobPatch
