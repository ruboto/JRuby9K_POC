require 'ruboto/toast'
require 'ruboto/widget'
require 'autoloading'

ruboto_import_widgets :Button, :CheckedTextView, :EditText, :ImageView, :LinearLayout, :ListView, :TextView

class AutoloadActivity
  include Autoloading

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
end
