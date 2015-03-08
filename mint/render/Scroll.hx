package mint.render;

import mint.Types;
import mint.Renderer;

import mint.render.LuxeMintRender;
import mint.render.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.Log.log;
import luxe.Log._debug;

class Scroll extends mint.render.Base {

    var scroll : mint.ScrollArea;
    public var visual : Sprite;
    public var scrollh : Sprite;
    public var scrollv : Sprite;

    public function new( _render:Renderer, _control:mint.ScrollArea ) {

        super(_render, _control);
        scroll = _control;

        _debug('create / ${control.name}');
        visual = new luxe.Sprite({
            centered: false,
            pos: new Vector(control.real_bounds.x, control.real_bounds.y),
            size: new Vector(control.real_bounds.w, control.real_bounds.h),
            color: new Color().rgb(0x343434),
            depth: control.depth,
            visible: control.visible,
        });

        scrollh = new luxe.Sprite({
            centered: false,
            pos: new Vector(scroll.scroll.h.bounds.x, scroll.scroll.h.bounds.y),
            size: new Vector(scroll.scroll.h.bounds.w, scroll.scroll.h.bounds.h),
            color: new Color().rgb(0x9dca63),
            depth: control.depth+0.00001,
            visible: control.visible,
        });
        scrollv = new luxe.Sprite({
            centered: false,
            pos: new Vector(scroll.scroll.v.bounds.x, scroll.scroll.v.bounds.y),
            size: new Vector(scroll.scroll.v.bounds.w, scroll.scroll.v.bounds.h),
            color: new Color().rgb(0x9dca63),
            depth: control.depth+0.00001,
            visible: control.visible,
        });

        visual.clip_rect = Convert.rect(control.clip_rect);

        connect();
        scroll.onscroll.listen(onscroll);
        scroll.onhandlevis.listen(onhandlevis);
    }

    override function ondestroy() {
        _debug('destroy');

        disconnect();
        scroll.onscroll.remove(onscroll);

        visual.destroy();
        visual = null;

        destroy();
    } //ondestroy

    override function onbounds() {
        visual.transform.pos.set_xy(control.real_bounds.x, control.real_bounds.y);
        visual.geometry_quad.resize( new Vector(control.real_bounds.w, control.real_bounds.h) );
        //
        scrollh.pos.set_xy(scroll.scroll.h.bounds.x, scroll.scroll.h.bounds.y);
        scrollv.pos.set_xy(scroll.scroll.v.bounds.x, scroll.scroll.v.bounds.y);
    }

    function onhandlevis(_h:Bool, _v:Bool) {
        scrollh.visible = _h;
        scrollv.visible = _v;
    }

    function onscroll(_dx:Float=0.0, _dy:Float=0.0) {
        _debug('scroll / $_dx / $_dy');
        scrollh.pos.x = scroll.scroll.h.bounds.x;
        scrollv.pos.y = scroll.scroll.v.bounds.y;
    }

    override function onchild( _child:Control ) {
        scrollv.depth = scroll.depth+(scroll.nodes*0.001)+0.00001;
        scrollh.depth = scroll.depth+(scroll.nodes*0.001)+0.00001;
    }

    override function onclip( _rect:Rect ) {
        _debug('clip / $_rect');
        if(_rect == null) {
            visual.clip_rect = null;
        } else {
            visual.clip_rect = Convert.rect(_rect);
        }
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        _debug('translate / $_x / $_y / $_offset');
        visual.pos.add_xyz(_x, _y);
        scrollh.pos.add_xyz(_x, _y);
        scrollv.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        _debug('visible / $_visible');
        visual.visible = _visible;
        scrollh.visible = scroll.scroll.h.enabled;
        scrollv.visible = scroll.scroll.v.enabled;
    } //onvisible

    override function ondepth( _depth:Float ) {
        _debug('depth / $_depth');
        visual.depth = _depth;
        scrollv.depth = _depth+(scroll.nodes*0.001)+0.00001;
        scrollh.depth = _depth+(scroll.nodes*0.001)+0.00001;
    } //ondepth

} //Scroll
