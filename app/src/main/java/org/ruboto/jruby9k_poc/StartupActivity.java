package org.ruboto.jruby9k_poc;

import android.app.Activity;
import android.os.Bundle;

import org.ruboto.JRubyAdapter;

public class StartupActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_startup);
    }

    @Override
    protected void onResume() {
        super.onResume();
        new Thread() {
            public void run() {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                StartupActivity.this.runOnUiThread(
                        new Runnable() {
                            @Override
                            public void run() {
                                final boolean jrubyOk = JRubyAdapter.setUpJRuby(StartupActivity.this);
                                JRubyAdapter.runScriptlet("puts 'Hello, world!'");
                                JRubyAdapter.put("jrubyOk", jrubyOk);
                                JRubyAdapter.runScriptlet("puts %{jrubyOk: #{jrubyOk}}");
                                JRubyAdapter.put("title_field", findViewById(R.id.title));
                                JRubyAdapter.runScriptlet("puts %{title_field: #{title_field.text}}");
                                JRubyAdapter.put("title_field", findViewById(R.id.title));
                                JRubyAdapter.runScriptlet("title_field.text = 'Hello Ruby World!'");
                                JRubyAdapter.put("title_field", findViewById(R.id.title));
                                JRubyAdapter.runScriptlet("puts %{title_field: #{title_field.text}}");
                            }
                        }
                );
            }
        }.start();
        System.out.println("Thread started.");
    }
}
