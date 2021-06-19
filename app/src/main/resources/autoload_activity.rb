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
    puts 'Testing autoload'

    require 'active_support/dependencies'

    ActiveSupport::Dependencies.autoload_paths << SRC_DIR
    # ActiveSupport::Dependencies.autoload_paths << APK_PATH

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

end
