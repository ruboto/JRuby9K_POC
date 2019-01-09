require 'ruboto/activity'

class StartupActivity
  def onCreate(savedInstanceState)
    super
    setContentView(R.layout.activity_startup)
    findViewById(R.id.json_btn).on_click_listener = -> view do
      begin
        puts 'listen'
        start_ruboto_activity('JsonActivity')
      rescue => e
        puts "Exception in listener: #{e}"
        puts e.backtrace.join("\n")
      end
    end
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
end
