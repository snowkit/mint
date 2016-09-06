package mint;

import mint.Control;
import mint.Panel;

import mint.types.Types;
import mint.core.Signal;
import mint.types.Types.Helper;
import mint.core.Macros.*;


/** Options for constructing a Slider */
typedef SliderOptions = {

    > ControlOptions,

        /** Whether or not the slider is vertical. default: false */
    @:optional var vertical: Bool;

        /** Inverts the sliders default direction. If true, horizontal slider goes from right to left and vertical slider from top to bottom. default: false */
    @:optional var invert: Bool;

        /** The slider minimum value. default: 0 */
    @:optional var min: Float;
        /** The slider maximum value. default: 1 */
    @:optional var max: Float;
        /** The slider initial value. default: 1 */
    @:optional var value: Float;
        /** The slider step value. default: none */
    @:optional var step: Float;

} //SliderOptions


/**
    A simple slider control
    Additional Signals: onchange
*/
@:allow(mint.render.Renderer)
class Slider extends Control {

    var options: SliderOptions;

    public var min : Float = 0;
    public var max : Float = 1;
    public var value  (default, set): Float = 1;
    public var percent : Float = 1;
    public var step : Null<Float>;
    public var vertical : Bool = false;
    public var invert : Bool = false;

    var bar_x : Float = 2.0;
    var bar_y : Float = 2.0;
    var bar_w : Float = 0.0;
    var bar_h : Float = 0.0;

    public var onchange: Signal<Float->Float->Void>;

    public function new( _options:SliderOptions ) {

        options = _options;

        def(options.name, 'slider.${Helper.uniqueid()}');
        def(options.mouse_input, true);

        max = def(options.max, 1);
        min = def(options.min, 0);
        value = def(options.value, max);
        vertical = def(options.vertical, false);
        invert = def(options.invert, false);
        step = options.step;

        super(options);

        onchange = new Signal();

        renderer = rendering.get(Slider, this);

        oncreate.emit();

        update_value(value);

    } //new

    public override function destroy() {

        super.destroy();

        onchange.clear();
        onchange = null;

    } //destroy

    var dragging = false;

    override function mousedown(e:MouseEvent) {

        super.mousedown(e);

        dragging = true;
        capture();
        update_value_from_mouse(e);

    } //mousedown

    inline function get_range() return max-min;
        
    var ignore_set = true;

    inline function update_value(_value:Float) {

        _value = Helper.clamp(_value, min, max);

        if(step != null) {
            _value = Math.round(_value/step) * step;
        }

        if(vertical) {

            bar_w = w - 4;
            bar_h = (h - 4) * (_value - min) / (max - min);
            bar_y = (!invert) ? ((h - ((h - 4) * (_value - min) / (max - min))) - 2) : 2;
            bar_h = Helper.clamp(bar_h, 1, h - 4);

        } else {

            bar_w = (w - 4) * (_value - min) / (max - min);
            bar_w = Helper.clamp(bar_w, 1, w-4);
            bar_h = h - 4;
            bar_x = (!invert) ? 2 : ((w - ((w - 4) * (_value - min) / (max - min))) - 2);

        }

        percent = _value/get_range();

        ignore_set = true;
            value = _value;
        ignore_set = false;

        onchange.emit(value, percent);

    } // update_bar
    
    inline function set_value(_value:Float):Float {

        if(ignore_set) return value = _value;

        update_value(_value);

        return value;

    } // set_value

    inline function update_value_from_mouse(e:MouseEvent) {

        if(!vertical) {

            var _dx = (!invert) ? e.x - x : (w) - (e.x - x);

            if(_dx < 1) _dx = 1;
            if(_dx >= w-4) _dx = w-4;

            var _v:Float = ((_dx - 1) / (w - 5)) * get_range() + min;

            update_value(_v);

        } else {

            var _dy = (!invert) ? (h) - (e.y - y) : e.y - y;

            if(_dy < 1) _dy = 1;
            if(_dy >= h-4) _dy = h-4;

            var _v:Float = ((_dy - 1) / (h - 5)) * get_range() + min;
                
            update_value(_v);

        } //vertical

    } //update_value

    override function mousemove(e:MouseEvent) {

        if(dragging) {

            update_value_from_mouse(e);

        } //dragging

    } //mousemove

    override function mouseup(e:MouseEvent) {

        dragging = false;
        uncapture();

        super.mouseup(e);

    } //mouseup

} //Slider
