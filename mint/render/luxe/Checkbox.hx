package mint.render.luxe;

import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

class Checkbox extends mint.render.Base {

    var box : mint.Checkbox;
    var visual : Sprite;
    var node : Sprite;

    public function new( _render:LuxeMintRender, _control:mint.Checkbox ) {

        super(_render, _control);
        box = _control;

        visual = new luxe.Sprite({
            batcher: _render.options.batcher,
            centered: false,
            pos: new Vector(control.x, control.y),
            size: new Vector(control.w, control.h),
            color: new Color().rgb(0x373737),
            depth: control.depth,
            visible: control.visible,
        });

        node = new luxe.Sprite({
            batcher: _render.options.batcher,
            centered: false,
            pos: new Vector(control.x+4, control.y+4),
            size: new Vector(control.w-8, control.h-8),
            color: new Color().rgb(0x9dca63),
            depth: control.depth,
            visible: control.visible
        });

        visual.clip_rect = Convert.bounds(control.clip_with);
        node.clip_rect = Convert.bounds(control.clip_with);

        box.onmouseenter.listen(function(e,c) { node.color.rgb(0xadca63); visual.color.rgb(0x445158); });
        box.onmouseleave.listen(function(e,c) { node.color.rgb(0x9dca63); visual.color.rgb(0x373737); });
        box.onmousedown.listen(function(e,c) { node.color.rgb(0x444444); visual.color.rgb(0x444444); });
        box.onmouseup.listen(function(e,c) { node.color.rgb(0x9dca63); visual.color.rgb(0x445158); });

        connect();
        box.onchange.listen(oncheck);

    }

    function oncheck(_new:Bool, _old:Bool) {

        node.visible = _new;

    } //oncheck

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.geometry_quad.resize_xy( control.w, control.h );
        node.transform.pos.set_xy(control.x+4, control.y+4);
        node.geometry_quad.resize_xy( control.w-8, control.h-8 );
    }

    override function ondestroy() {
        disconnect();

        visual.destroy();
        node.destroy();

        visual = null;
        node = null;

        destroy();
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = null;
            node.clip_rect = null;
        } else {
            visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
            node.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip


    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        node.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = _depth;
        node.depth = _depth;
    } //ondepth

} //Checkbox
