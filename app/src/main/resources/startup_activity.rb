require 'ruboto/activity'
require 'ruboto/stack'
require 'ruboto/toast'

class StartupActivity
  def onCreate(savedInstanceState)
    super
    setContentView(R.layout.activity_startup)
    findViewById(R.id.autoload_btn).on_click_listener = -> view {test_autoload}
    findViewById(R.id.for_loop_btn).on_click_listener = -> view {test_for_loop}
    findViewById(R.id.json_btn).on_click_listener = -> view {start_ruboto_activity('JsonActivity') }
    findViewById(R.id.json_pure_btn).on_click_listener = -> view {require 'json/pure' ; start_ruboto_activity('JsonActivity') }
    findViewById(R.id.ar_btn).on_click_listener = -> view {start_ruboto_activity('ActiveRecordActivity') }
  end

  def onResume
    super
    Thread.start do
      sleep(1)
      runOnUiThread do
        title_field = findViewById(R.id.title)
        puts %{title_field: #{title_field.text}}
        title_field.text = 'Hello Ruby World!'
        puts %{title_field: #{title_field.text}}
      end
    end
    puts "Thread started."
  end

  private

  def test_autoload
    puts 'Testing autoload'

    require 'active_support/dependencies'
    java.lang.RuntimeException.class_eval { include ActiveSupport::Dependencies::Blamable }

    puts "Class path: #{$CLASSPATH.inspect}"
    puts "Auto load path: #{ActiveSupport::Dependencies.autoload_paths.inspect}"

    ActiveSupport::Dependencies.autoload_paths << SRC_DIR

    puts "Auto load path: #{ActiveSupport::Dependencies.autoload_paths.inspect}"
    puts "Class path: #{$CLASSPATH.inspect}"

    # require 'autoloaded_class'

    AutoloadedClass.new.perform
    toast 'Autoload OK'
  rescue => e
    msg = "Exception testing autload: #{e}"
    puts e.class
    puts e.message
    puts msg
    puts e.backtrace.join("\n")
    toast msg
  end

  def test_for_loop
    puts 'Testing for loop'
    for i in [1,2,3]
      puts "i: #{i.inspect}"
      raise "Element not set: #{i.inspect}" unless i
    end
    toast 'For loop is OK!'
  rescue => e
    msg = "Exception testing for loop: #{e}"
    puts msg
    toast msg, Java::android.widget.Toast::LENGTH_LONG
  end
end
