package mint.core;

// Contibuted by Michael Bickel http://github.com/dazKind

import haxe.macro.Expr;

class Signal<T> {

    public var listeners:Array<T>;

    public function new() {

        listeners = [];

    } //new

    public function listen( _handler:T ):Void {

        if( listeners.indexOf(_handler) != -1 ) {
            throw "mint / signal / listen / attempted to add the same listener twice";
            return;
        }

        listeners.push(_handler);

    } //listen

    public function remove( _handler:T ):Void {

        if (listeners.remove(_handler) == false) {
            throw "mint / signal / remove failed / WTF?!?";
        }

    } //remove

    public inline function has( _handler:T ):Bool {

        return listeners.indexOf(_handler) != -1;

    } //has

    macro public function emit( ethis : Expr, args:Array<Expr> ) {
        return macro {
            for (l in $ethis.listeners) {
                l($a{args});
            }
        }
    } //dispatch

} //Signal