package mint.render;

import mint.render.Renderer;
import mint.render.Rendering;
import mint.Control;
import mint.types.Types;

/** The basic implementation for a control Renderer.
    This includes convenience functions and implementation
    of the base control events which are called
    to simplify integration. Be aware of the timing of signals. */
class Render implements Renderer {

    var rendering : Rendering;
    var control : Control;

    function new( _render:Rendering, _control:mint.Control ) {

        control = _control;
        rendering = _render;

        control.oncreate.listen(internal_connect);

    } //new

        /** Don't need to call this from Render subclasses */
    function internal_connect() {

        control.onvisible.listen(onvisible);
        control.ondepth.listen(ondepth);
        control.ondestroy.listen(ondestroy);
        control.onclip.listen(onclip);
        control.onchildadd.listen(onchildadd);
        control.onchildremove.listen(onchildremove);
        control.onbounds.listen(onbounds);
        control.ondestroy.listen(internal_disconnect);

    } //internal_connect

        /** Don't need to call this from Render subclasses */
    function internal_disconnect() {

        control.onvisible.remove(onvisible);
        control.ondepth.remove(ondepth);
        control.ondestroy.remove(ondestroy);
        control.onclip.remove(onclip);
        control.onchildadd.remove(onchildadd);
        control.onchildremove.remove(onchildremove);
        control.onbounds.remove(onbounds);

        control.oncreate.remove(internal_connect);
        control.ondestroy.remove(internal_disconnect);

    } //internal_disconnect

    function onvisible(_v:Bool) {}
    function ondepth(_d:Float) {}
    function ondestroy() {}
    function onbounds() {}
    function onclip(_disable:Bool,_x:Float,_y:Float,_w:Float,_h:Float){}
    function onchildadd(_c:Control) {}
    function onchildremove(_c:Control) {}

} //Render

