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

        var _index = listeners.indexOf(_handler);
        if(_index != -1) {
            listeners[_index] = null;
        }

    } //remove

    public inline function has( _handler:T ):Bool {

        return listeners.indexOf(_handler) != -1;

    } //has

    macro public function emit( ethis : Expr, args:Array<Expr> ) {
        return macro {
            var _idx = 0;
            var _count = $ethis.listeners.length;
            while(_idx < _count) {
                var fn = $ethis.listeners[_idx];
                if(fn != null) {
                    fn($a{args});
                }
                _idx++;
            }

            while(_count > 0) {
                var fn = $ethis.listeners[_count-1];
                if(fn == null) $ethis.listeners.splice(_count-1, 1);
                _count--;
            }
        }
    } //emit

} //Signal