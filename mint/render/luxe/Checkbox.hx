package mint.render.luxe;

import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.Log.*;

private typedef LuxeMintCheckboxOptions = {
    var color_normal: Color;
    var color_hover: Color;
    var color_node: Color;
    var color_node_hover: Color;
}

class Checkbox extends mint.render.Render {

    public var checkbox : mint.Checkbox;
    public var visual : Sprite;
    public var node : Sprite;
    public var node_off : Sprite;

    public var color_normal: Color;
    public var color_hover: Color;
    public var color_node: Color;
    public var color_node_hover: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Checkbox ) {

        checkbox = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintCheckboxOptions = checkbox.options.options;

        color_normal = def(_opt.color_normal, new Color().rgb(0x373737));
        color_hover = def(_opt.color_hover, new Color().rgb(0x445158));
        color_node = def(_opt.color_node, new Color().rgb(0x9dca63));
        color_node_hover = def(_opt.color_node_hover, new Color().rgb(0xadca63));

        visual = new luxe.Sprite({
            batcher: render.options.batcher,
            centered: false,
            pos: new Vector(control.x, control.y),
            size: new Vector(control.w, control.h),
            color: color_normal,
            depth: render.options.depth + control.depth,
            group: render.options.group,
            visible: control.visible,
        });

        node_off = new luxe.Sprite({
            batcher: render.options.batcher,
            centered: false,
            pos: new Vector(control.x+4, control.y+4),
            size: new Vector(control.w-8, control.h-8),
            color: color_node.clone().set(null,null,null,0.25),
            depth: render.options.depth + control.depth + 0.001,
            group: render.options.group,
            visible: control.visible
        });

        node = new luxe.Sprite({
            batcher: render.options.batcher,
            centered: false,
            pos: new Vector(control.x+4, control.y+4),
            size: new Vector(control.w-8, control.h-8),
            color: color_node,
            depth: render.options.depth + control.depth + 0.002,
            group: render.options.group,
            visible: control.visible
        });

        visual.clip_rect = Convert.bounds(control.clip_with);
        node_off.clip_rect = Convert.bounds(control.clip_with);
        node.clip_rect = Convert.bounds(control.clip_with);

        checkbox.onmouseenter.listen(function(e,c) { node.color = color_node_hover; visual.color = color_hover; });
        checkbox.onmouseleave.listen(function(e,c) { node.color = color_node; visual.color = color_normal; });

        connect();

        checkbox.onchange.listen(oncheck);

    } //new

    function oncheck(_new:Bool, _old:Bool) {

        node.visible = _new;

    } //oncheck

    override function onbounds() {

        visual.transform.pos.set_xy(control.x, control.y);
        visual.geometry_quad.resize_xy( control.w, control.h );
        node_off.transform.pos.set_xy(control.x+4, control.y+4);
        node_off.geometry_quad.resize_xy( control.w-8, control.h-8 );
        node.transform.pos.set_xy(control.x+4, control.y+4);
        node.geometry_quad.resize_xy( control.w-8, control.h-8 );

    } //onbounds

    override function ondestroy() {

        disconnect();

        visual.destroy();
        node_off.destroy();
        node.destroy();

        visual = node = node_off = null;

        destroy();

    } //ondestroy

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {

        if(_disable) {
            visual.clip_rect = node_off.clip_rect = node.clip_rect = null;
        } else {
            visual.clip_rect = node_off.clip_rect = node.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }

    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = node_off.visible = _visible;

        if(_visible) {
            if(checkbox.state) node.visible = _visible;
        } else {
            node.visible = _visible;
        }

    } //onvisible

    override function ondepth( _depth:Float ) {

        visual.depth = render.options.depth + _depth;
        node_off.depth = visual.depth + 0.001;
        node.depth = visual.depth + 0.002;

    } //ondepth


} //Checkbox
