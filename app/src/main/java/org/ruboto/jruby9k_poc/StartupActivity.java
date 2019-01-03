package org.ruboto.jruby9k_poc;

import android.app.Activity;
import android.os.Bundle;

import org.jruby.util.cli.Options;
import org.ruboto.JRubyAdapter;

import java.util.Properties;

public class StartupActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_startup);
    }

    @Override
    protected void onResume() {
        super.onResume();
        System.out.println("Options.COMPILE_INVOKEDYNAMIC.load(): " + Options.COMPILE_INVOKEDYNAMIC.load());
        System.getProperties().setProperty("sun.arch.data.model", "64");
        System.out.println("System#getProperty(\"sun.arch.data.model\"): " + System.getProperty("sun.arch.data.model"));
        System.out.println("Integer.getInteger(\"sun.arch.data.model\"): " + Integer.getInteger("sun.arch.data.model"));
        final boolean jrubyOk = JRubyAdapter.setUpJRuby(StartupActivity.this);
        JRubyAdapter.runScriptlet("puts 'Hello, world!'");
    }
}
