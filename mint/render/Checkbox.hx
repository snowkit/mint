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

class Checkbox extends mint.render.Base {

    var box : mint.Checkbox;
    var visual : Sprite;
    var node : Sprite;

    public function new( _render:Renderer, _control:mint.Checkbox ) {

        super(_render, _control);
        box = _control;

        _debug('create / ${control.name}');
        visual = new luxe.Sprite({
            centered: false,
            pos: new Vector(control.real_bounds.x, control.real_bounds.y),
            size: new Vector(control.real_bounds.w, control.real_bounds.h),
            color: new Color().rgb(0x373737),
            depth: control.depth,
            visible: control.visible,
        });

        node = new luxe.Sprite({
            centered: false,
            pos: new Vector(control.real_bounds.x+4, control.real_bounds.y+4),
            size: new Vector(control.real_bounds.w-8, control.real_bounds.h-8),
            color: new Color().rgb(0x9dca63),
            depth: control.depth,
            visible: control.visible
        });

        visual.clip_rect = Convert.rect(control.clip_rect);
        node.clip_rect = Convert.rect(control.clip_rect);

        box.mouseenter.listen(function(e,c) { node.color.rgb(0xadca63); visual.color.rgb(0x445158); });
        box.mouseleave.listen(function(e,c) { node.color.rgb(0x9dca63); visual.color.rgb(0x373737); });
        box.mousedown.listen(function(e,c) { node.color.rgb(0x444444); visual.color.rgb(0x444444); });
        box.mouseup.listen(function(e,c) { node.color.rgb(0x9dca63); visual.color.rgb(0x445158); });

        connect();
        box.oncheck.listen(oncheck);

    }

    function oncheck(_new:Bool, _old:Bool) {

        node.visible = _new;

    } //oncheck

    override function onbounds() {
        visual.transform.pos.set_xy(control.real_bounds.x, control.real_bounds.y);
        visual.geometry_quad.resize( new Vector(control.real_bounds.w, control.real_bounds.h) );
        node.transform.pos.set_xy(control.real_bounds.x+4, control.real_bounds.y+4);
        node.geometry_quad.resize( new Vector(control.real_bounds.w-8, control.real_bounds.h-8) );
    }

    override function ondestroy() {
        disconnect();

        visual.destroy();
        node.destroy();

        visual = null;
        node = null;

        destroy();
    }

    override function onclip( _rect:Rect ) {
        _debug('clip / $_rect');
        if(_rect == null) {
            visual.clip_rect = null;
            node.clip_rect = null;
        } else {
            visual.clip_rect = Convert.rect(_rect);
            node.clip_rect = Convert.rect(_rect);
        }
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        _debug('translate / $_x / $_y / $_offset');
        visual.pos.add_xyz(_x, _y);
        node.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        _debug('visible / $_visible');
        visual.visible = _visible;
        node.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        _debug('depth / $_depth');
        visual.depth = _depth;
        node.depth = _depth;
    } //ondepth

} //Checkbox
