package mint;

import mint.Types;
import mint.Signal;
import mint.Renderer;

typedef MouseSignal = MouseEvent->Control->Void;

typedef ControlOptions = {

        /** The control name */
    @:optional var name: String;
        /** The control bounds */
    @:optional var bounds: Rect;
        /** The control parent, if any */
    @:optional var parent: Control;
        /** The control depth. Usually set internally */
    @:optional var depth: Float;
        /** Whether or not the control is visible at creation */
    @:optional var visible: Bool;
        /** Whether or not the control responds to mouse input */
    @:optional var mouse_enabled: Bool;

} //ControlOptions


//base class for all controls
//handles propogation of events,
//mouse handling, alignment, so on
@:allow(mint.ControlRenderer)
class Control {

    public var name : String = 'control';
        //parent canvas that this element belongs to
    public var canvas : Canvas;
        //the top most control below the canvas that holds us
    public var closest_to_canvas : Control;

        //the relative bounds to the parent
    @:isVar public var bounds (default, set): Rect;
        //the offset bounds relative to the bounds
    @:isVar public var offset (default, set): Point;

        //the absolute bounds in screen space
    public var real_bounds : Rect;
        //the clipping rectangle for this control
    public var clip_rect : Rect;
        //the list of children added to this control
    public var children : Array<Control>;
        //if the control is under the mouse
    public var isfocused : Bool = false;
        //if the control is under the mouse
    public var ishovered : Bool = false;
        //if the control accepts mouse events
    public var mouse_enabled : Bool = false;

        //if the control is visible
    @:isVar public var visible (default, set) : Bool = true;
        //a getter for the bounds information about the children and their children in this control
    @:isVar public var children_bounds (get,null) : ChildBounds;

        //a shortcut to adding multiple mousedown handlers
    public var mousedown : Signal<MouseSignal>;
        //a shortcut to adding multiple mouseup handlers
    public var mouseup : Signal<MouseSignal>;
        //a shortcut to adding multiple mousemove handlers
    public var mousemove : Signal<MouseSignal>;
        //a shortcut to adding multiple mousewheel handlers
    public var mousewheel : Signal<MouseSignal>;
        //a shortcut to adding multiple mouseenter handlers
    public var mouseenter : Signal<MouseSignal>;
        //a shortcut to adding multiple mouseenter handlers
    public var mouseleave : Signal<MouseSignal>;

        //a shortcut to adding multiple mouseenter handlers
    public var onbounds : Signal<Void->Void>;

        //the parent control, null if no parent
    @:isVar public var parent(get,set) : Control;
        //the depth of this control
    @:isVar public var depth(get,set) : Float = 0.0;

    var ctrloptions : ControlOptions;
    var ondestroy   : Signal<Void->Void>;
    var onvisible   : Signal<Bool->Void>;
    var ondepth     : Signal<Float->Void>;
    var ontranslate : Signal<Float->Float->Bool->Void>;
    var onclip      : Signal<Rect->Void>;
    var onchild     : Signal<Control->Void>;

    public function new( _options:ControlOptions ) {

        ctrloptions = _options;

        onbounds = new Signal();
        ondestroy = new Signal();
        onvisible = new Signal();
        ondepth = new Signal();
        ontranslate = new Signal();
        onclip = new Signal();
        onchild = new Signal();

        bounds = ctrloptions.bounds == null ? new Rect(0,0,32,32) : ctrloptions.bounds;
        offset = new Point(0,0);

        real_bounds = new Rect(bounds.x+offset.x, bounds.y+offset.y, bounds.w, bounds.h);

        if(ctrloptions.name != null)            { name = ctrloptions.name; }
        if(ctrloptions.mouse_enabled != null)   { mouse_enabled = ctrloptions.mouse_enabled; }

        children = [];

        mousedown = new Signal();
        mouseup = new Signal();
        mousemove = new Signal();
        mousewheel = new Signal();
        mouseleave = new Signal();
        mouseenter = new Signal();

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

        if(ctrloptions.parent != null) {

            canvas = ctrloptions.parent.canvas;
            depth = canvas.next_depth();
            ctrloptions.parent.add(this);

        } else { //parent != null

            if( !Std.is(this, Canvas) && canvas == null) {
                throw "Control without a canvas " + ctrloptions;
            } //canvas
        }

            //closest_to_canvas
        closest_to_canvas = find_top_parent();

            //apply ctrloptions
        if(ctrloptions.visible != null)         { visible = ctrloptions.visible; }


    } //new

    public function topmost_child_under_point( _p:Point ) : Control {

            //if we have no children, we are the topmost child
        if(children.length == 0) return this;

            //if we have children, we look at each one, looking for the highest one
            //after we have the highest one, we ask it to return it's own highest child

        var highest_child : Control = this;
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

    public function contains_point( _p:Point ) {

            //if we aren't inside the clip_rect
            //we aren't going to be reporting true
        if(clip_rect != null) {
            if(!clip_rect.point_inside(_p)) {
                return false;
            }
        }

        return real_bounds.point_inside(_p);

    } //contains point


    function set_offset( _o:Point ) {

        var setup = offset == null;

        offset = _o;

        if(!setup) {
            bounds = bounds.set(bounds.x, bounds.y, bounds.w, bounds.h);
        }

        return offset;

    } //set_offset

    function set_bounds( _b:Rect ) {

        var setup = bounds == null;

        if(!setup) {
            if(parent != null) {
                real_bounds.set( parent.real_bounds.x+_b.x+offset.x, parent.real_bounds.y+_b.y+offset.y, _b.w, _b.h );
            } else {
                real_bounds.set( _b.x+offset.x, _b.y+offset.y, _b.w, _b.h );
            }
        }

        bounds = _b;

        if(!setup) {
            for(_child in children) {
                _child.bounds = _child.bounds.set(_child.bounds.x,_child.bounds.y,_child.bounds.w,_child.bounds.h);
            }
        }

        onbounds.emit();

        return bounds;

    } //set_bounds

    function clip_with_closest_to_canvas() {
        if(closest_to_canvas != null) {
            set_clip( closest_to_canvas.real_bounds );
        }
    } //clip_with_closest_to_canvas


    public function clip_with( ?_control:Control ) {
        if(_control != null) {
            var _b = _control.real_bounds;
            set_clip( new Rect(_b.x, _b.y, _b.w, _b.h) );
        } else {
            set_clip();
        }
    } //clip_with

    public function set_clip( ?_clip_rect:Rect = null ) {
        //temporarily, all children clip by their parent clip

        clip_rect = _clip_rect.clone();
        onclip.emit(clip_rect);

        for(_child in children) {
            _child.set_clip( clip_rect );
        }

    } //set clip

    function set_visible( _visible:Bool) {

        visible = _visible;
        onvisible.emit(visible);

        canvas.focus_invalid = true;

        for(_child in children) {
            _child.visible = visible;
        }

        return visible;

    } //set visible

    function find_top_parent( ?_from:Control = null ) {

        var _target = (_from == null) ? this : _from;

        if(_target == null || _target.parent == null) {
            return null;
        }

            //if the parent of the target is not canvas,
            //keep escalating until it is
        if( Std.is( _target.parent, Canvas ) ) {
            return _target;
        } else { //is
            return parent.find_top_parent( this );
        }

    } //find_top_parent

    public var nodes : Int = 0;
    public function add( child:Control ) {
        if(child.parent != null) {
            child.parent.remove(child);
            child.parent = null;
        }

        if(child.parent != this) {
            child.parent = this;
            children.push(child);

            if(parent != null || canvas == this) {
                var _nodes = child.nodes + 1;
                nodes += _nodes;
                if(parent != null) parent.nodes += _nodes;
            }

            onchild.emit(child);
        }
    }

    public function remove( child:Control ) {
        if(child.parent == this) {
            children.remove(child);

            if(parent != null || canvas == this) {
                var _nodes = child.nodes + 1;
                nodes -= _nodes;
                if(parent != null) parent.nodes -= _nodes;
            }

            onchild.emit(child);
        }
    }

        //if translating in offset mode, we don't update the clip rect and other stuff
        //this happens for example when moving children around from a scroll view, just
        //offseting their positions, not moving them as a whole
    public function translate( ?_x : Float = 0, ?_y : Float = 0, ?_offset:Bool = false ) {

        real_bounds.x += _x;
        real_bounds.y += _y;

        ontranslate.emit(_x, _y, _offset);

        for(child in children) {
            child.translate( _x, _y, _offset );
        }

        if(clip_rect != null && !_offset) {
            set_clip( clip_rect.set(clip_rect.x+_x, clip_rect.y+_y) );
        }

        canvas.focus_invalid = true;

    } //translate

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
        children_bounds.real_w = _current_r;
        children_bounds.real_h = _current_b;

        return children_bounds;

    } //children_bounds


    public function onmousemove( e:MouseEvent ) {

        mousemove.emit(e, this);

            //events bubble upward into the parent
        if(parent != null && parent != canvas && e.bubble) {
            parent.onmousemove(e);
        } //parent not null and parent not canvas

    } //onmousemove

    public function onmouseup( e:MouseEvent ) {

        mouseup.emit(e, this);

            //events bubble upward into the parent
        if(parent != null && parent != canvas && e.bubble) {
            parent.onmouseup(e);
        } //parent not null and parent not canvas

    } //onmouseup

    public function onmousewheel( e:MouseEvent ) {

        mousewheel.emit(e, this);

            //events bubble upward into the parent
        if(parent != null && parent != canvas && e.bubble) {
            parent.onmousewheel(e);
        } //parent not null and parent not canvas

    } //onmousewheel

    public function onmousedown( e:MouseEvent ) {

        mousedown.emit(e, this);

            //events bubble upward into the parent
        if( parent != null &&
            parent != canvas &&
            canvas != this &&
            e.bubble )
        {
            parent.onmousedown(e);
        } //parent not null and parent not canvas

    } //onmousedown

    public function onmouseenter( e:MouseEvent ) {

        mouseenter.emit(e, this);

    }

    public function onmouseleave( e:MouseEvent ) {
        mouseleave.emit(e, this);
    }

    public function destroy() {

        canvas.focus_invalid = true;

        if(parent != null) {
            parent.remove(this);
        }

        ondestroy.emit();

    } //destroy

    public function update(dt:Float) {

    } //update

//Properties
//Depth properties

    inline function get_depth() : Float {

        return depth;

    } //get_depth

    function set_depth( _depth:Float ) : Float {

        depth = _depth;
        ondepth.emit(depth);

        if(canvas != this) {
            for(child in children) {
                child.depth = _depth+0.001;
            }
        }

        return depth;

    } //set_depth

//Parent properties

    function set_parent(p:Control) {

        if(p != null) {
            real_bounds.set( p.real_bounds.x+bounds.x+offset.x, p.real_bounds.y+bounds.y+offset.y, bounds.w, bounds.h);
        } else {
            real_bounds.set(bounds.x+offset.x, bounds.y+offset.y, bounds.w, bounds.h);
        }

        return parent = p;

    } //set_parent

    inline function get_parent() {

        return parent;

    } //get_parent

} //Control


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