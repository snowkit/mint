package mint;

import mint.types.Types;
import mint.Control;
import mint.Label;
import mint.Signal;
import mint.core.Macros.*;

using mint.core.unifill.Unifill;

/** Options for constructing a TextEdit */
typedef TextEditOptions = {

    > ControlOptions,

        /** The default text value */
    @:optional var text: String;
        /** The text size of the text for the rendering to use */
    @:optional var text_size: Float;
        /** A filter to apply to text on input, inclusive */
    @:optional var filter: EReg;

} //TextEditOptions

/**
    A simple text edit control
    Additional Signals: none
*/
@:allow(mint.render.Renderer)
class TextEdit extends Control {

    public var label : Label;
    public var filter : EReg;
    @:isVar public var index (default, null) : Int = 0;

        /** Emitted whenever the index is changed. */
    public var onchangeindex: Signal<Int->Void>;

    var edit : String = '';
    var options: TextEditOptions;

    public function new( _options:TextEditOptions ) {

        options = _options;

        def(options.name, 'textedit');

        super(options);

        onchangeindex = new Signal();

        mouse_input = def(options.mouse_input, true);
        key_input = def(options.key_input, true);
        filter = def(options.filter, null);

        def(options.text, 'mint.TextEdit');
        def(options.text_size, options.h * 0.8);

        label = new Label({
            parent : this,
            x: 2, y: 0, w: w, h: h,
            text: options.text,
            text_size: options.text_size,
            align: TextAlign.left,
            align_vertical: TextAlign.center,
            name : name + '.label',
            mouse_input: false,
            visible: options.visible
        });

        edit = label.text;
        index = edit.uLength();

        renderer = rendering.render(TextEdit, this);

        refresh(edit);

    } //new

    override function mousedown( event:MouseEvent ) {

        super.mousedown(event);

    } //onmousedown

    override function textinput( event:TextEvent ) {

        if(filter != null) {
            if(!filter.match(event.text)) {
                return;
            }
        }

        var b = before(index);
        var a = after(index);
        index += event.text.uLength();

        refresh( b + event.text + a );

        // event.bubble = false;
        // super.textinput(event);

    } //ontextinput

    override function keydown( event:KeyEvent ) {

        switch(event.key) {
            case KeyCode.backspace:
                move(-1);
                cut(index, 1);
            case KeyCode.delete:
                cut(index, 1);
            case KeyCode.left:
                move(-1);
            case KeyCode.right:
                move(1);
            case KeyCode.enter:
            case KeyCode.tab:
            case KeyCode.unknown:
            case KeyCode.down:
            case KeyCode.up:
        }

        // event.bubble = false;
        // super.keydown(event);

    } //onkeydown

    inline function refresh( str:String ) {

        label.text = edit = str;
        update_cur();

        return edit;

    } //refresh

    function move(amount:Int = -1) {

        index += amount;
        index = Std.int(luxe.utils.Maths.clamp(index, 0, edit.uLength()));

        // trace('index $index / ${edit.uLength()}');
        // trace(before(index) + '|' + after(index));

        update_cur();

    } //move

    inline function cut( start:Int = 0, count:Int = 1 ) {

        var a = after(start);

        return refresh( before(start) + a.uSubstr(count, a.uLength()) );

    } //cut

    inline function after( cur:Int = 0 ) {

        return edit.uSubstr(cur, edit.length);

    } //after

    inline function before( cur:Int = 0 ) {

        return edit.uSubstr(0, cur);

    } //before

    inline function update_cur() {

        onchangeindex.emit(index);

    } //

} //TextEdit
