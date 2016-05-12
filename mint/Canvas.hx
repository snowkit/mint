package mint;

import mint.Control;
import mint.render.Rendering;

import mint.types.Types;
import mint.types.Types.Helper.in_rect;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a Canvas */
typedef CanvasOptions = {

    > ControlOptions,

        /** The scaling factor for this canvas.
            Note that this value is a hint for rendering the canvas,
            it does not affect any coordinates directly. */
    @:optional var scale: Float;

} //CanvasOptions


/**
    A canvas is a root object in mint.
    It requires a rendering instance, and handles all incoming events,
    propagating them to the children.
    Additional Signals: none
*/
@:allow(mint.render.Renderer)
class Canvas extends Control {

        /** The current focused control, null if none */
    @:isVar public var focused (get,set) : Control;
        /** The current marked control, null if none */
    @:isVar public var marked (get,set) : Control;
        /** The current modal control, null if none */
    @:isVar public var captured (get,set) : Control;
        /** Whether or not the current focus needs refreshing. */
    public var focus_invalid : Bool = true;
        /** The canvas scale factor.
            Note that this value is a hint for rendering the canvas,
            it does not affect any coordinates directly. */
    public var scale (default, set) : Float = 1.0;

        /** An event for when the focused state changes */ 
    public var onfocusedchange  : Signal<Control->Void>;
        /** An event for when the marked state changes */ 
    public var onmarkedchange   : Signal<Control->Void>;
        /** An event for when the captured state changes */ 
    public var oncapturedchange : Signal<Control->Void>;
        /** On scale changed */
    public var onscalechange : Signal<Float->Float->Void>;

    var options: CanvasOptions;

    public function new( _options:CanvasOptions ) {

        options = _options;

        onfocusedchange = new Signal();
        onmarkedchange = new Signal();
        oncapturedchange = new Signal();
        onscalechange = new Signal();

        assertnull(options, "No options given to canvas, at least a Renderer is required.");
        assertnull(options.rendering, "No Rendering given to Canvas, cannot create a canvas without one.");

        def(options.name, 'canvas');
        def(options.w, 800);
        def(options.h, 600);

        def(options.mouse_input, true);

        super(options);

        canvas = this;
        scale = def(options.scale, 1);

        captured = null;
        focused = null;
        marked = null;

        renderer = rendering.get( Canvas, this );

        oncreate.emit();

    } //new

    public function bring_to_front(control:Control) {

        //re-add it to the canvas will put it above
        canvas.add(control);
        sync_depth();

    } //bring_to_front

        /** Get the top most control under the given point, or null if there is none (or is the canvas itself) */
    public function topmost_at_point( _x:Float, _y:Float ) {

        var _control = topmost_child_at_point(_x, _y);

        if(_control != this) return _control;

        return null;

    } //topmost_at_point

//Internal

    @:allow(mint.Control)
    var depth_idx = 0.0;

    function apply_depth(control:Control) {

        control.depth = depth_idx+control.depth_offset;
        depth_idx++;

        for(child in control.children) {
            apply_depth(child);
        } //each child

    } //apply_depth

    @:allow(mint.Control)
    function sync_depth() {

        depth_idx = 0;
        apply_depth(this);

    } //sync_depth

//Overrides from Control

    public override function mouseup( e:MouseEvent ) {

        _mouse_down = false;
        onmouseup.emit(e, this);

    } //mouseup

    var _mouse_down = false;
    public override function mousedown( e:MouseEvent ) {

        _mouse_down = true;
        onmousedown.emit(e, this);

    } //mousedown

    public override function mousemove( e:MouseEvent ) {

        var _inside = in_rect(e.x, e.y, x, y, w, h);

        //inside but leaving
        if(ishovered && !_inside) {
            mouseleave(e);
            if(_mouse_down) mouseup(e); //:todo: config + move to mouseleave
        } else if(!ishovered && _inside) {
            mouseenter(e);
        }

        onmousemove.emit(e, this);

    } //mousemove

    public override function mousewheel( e:MouseEvent ) {

        onmousewheel.emit(e, this);

    } //mousewheel

    public override function keyup( e:KeyEvent ) {

        onkeyup.emit(e, this);

    } //keyup

    public override function keydown( e:KeyEvent ) {

        onkeydown.emit(e, this);

    } //keydown

    public override function textinput( e:TextEvent ) {

        ontextinput.emit(e, this);

    } //textinput

    public override function update(dt:Float) {

        for(control in children) {
            control.update(dt);
        }

    } //update

    public override function destroy() {

        super.destroy();

        onfocusedchange.clear();
        onmarkedchange.clear();
        oncapturedchange.clear();
        onscalechange.clear();

        onfocusedchange = null;
        onmarkedchange = null;
        oncapturedchange = null;
        onscalechange = null;

    } //destroy

//getters/setters
    

    function set_scale(_scale:Float) {

        var _prev = scale;  
        scale = _scale;

        if(_scale != _prev) {
             refresh_bounds();
        }

        onscalechange.emit(_scale, _prev);

        return scale;

    } //set_scale

    function get_focused() : Control {

        return focused;

    } //get_focused


    function set_focused(_control:Control) : Control {

        if(focused != null) {
            focused.isfocused = false;
        }

        focused = _control;
        onfocusedchange.emit(focused);

        if(focused != null) {
            focused.isfocused = true;
        }

        return focused;

    } //set_focused

    function get_captured() : Control {

        return captured;

    } //get_captured

    function set_captured(_control:Control) : Control {

        if(captured != null) {
            captured.iscaptured = false;
        }

        captured = _control;
        oncapturedchange.emit(captured);

        if(captured != null) {
            captured.iscaptured = true;
        }

        return captured;

    } //set_captured

    function get_marked() : Control {

        return marked;

    } //get_marked

    function set_marked(_control:Control) : Control {

        if(marked != null) {
            marked.ismarked = false;
        }

        marked = _control;
        onmarkedchange.emit(captured);

        if(marked != null) {
            marked.ismarked = true;
        }

        return marked;

    } //set_marked

} //Canvas
