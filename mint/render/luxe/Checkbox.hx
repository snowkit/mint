package mint.render.luxe;

import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

class Checkbox extends mint.render.Base {

    public var checkbox : mint.Checkbox;
    public var visual : Sprite;
    public var node : Sprite;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Checkbox ) {

        checkbox = _control;
        render = _render;

        super(render, _control);

        visual = new luxe.Sprite({
            batcher: render.options.batcher,
            centered: false,
            pos: new Vector(control.x, control.y),
            size: new Vector(control.w, control.h),
            color: new Color().rgb(0x373737),
            depth: render.options.depth + control.depth,
            group: render.options.group,
            visible: control.visible,
        });

        node = new luxe.Sprite({
            batcher: render.options.batcher,
            centered: false,
            pos: new Vector(control.x+4, control.y+4),
            size: new Vector(control.w-8, control.h-8),
            color: new Color().rgb(0x9dca63),
            depth: render.options.depth + control.depth + 0.001,
            group: render.options.group,
            visible: control.visible
        });

        visual.clip_rect = Convert.bounds(control.clip_with);
        node.clip_rect = Convert.bounds(control.clip_with);

        checkbox.onmouseenter.listen(function(e,c) { node.color.rgb(0xadca63); visual.color.rgb(0x445158); });
        checkbox.onmouseleave.listen(function(e,c) { node.color.rgb(0x9dca63); visual.color.rgb(0x373737); });
        checkbox.onmousedown.listen(function(e,c) { node.color.rgb(0x444444); visual.color.rgb(0x444444); });
        checkbox.onmouseup.listen(function(e,c) { node.color.rgb(0x9dca63); visual.color.rgb(0x445158); });

        connect();
        checkbox.onchange.listen(oncheck);

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

        visual = node = null;

        destroy();
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = node.clip_rect = null;
        } else {
            visual.clip_rect = node.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip


    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        if(_visible) {
            if(checkbox.state) node.visible = _visible;
        } else {
            node.visible = _visible;
        }
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
        node.depth = visual.depth + 0.001;
    } //ondepth

} //Checkbox
