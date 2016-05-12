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
    var scale (get, never) : Float;

    var sx (get, never) : Float;
    var sy (get, never) : Float;
    var sw (get, never) : Float;
    var sh (get, never) : Float;

    function new( _render:Rendering, _control:mint.Control ) {

        control = _control;
        rendering = _render;

        control.oncreate.listen(internal_connect);

    } //new

        /** Don't need to call this from Render subclasses */
    function internal_connect() {

        control.canvas.onscalechange.listen(onscale);
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

        control.canvas.onscalechange.remove(onscale);
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

    inline function get_scale() : Float return control.canvas.scale;
    inline function get_sx() : Float return control.x * control.canvas.scale;
    inline function get_sy() : Float return control.y * control.canvas.scale;
    inline function get_sw() : Float return control.w * control.canvas.scale;
    inline function get_sh() : Float return control.h * control.canvas.scale;
    inline function cs(_value:Float) return control.canvas.scale * _value;

    function onscale(_scale:Float, _prev:Float) {}
    function onvisible(_v:Bool) {}
    function ondepth(_d:Float) {}
    function ondestroy() {}
    function onbounds() {}
    function onclip(_disable:Bool,_x:Float,_y:Float,_w:Float,_h:Float){}
    function onchildadd(_c:Control) {}
    function onchildremove(_c:Control) {}

} //Render

