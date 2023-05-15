require 'ruboto/toast'
require 'ruboto/widget'

ruboto_import_widgets :Button, :CheckedTextView, :EditText, :ImageView, :LinearLayout, :ListView, :TextView

class AutoloadActivity
  def onCreate(savedInstanceState)
    super
    self.content_view =
        linear_layout do
          @button = button text: "Autoload\n(click me)",
              layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent},
              text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36],
              on_click_listener: -> field { test_autoload }
        end
  end

  private

  def test_autoload
    require "zeitwerk"
    loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
    %w[activerecord-jdbc-adapter.rb activerecord-time activerecord-time.rb concurrent_ruby_ext.jar.rb META-INF rails-observers.rb].each do |file|
      puts "ignore #{file}"
      loader.ignore("#{__dir__}/#{file}")
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
  end

end
