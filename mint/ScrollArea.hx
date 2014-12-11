package mint;

import mint.Types;
import mint.Control;
import mint.utils.Signal;

typedef ScrollInfo = {
    enabled: Bool,
    percent: Float,
    amount: Float,
    bounds: Rect
}

typedef ScrollAreaOptions = {
    > ControlOptions,

    ? onscroll: Float->Float->Void
}

class ScrollArea extends Control {

    public var scroll: { v:ScrollInfo, h:ScrollInfo };

    public var child_bounds : ChildBounds;

    public var onscroll : Signal<Float->Float->Void>;

    var handle_drag_v = false;
    var handle_drag_h = false;

    var last_modal : Control;

    @:allow(mint.ControlRenderer)
        var scroll_options: ScrollAreaOptions;

    // public var handle_h__bounds : Rect;
    // public var handle_v__bounds : Rect;

    public function new(_options:ScrollAreaOptions) {

        onscroll = new Signal();

        scroll_options = _options;
        super(_options);

        if(scroll_options.mouse_enabled == null){
            mouse_enabled = true;
        }

        scroll = {
            v: {
                enabled: false, percent: 0, amount: 0,
                bounds: new Rect(
                    real_bounds.x+real_bounds.w-8,
                    real_bounds.y,
                    8,16)
            },
            h: {
                enabled: false, percent: 0, amount: 0,
                bounds: new Rect(
                    real_bounds.x,
                    real_bounds.y+real_bounds.h-8,
                    16,8)
            }
        };

        canvas.renderer.render( ScrollArea, this );
        drag_offset = new Point();

    } //new

    public override function add(child:Control) {

        super.add(child);
        on_internal_scroll(0,0);

        child.clip_with( this );
        depth = depth;

    } //add

    var drag_offset:Point;
    public override function onmousedown(e : MouseEvent) {

        var forward = true;

        if(scroll.h.enabled || scroll.v.enabled) {

            var m = new Point(e.x, e.y);

            if(scroll.h.enabled && scroll.h.bounds.point_inside(m)) {
                drag_offset.x = e.x - scroll.h.bounds.x;
                handle_drag_h = true;
                last_modal = canvas.modal;
                canvas.modal = this;
                forward = false;
            }

            if(scroll.v.enabled && scroll.v.bounds.point_inside(m)) {
                drag_offset.y = e.y - scroll.v.bounds.y;
                handle_drag_v = true;
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

        if(handle_drag_v || handle_drag_h) {
            handle_drag_v = false;
            handle_drag_h = false;
            canvas.modal = last_modal;
        }

    } //onmouseup

    public override function onmousemove(e : MouseEvent) {

        super.onmousemove(e);

        if(handle_drag_v) {
            set_scroll_y( e.y-real_bounds.y-drag_offset.y );
        }

        if(handle_drag_h) {
            set_scroll_x( e.x-real_bounds.x-drag_offset.x );
        }

    } //onmousemove

    public override function onmousewheel(e:MouseEvent) {

            //forward to
        super.onmousewheel(e);

        if(e.x != 0 && scroll.h.enabled) {
            set_scroll_x((scroll.h.amount)-(real_bounds.w*0.03*e.x));
        }

        if(e.y != 0 && scroll.v.enabled) {
            set_scroll_y((scroll.v.amount)-(real_bounds.h*0.01*e.y));
        }

    } //onmousewheel

    public override function translate(?_x:Float = 0, ?_y:Float = 0, ?_offset:Bool = false ) {

        scroll.h.bounds.x += _x;
        scroll.h.bounds.y += _y;
        scroll.v.bounds.x += _x;
        scroll.v.bounds.y += _y;

        super.translate(_x, _y, _offset);

    } //translate

    function on_internal_scroll(_dx:Float, _dy:Float) {

        if(_dx != 0 || _dy != 0) {

                //tell the children to scroll the delta
            for(child in children) {
                child.translate(_dx, _dy, true);
            }

        } //has delta

        check_handle_vis();

        onscroll.emit(_dx, _dy);

        scroll.h.bounds.x += _dx;
        scroll.v.bounds.y += _dy;

    } //on_internal_scroll

    function check_handle_vis() {

            //make sure the child bounds are up to date
        child_bounds = children_bounds;

            //make sure the scroll goes away when too small
        scroll.h.enabled = false;
        scroll.v.enabled = false;

            //if the children bounds are < our size, it can't scroll
        if(child_bounds.real_w <= real_bounds.w) {
            scroll.h.enabled = false;
        } else {
            scroll.h.enabled = true;
        }

        if(child_bounds.real_h <= real_bounds.h) {
            scroll.v.enabled = false;
        } else {
            scroll.v.enabled = true;
        }

    } //check_handle_vis

        //set the scroll value directly in pixels, between 0 and bounds.h
    public function set_scroll_y(exact:Float) {

        if(!scroll.v.enabled) return;

            //can't go outside the bounds
        exact = Utils.clamp( exact, 0, real_bounds.h );

            //for a delta
        var last_p_y = scroll.v.percent;
            //the new percent is based on the size of the control
        scroll.v.percent = Utils.clamp(exact / (real_bounds.h-scroll.v.bounds.h), 0, 1);
        scroll.v.amount = exact;
            //we need the difference in scroll amount in pixels
        var pdiff = (last_p_y - scroll.v.percent) * (child_bounds.real_h - real_bounds.h);
            //update the real slider y value
        scroll.v.bounds.y = Utils.clamp( real_bounds.y + exact, real_bounds.y, real_bounds.y+real_bounds.h-scroll.v.bounds.h );

        on_internal_scroll(0, pdiff);

    } //set_scroll_y

    public function set_scroll_x(exact:Float) {

        if(!scroll.h.enabled) return;

            //limit to the size of the control
        exact = Utils.clamp( exact, 0, real_bounds.w );

            //for a delta
        var last_p_x = scroll.h.percent;
            //the new percent is based on the size of the control
        scroll.h.percent = Utils.clamp(exact / real_bounds.w, 0, 1);
        scroll.h.amount = exact;
            //we need the difference in scroll amount in pixels
        var pdiff = (last_p_x - scroll.h.percent) * (child_bounds.real_w - real_bounds.w);
            //update the real slider x value
        scroll.h.bounds.x = Utils.clamp( real_bounds.x + exact, real_bounds.x, real_bounds.x+real_bounds.w-scroll.h.bounds.w );

        on_internal_scroll(pdiff, 0);

    } //set_scroll_x

} //ScrollArea
