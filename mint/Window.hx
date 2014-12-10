package mint;

import mint.Types;
import mint.Control;
import mint.Label;

class Window extends Control {
#if no

    public var title_bounds : Rect;
    public var view_bounds : Rect;
    public var close_bounds : Rect;

    public var title : Label;
    public var close_button : Label;

    public var moveable : Bool = true;
    public var dragging : Bool = false;

    public var drag_start : Point;
    public var down_start : Point;

    public var onclose : Void->Bool;

    public function new(_options:Dynamic) {

        super(_options);

        _options.bounds = real_bounds;

        drag_start = new Point();
        down_start = new Point();

        if(_options.align == null) { _options.align = TextAlign.center; }
        if(_options.align_vertical == null) { _options.align_vertical = TextAlign.center; }
        if(_options.title_size != null) { _options.size = _options.title_size; }
        if(_options.title != null) { _options.text = _options.title; }
        if(_options.moveable != null) { moveable = _options.moveable; }

        title_bounds = new Rect(6, 6, bounds.w-12, 20 );
        close_bounds = new Rect(bounds.w-18, 5, 18, 20 );
        view_bounds = new Rect(32, 32, bounds.w - 64, bounds.h - 64 );

        _options.pos = new Point(real_bounds.x, real_bounds.y);

            //create the title label
        title = new Label({
            parent : this,
            bounds : title_bounds,
            text:_options.text,
            point_size:_options.title_size,
            name : name + '.titlelabel'
        });

            //create the close label
        close_button = new Label({
            parent : this,
            bounds : close_bounds,
            text:'x',
            align : TextAlign.left,
            point_size:13,
            name : name + '.closelabel'
        });

        close_button.mouse_enabled = true;
        close_button.mousedown.listen(function(e:MouseEvent, _) {
            on_close();
        });

            //update
        renderer.window.init( this, _options );

    } //new

    function on_close() {

        var do_close = true;

        if(onclose != null) {
            do_close = onclose();
        }

        if(do_close) {
            close();
        }

    } //on_close

    public function close() {

        set_visible(false);

    } //close

    public function open() {

        set_visible(true);

    } //open

    public override function onmousemove(e:MouseEvent)  {

        super.onmousemove(e);

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

        var _m : Point = new Point(e.x,e.y);
        var in_title = title.real_bounds.point_inside(_m);

        if(!in_title) {
            super.onmousedown(e);
        }

        bring_to_front();

            if(!dragging && moveable) {
                if( in_title ) {
                    dragging = true;
                    drag_start = _m.clone();
                    down_start = new Point(real_bounds.x, real_bounds.y);
                    canvas.dragged = this;
                } //if inside title bounds
            } //!dragging

    } //onmousedown

    public override function onmouseup(e:MouseEvent) {

        super.onmouseup(e);

        var _m : Point = new Point(e.x,e.y);
        if(dragging) {
            dragging = false;
            canvas.dragged = null;
        } //dragging

    } //onmouseup

    public override function translate( ?_x : Float = 0, ?_y : Float = 0, ?_offset:Bool = false ) {

        super.translate( _x, _y, _offset );

        title_bounds = new Rect(real_bounds.x, real_bounds.y, bounds.w, 30 );

        renderer.window.translate( this, _x, _y, _offset );

    } //translate

    public override function set_visible( ?_visible:Bool = true ) {
        super.set_visible(_visible);
        renderer.window.set_visible(this, _visible);
    } //set_visible


    private override function set_depth( _depth:Float ) : Float {

        super.set_depth(_depth);

        renderer.window.set_depth(this, _depth);

        return depth;

    } //set_depth

#end
}