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

    macro public static function assert(expr:Expr, ?reason:ExprOf<String>) {
        #if !luxe_no_assertions
            var str = haxe.macro.ExprTools.toString(expr);

            reason = switch(reason) {
                case macro null: macro '';
                case _: macro ' ( ' + $reason + ' )';
            }

            return macro @:pos(Context.currentPos()) {
                if(!$expr) throw mint.core.Macros.DebugError.assertion( '$str' + $reason);
            }
        #end
        return macro null;
    } //assert

    macro public static function assertnull(value:Expr, ?reason:ExprOf<String>) {
        #if !luxe_no_assertions
            var str = haxe.macro.ExprTools.toString(value);

            reason = switch(reason) {
                case macro null: macro '';
                case _: macro ' ( ' + $reason + ' )';
            }
            return macro @:pos(Context.currentPos()) {
                if($value == null) throw mint.core.Macros.DebugError.null_assertion('$str was null' + $reason);
            }
        #end
        return macro null;
    } //assertnull

} //Macros

enum DebugError {
    assertion(expr:String);
    null_assertion(expr:String);
}