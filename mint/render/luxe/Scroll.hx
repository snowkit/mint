package mint.render.luxe;

import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.Log.*;

private typedef LuxeMintScrollOptions = {
    var color: Color;
    var color_handles: Color;
}

class Scroll extends mint.render.Render {

    public var scroll : mint.Scroll;
    public var visual : Sprite;

    public var scrollh : Sprite;
    public var scrollv : Sprite;

    public var color: Color;
    public var color_handles: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Scroll ) {

        scroll = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintScrollOptions = scroll.options.options;

        color = def(_opt.color, new Color().rgb(0x343434));
        color_handles = def(_opt.color_handles, new Color().rgb(0x9dca63));

        visual = new luxe.Sprite({
            name: control.name+'.visual',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(control.x, control.y),
            size: new Vector(control.w, control.h),
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
        });

        scrollh = new luxe.Sprite({
            name: control.name+'.scrollh',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(scroll.scrollh.x, scroll.scrollh.y),
            size: new Vector(scroll.scrollh.w, scroll.scrollh.h),
            color: color_handles,
            depth: render.options.depth + scroll.scrollh.depth,
            visible: scroll.visible_h,
        });

        scrollv = new luxe.Sprite({
            name: control.name+'.scrollv',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(scroll.scrollv.x, scroll.scrollv.y),
            size: new Vector(scroll.scrollv.w, scroll.scrollv.h),
            color: color_handles,
            depth: render.options.depth + scroll.scrollv.depth,
            visible: scroll.visible_v
        });

        visual.clip_rect = Convert.bounds(control.clip_with);

        scroll.onchange.listen(onchange);
        scroll.onhandlevis.listen(onhandlevis);

    }

    override function ondestroy() {

        scroll.onchange.remove(onchange);

        scrollh.destroy();
        scrollv.destroy();
        visual.destroy();
        visual = null;

    } //ondestroy

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.geometry_quad.resize_xy( control.w, control.h );
        //
        scrollh.pos.set_xy(scroll.scrollh.x, scroll.scrollh.y);
        scrollv.pos.set_xy(scroll.scrollv.x, scroll.scrollv.y);
    }

    function onhandlevis(_h:Bool, _v:Bool) {
        scrollh.visible = _h && scroll.visible;
        scrollv.visible = _v && scroll.visible;
    }

    function onchange() {
        scrollh.pos.x = scroll.scrollh.x;
        scrollv.pos.y = scroll.scrollv.y;
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
        scrollh.visible = scroll.visible_h && _visible;
        scrollv.visible = scroll.visible_v && _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
        scrollv.depth = render.options.depth + scroll.scrollv.depth;
        scrollh.depth = render.options.depth + scroll.scrollh.depth;
    } //ondepth

} //Scroll
