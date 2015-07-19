package mint.render.luxe;

import luxe.Vector;
import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import phoenix.geometry.RectangleGeometry;
import luxe.Color;

class Dropdown extends mint.render.Render {

    public var dropdown : mint.Dropdown;
    public var visual : QuadGeometry;
    public var border : RectangleGeometry;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Dropdown ) {

        dropdown = _control;
        render = _render;

        super(render, _control);

        visual = Luxe.draw.box({
            batcher: render.options.batcher,
            x:control.x,
            y:control.y,
            w:control.w,
            h:control.h,
            color: new Color(0,0,0,1).rgb(0x373737),
            depth: render.options.depth + control.depth,
            group: render.options.group,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        border = Luxe.draw.rectangle({
            batcher: render.options.batcher,
            x: control.x,
            y: control.y,
            w: control.w,
            h: control.h,
            color: new Color(0,0,0,1).rgb(0x121212),
            depth: render.options.depth + control.depth+0.002,
            group: render.options.group,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        connect();

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
        border.set({ x:control.x, y:control.y, w:control.w, h:control.h, color:border.color });
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
        border.depth = render.options.depth + _depth+0.002;
    }


} //Dropdown
