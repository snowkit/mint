package mint;

import mint.Control;

import mint.types.Types;
import mint.types.Types.Helper.in_rect;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a scroll area */
typedef ScrollOptions = {

    > ControlOptions,

} //ScrollOptions


@:allow(mint.render.Renderer)
class Scroll extends Control {

    public var scroll: { v:ScrollInfo, h:ScrollInfo };

    public var child_bounds : ChildBounds;

    public var onscroll : Signal<Float->Float->Void>;
    public var onhandlevis : Signal<Bool->Bool->Void>;

    var handle_drag_v = false;
    var handle_drag_h = false;
    var drag_offset_x = 0.0;
    var drag_offset_y = 0.0;

    var last_modal : Control;

    var options: ScrollOptions;

    public function new(_options:ScrollOptions) {

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
                x: x+w-8, y: y, w: 8, h: 16
            },
            h: {
                enabled: false, percent: 0, amount: 0,
                x: x, y: y+h-8, w: 16, h: 8
            }
        };

        renderer = rendering.get( Scroll, this );
        check_handle_vis();

    } //new

    public override function add(child:Control) {

        super.add(child);
        on_internal_scroll(0,0);

        child.clip_with = this;
        depth = depth;

    } //add

    public override function mousedown(e : MouseEvent) {

        var forward = true;

        if(scroll.h.enabled || scroll.v.enabled) {

            if(scroll.h.enabled && in_rect(e.x, e.y, scroll.h.x, scroll.h.y, scroll.h.w, scroll.h.h)) {
                drag_offset_x = e.x - scroll.h.x;
                handle_drag_h = true;
                last_modal = canvas.modal;
                canvas.modal = this;
                forward = false;
            }

            if(scroll.v.enabled && in_rect(e.x, e.y, scroll.v.x, scroll.v.y, scroll.v.w, scroll.v.h)) {
                drag_offset_y = e.y - scroll.v.y;
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

        drag_offset_x = 0;
        drag_offset_y = 0;

        if(handle_drag_v || handle_drag_h) {
            handle_drag_v = false;
            handle_drag_h = false;
            canvas.modal = last_modal;
        }

    } //mouseup

    public override function mousemove(e : MouseEvent) {

        super.mousemove(e);

        if(handle_drag_v) {
            set_scroll_y( e.y-y-drag_offset_y );
        }

        if(handle_drag_h) {
            set_scroll_x( e.x-x-drag_offset_x );
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
            scroll.v.x = x+w-8;
            scroll.v.y = y+scroll.v.amount;
            scroll.h.x = x+scroll.h.amount;
            scroll.h.y = y+h-8;
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

        scroll.h.x += _dx;
        scroll.v.y += _dy;

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
        exact = Helper.clamp( exact, 0, h );

            //for a delta
        var last_p_y = scroll.v.percent;
            //the new percent is based on the size of the control
        scroll.v.percent = Helper.clamp(exact / (h-scroll.v.h), 0, 1);
        scroll.v.amount = exact;
            //we need the difference in scroll amount in pixels
        var pdiff = (last_p_y - scroll.v.percent) * (child_bounds.real_h - h);
            //update the real slider y value
        scroll.v.y = Helper.clamp( y + exact, y, y+h-scroll.v.h );

        on_internal_scroll(0, pdiff);

    } //set_scroll_y

    public function set_scroll_x(exact:Float) {

        if(!scroll.h.enabled) return;

            //limit to the size of the control
        exact = Helper.clamp( exact, 0, w );

            //for a delta
        var last_p_x = scroll.h.percent;
            //the new percent is based on the size of the control
        scroll.h.percent = Helper.clamp(exact / w, 0, 1);
        scroll.h.amount = exact;
            //we need the difference in scroll amount in pixels
        var pdiff = (last_p_x - scroll.h.percent) * (child_bounds.real_w - w);
            //update the real slider x value
        scroll.h.x = Helper.clamp( x + exact, x, x+w-scroll.h.w );

        on_internal_scroll(pdiff, 0);

    } //set_scroll_x

} //Scroll


private typedef ScrollInfo = {
    enabled: Bool,
    percent: Float,
    amount: Float,
    x:Float,
    y:Float,
    w:Float,
    h:Float
}