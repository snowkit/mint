package mint.render;

import mint.render.Renderer;
import mint.render.Rendering;
import mint.Control;
import mint.types.Types;

class Render implements Renderer {

    var rendering : Rendering;
    var control : Control;

    public function new( _render:Rendering, _control:mint.Control ) {
        control = _control;
        rendering = _render;
    }

    function connect() {
        control.onvisible.listen(onvisible);
        control.ondepth.listen(ondepth);
        control.ondestroy.listen(ondestroy);
        control.onclip.listen(onclip);
        control.onchild.listen(onchild);
        control.onbounds.listen(onbounds);
    }

    function disconnect() {
        control.onvisible.remove(onvisible);
        control.ondepth.remove(ondepth);
        control.ondestroy.remove(ondestroy);
        control.onclip.remove(onclip);
        control.onchild.remove(onchild);
        control.onbounds.remove(onbounds);
    }

    function destroy() {
        rendering.unfollow(control, this);
    }

    function onvisible(_v:Bool){}
    function ondepth(_d:Float){}
    function ondestroy(){}
    function onbounds(){}
    function onclip(_disable:Bool,_x:Float,_y:Float,_w:Float,_h:Float){}
    function onchild(_c:Control){}

} //Render

