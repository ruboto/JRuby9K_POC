package org.ruboto;

import java.io.IOException;
import org.ruboto.ScriptLoader;

public class RubotoBroadcastReceiver extends android.content.BroadcastReceiver implements org.ruboto.RubotoComponent {
    private final ScriptInfo scriptInfo = new ScriptInfo();

    public ScriptInfo getScriptInfo() {
        return scriptInfo;
    }

    public RubotoBroadcastReceiver() {
        super();
        scriptInfo.setRubyClassName(getClass().getSimpleName());
        if (JRubyAdapter.isInitialized()) {
            ScriptLoader.loadScript(this);
        }
    }

    public void onReceive(android.content.Context context, android.content.Intent intent) {
        try {
            Log.d("onReceive: " + this + " " + ScriptLoader.isCalledFromJRuby());
            if (ScriptLoader.isCalledFromJRuby()) {
                return;
            }
            if (!scriptInfo.isLoaded()) {
                if (JRubyAdapter.setUpJRuby(context)) {
                    ScriptLoader.loadScript(this);
                } else {
                    // FIXME(uwe): What to do if the Ruboto Core platform is missing?
                }
            }

            // FIXME(uwe):  Simplify when we stop support for snake case aliasing interface callback methods.
            if ((Boolean)JRubyAdapter.runScriptlet(scriptInfo.getRubyClassName() + ".instance_methods(false).any?{|m| m.to_sym == :onReceive}")) {
                Log.d("onReceive: call method");
    	        JRubyAdapter.runRubyMethod(this, "onReceive", new Object[]{context, intent});
            } else if ((Boolean)JRubyAdapter.runScriptlet(scriptInfo.getRubyClassName() + ".instance_methods(false).any?{|m| m.to_sym == :on_receive}")) {
    	        JRubyAdapter.runRubyMethod(this, "on_receive", new Object[]{context, intent});
            }
            // EMXIF
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

}
