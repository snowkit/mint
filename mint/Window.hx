package mint;

import mint.Types;
import mint.Control;
import mint.Label;
import mint.Signal;

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
        var window_options : WindowOptions;

    public function new( _options:WindowOptions ) {

        window_options = _options;
        onclose = new Signal();

        super(_options);

        if(window_options.mouse_enabled == null){
            mouse_enabled = true;
        }

        _mouse = new Point();
        drag_start = new Point();
        down_start = new Point();

        if(_options.moveable != null) { moveable = _options.moveable; }
        if(_options.closeable != null) { closeable = _options.closeable; }
        if(_options.focusable != null) { focusable = _options.focusable; }

        var title_bounds = new Rect(2, 2, bounds.w-4, 22 );
        var close_bounds = new Rect(bounds.w-24, 2, 22, 22 );
        var view_bounds = new Rect(24, 24, bounds.w - 48, bounds.h - 48 );

        resize_handle = new Control({
            parent : this,
            bounds : new Rect(bounds.w-24, bounds.h-24, 24, 24),
            name : name + '.resize_handle',
        });

        resize_handle.mouse_enabled = true;//options.resizable
        resize_handle.mousedown.listen(on_resize_down);
        resize_handle.mouseup.listen(on_resize_up);

            //create the title label
        title = new Label({
            parent : this,
            bounds : title_bounds,
            text: _options.title,
            align : TextAlign.center,
            align_vertical : TextAlign.center,
            point_size: 14,
            name: name + '.titlelabel'
        });

            //create the close label
        close_button = new Label({
            parent : this,
            bounds : close_bounds,
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
        canvas.renderer.render( Window, this );

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
        canvas.dragged = this;
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

        super.onmousemove(e);

        if(resizing) {
            var diff_x = e.x - resize_start.x;
            var diff_y = e.y - resize_start.y;
            // resize_start
            var ww = bounds.w + diff_x;
            var hh = bounds.h + diff_y;
            resize_start.set(e.x, e.y);
            bounds = new Rect(bounds.x, bounds.y, ww, hh);
        }

        if(dragging) {

            var diff_x = e.x - drag_start.x;
            var diff_y = e.y - drag_start.y;

            drag_start.set(e.x,e.y);

            translate(diff_x, diff_y);

        } //dragging
    } //onmousemove

    function bring_to_front() {
        if(depth != canvas.depth) {
            depth = canvas.next_depth();
        }
    }

    public override function onmousedown(e:MouseEvent)  {

        _mouse.set(e.x,e.y);
        var in_title = title.real_bounds.point_inside(_mouse);


        if(!in_title) {
            super.onmousedown(e);
        }

        if(focusable) bring_to_front();

            if(!dragging && moveable) {
                if( in_title ) {
                    dragging = true;
                    drag_start.set(_mouse.x, _mouse.y);
                    down_start.set(real_bounds.x, real_bounds.y);
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

    override function set_bounds( _b:Rect ) {

        bounds = super.set_bounds(_b);

        if(resize_handle != null)
        resize_handle.bounds = new Rect(_b.w-24, _b.h-24, 24, 24);

        return bounds;
    }

}