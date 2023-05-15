module Autoloading
  def test_autoload
    require "zeitwerk"
    loader = Zeitwerk::Registry.loader_for_gem(APK_PATH + '/autoloading.rb', namespace: Object, warn_on_extra_files: false)
    %w[activerecord-jdbc-adapter.rb activerecord-time activerecord-time.rb
       concurrent_ruby_ext.jar.rb concurrent/atomic_reference/jruby+truffle.rb META-INF
       rails-observers.rb
    ].each do |file|
      puts "ignore #{file}"
      loader.ignore("#{APK_PATH}/#{file}")
    end
    loader.setup
    toast 'Autoload class...'
    AutoloadedClass.new.perform
    toast 'Autoload OK'
  rescue => e
    msg = "Exception testing autload: #{e}"
    puts msg
    puts "#{e.class}: #{e.message}"
    puts e.backtrace.join("\n")
    toast msg
  ensure
    loader&.unload
  end
end
