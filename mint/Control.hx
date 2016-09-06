package mint;

import mint.render.Rendering;

import mint.types.Types;
import mint.types.Types.Helper.in_rect;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a control */
typedef ControlOptions = {

        /** Generic framework/user specific options,
            which can be strong typed on the receiving end. */
    @:optional var options: Dynamic;
    /** Generic framework/user specific data to store on the control `user` property,
            which can be strong typed on the receiving end. */
    @:optional var user: Dynamic;

        /** The control name */
    @:optional var name: String;
        /** The control x position, relative to its container */
    @:optional var x: Float;
        /** The control y position, relative to its container */
    @:optional var y: Float;
        /** The control width */
    @:optional var w: Float;
        /** The control height */
    @:optional var h: Float;

        /** The control minimum width */
    @:optional var w_min: Float;
        /** The control maximum width */
    @:optional var w_max: Float;
        /** The control minimum height */
    @:optional var h_min: Float;
        /** The control maximum height */
    @:optional var h_max: Float;

        /** The control parent, if any */
    @:optional var parent (default, null): Control;
        /** The control depth. Usually set internally */
    @:optional var depth: Float;
        /** Whether or not the control is visible at creation */
    @:optional var visible: Bool;
        /** Whether or not the control responds to mouse input */
    @:optional var mouse_input: Bool;
        /** Whether or not the control responds to key input */
    @:optional var key_input: Bool;
        /** Whether or not the control emits render signals from the canvas render call */
    @:optional var renderable: Bool;

        /** The render service that provides this instance with an implementation.
            Defaults to using the owning canvas render service if not specified */
    @:optional var rendering: Rendering;

        /** Internal. Internal parent visibility for creating sub controls. */
    @:noCompletion @:optional var internal_visible: Bool;

} //ControlOptions


/** An empty control.
    Base class for all controls
    handles propogation of events,
    mouse handling, layout and so on */
@:allow(mint.render.Renderer)
class Control {

        /** The name of this control. default: 'control'*/
    public var name (default, set): String = 'control';
        /** Generic framework/user specific data to store with the control,
            which can be strong typed on the receiving end. */
    public var user: Dynamic;

        /** Root canvas that this element belongs to */
    public var canvas : Canvas;
        /** the top most control below the canvas that holds us */
    public var closest_to_canvas : Control;

        /** The x position of the control bounds, world coordinate */
    @:isVar public var x (default, set) : Float;
        /** The y position of the control bounds, world coordinate */
    @:isVar public var y (default, set) : Float;
        /** The width of the control bounds */
    @:isVar public var w (default, set) : Float;
        /** The height of the control bounds */
    @:isVar public var h (default, set) : Float;

        /** The minimum width*/
    @:isVar public var w_min (default, set) : Float = 0;
        /** The minimum height */
    @:isVar public var h_min (default, set) : Float = 0;
        /** The maximum width*/
    @:isVar public var w_max (default, set) : Float = 0;
        /** The maximum height */
    @:isVar public var h_max (default, set) : Float = 0;

        /** The right edge of the control bounds */
    public var right (get, never) : Float;
        /** The bottom edge of the control bounds */
    public var bottom (get, never) : Float;

        /** The x position of the control bounds, relative to its container */
    @:isVar public var x_local (get, set) : Float;
        /** The y position of the control bounds, relative to its container */
    @:isVar public var y_local (get, set) : Float;

        /** The control this one is clipped by */
    @:isVar public var clip_with (default, set): Control;
        /** the list of children added to this control */
    public var children : Array<Control>;
        /** the number of controls below and including this one */
    public var nodes (get,never) : Int;

        /** if the control has focus */
    public var isfocused : Bool = false;
        /** if the control is marked for potential focus */
    public var ismarked : Bool = false;
        /** if the control has modal focus */
    public var iscaptured : Bool = false;
        /** if the control is under the mouse */
    public var ishovered : Bool = false;
        /** if the control accepts mouse events */
    public var mouse_input : Bool = false;
        /** if the control accepts key events */
    public var key_input : Bool = false;
        /** if the control emits a render signal */
    public var renderable : Bool = false;
        /** if the control has been destroyed and is no longer usable */
    public var destroyed (default,null) : Bool = false;

        /** If the control is visible */
    @:isVar public var visible (default, set) : Bool = true;
        /** A getter for the bounds information about the children and their children in this control */
    @:isVar public var children_bounds (get,null) : ChildBounds;


        /** An event for when the control is created. Used by the rendering service */ 
    public var oncreate      : Signal<Void->Void>;
        /** An event for when (if) a control is marked as renderable and is rendered. */ 
    public var onrender      : Signal<Void->Void>;
        /** An event for when the name of the control changes. args: old, new */ 
    public var onrenamed     : Signal<String->String->Void>;
        /** An event for when the bounds of the control change. */ 
    public var onbounds      : Signal<Void->Void>;
        /** An event for when the control is being destroyed. */ 
    public var ondestroy     : Signal<Void->Void>;
        /** An event for when the visibility of the control changes. */ 
    public var onvisible     : Signal<Bool->Void>;
        /** An event for when the control moves in depth in the canvas. */ 
    public var ondepth       : Signal<Float->Void>;
        /** An event for when the clipping rectangle changes for the control. */ 
    public var onclip        : Signal<Bool->Float->Float->Float->Float->Void>;
        /** An event for when a child is added to the control. */ 
    public var onchildadd    : Signal<Control->Void>;
        /** An event for when a child is removed from the control. */ 
    public var onchildremove : Signal<Control->Void>;
        /** An event for when the mouse is clicked on this control (if `mouse_input`). */ 
    public var onmousedown   : Signal<MouseSignal>;
        /** An event for when the mouse is released on this control (if `mouse_input`). */ 
    public var onmouseup     : Signal<MouseSignal>;
        /** An event for when the mouse is moved inside this control (if `mouse_input`). */ 
    public var onmousemove   : Signal<MouseSignal>;
        /** An event for when the mousewheel is moved while the mouse is inside this control (if `mouse_input`). */ 
    public var onmousewheel  : Signal<MouseSignal>;
        /** An event for when the mouse enters the control (if `mouse_input`). */ 
    public var onmouseenter  : Signal<MouseSignal>;
        /** An event for when the mouse leaves the control (if `mouse_input`). */ 
    public var onmouseleave  : Signal<MouseSignal>;
        /** An event for when a key is pressed and the control is focused (if `key_input`). */ 
    public var onkeydown     : Signal<KeySignal>;
        /** An event for when a key is released and the control is focused (if `key_input`). */ 
    public var onkeyup       : Signal<KeySignal>;
        /** An event for when a text/typing event happened and the control is focused (if `key_input`). */ 
    public var ontextinput   : Signal<TextSignal>;
        /** An event for when this control gains or loses focus */ 
    public var onfocused     : Signal<Bool->Void>;
        /** An event for when this control is marked or unmarked for focus */ 
    public var onmarked      : Signal<Bool->Void>;
        /** An event for when this control is made or unmade the modal focus */ 
    public var oncaptured    : Signal<Bool->Void>;


        //the parent control, null if no parent
    @:isVar public var parent(get,set) : Control;
        //the depth of this control
    @:isVar public var depth(get,set) : Float = 1.0;
        //The concrete renderer for this control instance
    public var renderer : mint.render.Renderer;
        /** The rendering service that this instance uses, defaults to the canvas render service */
    public var rendering : Rendering;

        /** The control specific options */
    var _options_ : ControlOptions;
    var depth_offset : Float = 0;

        /** Create a Control with the given options.
            The emit_oncreate flag will fire the oncreate signal at the end of this function default:false */
    public function new( _options:ControlOptions, _emit_oncreate:Bool = false ) {

        _options_ = _options;
        def(_options_.options, {});

        oncreate      = new Signal();
        onrender      = new Signal();
        onrenamed     = new Signal();
        onbounds      = new Signal();
        ondestroy     = new Signal();
        onvisible     = new Signal();
        ondepth       = new Signal();
        onclip        = new Signal();
        onchildadd    = new Signal();
        onchildremove = new Signal();
        onmousedown   = new Signal();
        onmouseup     = new Signal();
        onmousemove   = new Signal();
        onmousewheel  = new Signal();
        onmouseleave  = new Signal();
        onmouseenter  = new Signal();
        onkeydown     = new Signal();
        onkeyup       = new Signal();
        ontextinput   = new Signal();
        onfocused     = new Signal();
        onmarked      = new Signal();
        oncaptured    = new Signal();

        children = [];

        name = def(_options_.name, 'control.${Helper.uniqueid()}');
        user = _options_.user;
        depth_offset = def(_options_.depth, 0);

        w_min = def(_options_.w_min, 0);
        h_min = def(_options_.h_min, 0);
        w_max = def(_options_.w_max, 0);
        h_max = def(_options_.h_max, 0);

        ignore_spatial = true;

            x = def(_options_.x, 0);
            y = def(_options_.y, 0);
            w = def(_options_.w, 32);
            h = def(_options_.h, 32);

            x_local = x;
            y_local = y;

        ignore_spatial = false;

        mouse_input = def(_options_.mouse_input, false);
        key_input = def(_options_.key_input, false);

        children_bounds = {
            x:0, y:0, right:0, bottom:0,
            real_x : 0, real_y : 0, real_w : 0, real_h : 0
        };

        if(_options_.parent != null) {

            canvas = _options_.parent.canvas;
            _options_.parent.add(this);

        } else { //parent != null

            if( !Std.is(this, Canvas) && canvas == null) {
                throw "Control without a canvas " + _options_;
            } //canvas

        }

        closest_to_canvas = find_top_parent();

        //canvas must be valid here

        rendering = def(_options.rendering, canvas.rendering);

        if(_options_.renderable != null) {
            renderable = _options_.renderable;
        } else {
            if(canvas != null) {
                renderable = canvas.renderable;
            }
        }

        if(_options_.visible != null) {
            visible = _options_.visible;
        } else if(_options_.internal_visible != null) {
            set_visible_only(_options_.internal_visible);
        } else if(parent != null) {
            set_visible_only(parent.visible);
        }

        if(_emit_oncreate) oncreate.emit();

    } //new

    public function children_at_point(_x:Float, _y:Float, ?_into:Array<Control>) : Array<Control> {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        var _result = def(_into, []);

        if(children.length == 0) return _result;

        for(_child in children) {
            if(_child.contains(_x, _y) && _child.visible) {
                _result.push(_child);
                if(_child.children.length > 0) {
                    return _child.children_at_point(_x, _y, _result);
                }
            }
        }

        _result.sort(function(a, b) {
            if(a.depth == b.depth) return 0;
            if(a.depth < b.depth) return -1;
            return 1;
        });

        return _result;

    } //children_at_point

    public function topmost_child_at_point( _x:Float, _y:Float ) : Control {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        //if we have no children, we are the topmost child
        if(children.length == 0) return this;

            //if we have children, we look at each one, looking for the highest one
            //after we have the highest one, we ask it to return it's own highest child

        var highest_child = this;
        var highest_depth = 0.0;

        for(_child in children) {

            if(_child.visible && _child.contains(_x, _y)) {

                if(_child.depth >= highest_depth) {
                    highest_child = _child;
                    highest_depth = _child.depth;
                } //highest_depth

            } //child contains point
        } //child in children

        if(highest_child != this && highest_child.children.length != 0) {
            return highest_child.topmost_child_at_point(_x, _y);
        } else {
            return highest_child;
        }

    } //topmost_child_at_point

    public function contains( _x:Float, _y:Float ) {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        var inside = in_rect(_x, _y, x, y, w, h);

        if(clip_with == null) return inside;

        return inside && clip_with.contains(_x, _y);

    } //contains

    function onclipchanged() {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');        

        if(clip_with != null) {
            onclip.emit(false, clip_with.x, clip_with.y, clip_with.w, clip_with.h);
        }

    } //onclipchanged

    function set_clip_with(_other:Control) {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(clip_with != null) {
            clip_with.onbounds.remove(onclipchanged);
        }

        clip_with = _other;

        if(clip_with != null) {

            clip_with.onbounds.listen(onclipchanged);

                //:todo:
            for(child in children) {
                child.clip_with = clip_with;
            }

            onclipchanged();

        } else {
            onclip.emit(true, 0,0,0,0);
        }

        return clip_with;

    } //set_clip_with

        //This is set by set_visible, to allow controls to retain their logical
        //visibility state when their parent is trying to
        //change it against what it's set at
    var vis_state = true;
    var update_vis_state = true;

    inline function set_visible_only(_visible:Bool) {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        update_vis_state = false;
        visible = _visible;
        update_vis_state = true;

    } //set_visible_only

    function set_visible( _visible:Bool) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        visible = _visible;
        if(update_vis_state) vis_state = _visible;

        onvisible.emit(visible);

        for(_child in children) {
            _child.set_visible_only(visible && _child.vis_state);
        }

        canvas.focus_invalid = true;

        return visible;

    } //set visible

    function find_top_parent( ?_from:Control = null ) {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

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

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(child.parent != null) {
            child.parent.remove(child);
        }

        if(child.parent != this) {
            children.push(child);
            child.parent = this;
            onchildadd.emit(child);
        }

        canvas.sync_depth();

    } //add

    public function remove( child:Control ) {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(child.parent == this) {
            children.remove(child);
            onchildremove.emit(child);
            child.parent = null;
            canvas.sync_depth();
        }

    }

        //:todo: clean up
    function get_children_bounds() : ChildBounds {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

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

        var _current_x : Float = _first_child.x_local;
        var _current_y : Float = _first_child.y_local;
        var _current_r : Float = _first_child.x_local + _first_child.w;
        var _current_b : Float = _first_child.y_local + _first_child.h;

        var _real_x : Float = _first_child.x;
        var _real_y : Float = _first_child.y;

        for(child in children) {

            _current_x = Math.min( child.x_local, _current_x );
            _current_y = Math.min( child.y_local, _current_y );
            _current_r = Math.max( _current_r, child.x_local+child.w );
            _current_b = Math.max( _current_b, child.y_local+child.h );

            _real_x = Math.min( child.x, _real_x );
            _real_y = Math.min( child.y, _real_y );

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

    public function render() {

        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(renderable) onrender.emit();

        for(child in children) child.render();

    } //render

    public function keyup( e:KeyEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        onkeyup.emit(e, this);

        if( parent != null &&
            parent != canvas &&
            canvas != this &&
            e.bubble )
        {
            parent.keyup(e);
        }

    } //keyup

    public function keydown( e:KeyEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        onkeydown.emit(e, this);

        if( parent != null &&
            parent != canvas &&
            canvas != this &&
            e.bubble )
        {
            parent.keydown(e);
        }

    } //keydown

    public function textinput( e:TextEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        ontextinput.emit(e, this);

        if( parent != null &&
            parent != canvas &&
            canvas != this &&
            e.bubble )
        {
            parent.textinput(e);
        }

    } //textinput

    public function mousemove( e:MouseEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        onmousemove.emit(e, this);

        if( parent != null &&
            parent != canvas &&
            canvas != this &&
            e.bubble )
        {
            parent.mousemove(e);
        }

    } //mousemove

    public function mouseup( e:MouseEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        onmouseup.emit(e, this);

        if( parent != null &&
            parent != canvas &&
            canvas != this &&
            e.bubble )
        {
            parent.mouseup(e);
        }

    } //mouseup

    public function mousewheel( e:MouseEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        onmousewheel.emit(e, this);

        if( parent != null &&
            parent != canvas &&
            canvas != this &&
            e.bubble )
        {
            parent.mousewheel(e);
        }

    } //mousewheel

    public function mousedown( e:MouseEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        onmousedown.emit(e, this);

        if( parent != null &&
            parent != canvas &&
            canvas != this &&
            e.bubble )
        {
            parent.mousedown(e);
        }

    } //mousedown

    public function mouseenter( e:MouseEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        onmouseenter.emit(e, this);
        ishovered = true;

    } //mouseenter

    public function mouseleave( e:MouseEvent ) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        onmouseleave.emit(e, this);
        ishovered = false;

    } //mouseleave

    public function destroy_children() {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        while(children.length > 0) {
            var child = children.shift();
                child.destroy();
        }

    } //destroy_children

    public function destroy() {

        assert(destroyed == false, 'attempt to destroy control twice `$this` ($name)');

        unmark();
        unfocus();
        uncapture();

        destroy_children();

        if(clip_with != null) {
            clip_with.onbounds.remove(onclipchanged);
        }

        if(parent != null) {
            parent.remove(this);
        }

        ondestroy.emit();

        user = null;
        
        oncreate.clear();       oncreate = null;
        onrender.clear();       onrender = null;
        onrenamed.clear();      onrenamed = null;
        onbounds.clear();       onbounds = null;
        ondestroy.clear();      ondestroy = null;
        onvisible.clear();      onvisible = null;
        ondepth.clear();        ondepth = null;
        onclip.clear();         onclip = null;
        onchildadd.clear();     onchildadd = null;
        onchildremove.clear();  onchildremove = null;
        onmousedown.clear();    onmousedown = null;
        onmouseup.clear();      onmouseup = null;
        onmousemove.clear();    onmousemove = null;
        onmousewheel.clear();   onmousewheel = null;
        onmouseleave.clear();   onmouseleave = null;
        onmouseenter.clear();   onmouseenter = null;
        onkeydown.clear();      onkeydown = null;
        onkeyup.clear();        onkeyup = null;
        ontextinput.clear();    ontextinput = null;
        onfocused.clear();      onfocused = null;
        onmarked.clear();       onmarked = null;
        oncaptured.clear();     oncaptured = null;

        destroyed = true;

    } //destroy

    public function update(dt:Float) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

    } //update

    public inline function focus() {
                
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(canvas == this) return;

        var _pre = canvas.focused == this;
        
        canvas.focused = this;
        
        if(!_pre) onfocused.emit(true);

    } //focus

    public function unfocus() {
                
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(canvas == this) return;
        if(canvas.focused == this) {
            canvas.focused = null;
            onfocused.emit(false);
        }

    } //unfocus

    public inline function capture() {
                
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(canvas == this) return;

        var _pre = canvas.captured == this;

        canvas.captured = this;
        
        if(!_pre) oncaptured.emit(true);

    } //capture

    public inline function uncapture() {
                
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(canvas == this) return;
        if(canvas.captured == this) {
            canvas.captured = null;
            oncaptured.emit(false);
        }

    } //uncapture

    public inline function mark() {
                
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(canvas == this) return;

        var _pre = canvas.marked == this;

        canvas.marked = this;

        if(!_pre) onmarked.emit(true);
    
    } //mark

    public inline function unmark() {
                
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(canvas == this) return;
        if(canvas.marked == this) {
            canvas.marked = null;
            onmarked.emit(false);
        }

    } //unmark

    function refresh_bounds() {
            
        onbounds.emit();
        
        for(_child in children) {
            _child.refresh_bounds();
        }

    } //refresh_bounds

    var updating = false;
    function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        if(updating) return;

        if(_dx != 0.0 || _dy != 0.0) {
            for(child in children) {
                child.set_pos(child.x + _dx, child.y + _dy);
            }
        }

        onbounds.emit();

    } //bounds_changed

//Properties

//Spatial properties

    public function set_pos(_x:Float, _y:Float) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        updating = true;

        var _dx = _x - x;
        var _dy = _y - y;

        x = _x;
        y = _y;

        updating = false;

        bounds_changed(_dx, _dy, 0, 0);

    } //set_pos

    public function set_size(_w:Float, _h:Float) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        updating = true;

        var _dw = _w - w;
        var _dh = _h - h;

        w = _w;
        h = _h;

        updating = false;

        bounds_changed(0,0, _dw, _dh);

    } //set_size

    inline function get_right() : Float {

        return x + w;

    } //get_right

    inline function get_bottom() : Float {

        return y + h;

    } //get_bottom

    function set_name(_name:String) : String {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        var _prev = name;
        name = _name;

        onrenamed.emit(_prev, _name);

        return name;

    } //set_name

    function set_x(_x:Float) : Float {

        var _dx = _x - x;

        x = _x;

        if(!ignore_spatial) {
            ignore_spatial = true;
                if(parent != null) {
                    x_local = x - parent.x;
                } else {
                    x_local = x;
                }
            ignore_spatial = false;
        } //ignore_spatial

        bounds_changed(_dx);

        return x;

    } //set_x

    function set_y(_y:Float) : Float {

        var _dy = _y - y;

        y = _y;

        if(!ignore_spatial) {
            ignore_spatial = true;
                if(parent != null) {
                    y_local = y - parent.y;
                } else {
                    y_local = y;
                }
            ignore_spatial = false;
        } //ignore_spatial

        bounds_changed(0, _dy);

        return y;

    } //set_y

    function set_w_min(_w_min:Float) : Float {

        w_min = _w_min;

        if(w < w_min) w = w_min;

        return w_min;

    } //set_w_min

    function set_h_min(_h_min:Float) : Float {

        h_min = _h_min;

        if(h < h_min) h = h_min;

        return h_min;

    } //set_h_min

    function set_w_max(_w_max:Float) : Float {

        w_max = _w_max;

        if(w > w_max) w = w_max;

        return w_max;

    } //set_w_max

    function set_h_max(_h_max:Float) : Float {

        h_max = _h_max;

        if(h > h_max) h = h_max;

        return h_max;

    } //set_h_max

    function set_w(_w:Float) : Float {

        if(_w < w_min) _w = w_min;
        if(_w > w_max && w_max != 0) _w = w_max;

        var _dw = _w - w;

        w = _w;

        bounds_changed(0,0, _dw);

        return w;

    } //set_w

    function set_h(_h:Float) : Float {

        if(_h < h_min) _h = h_min;
        if(_h > h_max && h_max != 0) _h = h_max;

        var _dh = _h - h;

        h = _h;

        bounds_changed(0,0,0, _dh);

        return h;

    } //set_h

    var ignore_spatial = false;
    function set_x_local(_x:Float) : Float {

        x_local = _x;

        if(!ignore_spatial) {
            ignore_spatial = true;
                if(parent != null) {
                    x = parent.x + x_local;
                } else {
                    x = x_local;
                }
            ignore_spatial = false;
        } //ignore_spatial

        return x_local;

    } //set_x_local

    function set_y_local(_y:Float) : Float {

        y_local = _y;

        if(!ignore_spatial) {
            ignore_spatial = true;
                if(parent != null) {
                    y = parent.y + y_local;
                } else {
                    y = y_local;
                }
            ignore_spatial = false;
        } //ignore_spatial

        return y_local;

    } //set_y_local

    function get_x_local() : Float {

        return x_local;

    } //get_x_local

    function get_y_local() : Float {

        return y_local;

    } //get_y_local

//Node properties

    inline function get_nodes() : Int {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        var _nodes = 1;
        for(child in children) _nodes += child.nodes;
        return _nodes;

    } //get_nodes

//Depth properties

    inline function get_depth() : Float {

        return depth;

    } //get_depth

    function set_depth( _depth:Float ) : Float {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        depth = _depth;

        ondepth.emit(depth);

        return depth;

    } //set_depth

//Parent properties

    function set_parent(p:Control) {
        
        assert(destroyed == false, '$name was already destroyed but is being interacted with');

        //do stuff with old parent

        parent = p;

        if(parent != null) {
            ignore_spatial = true;
                x = parent.x + x_local;
                y = parent.y + y_local;
            ignore_spatial = false;
        }

        return parent;

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

} //ChildBounds


    /** A signal for mouse input events */
typedef MouseSignal = MouseEvent->Control->Void;
    /** A signal for key input events */
typedef KeySignal   = KeyEvent->Control->Void;
    /** A signal for text input events */
typedef TextSignal  = TextEvent->Control->Void;
