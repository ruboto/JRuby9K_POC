require 'ruboto/package'

class StartupActivity
  def onCreate(savedInstanceState)
    super
    setContentView($package.R.layout.activity_startup)
  end

  def onResume
    super
    Thread.start do
      sleep(1)
      runOnUiThread do
        title_field = findViewById($package.R.id.title)
        puts %{title_field: #{title_field.text}}
        title_field.text = 'Hello Ruby World!'
        puts %{title_field: #{title_field.text}}
      end
    end
    puts "Thread started."
  end
end
