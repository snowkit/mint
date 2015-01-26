package mint;

import mint.Types;
import mint.Control;
import mint.Signal;

typedef LabelOptions = {
    > ControlOptions,
    text: String,
    ? align: mint.Types.TextAlign,
    ? align_vertical: mint.Types.TextAlign,
    ? bounds_wrap: Bool,
    ? point_size: Float,
    ? onclick: MouseSignal
}

class Label extends Control {

    @:isVar public var text(default, set) : String;

    @:allow(mint.ControlRenderer)
        var ontext : Signal<String->Void>;
    @:allow(mint.ControlRenderer)
        var label_options : LabelOptions;

    public function new( _options:LabelOptions ) {

        ontext = new Signal();
        label_options = _options;

            //disable mouse input by default
        mouse_enabled = false;

        super(label_options);

            //assign any potential options
        if(label_options.align == null)          { label_options.align = TextAlign.center; }
        if(label_options.align_vertical == null) { label_options.align_vertical = TextAlign.center; }

        if(label_options.onclick != null) {
            mouse_enabled = true;
            mousedown.listen(label_options.onclick);
        }

            //store the text
        text = label_options.text;
            //create it
        canvas.renderer.render(Label, this);

    } //new

    public function set_text(_s:String) : String {

        text = _s;
        ontext.emit( text );
        return text;

    } //set_text

} //Label
