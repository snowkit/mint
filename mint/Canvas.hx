package mint;

import mint.Types;
import mint.Control;

class Canvas extends Control {

    public var focused : Control;
    public var dragged : Control;
    public var modal   : Control;

    public var focus_invalid : Bool = true;

    public function new( _options:Dynamic ) {

        if(_options == null) throw "No options given to canvas, at least a Renderer is required.";
        if(_options.renderer == null) throw "No renderer given to Canvas, cannot create this way.";
        if(_options.name == null) _options.name = 'canvas';
        if(_options.bounds == null) _options.bounds = new Rect(0, 0, 800, 600 );

        renderer = _options.renderer;

        super(_options);
        if(_options.parent == null) {
            canvas = this;
        } else {
            canvas = _options.parent;
        } //parent null

        mouse_enabled = true;
        focused = null;
        depth = _options.depth;

        renderer.canvas.init( this, _options );

        _mouse_last = new Point();

    } //new

    public override function set_visible( ?_visible:Bool = true ) {
        super.set_visible(_visible);
        renderer.canvas.set_visible(this, _visible);
    } //set_visible


    private override function set_depth( _depth:Float ) : Float {

        super.set_depth(_depth);

        renderer.canvas.set_depth(this, _depth);

        return depth;

    } //set_depth

    public function topmost_control_under_point( _p:Point ) {
        var _control = topmost_child_under_point(_p);
        if(_control != this) return _control;
        return null;
    }

    var _mouse_last:Point;

    private function set_control_unfocused(_control:Control, e:MouseEvent, ?do_mouseleave:Bool = true) {
        if(_control != null) {

            _control.ishovered = false;
            _control.isfocused = false;

            if(_control.mouse_enabled && do_mouseleave) {
                _control.onmouseleave(e);
            } //mouse enabled and we want handlers

        } //_control != null
    } //set_unfocused

    private function set_control_focused(_control:Control, e:MouseEvent, ?do_mouseenter:Bool = true) {
        if(_control != null) {
            _control.ishovered = true;
            _control.isfocused = true;

            if(_control.mouse_enabled && do_mouseenter) {
                _control.onmouseenter(e);
            } //mouse enabled and we want handlers
        }
    } //set_focused

    private function get_focused( _p : Point ) {

        if( modal != null ) {
            return modal;
        } else {
            return topmost_control_under_point( _p );
        }

    } //get_focused

    public function reset_focus( ?_control:Control, ?e:MouseEvent ) {

        //this happens in children want to invalidate their focus

        if(_control != null && focused == _control) {
            set_control_unfocused(_control, e);
        }

        focused = null;

    } //reset_focus

    public function find_focus( ?e:MouseEvent ) {

        focused = get_focused( _mouse_last );

        if(focused != null) {
            set_control_focused( focused, e );
        }

        focus_invalid = false;

    } //find_focus

    public override function onmousemove( e:MouseEvent ) {

        _mouse_last.set(e.x,e.y);

            //first we check if the mouse is still inside the focused element
        if(focused != null) {

            if(focused.contains_point(_mouse_last)) {

                    //now check if we haven't gone into any of it's children
                var _child_over = focused.topmost_child_under_point(_mouse_last);
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

            } else { //focused.real_bounds point_inside( mouse )

                    //unfocus the existing one
                set_control_unfocused(focused, e);

                    //find a new one, if any
                find_focus(e);

            } //focused inside

        } else { //focused != null

                //nothing focused at the moment, check that the mouse is inside our canvas first
            if( real_bounds.point_inside(_mouse_last) ) {

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

        if(focused != null && focused.mouse_enabled) {
            focused.onmousewheel(e);
        } //focused

    } //onmouseup

    public override function onmousedown( e:MouseEvent ) {

        _mouse_last.set(e.x,e.y);

        if(focus_invalid) {
            find_focus(e);
        }

        if(focused != null && focused.mouse_enabled) {
            focused.onmousedown(e);
        } //focused

    } //onmousedown

    public function next_depth() {
        depth+=1;
        return depth;
    } //next_depth

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