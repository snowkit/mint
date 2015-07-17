package mint;

import mint.Types;
import mint.Control;
import mint.Label;
import mint.Signal;
import mint.Macros.*;

typedef WindowOptions = {
    > ControlOptions,
    ? title: String,
    ? moveable: Bool,
    ? closeable: Bool,
    ? focusable: Bool,
    ? onclose: Void->Bool,
}

class Window extends Control {

    public var title : Label;
    public var close_button : Label;

    public var moveable : Bool = true;
    public var closeable : Bool = true;
    public var focusable : Bool = true;

    public var onclose : Signal<Void->Bool>;

    var dragging : Bool = false;
    var drag_start : Point;
    var down_start : Point;
    var _mouse:Point;

    var resize_handle : Control;

    @:allow(mint.ControlRenderer)
        var options : WindowOptions;

    public function new( _options:WindowOptions ) {

        options = _options;
        onclose = new Signal();

        def(options.name, 'window');

        super(_options);

        if(options.mouse_enabled == null){
            mouse_enabled = true;
        }

        _mouse = new Point();
        drag_start = new Point();
        down_start = new Point();

        if(_options.moveable != null) { moveable = _options.moveable; }
        if(_options.closeable != null) { closeable = _options.closeable; }
        if(_options.focusable != null) { focusable = _options.focusable; }

        resize_handle = new Control({
            parent : this,
            x: w-24, y: h-24, w: 24, h: 24,
            name : name + '.resize_handle',
        });

        resize_handle.mouse_enabled = true;//options.resizable
        resize_handle.mousedown.listen(on_resize_down);
        resize_handle.mouseup.listen(on_resize_up);

            //create the title label
        title = new Label({
            parent : this,
            x: 2, y: 2, w: w - 4, h: 22,
            text: _options.title,
            align : TextAlign.center,
            align_vertical : TextAlign.center,
            point_size: 14,
            name: name + '.titlelabel'
        });

            //create the close label
        close_button = new Label({
            parent : this,
            x: w - 24, y: 2, w: 22, h: 22,
            text:'x',
            align : TextAlign.center,
            align_vertical : TextAlign.center,
            point_size:15,
            name : name + '.closelabel'
        });

        close_button.mouse_enabled = true;
        close_button.mousedown.listen(function(e:MouseEvent, _) {
            on_close();
        });

            //update
        render = canvas.renderer.render( Window, this );

    } //new

    var resizing = false;
    var resize_start : Point;

    function on_resize_up(e:MouseEvent, _) {
        resizing = false;
        canvas.dragged = null;
    }

    function on_resize_down(e:MouseEvent, _) {
        if(resizing) return;
        resizing = true;
        resize_start = new Point(e.x, e.y);
        canvas.dragged = resize_handle;
    }

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

    public override function onmousemove(e:MouseEvent)  {

        if(resizing) {

            var diff_x = e.x - resize_start.x;
            var diff_y = e.y - resize_start.y;

            var ww = w + diff_x;
            var hh = h + diff_y;

            resize_start.set(e.x, e.y);

            set_size(ww, hh);

        } else if(dragging) {

            var diff_x = e.x - drag_start.x;
            var diff_y = e.y - drag_start.y;

            drag_start.set(e.x,e.y);

            set_pos(x + diff_x, y + diff_y);

        } else { //dragging

            super.onmousemove(e);

        }

    } //onmousemove

    function bring_to_front() {
        if(depth != @:privateAccess canvas.depth_seq) {
            depth = canvas.next_depth();
        }
    }

    public override function onmousedown(e:MouseEvent)  {

        _mouse.set(e.x,e.y);

        var in_title = title.contains(_mouse.x, _mouse.y);

        if(!in_title) {
            super.onmousedown(e);
        }

        if(focusable) bring_to_front();

            if(!dragging && moveable) {
                if( in_title ) {
                    dragging = true;
                    drag_start.set(_mouse.x, _mouse.y);
                    down_start.set(x, y);
                    canvas.dragged = this;
                } //if inside title bounds
            } //!dragging

    } //onmousedown

    public override function onmouseup(e:MouseEvent) {

        super.onmouseup(e);

        _mouse.set(e.x,e.y);

        if(dragging) {
            dragging = false;
            canvas.dragged = null;
        } //dragging

    } //onmouseup

    override function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0, ?_offset:Bool = false ) {

        super.bounds_changed(_dx, _dy, _dw, _dh, _offset);

        if(close_button != null) close_button.x_local = w - 24;
        if(title != null) title.w = w - 4;
        if(resize_handle != null) resize_handle.set_pos(x + w - 24, y + h - 24);


    } //bounds_changed

}