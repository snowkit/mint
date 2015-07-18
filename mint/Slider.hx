package mint;

import mint.Types;
import mint.Control;
import mint.Panel;
import mint.Macros.*;

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
@:allow(mint.ControlRenderer)
class Slider extends Control {

    var options: SliderOptions;

    public var min : Float = 0;
    public var max : Float = 1;
    public var value : Float = 1;
    public var step : Null<Float>;
    public var vertical : Bool = false;

    public var bar : Panel;
    public var label : Label;

    public function new( _options:SliderOptions ) {

        options = _options;

        def(options.name, 'slider');
        max = def(options.max, 1);
        min = def(options.min, 0);
        value = def(options.value, max);
        vertical = def(options.vertical, false);
        step = options.step;

        super(options);

        mouse_input = true;

        bar = new Panel({
            parent : this,
            x: 2, y:2, w: w-4, h: h-4,
            name : name + '.bar',
            w_min : 1, h_min : 1,
            mouse_input: false,
            visible: options.visible
        });

        label = new Label({
            parent : this,
            x: 0, y:0, w: w, h: h,
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            text: '${options.value}',
            point_size: 12,
            name : name + '.label',
            mouse_input: false,
            visible: options.visible
        });

        renderinst = render_service.render(Slider, this);

    } //new

    var dragging = false;
    var drag_x = 0.0;
    var drag_y = 0.0;

    override function mousedown(e:MouseEvent) {

        super.mousedown(e);

        dragging = true;
        drag_x = e.x;
        drag_y = e.y;
        canvas.dragged = this;

    } //mousedown

    inline function get_amount() {
        return (max-min) * value;
    }

    inline function get_range() {
        return max-min;
    }

    override function mousemove(e:MouseEvent) {

        if(dragging) {

            if(!vertical) {

                var _bar_w = e.x - x;

                if(_bar_w < 1) _bar_w = 1;
                if(_bar_w >= w-4) _bar_w = w-4;

                _bar_w = bar.w + (_bar_w - bar.w);
                value = ((_bar_w - 1) / (w - 5)) * get_range();

                if(step != null) value = Math.round(value/step) * step;

                bar.w = _bar_w;

            } else {

                var _bar_h = (h) - (e.y - y);

                if(_bar_h < 1) _bar_h = 1;
                if(_bar_h >= h-4) _bar_h = h-4;

                _bar_h = bar.h + (_bar_h - bar.h);
                value = ((_bar_h - 1) / (h - 5)) * get_range();

                if(step != null) value = Math.round(value/step) * step;

                bar.h = _bar_h;
                bar.y_local = (h - _bar_h) - 2;

            } //vertical

            label.text = Std.string(value);

        } //dragging

    } //mousemove

    override function mouseup(e:MouseEvent) {

        dragging = false;
        canvas.dragged = null;

        super.mouseup(e);

    } //mouseup

} //Slider
