package mint;

import mint.Control;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a Label */
typedef LabelOptions = {

    > ControlOptions,

        /** The text to display on the label */
    var text: String;
        /** The text alignment on the horizontal axis, relative to the bounds */
    @:optional var align: mint.types.Types.TextAlign;
        /** The text alignment on the vertical axis, relative to the bounds */
    @:optional var align_vertical: mint.types.Types.TextAlign;
        /** Whether or not to wrap the text by the bounds for the rendering to apply */
    @:optional var bounds_wrap: Bool;
        /** The text size of the text  */
    @:optional var text_size: Float;
        /** An optional mouseup handler for convenience */
    @:optional var onclick: MouseSignal;

} //LabelOptions


/**
    A simple label control
    Additional Signals: onchange
*/
@:allow(mint.render.Renderer)
class Label extends Control {

        /** The text displayed by the label */
    @:isVar public var text(default, set) : String;

        /** Emitted whenever text is changed.
            `function(text:String)` */
    public var onchange : Signal<String->Void>;

    var options : LabelOptions;

    public function new( _options:LabelOptions ) {

        options = _options;

        def(options.name, 'label.${Helper.uniqueid()}');

        super(options);

        onchange = new Signal();

        def(options.align, TextAlign.center);
        def(options.align_vertical, TextAlign.center);
        def(options.text_size, 14);

        if(options.onclick != null) {
            mouse_input = true;
            onmouseup.listen(options.onclick);
        }

        text = options.text;

        renderer = rendering.get(Label, this);

        oncreate.emit();

    } //new

    public override function destroy() {

        super.destroy();

        onchange.clear();
        onchange = null;

    } //destroy

//Internal

    function set_text( _s:String ) : String {

        text = _s;

        onchange.emit( text );

        return text;

    } //set_text

} //Label
