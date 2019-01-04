package org.jruby.runtime.scopes;

import org.jruby.parser.StaticScope;
import org.jruby.runtime.DynamicScope;
import org.jruby.runtime.builtin.IRubyObject;

public class DynamicScope0 extends DynamicScope {
    public DynamicScope0(StaticScope var1, DynamicScope var2) {
        super(var1, var2);
    }

    private static RuntimeException sizeError() {
        return new RuntimeException("org.jruby.runtime.scopes.DynamicScope0 only supports scopes with 0 variables");
    }

    public IRubyObject getValue(int var1, int var2) {
        if (var2 == 0) {
            throw sizeError();
        } else {
            return this.parent.getValue(var1, var2 - 1);
        }
    }

    public IRubyObject getValueDepthZero(int var1) {
        throw sizeError();
    }
    public IRubyObject getValueEightDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueEightDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueFiveDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueFiveDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueFourDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueFourDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueNineDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueNineDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueOneDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueOneDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueSevenDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueSevenDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueSixDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueSixDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueThreeDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueThreeDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueTwoDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueTwoDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject getValueZeroDepthZero() {
        throw sizeError();
    }
    public IRubyObject getValueZeroDepthZeroOrNil(IRubyObject var1) {
        throw sizeError();
    }
    public IRubyObject setValueDepthZero(IRubyObject var1, int var2) {
        throw sizeError();
    }
    public void setValueEightDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueFiveDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueFourDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueNineDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueOneDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueSevenDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueSixDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueThreeDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueTwoDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
    public void setValueVoid(IRubyObject var1, int var2, int var3) { if (var3 == 0) { throw sizeError(); } }
    public void setValueZeroDepthZeroVoid(IRubyObject var1) { throw sizeError(); }
}
