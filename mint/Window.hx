package mint;

import mint.types.Types;
import mint.Control;
import mint.Label;
import mint.Signal;
import mint.core.Macros.*;

typedef WindowOptions = {

    > ControlOptions,

        /** The title of the window to display as a label */
    @:optional var title: String;
        /** The text size for the title text */
    @:optional var text_size: Float;
        /** Whether or not the window can be moved by it's title bar */
    @:optional var moveable: Bool;
        /** Whether or not the window can be closed by the top right corner */
    @:optional var closeable: Bool;
        /** Whether or not the window can be resized by it's bottom right corner*/
    @:optional var resizable: Bool;
        /** Whether or not the window is focusable (bring to front on click) */
    @:optional var focusable: Bool;

} //WindowOptions

@:allow(mint.render.Renderer)
class Window extends Control {

    public var title : Label;
    public var close_button : Label;

    public var moveable : Bool = true;
    public var closeable : Bool = true;
    public var focusable : Bool = true;
    public var resizable : Bool = true;

    public var onclose : Signal<Void->Bool>;

    var dragging : Bool = false;
    var drag_start_x : Float = 0;
    var drag_start_y : Float = 0;

    var resize_handle : Control;
    var options : WindowOptions;

    public function new( _options:WindowOptions ) {

        options = _options;
        onclose = new Signal();

        def(options.name, 'window');

        super(options);

        if(options.mouse_input == null){
            mouse_input = true;
        }

        if(options.moveable != null) { moveable = options.moveable; }
        if(options.closeable != null) { closeable = options.closeable; }
        if(options.focusable != null) { focusable = options.focusable; }
        if(options.resizable != null) { resizable = options.resizable; }

        resize_handle = new Control({
            parent : this,
            x: w-24, y: h-24, w: 24, h: 24,
            name : name + '.resize_handle',
        });

        resize_handle.mouse_input = resizable;
        resize_handle.onmousedown.listen(on_resize_down);
        resize_handle.onmouseup.listen(on_resize_up);

            //create the title label
        title = new Label({
            parent : this,
            x: 2, y: 2, w: w - 4, h: 22,
            text: options.title,
            align : TextAlign.center,
            align_vertical : TextAlign.center,
            text_size: options.text_size,
            name: name + '.titlelabel',
            visible: options.visible
        });

            //create the close label
        close_button = new Label({
            parent : this,
            x: w - 24, y: 2, w: 22, h: 22,
            text:'x',
            align : TextAlign.center,
            align_vertical : TextAlign.center,
            text_size: options.text_size,
            name : name + '.closelabel',
            visible: options.visible && closeable
        });

        close_button.mouse_input = true;
        close_button.onmousedown.listen(function(e:MouseEvent, _) {
            on_close();
        });

            //update
        renderer = rendering.render( Window, this );

    } //new

    var resizing = false;
    var resize_start_x = 0.0;
    var resize_start_y = 0.0;

    function on_resize_up(e:MouseEvent, _) {

        if(!resizable) return;

        resizing = false;
        canvas.dragged = null;

    } //on_resize_up

    function on_resize_down(e:MouseEvent, _) {

        if(!resizable) return;
        if(resizing) return;

        resizing = true;
        resize_start_x = e.x;
        resize_start_y = e.y;
        canvas.dragged = resize_handle;

    } //on_resize_down

    function on_close() {

        onclose.emit();

        if(closeable) {
            close();
        }

    } //on_close

    public function close() {

        visible = false;

    } //close

    public function open() {

        visible = true;

    } //open

    public override function mousemove(e:MouseEvent)  {

        if(resizing) {

            var diff_x = e.x - resize_start_x;
            var diff_y = e.y - resize_start_y;

            var ww = w + diff_x;
            var hh = h + diff_y;

            var resized = false;

            if(ww >= w_min || ww <= w_max) {
                resize_start_x = e.x;
                resized = true;
            }

            if(hh >= h_min || hh <= h_max) {
                resize_start_y = e.y;
                resized = true;
            }

            if(resized) set_size(ww, hh);

        } else if(dragging) {

            var diff_x = e.x - drag_start_x;
            var diff_y = e.y - drag_start_y;

            drag_start_x = e.x;
            drag_start_y = e.y;

            set_pos(x + diff_x, y + diff_y);

        } else { //dragging

            super.mousemove(e);

        }

    } //onmousemove

    function bring_to_front() {
        if(depth != @:privateAccess canvas.depth_seq) {
            depth = canvas.next_depth();
        }
    }

    public override function mousedown(e:MouseEvent)  {

        if(close_button.contains(e.x, e.y)) return;

        var in_title = title.contains(e.x, e.y);

        if(!in_title) {
            super.mousedown(e);
        }

        if(focusable) bring_to_front();

            if(!dragging && moveable) {
                if( in_title ) {
                    dragging = true;
                    drag_start_x = e.x;
                    drag_start_y = e.y;
                    canvas.dragged = this;
                } //if inside title bounds
            } //!dragging

    } //onmousedown

    public override function mouseup(e:MouseEvent) {

        super.mouseup(e);

        if(dragging) {
            dragging = false;
            canvas.dragged = null;
        } //dragging

    } //mouseup

    override function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0, ?_offset:Bool = false ) {

        super.bounds_changed(_dx, _dy, _dw, _dh, _offset);

        if(close_button != null) close_button.x_local = w - 24;
        if(title != null) title.w = w - 4;
        if(resize_handle != null) resize_handle.set_pos(x + w - 24, y + h - 24);

    } //bounds_changed

}