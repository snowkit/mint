package mint;

import mint.Label;
import mint.Types;
import mint.Control;

class Number extends Control {

    @:isVar public var value(get,set) : Float;

    public var max : Float = 1;
    public var min : Float = 0;

    public var precision : Int = 4;
    public var steps : Int = 200;

    public var label : Label;

    var can_change : Bool = false;
    var _current : Float = 0.0;
    var startdrag : Int = 0;

    public var on_change : Control->Float->Void;

    public function new(_options:Dynamic) {

        super(_options);

        mouse_enabled = true;

        if(_options.value == null) { _options.value = 0.0; }
        if(_options.align == null) { _options.align = TextAlign.center; }
        if(_options.align_vertical == null) { _options.align_vertical = TextAlign.center; }
        if(_options.point_size != null) { _options.size = _options.point_size; }
        if(_options.mouse_enabled != null) { mouse_enabled = _options.mouse_enabled; }

        var _value = _options.value;

        label = new Label({
            parent : this,
            bounds : _options.bounds.clone().set(0,0),
            text: Std.string(_value),
            point_size:_options.point_size,
            name : name + '.label'
        });

        // mouse_enabled = true;
        label.mouse_enabled = mouse_enabled;

    } //new

    public function set_value(_v:Float) : Float {

        value = _v;

        label.set_text( Std.string(_v) );

        return value;

    } //set_text

    public function get_value() : Float {
        return value;
    }

    public override function onmousedown(e:MouseEvent) {
        super.onmousedown(e);
        if(!can_change) {
            can_change = true;
            canvas.dragged = this;
        }
    }

    public override function onmouseup(e:MouseEvent) {
        super.onmouseup(e);
        if(can_change) {
            can_change = false;
            canvas.dragged = null;
        }
    }

    public override function onmousemove(e:MouseEvent) {
        super.onmousemove(e);
        if(can_change) {
            var diff = Std.int(e.x) - startdrag;
            var d = diff*0.0001;
            var _value = value + d;
            if(_value <= min) { _value = min; startdrag = Std.int(e.x); }
            if(_value >= max) { _value = max; startdrag = Std.int(e.x); }

            // _value = phoenix.utils.Maths.fixed(_value, precision);
            if(on_change != null) {
                on_change(this, _value);
            }

            value = _value;
        }
    } //onmousemove

    public override function destroy() {
        super.destroy();
    }

}