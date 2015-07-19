package mint.render.luxe;

import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

class Scroll extends mint.render.Render {

    public var scroll : mint.Scroll;
    public var visual : Sprite;
    public var scrollh : Sprite;
    public var scrollv : Sprite;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Scroll ) {

        scroll = _control;
        render = _render;

        super(render, _control);

        visual = new luxe.Sprite({
            batcher: render.options.batcher,
            centered: false,
            pos: new Vector(control.x, control.y),
            size: new Vector(control.w, control.h),
            color: new Color().rgb(0x343434),
            depth: render.options.depth + control.depth,
            group: render.options.group,
            visible: control.visible,
        });

        scrollh = new luxe.Sprite({
            batcher: render.options.batcher,
            centered: false,
            pos: new Vector(scroll.scroll.h.x, scroll.scroll.h.y),
            size: new Vector(scroll.scroll.h.w, scroll.scroll.h.h),
            color: new Color().rgb(0x9dca63),
            depth: render.options.depth + control.depth+0.00001,
            group: render.options.group,
            visible: control.visible,
        });

        scrollv = new luxe.Sprite({
            batcher: render.options.batcher,
            centered: false,
            pos: new Vector(scroll.scroll.v.x, scroll.scroll.v.y),
            size: new Vector(scroll.scroll.v.w, scroll.scroll.v.h),
            color: new Color().rgb(0x9dca63),
            depth: render.options.depth + control.depth+0.00001,
            group: render.options.group,
            visible: control.visible,
        });

        visual.clip_rect = Convert.bounds(control.clip_with);

        connect();
        scroll.onscroll.listen(onscroll);
        scroll.onhandlevis.listen(onhandlevis);
    }

    override function ondestroy() {

        scroll.onscroll.remove(onscroll);

        visual.destroy();
        visual = null;

    } //ondestroy

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.geometry_quad.resize_xy( control.w, control.h );
        //
        scrollh.pos.set_xy(scroll.scroll.h.x, scroll.scroll.h.y);
        scrollv.pos.set_xy(scroll.scroll.v.x, scroll.scroll.v.y);
    }

    function onhandlevis(_h:Bool, _v:Bool) {
        scrollh.visible = _h;
        scrollv.visible = _v;
    }

    function onscroll(_dx:Float=0.0, _dy:Float=0.0) {
        scrollh.pos.x = scroll.scroll.h.x;
        scrollv.pos.y = scroll.scroll.v.y;
    }

    override function onchild( _child:Control ) {
        scrollv.depth = scroll.depth+(scroll.nodes*0.001)+0.00001;
        scrollh.depth = scroll.depth+(scroll.nodes*0.001)+0.00001;
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = null;
        } else {
            visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip


    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        scrollh.visible = scroll.scroll.h.enabled && _visible;
        scrollv.visible = scroll.scroll.v.enabled && _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
        scrollv.depth = render.options.depth + _depth+(scroll.nodes*0.001)+0.00001;
        scrollh.depth = render.options.depth + _depth+(scroll.nodes*0.001)+0.00001;
    } //ondepth

} //Scroll
