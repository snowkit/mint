package mint;

import mint.Types;
import mint.Control;
import mint.Signal;
import mint.Macros.*;

typedef LabelOptions = {
    > ControlOptions,
    text: String,
    ? align: mint.Types.TextAlign,
    ? align_vertical: mint.Types.TextAlign,
    ? bounds_wrap: Bool,
    ? point_size: Float,
    ? onclick: MouseSignal
}

@:allow(mint.ControlRenderer)
class Label extends Control {

    @:isVar public var text(default, set) : String;

    public var onchange : Signal<String->Void>;

    var options : LabelOptions;

    public function new( _options:LabelOptions ) {

        onchange = new Signal();
        options = _options;

        super(options);

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
