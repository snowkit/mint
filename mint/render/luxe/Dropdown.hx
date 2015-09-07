package mint.render.luxe;

import luxe.Vector;
import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import phoenix.geometry.RectangleGeometry;
import luxe.Color;
import luxe.Log.*;

private typedef LuxeMintDropdownOptions = {
    var color: Color;
    var color_border: Color;
}

class Dropdown extends mint.render.Render {

    public var dropdown : mint.Dropdown;
    public var visual : QuadGeometry;
    public var border : RectangleGeometry;

    public var color: Color;
    public var color_border: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Dropdown ) {

        dropdown = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintDropdownOptions = dropdown.options.options;

        color = def(_opt.color, new Color().rgb(0x373737));
        color_border = def(_opt.color_border, new Color().rgb(0x121212));

        visual = Luxe.draw.box({
            id: control.name+'.visual',
            batcher: render.options.batcher,
            x:control.x,
            y:control.y,
            w:control.w,
            h:control.h,
            color: color,
            depth: render.options.depth + control.depth,
            group: render.options.group,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        border = Luxe.draw.rectangle({
            id: control.name+'.border',
            batcher: render.options.batcher,
            x: control.x,
            y: control.y,
            w: control.w,
            h: control.h,
            color: color_border,
            depth: render.options.depth + control.depth+0.001,
            group: render.options.group,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

    } //new

    override function ondestroy() {
        visual.drop();
        border.drop();
        visual = null;
        border = null;
    }

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.resize_xy(control.w, control.h);
        border.set_xywh(control.x, control.y, control.w+1, control.h);
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = border.clip_rect = null;
        } else {
            visual.clip_rect = border.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip

    override function onvisible( _visible:Bool ) {
        visual.visible = border.visible = _visible;
    }

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
        border.depth = visual.depth+0.001;
    }


} //Dropdown
