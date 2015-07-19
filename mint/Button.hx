package mint;

import mint.Control;
import mint.Label;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a Button */
typedef ButtonOptions = {

    > LabelOptions,

} //ButtonOptions


/**
    A simple button with a label
    Additional Signals: none
*/
@:allow(mint.render.Renderer)
class Button extends Control {

        /** The label the button displays */
    public var label : Label;

    var options: ButtonOptions;

    public function new( _options:ButtonOptions ) {

        options = _options;

        def(options.name, 'button');

        super(options);

        mouse_input = def(options.mouse_input, true);

        def(options.align, TextAlign.center);
        def(options.align_vertical, TextAlign.center);
        def(options.text_size, 14);

        label = new Label({
            parent : this,
            x: 0, y:0, w: w, h: h,
            text: options.text,
            text_size: options.text_size,
            name : name + '.label',
            mouse_input: false,
            visible: options.visible
        });

        if(options.onclick != null) {
            onmouseup.listen(options.onclick);
        }

        renderer = rendering.get( Button, this );

    } //new


} //Button
