require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :CheckedTextView, :EditText, :ImageView, :LinearLayout, :ListView, :TextView

java_import android.content.Intent
java_import android.view.KeyEvent

class ActiveRecordActivity
  def onCreate(savedInstanceState)
    super
    self.content_view =
        linear_layout do
          linear_layout(orientation: :vertical, layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent}) do
            @setup_button = button text: 'Setup simple',
                layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent},
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 36],
                on_click_listener: -> field { setup_simple_db }
            @setup_adv_btn = button text: 'Setup advanced',
                layout: {:weight= => 2, :height= => :fill_parent, :width= => :fill_parent},
                text_size: [android.util.TypedValue::COMPLEX_UNIT_DIP, 32],
                on_click_listener: -> field { setup_advanced_db }
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
        toast 'Simple setup OK'
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


  def setup_advanced_db
    require 'setup_active_record_sqlite_advanced'
  rescue => e
    message = "Exception setting up advanced ActiveRecord: #{e}"
    puts message
    puts e.backtrace.join("\n")
    toast message
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
    @setup_adv_btn.enabled = false
    @value_field.text = 'Loading...'
  end

  def enable_increment
    counter = Counter.first_or_create!(value: 0)
    @value_field.text = counter.value.to_s
    @value_field.enabled = true
    @inc_btn.enabled = true
  end
end
