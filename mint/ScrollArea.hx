package mint;

import mint.Types;
import mint.Control;

class ScrollArea extends Control {
#if no


    public var can_scroll_h : Bool = false;
    public var can_scroll_v : Bool = false;

    public var scroll_amount : Point;
    public var scroll_percent : Point;
    public var child_bounds : ChildBounds;

    public var onscroll : Float -> Float -> Void;

    public var handle_drag_vertical = false;
    public var handle_drag_horizontal = false;

    var sliderh_x : Float = 0;
    var sliderh_y : Float = 0;
    var sliderv_x : Float = 0;
    var sliderv_y : Float = 0;

    var slider_v_visible : Bool = false;
    var slider_h_visible : Bool = false;

    var last_modal : Control;

    public var handle_h_bounds : Rect;
    public var handle_v_bounds : Rect;


    public function new(_options:Dynamic) {

        super(_options);

        scroll_amount = new Point();
        scroll_percent = new Point();

        onscroll = _options.onscroll;

        renderer.scroll.init( this, _options );

        handle_h_bounds = renderer.scroll.get_handle_bounds(this, false);
        handle_v_bounds = renderer.scroll.get_handle_bounds(this, true);

        sliderh_x = handle_h_bounds.x;
        sliderh_y = handle_h_bounds.y;

        sliderv_x = handle_v_bounds.x;
        sliderv_y = handle_v_bounds.y;

        on_internal_scroll(0, 0);

    } //new

    public override function add(child:Control) {

        super.add(child);
        on_internal_scroll(0,0);

        child.clip_with( this );
        depth = depth;

    } //add


    public override function onmousedown(e : MouseEvent) {

        var forward = true;

        if(can_scroll_h || can_scroll_v) {

            var m = new Point(e.x, e.y);

            if(can_scroll_h && handle_h_bounds.point_inside(m)) {
                handle_drag_horizontal = true;
                last_modal = canvas.modal;
                canvas.modal = this;
                forward = false;
            }

            if(can_scroll_v && handle_v_bounds.point_inside(m)) {
                handle_drag_vertical = true;
                last_modal = canvas.modal;
                canvas.modal = this;
                forward = false;
            }

        } //can_scroll at all

        if(forward) {
            super.onmousedown(e);
        }

    } //onmousedown

    public override function onmouseup(e : MouseEvent) {

        super.onmouseup(e);

        if(handle_drag_vertical || handle_drag_horizontal) {
            handle_drag_vertical = false;
            handle_drag_horizontal = false;
            canvas.modal = last_modal;
        }

    } //onmouseup

    public override function onmousemove(e : MouseEvent) {

        super.onmousemove(e);

        if(handle_drag_vertical) {
            set_scroll_y( e.y-real_bounds.y );
        }

        if(handle_drag_horizontal) {
            set_scroll_x( e.x-real_bounds.x );
        }

    } //onmousemove

    public override function onmousewheel(e:MouseEvent) {

            //forward to
        super.onmousewheel(e);

        if(e.x != 0 && can_scroll_h) {
            set_scroll_x((scroll_amount.x)-(real_bounds.w*0.03*e.x));
        }

        trace(e.y);

        if(e.y != 0 && can_scroll_v) {
            set_scroll_y((scroll_amount.y)-(real_bounds.h*0.01*e.y));
        }

    } //onmousewheel

    public override function translate(?_x:Float = 0, ?_y:Float = 0, ?_offset:Bool = false ) {

        super.translate( _x, _y, _offset);

            handle_h_bounds.x += _x;
            handle_h_bounds.y += _y;
            handle_v_bounds.x += _x;
            handle_v_bounds.y += _y;
            sliderh_x += _x;
            sliderh_y += _y;
            sliderv_x += _x;
            sliderv_y += _y;

        renderer.scroll.translate( this, _x, _y, _offset );

    } //translate

    function on_internal_scroll(_dx:Float, _dy:Float) {

        if(_dx != 0 || _dy != 0) {

                //tell the children to scroll the delta
            for(child in children) {
                child.translate(_dx, _dy, true);
            }

                //call the handler if any
            if(onscroll != null) {
                onscroll(_dx, _dy);
            }

        } //has delta

            //update the bounds of the handles
        handle_v_bounds.y = sliderv_y;
        handle_h_bounds.x = sliderh_x;

            //make sure the child bounds are up to date
        child_bounds = children_bounds;

            //make sure the scroll goes away when too small
        slider_h_visible = false;
        slider_v_visible = false;
        can_scroll_h = false;
        can_scroll_v = false;

            //if the children bounds are < our size, it can't scroll
        if(child_bounds.real_w <= real_bounds.w) {
            can_scroll_h = false;
            slider_h_visible = false;
        } else {
            can_scroll_h = true;
            slider_h_visible = true;
        }

        if(child_bounds.real_h <= real_bounds.h) {
            can_scroll_v = false;
            slider_v_visible = false;
        } else {
            can_scroll_v = true;
            slider_v_visible = true;
        }

            //refresh the rendering state
        renderer.scroll.refresh_scroll( this, sliderh_x, sliderh_y, sliderv_x, sliderv_y, slider_h_visible, slider_v_visible );

    } //on_internal_scroll

        //set the scroll value directly in pixels, between 0 and bounds.h
    public function set_scroll_y(exact:Float) {

        if(!can_scroll_v) return;

            //can't go outside the bounds
        exact = Utils.clamp( exact, 0, real_bounds.h );

            //for a delta
        var last_p_y = scroll_percent.y;
            //the new percent is based on the size of the control
        scroll_percent.y = Utils.clamp(exact / (real_bounds.h-handle_v_bounds.h), 0, 1);
        scroll_amount.y = exact;
            //we need the difference in scroll amount in pixels
        var pdiff = (last_p_y - scroll_percent.y) * (child_bounds.real_h - real_bounds.h);
            //update the real slider y value
        sliderv_y = Utils.clamp( real_bounds.y + exact, real_bounds.y, real_bounds.y+real_bounds.h-handle_v_bounds.h );

        on_internal_scroll(0, pdiff);

    } //set_scroll_y

    public function set_scroll_x(exact:Float) {

        if(!can_scroll_h) return;

            //limit to the size of the control
        exact = Utils.clamp( exact, 0, real_bounds.w );

            //for a delta
        var last_p_x = scroll_percent.x;
            //the new percent is based on the size of the control
        scroll_percent.x = Utils.clamp(exact / real_bounds.w, 0, 1);
        scroll_amount.x = exact;
            //we need the difference in scroll amount in pixels
        var pdiff = (last_p_x - scroll_percent.x) * (child_bounds.real_w - real_bounds.w);
            //update the real slider x value
        sliderh_x = Utils.clamp( real_bounds.x + exact, real_bounds.x, real_bounds.x+real_bounds.w-handle_h_bounds.w );

        on_internal_scroll(pdiff, 0);

    } //set_scroll_x

    public override function set_visible( ?_visible:Bool = true ) {

        super.set_visible(_visible);
        renderer.scroll.set_visible(this, _visible);
        if(_visible) {
            on_internal_scroll(0,0);
        }

    } //set_visible


    private override function set_depth( _depth:Float ) : Float {

        super.set_depth(_depth);

        renderer.scroll.set_depth(this, _depth);

        return depth;

    } //set_depth

#end
}