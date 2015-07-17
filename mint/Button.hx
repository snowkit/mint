package mint;

import mint.Types;
import mint.Control;
import mint.Label;
import mint.Macros.*;

/** Options for constructing a Button */
typedef ButtonOptions = {

    > LabelOptions,

} //ButtonOptions


/**
    A simple button with a label
    Additional Signals: none
*/
@:allow(mint.ControlRenderer)
class Button extends Control {

        /** The label the button displays */
    public var label : Label;

    var options: ButtonOptions;

    public function new( _options:ButtonOptions ) {

        options = _options;

        def(options.name, 'button');

        super(options);

        mouse_enabled = def(options.mouse_enabled, true);

        label = new Label({
            parent : this,
            x: 0, y:0, w: w, h: h,
            text: options.text,
            point_size: options.point_size,
            name : name + '.label',
            mouse_enabled: false
        });

        if(options.onclick != null) {
            mouseup.listen(options.onclick);
        }

        render = canvas.renderer.render( Button, this );

    } //new


} //Button
