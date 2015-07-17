package mint;

import mint.Types;
import mint.Control;
import mint.Signal;
import mint.Macros.*;

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

@:allow(mint.ControlRenderer)
class ScrollArea extends Control {

    public var scroll: { v:ScrollInfo, h:ScrollInfo };

    public var child_bounds : ChildBounds;

    public var onscroll : Signal<Float->Float->Void>;
    public var onhandlevis : Signal<Bool->Bool->Void>;

    var handle_drag_v = false;
    var handle_drag_h = false;

    var last_modal : Control;

    var options: ScrollAreaOptions;

    public function new(_options:ScrollAreaOptions) {

        onscroll = new Signal();
        onhandlevis = new Signal();

        options = _options;

        def(options.name, 'scroll');

        super(_options);

        if(options.mouse_input == null){
            mouse_input = true;
        }

        scroll = {
            v: {
                enabled: false, percent: 0, amount: 0,
                bounds: new Rect(
                    x+w-8,
                    y,
                    8,16)
            },
            h: {
                enabled: false, percent: 0, amount: 0,
                bounds: new Rect(
                    x,
                    y+h-8,
                    16,8)
            }
        };

        renderinst = render_service.render( ScrollArea, this );
        drag_offset = new Point();
        check_handle_vis();

    } //new

    public override function add(child:Control) {

        super.add(child);
        on_internal_scroll(0,0);

        child.clip_with( this );
        depth = depth;

    } //add

    var drag_offset:Point;
    public override function mousedown(e : MouseEvent) {

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
            super.mousedown(e);
        }

    } //mousedown

    public override function mouseup(e : MouseEvent) {

        super.mouseup(e);

        drag_offset.set(0,0);

        if(handle_drag_v || handle_drag_h) {
            handle_drag_v = false;
            handle_drag_h = false;
            canvas.modal = last_modal;
        }

    } //mouseup

    public override function mousemove(e : MouseEvent) {

        super.mousemove(e);

        if(handle_drag_v) {
            set_scroll_y( e.y-y-drag_offset.y );
        }

        if(handle_drag_h) {
            set_scroll_x( e.x-x-drag_offset.x );
        }

    } //mousemove

    public override function mousewheel(e:MouseEvent) {

            //forward to
        super.mousewheel(e);

        if(e.x != 0 && scroll.h.enabled) {
            set_scroll_x((scroll.h.amount)+(w*0.03*e.x));
        }

        if(e.y != 0 && scroll.v.enabled) {
            set_scroll_y((scroll.v.amount)+(h*0.01*e.y));
        }

    } //mousewheel


    override function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0, ?_offset:Bool = false ) {

        if(scroll != null) {
            scroll.v.bounds.x = x+w-8;
            scroll.v.bounds.y = y+scroll.v.amount;
            scroll.h.bounds.x = x+scroll.h.amount;
            scroll.h.bounds.y = y+h-8;
        }

        super.bounds_changed(_dx, _dy, _dw, _dh, _offset);

    } //bounds_changed

    function on_internal_scroll(_dx:Float, _dy:Float) {

        if(_dx != 0 || _dy != 0) {

                //tell the children to scroll the delta
            for(child in children) {
                child.set_pos(child.x+_dx, child.y+_dy, true);
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

        var _preh = scroll.h.enabled;
        var _prev = scroll.v.enabled;

            //make sure the scroll goes away when too small
        scroll.h.enabled = false;
        scroll.v.enabled = false;

            //if the children bounds are < our size, it can't scroll
        if(child_bounds.real_w <= w) {
            scroll.h.enabled = false;
        } else {
            scroll.h.enabled = true;
        }

        if(child_bounds.real_h <= h) {
            scroll.v.enabled = false;
        } else {
            scroll.v.enabled = true;
        }

        onhandlevis.emit(scroll.h.enabled, scroll.v.enabled);

    } //check_handle_vis

        //set the scroll value directly in pixels, between 0 and h
    public function set_scroll_y(exact:Float) {

        if(!scroll.v.enabled) return;

            //can't go outside the bounds
        exact = Utils.clamp( exact, 0, h );

            //for a delta
        var last_p_y = scroll.v.percent;
            //the new percent is based on the size of the control
        scroll.v.percent = Utils.clamp(exact / (h-scroll.v.bounds.h), 0, 1);
        scroll.v.amount = exact;
            //we need the difference in scroll amount in pixels
        var pdiff = (last_p_y - scroll.v.percent) * (child_bounds.real_h - h);
            //update the real slider y value
        scroll.v.bounds.y = Utils.clamp( y + exact, y, y+h-scroll.v.bounds.h );

        on_internal_scroll(0, pdiff);

    } //set_scroll_y

    public function set_scroll_x(exact:Float) {

        if(!scroll.h.enabled) return;

            //limit to the size of the control
        exact = Utils.clamp( exact, 0, w );

            //for a delta
        var last_p_x = scroll.h.percent;
            //the new percent is based on the size of the control
        scroll.h.percent = Utils.clamp(exact / w, 0, 1);
        scroll.h.amount = exact;
            //we need the difference in scroll amount in pixels
        var pdiff = (last_p_x - scroll.h.percent) * (child_bounds.real_w - w);
            //update the real slider x value
        scroll.h.bounds.x = Utils.clamp( x + exact, x, x+w-scroll.h.bounds.w );

        on_internal_scroll(pdiff, 0);

    } //set_scroll_x

} //ScrollArea
