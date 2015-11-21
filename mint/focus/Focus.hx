package mint.focus;

import mint.types.Types;
import mint.types.Types.Helper.in_rect;

class Focus {

    public var canvas: mint.Canvas;

    public function new(_canvas:mint.Canvas) {
        
        canvas = _canvas;

        canvas.onmousemove.listen(mousemove);
        canvas.onmousedown.listen(mousedown);
        canvas.onmouseup.listen(mouseup);
        canvas.onmousewheel.listen(mousewheel);

        canvas.onkeydown.listen(keydown);
        canvas.onkeyup.listen(keyup);
        canvas.ontextinput.listen(textinput);

    } //new

    public function destroy() {

        canvas.onmousemove.remove(mousemove);
        canvas.onmousedown.remove(mousedown);
        canvas.onmouseup.remove(mouseup);
        canvas.onmousewheel.remove(mousewheel);

        canvas.onkeydown.remove(keydown);
        canvas.onkeyup.remove(keyup);
        canvas.ontextinput.remove(textinput);

    } //destroy

    function keydown(e:KeyEvent, target:mint.Control) {
        if(canvas.focused != null && canvas.focused.key_input) {
            canvas.focused.keydown(e);
        }
    }

    function keyup(e:KeyEvent, target:mint.Control) {
        if(canvas.focused != null && canvas.focused.key_input) {
            canvas.focused.keyup(e);
        }
    }

    function textinput(e:TextEvent, target:mint.Control) {
        if(canvas.focused != null && canvas.focused.key_input) {
            canvas.focused.textinput(e);
        }
    }

    function mousedown(e:MouseEvent, target:mint.Control) {
        if(canvas.focused != null && canvas.focused.mouse_input) {
            canvas.focused.mousedown(e);
        } 

        if(marked_mouse()) canvas.marked.mousedown(e);

    }

    function mouseup(e:MouseEvent, target:mint.Control) {
        if(canvas.focused != null && canvas.focused.mouse_input) {
            canvas.focused.mouseup(e);
        } 

        if(marked_mouse()) canvas.marked.mouseup(e);

    }

    function mousewheel(e:MouseEvent, target:mint.Control) {
        if(canvas.focused != null && canvas.focused.mouse_input) {
            canvas.focused.mousewheel(e);
        } 

        if(marked_mouse()) canvas.marked.mousewheel(e);

    }

    function marked_mouse() {
        return canvas.marked != canvas.focused && canvas.marked != null && canvas.marked.mouse_input;
    }

    function mousemove(e:MouseEvent, target:mint.Control) {

        if(canvas.ishovered) {

                //first we check if the mouse is still inside the focused element
            var _marked = canvas.marked;
            if(_marked != null) {

                if(_marked.contains(e.x, e.y)) {

                    var _target = _marked.parent;
                    if(_target == null) _target = canvas;

                    var _hovered = _target.topmost_child_at_point(e.x, e.y);
                    if(_hovered != null && _hovered != _marked && _hovered != canvas) {

                            //reset the previous
                        unmark_control(_marked, e);
                            //set the newly hovered one
                        mark_control(_hovered, e);
                            //change the focused item
                        canvas.marked = _hovered;

                    } //_hovered != null

                } else { //_marked.contains

                        //unfocus the existing one
                    unmark_control(_marked, e);

                        //find a new one, if any
                    find_marked(e);

                } //_marked inside

            } else { //_marked != null

                    //nothing focused at the moment, check that the mouse is inside our canvas first
                if( canvas.ishovered ) {
                    find_marked(e);
                } else {
                    reset_marked(e);
                }

            } //no currently marked

        } //canvas.ishovered

        if(canvas.focused != null && canvas.focused.mouse_input) {
            canvas.focused.mousemove(e);
        } 

        if(marked_mouse()) canvas.marked.mousemove(e);

    } //mousemove

    function reset_marked( ?_control:Control, ?e:MouseEvent ) {

        if(_control != null && _control.ismarked) {
            unmark_control(_control, e);
        }

    } //reset_focus

    function get_focusable( _x:Float, _y:Float ) {

        if( canvas.captured != null ) {
            return canvas.captured;
        } else {
            return canvas.topmost_at_point(_x, _y);
        }

    } //get_focusable

    function find_marked(e:MouseEvent) {

        var _marked = get_focusable(e.x, e.y);

        if(_marked != null) {
            mark_control(_marked, e);
        }

        return _marked;

    } //find_marked

    function unmark_control(_control:Control, e:MouseEvent) {

        if(_control != null) {

            _control.unmark();

            if(_control.mouse_input) _control.mouseleave(e);

        } //_control != null

    } //set_unfocused

    function mark_control(_control:Control, e:MouseEvent) {

        if(_control != null) {

            _control.mark();

            if(_control.mouse_input) _control.mouseenter(e);

        }

    } //set_focused

}