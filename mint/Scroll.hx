package mint;

import mint.Control;

import mint.types.Types;
import mint.types.Types.Helper.in_rect;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a scroll area */
typedef ScrollOptions = {

    > ControlOptions,

    ?units_to_scroll_h: Float,
    ?units_to_scroll_v: Float

} //ScrollOptions


@:allow(mint.render.Renderer)
class Scroll extends Control {

    public var scrollh: mint.Control;
    public var scrollv: mint.Control;
    public var container: mint.Control;
    public var child_bounds : ChildBounds;

    public var onchange : Signal<Void->Void>;
    public var onhandlevis : Signal<Bool->Bool->Void>;

    public var units_to_scroll_h: Float = 16;
    public var units_to_scroll_v: Float = 16;

    var drag_v = false;
    var drag_y = 0.0;
    var percent_v = 0.0;
    var visible_v = false;

    var drag_h = false;
    var drag_x = 0.0;
    var percent_h = 0.0;
    var visible_h = false;

    var options: ScrollOptions;
    var ready = false;

//Public API

    public function new(_options:ScrollOptions) {

        onchange = new Signal();
        onhandlevis = new Signal();

        options = _options;

        def(options.name, 'scroll.${Helper.uniqueid()}');
        def(options.mouse_input, true);
        
        units_to_scroll_h = def(options.units_to_scroll_h, 16);
        units_to_scroll_v = def(options.units_to_scroll_v, 16);

        super(_options);

        container = new mint.Control({
            parent : this,
            name: '$name.container',
            mouse_input: true,
            internal_visible: options.visible,
            x:0, y:0, w:w, h:h
        });

        scrollv = new mint.Control({
            parent : this, name: '$name.scroll_v',
            mouse_input: true,
            internal_visible: options.visible,
            x: w-8, y: 0, w: 8, h: 16
        });

        scrollh = new mint.Control({
            parent : this, name: '$name.scroll_h',
            mouse_input: true,
            internal_visible: options.visible,
            x: 0, y: h-8, w: 16, h: 8
        });

        child_bounds = container.children_bounds;

        container.clip_with = this;
        scrollv.clip_with = this;
        scrollh.clip_with = this;

        ready = true;

        scrollv.onmousedown.listen(scrollvdown);
        scrollv.onmouseup.listen(scrollvup);
        scrollv.onmousemove.listen(scrollvmove);

        scrollh.onmousedown.listen(scrollhdown);
        scrollh.onmouseup.listen(scrollhup);
        scrollh.onmousemove.listen(scrollhmove);

        renderer = rendering.get( Scroll, this );

        oncreate.emit();

    } //new

    public function set_scroll_percent(?_horizontal:Null<Float>, ?_vertical:Null<Float>) {

        percent_v = def(_vertical, percent_v);
        percent_h = def(_horizontal, percent_h);

        percent_v = Helper.clamp(percent_v, 0, 1);
        percent_h = Helper.clamp(percent_h, 0, 1);

        update_scroll();

    } //set_scroll_percent

    public function update_container() {

        if(!ready) return;

        child_bounds = container.children_bounds;

        container.w = child_bounds.real_w;
        container.h = child_bounds.real_h;

    } //update_container

//Internal

//vertical

    function scrollvdown(e:MouseEvent,_) {

        if(!visible_v) return;

        drag_v = true;
        drag_y = e.y - scrollv.y;
        scrollv.capture();

    } //scrollvdown

    function scrollvup(e:MouseEvent,_) {

        drag_v = false;
        scrollv.uncapture();

    } //scrollvup

    function scrollvmove(e:MouseEvent,_) {

        if(drag_v && visible_v) {

            var _dest = Helper.clamp(e.y-drag_y, y, bottom-scrollv.h);
            percent_v = (_dest-y) / (h-scrollv.h);
            update_scroll();

        } //drag_v

    } //scrollvmove

//horizontal

    function scrollhdown(e:MouseEvent,_) {

        if(!visible_h) return;

        drag_h = true;
        drag_x = e.x - scrollh.x;
        scrollh.capture();

    } //scrollhdown

    function scrollhup(e:MouseEvent,_) {

        drag_h = false;
        scrollh.uncapture();

    } //scrollhup

    function scrollhmove(e:MouseEvent,_) {

        if(drag_h && visible_h) {

            var _dest = Helper.clamp(e.x-drag_x, x, right-scrollh.w);
            percent_h = (_dest-x) / (w-scrollh.w);
            update_scroll();

        } //drag_h

    } //scrollvmove

//Refresh all relevant values

    function update_scroll() {

        if(!ready) return;

            //:todo: this should generally
            //only be calculated when the children
            //bounds are changing, where that calls this
        // update_container();

        var _dy = (h - container.h);
        var _dx = (w - container.w);

        visible_h = _dx < 0;
        visible_v = _dy < 0;

        if(_dx >= 0) _dx = 0;
        if(_dy >= 0) _dy = 0;

        container.x = x + (_dx * percent_h);
        container.y = y + (_dy * percent_v);

        scrollh.x = x + (percent_h * (w-scrollh.w));
        scrollv.y = y + (percent_v * (h-scrollv.h));

        onchange.emit();
        onhandlevis.emit(visible_h, visible_v);

    } //update_scroll

    inline function get_step_h() return units_to_scroll_h / container.w;
    inline function get_step_v() return units_to_scroll_v / container.h;

//Control overrides

    public override function destroy() {

            //:todo: hmm
        ready = false;

        super.destroy();

        onchange.clear();
        onchange = null;
        onhandlevis.clear();
        onhandlevis = null;

    } //destroy

    public override function add(child:Control) {

            //if the internal controls add them normally
        if(!ready) {

            super.add(child);

        } else {

            container.add(child);

            refresh_scroll();

            child.clip_with = this;
            // depth = depth;

        } //

    } //add

    public function refresh_scroll() {

        update_container();
        update_scroll();

    } //refresh_scroll

    public override function remove(child:Control) {

        super.remove(child);

        refresh_scroll();

    } //remove

    public override function mousewheel(e:MouseEvent) {

        super.mousewheel(e);

        if(e.x != 0 && visible_h) {
            var _dir = Helper.sign(e.x);
            set_scroll_percent(percent_h + (_dir*get_step_h()), percent_v);
        }

        if(e.y != 0 && visible_v) {
            var _dir = Helper.sign(e.y);
            set_scroll_percent(percent_h, percent_v + (_dir*get_step_v()));
        }

    } //mousewheel

    override function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0) {

        super.bounds_changed(_dx, _dy, _dw, _dh);

        refresh_scroll();

        if(scrollh != null) scrollh.y_local = h-8;
        if(scrollv != null) scrollv.x_local = w-8;

    } //bounds_changed

} //Scroll
