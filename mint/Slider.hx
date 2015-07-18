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

    public var bar : Panel;
    public var label : Label;

    public function new( _options:SliderOptions ) {

        options = _options;

        def(options.name, 'slider');
        max = def(options.max, 1);
        min = def(options.min, 0);
        value = def(options.value, 1);
        step = options.step;

        super(options);

        mouse_input = true;

        bar = new Panel({
            parent : this,
            x: 2, y:2, w: w-4, h: h-4,
            name : name + '.bar',
            w_min : 1,
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

    function get_amount() {
        var a = ((max-min) * value);
        return a;
    }

    override function mousemove(e:MouseEvent) {

        if(dragging) {
            var ww = e.x - x;
            if(ww < 1) ww = 1;
            if(ww >= w-4) ww = w-4;
            var dw = (ww - bar.w);
            ww = bar.w + dw;
            bar.w = ww;
            value = (ww - 1) / (w - 5);
            label.text = Std.string(get_amount());
        }

    } //mousemove

    override function mouseup(e:MouseEvent) {

        dragging = false;
        canvas.dragged = null;

        super.mouseup(e);

    } //mouseup

} //Slider
