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

        color = def(_opt.color, new Color().rgb(0x19191a));
        color_handles = def(_opt.color_handles, new Color().rgb(0x9dca63));

        visual = new luxe.Sprite({
            name: control.name+'.visual',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(sx, sy),
            size: new Vector(sw, sh),
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
        });

        scrollh = new luxe.Sprite({
            name: control.name+'.scrollh',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(cs(scroll.scrollh.x), cs(scroll.scrollh.y)),
            size: new Vector(cs(scroll.scrollh.w), cs(scroll.scrollh.h)),
            color: color_handles,
            depth: render.options.depth + scroll.scrollh.depth,
            visible: scroll.visible_h,
        });

        scrollv = new luxe.Sprite({
            name: control.name+'.scrollv',
            batcher: render.options.batcher,
            no_scene: true,
            centered: false,
            pos: new Vector(cs(scroll.scrollv.x), cs(scroll.scrollv.y)),
            size: new Vector(cs(scroll.scrollv.w), cs(scroll.scrollv.h)),
            color: color_handles,
            depth: render.options.depth + scroll.scrollv.depth,
            visible: scroll.visible_v
        });

        update_clip(scale);

        scroll.onchange.listen(onchange);
        scroll.onhandlevis.listen(onhandlevis);

    }

    function update_clip(_scale:Float) {

        var _clip = Convert.bounds(control.clip_with, _scale);

        visual.clip_rect = _clip;
        scrollh.clip_rect = _clip;
        scrollv.clip_rect = _clip;

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {

        scrollh.geometry_quad.resize_xy(cs(scroll.scrollh.w), cs(scroll.scrollh.h));
        scrollv.geometry_quad.resize_xy(cs(scroll.scrollv.w), cs(scroll.scrollv.h));

        update_clip(_scale);

    } //onscale

    override function ondestroy() {

        scroll.onchange.remove(onchange);

        scrollh.destroy();
        scrollv.destroy();
        visual.destroy();
        visual = null;

    } //ondestroy

    override function onbounds() {

        visual.transform.pos.set_xy(sx, sy);
        visual.geometry_quad.resize_xy(sw, sh);
        
        //
        scrollh.pos.set_xy(cs(scroll.scrollh.x), cs(scroll.scrollh.y));
        scrollv.pos.set_xy(cs(scroll.scrollv.x), cs(scroll.scrollv.y));

    } //onbounds

    function onhandlevis(_h:Bool, _v:Bool) {

        scrollh.visible = _h && scroll.visible;
        scrollv.visible = _v && scroll.visible;

    } //onhandlevis

    function onchange() {

        scrollh.pos.x = cs(scroll.scrollh.x);
        scrollv.pos.y = cs(scroll.scrollv.y);

    } //onchange

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        
        update_clip(scale);

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
