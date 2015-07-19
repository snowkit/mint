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

} //CanvasOptions


/**
    A canvas is a root object in mint.
    It requires a rendering instance, and handles all incoming events,
    propagating them to the children. It also maintains the state
    of modality, focused controls and dragged contorls to simplify interaction.
    Additional Signals: none
*/
class Canvas extends Control {

        /** The current focused control, null if none */
    public var focused : Control;
        /** The current dragged control, null if none */
    public var dragged : Control;
        /** The current modal control, null if none */
    public var modal   : Control;

        /** Whether or not the current focus needs refreshing. */
    public var focus_invalid : Bool = true;

    var options: CanvasOptions;
    var depth_seq : Float = 0;

    public function new( _options:CanvasOptions ) {

        options = _options;

        assertnull(options, "No options given to canvas, at least a Renderer is required.");
        assertnull(options.rendering, "No Rendering given to Canvas, cannot create a canvas without one.");

        def(options.name, 'canvas');
        def(options.w, 800);
        def(options.h, 600);

        super(options);

        canvas = this;

        mouse_input = true;
        depth = def(options.depth, 0.0);
        depth_seq = depth;

        focused = null;
        modal = null;
        dragged = null;

        renderer = rendering.render( Canvas, this );

    } //new

        /** Get the top most control under the given point, or null if there is none (or is the canvas itself) */
    public function topmost_at_point( _x:Float, _y:Float ) {

        var _control = topmost_child_at_point(_x, _y);

        if(_control != this) return _control;

        return null;

    } //topmost_at_point

//Internal

        /** Get the next viable depth */
    @:allow(mint.Control)
    function next_depth() {

        depth_seq += 1;

        return depth_seq;

    } //next_depth

        /** Reset the focus to nothing, if given a control will tell
            that control of itself losing focus */
    function reset_focus( ?_control:Control, ?e:MouseEvent ) {

        //this happens in children want to invalidate their focus

        if(_control != null && focused == _control) {
            set_control_unfocused(_control, e);
        }

        focused = null;

    } //reset_focus

        /** Find viable focusable controls, if any */
    function find_focus( e:MouseEvent ) {

        focused = get_focused( e.x, e.y );

        if(focused != null) {
            set_control_focused( focused, e );
        }

        focus_invalid = false;

    } //find_focus

        /** Mark a control as unfocused */
    function set_control_unfocused(_control:Control, e:MouseEvent, ?do_mouseleave:Bool = true) {

        if(_control != null) {

            _control.ishovered = false;
            _control.isfocused = false;

            if(_control.mouse_input && do_mouseleave) {
                _control.mouseleave(e);
            } //mouse enabled and we want handlers

        } //_control != null

    } //set_unfocused

        /** Mark a control as focused */
    function set_control_focused(_control:Control, e:MouseEvent, ?do_mouseenter:Bool = true) {

        if(_control != null) {
            _control.ishovered = true;
            _control.isfocused = true;

            if(_control.mouse_input && do_mouseenter) {
                _control.mouseenter(e);
            } //mouse enabled and we want handlers
        }

    } //set_focused

        /** Return a control to focus from a point.
            If modal is set, that will be returned instead */
    function get_focused( _x:Float, _y:Float ) {

        if( modal != null ) {
            return modal;
        } else {
            return topmost_at_point( _x, _y );
        }

    } //get_focused

//Overrides from Control

    public override function mousemove( e:MouseEvent ) {

        var _inside = in_rect(e.x, e.y, x, y, w, h);

        if(!_inside && _mouse_down) {
            mouseup(e);
        }

            //first we check if the mouse is still inside the focused element
        if(focused != null) {

            if(focused.contains(e.x, e.y)) {

                    //now check if we haven't gone into any of it's children
                var _child_over = focused.topmost_child_at_point(e.x, e.y);
                if(_child_over != null && _child_over != focused) {

                        //if we don't want mouseleave when the child takes focus, set to false
                    var _mouseleave_parent = true;
                        //unfocus the parent
                    set_control_unfocused(focused, e, _mouseleave_parent);
                        //focus the child now
                    set_control_focused(_child_over, e);
                        //change the focused item
                    focused = _child_over;

                } //child_over != null

            } else { //focused.contains

                    //unfocus the existing one
                set_control_unfocused(focused, e);

                    //find a new one, if any
                find_focus(e);

            } //focused inside

        } else { //focused != null

                //nothing focused at the moment, check that the mouse is inside our canvas first
            if( _inside ) {

                find_focus(e);

            } else { //mouse is inside canvas at all?

                reset_focus(e);

            } //inside canvas

        } //focused == null

        if(focused != null && focused != this) {
            focused.mousemove(e);
        } //focused != null

        if(dragged != null && dragged != focused && dragged != this) {
            dragged.mousemove(e);
        } //dragged ! null and ! focused

    } //mousemove

    public override function mouseup( e:MouseEvent ) {

        _mouse_down = false;

        if(focus_invalid) {
            find_focus(e);
        }

        if(focused != null && focused.mouse_input) {
            focused.mouseup(e);
        } //focused

        if(dragged != null && dragged != focused && dragged != this) {
            dragged.mouseup(e);
        } //dragged ! null and ! focused

    } //mouseup

    public override function mousewheel( e:MouseEvent ) {

        super.mousewheel(e);

        if(focused != null && focused.mouse_input) {
            focused.mousewheel(e);
        } //focused

    } //mousewheel

    public override function keyup( e:KeyEvent ) {

        super.keyup(e);

        if(focused != null && focused.key_input) {
            focused.keyup(e);
        } //focused

    } //keyup

    public override function keydown( e:KeyEvent ) {

        super.keydown(e);

        if(focused != null && focused.key_input) {
            focused.keydown(e);
        } //focused

    } //keydown

    public override function textinput( e:TextEvent ) {

        super.textinput(e);

        if(focused != null && focused.key_input) {
            focused.textinput(e);
        } //focused

    } //textinput

    var _mouse_down = false;

    public override function mousedown( e:MouseEvent ) {

        super.mousedown(e);

        _mouse_down = true;

        if(focus_invalid) {
            find_focus(e);
        }

        if(focused != null && focused.mouse_input) {
            focused.mousedown(e);
        } //focused

    } //mousedown

    public override function add( child:Control ) {

        super.add(child);

    } //add

    public override function update(dt:Float) {

        for(control in children) {
            control.update(dt);
        }

    } //update

    public override function destroy(){

        super.destroy();

    } //destroy

} //Canvas
