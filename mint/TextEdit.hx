package mint;

import mint.Control;
import mint.Label;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;

using mint.core.unifill.Unifill;


/** Options for constructing a TextEdit */
typedef TextEditOptions = {

    > ControlOptions,

        /** The default text value */
    @:optional var text: String;
        /** The text size of the text for the rendering to use */
    @:optional var text_size: Float;
        /** A filter function to call when text is entered.
            It passes `new character`, `new text`, `old text`.
            Returning false will reject the character */
    @:optional var filter: String->String->String->Bool;

} //TextEditOptions


/**
    A simple text edit control
    Additional Signals: none
*/
@:allow(mint.render.Renderer)
class TextEdit extends Control {

    public var label : Label;
    public var filter : String->String->String->Bool;
    @:isVar public var index (default, null) : Int = 0;
    public var text (get, set): String;

        /** Emitted whenever the index is changed. */
    public var onchangeindex: Signal<Int->Void>;
    public var onchange: Signal<String->Void>;

    var edit : String = '';
    var options: TextEditOptions;

    public function new( _options:TextEditOptions ) {

        options = _options;

        def(options.name, 'textedit');
        def(options.mouse_input, true);
        def(options.key_input, true);

        super(options);

        onchangeindex = new Signal();
        onchange = new Signal();

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
            options: options.options.label,
            name : name + '.label',
            mouse_input: false,
            internal_visible: options.visible
        });

        edit = label.text;
        index = edit.uLength();

        renderer = rendering.get(TextEdit, this);

        refresh(edit);

        oncreate.emit();

    } //new

    override function mousedown( event:MouseEvent ) {

        super.mousedown(event);

    } //onmousedown

    override function textinput( event:TextEvent ) {

        var b = before(index);
        var a = after(index);
        var new_text = b + event.text + a;

        if(filter != null && !filter(event.text, new_text, edit)) {
            return;
        }

        index += event.text.uLength();
        refresh( new_text );

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

        onchange.emit(edit);

        return edit;

    } //refresh

    inline function get_text() {
        return edit;
    }

    inline function set_text(v:String) {
        index = v.uLength();
        return refresh(v);
    }

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
