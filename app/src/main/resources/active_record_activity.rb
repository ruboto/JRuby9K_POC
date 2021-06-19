require 'ruboto/stack'
require 'ruboto/toast'
require 'ruboto/widget'

ruboto_import_widgets :Button, :CheckedTextView, :EditText, :ImageView, :LinearLayout, :ListView, :TextView

class ActiveRecordActivity
  def onCreate(savedInstanceState)
    super
    self.content_view =
        linear_layout do
          linear_layout(orientation: :vertical, layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent}) do
            @setup_button = button text: 'Setup DB',
                layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent},
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36],
                on_click_listener: -> field { setup_simple_db }
            @inc_btn = button text: 'Increment',
                layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent},
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 32],
                on_click_listener: -> field { increment_counter },
                enabled: false
          end
          linear_layout(orientation: :vertical, layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent}) do
            text_view text: 'Value:', text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36]
            @value_field = edit_text layout: {:width= => :fill_parent},
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36],
                enabled: false
          end
        end
  end

  def onResume
    super
    if defined?(Counter)
      disable_setup
      enable_increment
    end
  end

  private

  def setup_simple_db
    disable_setup
    Thread.start do
      require 'setup_active_record_sqlite'
      runOnUiThread do
        toast 'Database setup OK'
        enable_increment
      end
    rescue => e
      message = "Exception setting up simple ActiveRecord: #{e}"
      puts message
      puts e.backtrace.join("\n")
      runOnUiThread do
        toast message
      end
    end
  end

  def increment_counter
    puts 'Increment'
    counter = Counter.first_or_create!(value: 0)
    value = @value_field.text.to_s.to_i
    value += 1
    counter.update! value: value
    @value_field.text = value.to_s
  end

  def disable_setup
    @setup_button.enabled = false
    @value_field.text = 'Loading...'
  end

  def enable_increment
    counter = Counter.first_or_create!(value: 0)
    @value_field.text = counter.value.to_s
    @value_field.enabled = true
    @inc_btn.enabled = true
  end
end
