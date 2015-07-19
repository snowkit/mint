package mint.render;

import mint.render.Renderer;
import mint.render.Rendering;
import mint.Control;
import mint.types.Types;

/** The basic implementation for a control Renderer.
    This includes convenience functions and implementation
    of the base control events which can be called
    to simplify integration. Be aware of the timing,
    as signals connected before Renderer details are ready
    may fire from the controls ahead of your init. */
class Render implements Renderer {

    var rendering : Rendering;
    var control : Control;

    function new( _render:Rendering, _control:mint.Control ) {

        control = _control;
        rendering = _render;

        control.ondestroy.listen(internal_disconnect);

    } //new

    function connect() {

        control.onvisible.listen(onvisible);
        control.ondepth.listen(ondepth);
        control.ondestroy.listen(ondestroy);
        control.onclip.listen(onclip);
        control.onchild.listen(onchild);
        control.onbounds.listen(onbounds);

    } //connect

        /** Don't need to call this from Render subclasses */
    function internal_disconnect() {

        control.onvisible.remove(onvisible);
        control.ondepth.remove(ondepth);
        control.ondestroy.remove(ondestroy);
        control.onclip.remove(onclip);
        control.onchild.remove(onchild);
        control.onbounds.remove(onbounds);

        control.ondestroy.remove(internal_disconnect);

    } //internal_disconnect

    function onvisible(_v:Bool){}
    function ondepth(_d:Float){}
    function ondestroy(){}
    function onbounds(){}
    function onclip(_disable:Bool,_x:Float,_y:Float,_w:Float,_h:Float){}
    function onchild(_c:Control){}

} //Render

