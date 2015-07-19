package mint.render.luxe;

import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.Log.*;

private typedef LuxeMintButtonOptions = {
    var color_normal: Color;
    var color_hover: Color;
    var color_down: Color;
}

class Button extends mint.render.Render {

    public var button : mint.Button;
    public var visual : Sprite;

    public var color_normal: Color;
    public var color_hover: Color;
    public var color_down: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Button ) {

        render = _render;
        button = _control;

        super(render, _control);

        var _opt: LuxeMintButtonOptions = button.options.options;

        color_normal = def(_opt.color_normal, new Color().rgb(0x373737));
        color_hover = def(_opt.color_hover, new Color().rgb(0x445158));
        color_down = def(_opt.color_down, new Color().rgb(0x444444));

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

        visual.clip_rect = Convert.bounds(control.clip_with);

        button.onmouseenter.listen(function(e,c) { visual.color = color_hover; });
        button.onmouseleave.listen(function(e,c) { visual.color = color_normal; });
        button.onmousedown.listen(function(e,c) { visual.color = color_down; });
        button.onmouseup.listen(function(e,c) { visual.color = color_hover; });

        connect();

    } //new

    override function onbounds() {

        visual.transform.pos.set_xy(control.x, control.y);
        visual.geometry_quad.resize_xy(control.w, control.h);

    } //onbounds

    override function ondestroy() {

        visual.destroy();
        visual = null;

    } //ondestroy

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {

        if(_disable) {
            visual.clip_rect = null;
        } else {
            visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }

    } //onclip


    override function onvisible( _visible:Bool ) {

        visual.visible = _visible;

    } //onvisible

    override function ondepth( _depth:Float ) {

        visual.depth = render.options.depth + _depth;

    } //ondepth


} //Button
