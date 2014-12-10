package mint;

import mint.Types;
import mint.utils.Signal;
import mint.Renderer;


typedef ControlOptions = {
    ?name:String,
    ?bounds : Rect,
    ?parent: Control,
    ?depth: Float,

    ?mouse_enabled : Bool,
}

typedef MouseSignal = MouseEvent->Control->Void;


//base class for all controls
//handles propogation of events,
//mouse handling, alignment, so on

class Control {

    public var name : String = 'control';

        //parent canvas that this element belongs to
    public var canvas : Canvas;
        //the top most control below the canvas that holds us
    public var closest_to_canvas : Control;

        //the relative bounds to the parent
    public var bounds : Rect;
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

        //the parent control, null if no parent
    @:isVar public var parent(get,set) : Control;
        //the depth of this control
    @:isVar public var depth(get,set) : Float = 0.0;

    @:allow(mint.ControlRenderer)
        var options : ControlOptions;

        //shared render event signals
    @:allow(mint.ControlRenderer)
        var ondestroy : Signal<Void->Void>;
    @:allow(mint.ControlRenderer)
        var onvisible : Signal<Bool->Void>;
    @:allow(mint.ControlRenderer)
        var ondepth : Signal<Float->Void>;
    @:allow(mint.ControlRenderer)
        var ontranslate : Signal<Float->Float->Bool->Void>;
    @:allow(mint.ControlRenderer)
        var onclip : Signal<Rect->Void>;

    public function new( _options:ControlOptions ) {

        options = _options;
        ondestroy = new Signal();
        onvisible = new Signal();
        ondepth = new Signal();
        ontranslate = new Signal();
        onclip = new Signal();

        bounds = options.bounds == null ? new Rect(0,0,32,32) : options.bounds;
        real_bounds = bounds.clone();

        if(options.name != null)            { name = options.name; }
        if(options.mouse_enabled != null)   { trace('set me');mouse_enabled = options.mouse_enabled; }
        // if(options.padding == null)         { options.padding = new Rect(); }

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

        if(options.parent != null) {

            canvas = options.parent.canvas;
            depth = canvas.next_depth();
            options.parent.add(this);

        } else { //parent != null

            if( !Std.is(this, Canvas) && canvas == null) {
                throw "Control without a canvas " + options;
            } //canvas
        }

            //closest_to_canvas
        closest_to_canvas = find_top_parent();

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

    function clip_with_closest_to_canvas() {
        if(closest_to_canvas != null) {
            set_clip( closest_to_canvas.real_bounds );
        }
    } //clip_with_closest_to_canvas


    public function clip_with( ?_control:Control ) {
        if(_control != null) {
            var _b = _control.real_bounds;
            set_clip( new Rect(_b.x, _b.y, _b.w-1, _b.h-1) );
        } else {
            set_clip();
        }
    } //clip_with

    public function set_clip( ?_clip_rect:Rect = null ) {
        //temporarily, all children clip by their parent clip

        clip_rect = _clip_rect;
        onclip.emit(clip_rect);

        // for(_child in children) {
        //  _child.set_clip( _clip_rect );
        // }

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


    public function add( child:Control ) {
        if(child.parent != this) {
            child.parent = this;
            children.push(child);
        }
    }

    public function remove( child:Control ) {
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

        ontranslate.emit(_x, _y, _offset);

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
        // trace('mouse enter ' + name);

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

    private function get_depth() : Float {

        return depth;

    } //get_depth

    private function set_depth( _depth:Float ) : Float {

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

    private function set_parent(p:Control) {

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