require 'ruboto/widget'

ruboto_import_widgets :Button, :CheckedTextView, :EditText, :ImageView, :LinearLayout, :ListView, :TextView

java_import android.content.Intent
java_import android.view.KeyEvent

class JsonActivity
  def onCreate(savedInstanceState)
    super
    self.content_view =
        linear_layout do
          @button = button :text => 'Generate',
              layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent},
              text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36],
              on_click_listener: -> { convert_ruby_to_json }
          linear_layout(orientation: :vertical, layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent}) do
            text_view text: 'Ruby:', text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36]
            @source_field = edit_text layout: {:width= => :fill_parent}, text: '[{A: 42}]',
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36]
            text_view text: 'JSON:', text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36]
            @json_field = edit_text layout: {:width= => :fill_parent},
                transformation_method: android.text.method.PasswordTransformationMethod.instance,
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36]
          end
        end
  end

  private

  def convert_ruby_to_json
    puts "Convert '#{@source_field.text}' to JSON"
    @json_field.text = JSON.dump(eval(@source_field.text))
  end
end
