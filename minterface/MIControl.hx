package minterface;

import minterface.MITypes;

    //base class for all controls
    //handles propogation of events,
    //mouse handling, alignment, so on

typedef ChildBounds = {
    var x : Float;
    var y : Float;
    var bottom : Float;
    var right : Float;

    var real_y : Float;
    var real_x : Float;
    var real_w : Float;
    var real_h : Float;
}

class MIControl {

    public var name : String = 'control';

        //parent canvas that this element belongs to
    public var canvas : MICanvas;
        //the renderer that is handling the canvas
    public var renderer : MIRenderer;
        //the top most control below the canvas that holds us
    public var closest_to_canvas : MIControl;

        //the items specific to rendering this item
    public var render_items : Map<String, Dynamic>;

        //the relative bounds to the parent
    public var bounds : MIRectangle;
        //the absolute bounds in screen space
    public var real_bounds : MIRectangle;
        //the clipping rectangle for this control
    public var clip_rect : MIRectangle;
        //the list of children added to this control
    public var children : Array<MIControl>;
        //if the control is under the mouse
    public var isfocused : Bool = false;
        //if the control is under the mouse
    public var ishovered : Bool = false;
        //if the control is visible
    public var visible : Bool = true;
        //if the control accepts mouse events
    public var mouse_enabled : Bool = true;

        //a getter for the bounds information about the children and their children in this control
    @:isVar public var children_bounds (get,null) : ChildBounds;

        //a shortcut to adding multiple mousedown handlers
    @:isVar public var mousedown (get,set) : MIControl->?MIMouseEvent->Void;
        //a shortcut to adding multiple mouseup handlers
    @:isVar public var mouseup (get,set) : MIControl->?MIMouseEvent->Void;
        //a shortcut to adding multiple mousemove handlers
    @:isVar public var mousemove (get,set) : MIControl->?MIMouseEvent->Void;
        //a shortcut to adding multiple mousewheel handlers
    @:isVar public var mousewheel (get,set) : MIControl->?MIMouseEvent->Void;
        //a shortcut to adding multiple mouseenter handlers
    @:isVar public var mouseenter (get,set) : MIControl->?MIMouseEvent->Void;
        //a shortcut to adding multiple mouseenter handlers
    @:isVar public var mouseleave (get,set) : MIControl->?MIMouseEvent->Void;
        //the parent control, null if no parent
    @:isVar public var parent(get,set) : MIControl;
        //the depth of this control
    @:isVar public var depth(get,set) : Float = 0.0;

        //the list of internal handlers, for calling
    var mouse_down_handlers : Array<MIControl->?MIMouseEvent->Void>;
        //the list of internal handlers, for calling
    var mouse_up_handlers : Array<MIControl->?MIMouseEvent->Void>;
        //the list of internal handlers, for calling
    var mouse_move_handlers : Array<MIControl->?MIMouseEvent->Void>;
        //the list of internal handlers, for calling
    var mouse_wheel_handlers : Array<MIControl->?MIMouseEvent->Void>;
        //the list of internal handlers, for calling
    var mouse_enter_handlers : Array<MIControl->?MIMouseEvent->Void>;
        //the list of internal handlers, for calling
    var mouse_leave_handlers : Array<MIControl->?MIMouseEvent->Void>;

    public function new(_options:Dynamic) {

        render_items = new Map<String,Dynamic>();

        bounds = _options.bounds == null ? new MIRectangle(0,0,32,32) : _options.bounds;
        real_bounds = bounds.clone();

        if(_options.name != null) { name = _options.name; }

        children = [];
        mouse_down_handlers = [];
        mouse_up_handlers = [];
        mouse_move_handlers = [];
        mouse_wheel_handlers = [];
        mouse_leave_handlers = [];
        mouse_enter_handlers = [];

        children_bounds = {
            x:0,
            y:0,
            right:0,
            bottom:0,
            real_x : 0,
            real_y : 0,
            real_w : 0,
            real_h : 0
        };

        if(_options.parent != null) {

            renderer = _options.parent.renderer;
            canvas = _options.parent.canvas;
            depth = canvas.next_depth();
            _options.parent.add(this);

        } else { //parent != null

            if( !Std.is(this, MICanvas) && canvas == null) {
                throw "Control without a canvas " + _options;
            } //canvas
        }

            //closest_to_canvas
        closest_to_canvas = find_top_parent();

    } //new

    public function topmost_child_under_point( _p:MIPoint ) : MIControl {

            //if we have no children, we are the topmost child
        if(children.length == 0) return this;

            //if we have children, we look at each one, looking for the highest one
            //after we have the highest one, we ask it to return it's own highest child

        var highest_child : MIControl = this;
        var highest_depth : Float = 0;

        for(_child in children) {
            if(_child.contains_point(_p) && _child.mouse_enabled && _child.visible) {

                if(_child.depth >= highest_depth) {
                    highest_child = _child;
                    highest_depth = _child.depth;
                } //highest_depth

            } //child contains point
        } //child in children

        if(highest_child != this && highest_child.children.length != 0) {
            return highest_child.topmost_child_under_point(_p);
        } else {
            return highest_child;
        }

    } //topmost_child_under_point

    public function contains_point( _p:MIPoint ) {

            //if we aren't inside the clip_rect
            //we aren't going to be reporting true
        if(clip_rect != null) {
            if(!clip_rect.point_inside(_p)) {
                return false;
            }
        }

        return real_bounds.point_inside(_p);

    } //contains point

    function clip_with_closest_to_canvas() {
        if(closest_to_canvas != null) {
            set_clip( closest_to_canvas.real_bounds );
        }
    } //clip_with_closest_to_canvas


    public function clip_with( ?_control:MIControl ) {
        if(_control != null) {
            var _b = _control.real_bounds;
            set_clip( new MIRectangle(_b.x, _b.y, _b.w-1, _b.h-1) );
        } else {
            set_clip();
        }
    } //clip_with

    public function set_clip( ?_clip_rect:MIRectangle = null ) {
        //temporarily, all children clip by their parent clip

        clip_rect = _clip_rect;

        // for(_child in children) {
        //  _child.set_clip( _clip_rect );
        // }

    } //set clip

    public function set_visible( ?_visible:Bool = true ) {

        visible = _visible;

        canvas.focus_invalid = true;

        for(_child in children) {
            _child.set_visible( _visible );
        }

    } //set visible

    function find_top_parent( ?_from:MIControl = null ) {

        var _target = (_from == null) ? this : _from;

        if(_target == null || _target.parent == null) {
            return null;
        }

            //if the parent of the target is not canvas,
            //keep escalating until it is
        if( Std.is( _target.parent, MICanvas ) ) {
            return _target;
        } else { //is
            return parent.find_top_parent( this );
        }

    } //find_top_parent

    function get_mouseenter() {
        return mouse_enter_handlers[0];
    }

    function get_mousedown() {
        return mouse_down_handlers[0];
    }

    function get_mouseup() {
        return mouse_up_handlers[0];
    }

    function get_mousewheel() {
        return mouse_wheel_handlers[0];
    }

    function get_mousemove() {
        return mouse_move_handlers[0];
    }

    function get_mouseleave() {
        return mouse_leave_handlers[0];
    }

    function set_mouseenter( listener: MIControl->?MIMouseEvent->Void ) {
        mouse_enter_handlers.push(listener);
        return listener;
    }
    function set_mousedown( listener: MIControl->?MIMouseEvent->Void ) {
        mouse_down_handlers.push(listener);
        return listener;
    }
    function set_mouseup( listener: MIControl->?MIMouseEvent->Void ) {
        mouse_up_handlers.push(listener);
        return listener;
    }
    function set_mousemove( listener: MIControl->?MIMouseEvent->Void ) {
        mouse_move_handlers.push(listener);
        return listener;
    }
    function set_mousewheel( listener: MIControl->?MIMouseEvent->Void ) {
        mouse_wheel_handlers.push(listener);
        return listener;
    }
    function set_mouseleave( listener: MIControl->?MIMouseEvent->Void ) {
        mouse_leave_handlers.push(listener);
        return listener;
    }

    public function add( child:MIControl ) {
        if(child.parent != this) {
            child.parent = this;
            children.push(child);
        }
    }

    public function remove( child:MIControl ) {
        if(child.parent == this) {
            children.remove(child);
        }
    }

        //if translating in offset mode, we don't update the clip rect and other stuff
        //this happens for example when moving children around from a scroll view, just
        //offseting their positions, not moving them as a whole
    public function translate( ?_x : Float = 0, ?_y : Float = 0, ?_offset:Bool = false ) {

        real_bounds.x += _x;
        real_bounds.y += _y;

        if(parent != null) {
            bounds.x = real_bounds.x - parent.real_bounds.x;
            bounds.y = real_bounds.y - parent.real_bounds.y;
        }

        if(clip_rect != null && !_offset) {
            clip_rect.x += _x;
            clip_rect.y += _y;
        }

        for(child in children) {
            child.translate( _x, _y, _offset );
        }

        canvas.focus_invalid = true;

    } //translate

    private function options_plus(options:Dynamic, plus:Dynamic) {

        var _fields = Reflect.fields(plus);

        for(_field in _fields) {
            Reflect.setField(options, _field, Reflect.field( plus, _field ) );
        }

        return options;

    } //options_plus

    public function right() {
        return bounds.x + bounds.w;
    } //right

    public function bottom() {
        return bounds.y + bounds.h;
    } //bottom

    function get_children_bounds() : ChildBounds {

        if(children.length == 0) {

            children_bounds.x = 0;
            children_bounds.y = 0;
            children_bounds.right = 0;
            children_bounds.bottom = 0;
            children_bounds.real_x = 0;
            children_bounds.real_y = 0;
            children_bounds.real_w = 0;
            children_bounds.real_h = 0;

            return children_bounds;

        } //no children

        var _first_child = children[0];

        var _current_x : Float = _first_child.bounds.x;
        var _current_y : Float = _first_child.bounds.y;
        var _current_r : Float = _first_child.right();
        var _current_b : Float = _first_child.bottom();

        var _real_x : Float = _first_child.real_bounds.x;
        var _real_y : Float = _first_child.real_bounds.y;

        for(child in children) {

            _current_x = Math.min( child.bounds.x, _current_x );
            _current_y = Math.min( child.bounds.y, _current_y );
            _current_r = Math.max( _current_r, child.right() );
            _current_b = Math.max( _current_b, child.bottom() );

            _real_x = Math.min( child.real_bounds.x, _real_x );
            _real_y = Math.min( child.real_bounds.y, _real_y );

        } //child in children

        children_bounds.x = _current_x;
        children_bounds.y = _current_y;
        children_bounds.right = _current_r;
        children_bounds.bottom = _current_b;
        children_bounds.real_x = _real_x;
        children_bounds.real_y = _real_y;
        children_bounds.real_w = _current_r - _first_child.bounds.x;
        children_bounds.real_h = _current_b - _first_child.bounds.y;

        return children_bounds;

    } //children_bounds


    public function onmousemove( e:MIMouseEvent ) {

        if(mousemove != null) {
            for(handler in mouse_move_handlers) {
                handler(this, e);
            }
        } //mousemove != null

            //events bubble upward into the parent
        if(parent != null && parent != canvas && e.bubble) {
            parent.onmousemove(e);
        } //parent not null and parent not canvas

    } //onmousemove

    public function onmouseup( e:MIMouseEvent ) {

        if(mouseup != null) {
            for(handler in mouse_up_handlers) {
                handler(this, e);
            }
        } //mouseup != null

            //events bubble upward into the parent
        if(parent != null && parent != canvas && e.bubble) {
            parent.onmouseup(e);
        } //parent not null and parent not canvas

    } //onmouseup

    public function onmousewheel( e:MIMouseEvent ) {

        if(mousewheel != null) {
            for(handler in mouse_wheel_handlers) {
                handler(this, e);
            }
        } //mousewheel != null

            //events bubble upward into the parent
        if(parent != null && parent != canvas && e.bubble) {
            parent.onmousewheel(e);
        } //parent not null and parent not canvas

    } //onmousewheel

    public function onmousedown( e:MIMouseEvent ) {

        if(mousedown != null) {
            for(handler in mouse_down_handlers) {
                handler(this, e);
            }
        } //mousedown != null

            //events bubble upward into the parent
        if(parent != null && parent != canvas && e.bubble) {
            parent.onmousedown(e);
        } //parent not null and parent not canvas

    } //onmousedown

    public function onmouseenter( e:MIMouseEvent ) {
        // trace('mouse enter ' + name);

        if(mouseenter != null) {
            for(handler in mouse_enter_handlers) {
                handler(this, e);
            }
        } //mouseenter != null

    }

    public function onmouseleave( e:MIMouseEvent ) {
        // trace('mouse leave ' + name);
        if(mouseleave != null) {
            for(handler in mouse_leave_handlers) {
                handler(this, e);
            }
        } //mouseleave != null

    }

    public function destroy() {
        if(parent != null) {
            parent.remove(this);
        }
    } //destroy

    public function update(dt:Float) {

    } //update

//Properties
//Depth properties

    private function get_depth() : Float {

        return depth;

    } //get_depth

    private function set_depth( _depth:Float ) : Float {

        depth = _depth;

        if(canvas != this) {
            for(child in children) {
                child.depth = _depth+0.001;
            }
        }

        return depth;

    } //set_depth

//Parent properties

    private function set_parent(p:MIControl) {

        if(p != null) {
            real_bounds.set( p.real_bounds.x+bounds.x, p.real_bounds.y+bounds.y, bounds.w, bounds.h);
        } else {
            real_bounds.set(bounds.x, bounds.y, bounds.w, bounds.h);
        }

        return parent = p;

    } //set_parent

    private function get_parent() {

        return parent;

    } //get_parent

} //MIControl

