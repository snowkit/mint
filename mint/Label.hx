package mint;

import mint.Types;
import mint.Control;
import mint.Signal;
import mint.Macros.*;

/** Options for constructing a Label */
typedef LabelOptions = {

    > ControlOptions,

        /** The text to display on the label */
    var text: String;
        /** The text alignment on the horizontal axis, relative to the bounds */
    @:optional var align: mint.Types.TextAlign;
        /** The text alignment on the vertical axis, relative to the bounds */
    @:optional var align_vertical: mint.Types.TextAlign;
        /** Whether or not to wrap the text by the bounds for the renderer to apply */
    @:optional var bounds_wrap: Bool;
        /** The point size of the text for the renderer to use */
    @:optional var point_size: Float;
        /** An optional mouseup handler for convenience */
    @:optional var onclick: MouseSignal;

} //LabelOptions

/**
    A simple label control
    Additional Signals: onchange
*/
@:allow(mint.ControlRenderer)
class Label extends Control {

        /** The text displayed by the label */
    @:isVar public var text(default, set) : String;

        /** Emitted whenever text is changed.
            `function(text:String)` */
    public var onchange : Signal<String->Void>;

    var options : LabelOptions;

    public function new( _options:LabelOptions ) {

        options = _options;

        def(options.name, 'label');

        super(options);

        onchange = new Signal();

        mouse_enabled = def(options.mouse_enabled, false);

        def(options.align, TextAlign.center);
        def(options.align_vertical, TextAlign.center);

        if(options.onclick != null) {
            mouse_enabled = true;
            mouseup.listen(options.onclick);
        }

        text = options.text;
        canvas.renderer.render(Label, this);

    } //new

//Internal

    function set_text( _s:String ) : String {

        text = _s;

        onchange.emit( text );

        return text;

    } //set_text

} //Label
