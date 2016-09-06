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

    function get_markable(_target:mint.Control, _x:Float, _y:Float) {
        
        var _highest = _target.topmost_child_at_point(_x, _y);
            
        if(_highest == null && _highest == _target) {
            return null;
        }

        // now if we have the highest possible control, 
        // we have to walk backward up the tree, 
        // looking for the highest one with mouse input

        var _current = _highest;
        var _canvas = _target.canvas;

        while(true) {

            if(_current == null || _current == _canvas) {
                return _current;
            }

            if(_current.mouse_input) {
                return _current;
            }

            _current = _current.parent;

        } //while

            //unreachable?
        return null;

    } //get_markable

    function mousemove(e:MouseEvent, _) {

        var _mark_target = canvas;
        var _captured = canvas.captured;

        if(_captured != null && _captured.mouse_input) {

            var _markable = get_markable(_captured, e.x, e.y);
            
            if(_markable != null) {
                mark_control(_markable, e);
            }

            if(marked_mouse()) canvas.marked.mousemove(e);

        } else if(canvas.ishovered) {

                //if the mouse has left the current marked control, unmark
            if(canvas.marked != null && !canvas.marked.contains(e.x, e.y)) {
                unmark_control(canvas.marked, e);
            }

                // the focused control always gets the events
            if(canvas.focused != null && canvas.focused.mouse_input) {
                canvas.focused.mousemove(e);
            }

                //get the marked control from the canvas
            var _markable = get_markable(canvas, e.x, e.y);
            
            if(_markable != null) {
                mark_control(_markable, e);
            }

            if(marked_mouse()) canvas.marked.mousemove(e);

        } //canvas is hovered

    } //mousemove

    function reset_marked( ?_control:Control, ?e:MouseEvent ) {

        if(_control != null && _control.ismarked) {
            unmark_control(_control, e);
        }

    } //reset_marked

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

        if(_control != null && _control.ismarked) {

            _control.unmark();

            if(_control.mouse_input) _control.mouseleave(e);

        } //_control != null

    } //set_unfocused

    function mark_control(_control:Control, e:MouseEvent) {

        if(_control != null && !_control.ismarked) {

            reset_marked(canvas.marked);

            _control.mark();

            if(_control.mouse_input) _control.mouseenter(e);

        }

    } //mark_control

}