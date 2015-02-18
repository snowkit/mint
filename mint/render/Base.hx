package mint.render;

import mint.Renderer;
import mint.Control;
import mint.Types;

class Base implements ControlRenderer {

    var renderer : Renderer;
    var control : Control;

    public function new( _render:Renderer, _control:mint.Control ) {
        control = _control;
        renderer = _render;
    }

    function connect() {
        control.onvisible.listen(onvisible);
        control.ondepth.listen(ondepth);
        control.ondestroy.listen(ondestroy);
        control.onclip.listen(onclip);
        control.ontranslate.listen(ontranslate);
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
        renderer.unfollow(control, this);
    }

    function onvisible(_v:Bool){}
    function ondepth(_d:Float){}
    function ondestroy(){}
    function onbounds(){}
    function onclip(_r:Rect){}
    function onchild(_c:Control){}
    function ontranslate(_x:Float=0.0,_y:Float=0.0,_o:Bool=false){}

} //Base

