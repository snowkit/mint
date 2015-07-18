package mint.render.luxe;

import luxe.Vector;
import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import luxe.Color;

class Panel extends mint.render.Base {

    public var panel : mint.Panel;
    public var visual : QuadGeometry;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Panel ) {

        panel = _control;
        render = _render;

        super(render, _control);

        visual = Luxe.draw.box({
            batcher: render.options.batcher,
            x:control.x,
            y:control.y,
            w:control.w,
            h:control.h,
            color: new Color(0,0,0,1).rgb(0x242424),
            depth: render.options.depth + control.depth,
            group: render.options.group,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        connect();

    } //new

    override function ondestroy() {
        disconnect();

        visual.drop();
        visual = null;

        destroy();
    }

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.resize_xy(control.w, control.h);
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
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
    } //ondepth

} //Panel
