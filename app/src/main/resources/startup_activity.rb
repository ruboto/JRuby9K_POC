require 'ruboto/activity'
require 'ruboto/util/toast'

class StartupActivity
  def onCreate(savedInstanceState)
    super
    setContentView(R.layout.activity_startup)
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

  def test_for_loop
    puts 'Testing for loop'
    for e in [1,2,3]
      p e
      raise "Element not set: #{e.inspect}" unless e
    end
  rescue => e
    msg = "Exception testing for loop: #{e}"
    puts msg
    toast msg
  end
end
