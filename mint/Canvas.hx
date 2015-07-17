package mint;

import mint.Types;
import mint.Control;
import mint.Renderer;
import mint.Macros.*;
import mint.Types.Utils.in_rect;

/** Options for constructing a Canvas */
typedef CanvasOptions = {

    > ControlOptions,

    var renderer : Renderer;

} //CanvasOptions

/**
    A canvas is a root object in mint.
    It requires a renderer and handles all incoming events,
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

        /** The renderer that this canvas refers it's children to by default */
    public var renderer : Renderer;
        /** Whether or not the current focus needs refreshing. */
    public var focus_invalid : Bool = true;

    var options: CanvasOptions;
    var _mouse_last:Point;
    var depth_seq : Float = 0;

    public function new( _options:CanvasOptions ) {

        options = _options;

        assertnull(options, "No options given to canvas, at least a Renderer is required.");
        assertnull(options.renderer, "No renderer given to Canvas, cannot create a canvas without one.");

        renderer = options.renderer;

        def(options.name, 'canvas');
        def(options.w, 800);
        def(options.h, 600);

        super(options);

        canvas = this;

        mouse_enabled = true;
        depth = def(options.depth, 0.0);
        depth_seq = depth;

        focused = null;
        modal = null;
        dragged = null;

        render = renderer.render( Canvas, this );

        _mouse_last = new Point();

    } //new

        /** Get the top most control under the given point, or null if there is none (or is the canvas itself) */
    public function topmost_at_point( _p:Point ) {

        var _control = topmost_child_at_point(_p);

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
    function find_focus( ?e:MouseEvent ) {

        focused = get_focused( _mouse_last );

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

            if(_control.mouse_enabled && do_mouseleave) {
                _control.onmouseleave(e);
            } //mouse enabled and we want handlers

        } //_control != null

    } //set_unfocused

        /** Mark a control as focused */
    function set_control_focused(_control:Control, e:MouseEvent, ?do_mouseenter:Bool = true) {

        if(_control != null) {
            _control.ishovered = true;
            _control.isfocused = true;

            if(_control.mouse_enabled && do_mouseenter) {
                _control.onmouseenter(e);
            } //mouse enabled and we want handlers
        }

    } //set_focused

        /** Return a control to focus from a point.
            If modal is set, that will be returned instead */
    function get_focused( _p : Point ) {

        if( modal != null ) {
            return modal;
        } else {
            return topmost_at_point( _p );
        }

    } //get_focused

//Overrides from Control

    public override function onmousemove( e:MouseEvent ) {

        _mouse_last.set(e.x,e.y);

        var _inside = in_rect(_mouse_last.x, _mouse_last.y, x, y, w, h);

        if(!_inside) {
            onmouseup(e);
        }

            //first we check if the mouse is still inside the focused element
        if(focused != null) {

            if(focused.contains(_mouse_last.x, _mouse_last.y)) {

                    //now check if we haven't gone into any of it's children
                var _child_over = focused.topmost_child_at_point(_mouse_last);
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
            focused.onmousemove(e);
        } //focused != null

        if(dragged != null && dragged != focused && dragged != this) {
            dragged.onmousemove(e);
        } //dragged ! null and ! focused

    } //onmousemove

    public override function onmouseup( e:MouseEvent ) {

        _mouse_last.set(e.x,e.y);

        if(focus_invalid) {
            find_focus(e);
        }

        if(focused != null && focused.mouse_enabled) {
            focused.onmouseup(e);
        } //focused

        if(dragged != null && dragged != focused && dragged != this) {
            dragged.onmouseup(e);
        } //dragged ! null and ! focused

    } //onmouseup

    public override function onmousewheel( e:MouseEvent ) {

        super.onmousewheel(e);

        if(focused != null && focused.mouse_enabled) {
            focused.onmousewheel(e);
        } //focused

    } //onmouseup

    public override function onkeyup( e:KeyEvent ) {

        super.onkeyup(e);

        if(focused != null && focused.key_enabled) {
            focused.onkeyup(e);
        } //focused

    } //onkeyup

    public override function onkeydown( e:KeyEvent ) {

        super.onkeydown(e);

        if(focused != null && focused.key_enabled) {
            focused.onkeydown(e);
        } //focused

    } //onkeydown

    public override function ontextinput( e:TextEvent ) {

        super.ontextinput(e);

        if(focused != null && focused.key_enabled) {
            focused.ontextinput(e);
        } //focused

    } //ontextinput

    public override function onmousedown( e:MouseEvent ) {

        super.onmousedown(e);

        _mouse_last.set(e.x,e.y);

        if(focus_invalid) {
            find_focus(e);
        }

        if(focused != null && focused.mouse_enabled) {
            focused.onmousedown(e);
        } //focused

    } //onmousedown

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
