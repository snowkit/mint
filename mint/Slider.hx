package mint;

import mint.Control;
import mint.Panel;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a Slider */
typedef SliderOptions = {

    > ControlOptions,

        /** Whether or not the slider is vertical. default: false */
    @:optional var vertical: Bool;

        /** The slider minimum value. default: 0 */
    @:optional var min: Float;
        /** The slider maximum value. default: 1 */
    @:optional var max: Float;
        /** The slider initial value. default: 1 */
    @:optional var value: Float;
        /** The slider step value. default: none */
    @:optional var step: Null<Float>;

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

    var bar_x : Float = 2.0;
    var bar_y : Float = 2.0;
    var bar_w : Float = 0.0;
    var bar_h : Float = 0.0;

    public var onchange: Signal<Float->Float->Void>;

    public function new( _options:SliderOptions ) {

        options = _options;

        def(options.name, 'slider');
        def(options.mouse_input, true);

        max = def(options.max, 1);
        min = def(options.min, 0);
        value = def(options.value, max);
        vertical = def(options.vertical, false);
        step = options.step;

        super(options);

        onchange = new Signal();
        
        update_bar();

        renderer = rendering.get(Slider, this);

        oncreate.emit();

    } //new

    var dragging = false;

    override function mousedown(e:MouseEvent) {

        super.mousedown(e);

        dragging = true;
        canvas.modal = this;
        update_value(e);

    } //mousedown

    inline function get_range() return max-min;
    
    inline function update_bar() {
        if(vertical) {
            bar_w = w - 4;
            bar_h = (h - 4) * (value - min) / (max - min);
            bar_y = ((h - ((h - 4) * (value - min) / (max - min))) - 2);
            if(bar_h < 1) bar_h = 1;
            if(bar_h >= w-4) bar_h = h - 4;
        }
        else {
            bar_w = (w - 4) * (value - min) / (max - min);
            if(bar_w < 1) bar_w = 1;
            if(bar_w >= w-4) bar_w = w - 4;
            bar_h = h - 4;
        }
    } // update_bar
    
    inline function set_value(v:Float):Float {
        value = luxe.utils.Maths.clamp(v, min, max);
        update_bar();
        percent = value/get_range();
        if(onchange != null) onchange.emit(value, percent);
        return value;
    } // set_value

    inline function update_value(e:MouseEvent) {

        var prev = value;

        if(!vertical) {

            var _dx = e.x - x;

            if(_dx < 1) _dx = 1;
            if(_dx >= w-4) _dx = w-4;

            var _v:Float = ((_dx - 1) / (w - 5)) * get_range() + min;

            if(step != null) _v = Math.round(_v/step) * step;
            value = _v;

        } else {

            var _dy = (h) - (e.y - y);

            if(_dy < 1) _dy = 1;
            if(_dy >= h-4) _dy = h-4;

            var _v:Float = ((_dy - 1) / (h - 5)) * get_range() + min;

            if(step != null) _v = Math.round(_v/step) * step;
            value = _v;

        } //vertical

    } //update_value

    override function mousemove(e:MouseEvent) {

        if(dragging) {

            update_value(e);

        } //dragging

    } //mousemove

    override function mouseup(e:MouseEvent) {

        dragging = false;
        canvas.modal = null;

        super.mouseup(e);

    } //mouseup

} //Slider
