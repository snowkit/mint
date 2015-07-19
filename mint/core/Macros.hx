package mint.core;

import haxe.macro.Context;
import haxe.macro.Expr;

class Macros {

    macro public static function def(value:Expr, def:Expr):Expr {
        return macro @:pos(Context.currentPos()) {
            if($value == null) $value = $def;
            $value;
        }
    }

    macro public static function assert(expr:Expr, ?reason:String='') {
        #if !mint_no_assertions
            var str = haxe.macro.ExprTools.toString(expr);
                if(reason != '') str += ' ($reason)';
            return macro @:pos(Context.currentPos()) {
                if(!$expr) throw luxe.Log.DebugError.assertion('$str');
            }
        #end
        return macro null;
    } //assert


    macro public static function assertnull(value:Expr, ?reason:String='') {
        #if !mint_no_assertions
            var str = haxe.macro.ExprTools.toString(value);
            if(reason != '') reason = ' ($reason)';
            return macro @:pos(Context.currentPos()) {
                if($value == null) throw luxe.Log.DebugError.null_assertion('$str was null$reason');
            }
        #end
        return macro null;
    } //assert

} //Macros