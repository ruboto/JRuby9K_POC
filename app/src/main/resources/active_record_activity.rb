require 'ruboto/widget'

ruboto_import_widgets :Button, :CheckedTextView, :EditText, :ImageView, :LinearLayout, :ListView, :TextView

java_import android.content.Intent
java_import android.view.KeyEvent

class ActiveRecordActivity
  def onCreate(savedInstanceState)
    super
    self.content_view =
        linear_layout do
          linear_layout(orientation: :vertical, layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent}) do
            @button = button text: 'Setup',
                layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent},
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36],
                on_click_listener: -> field { setup_db }
            @inc_btn = button text: 'Increment',
                layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent},
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 32],
                on_click_listener: -> field { increment_counter }
          end
          linear_layout(orientation: :vertical, layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent}) do
            text_view text: 'Value:', text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36]
            @source_field = edit_text layout: {:width= => :fill_parent},
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36]
          end
        end
  end

  private

  def setup_db
    require 'setup_active_record_sqlite'
  end

  def increment_counter
    puts "Not implemented, yet."
  end
end
