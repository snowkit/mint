package mint.render.luxe;

import luxe.Vector;
import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import luxe.Color;
import luxe.Log.*;

private typedef LuxeMintPanelOptions = {
    var color: Color;
}

class Panel extends mint.render.Render {

    public var panel : mint.Panel;
    public var visual : QuadGeometry;

    public var color: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Panel ) {

        panel = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintPanelOptions = panel.options.options;

        color = def(_opt.color, new Color().rgb(0x242424));

        visual = Luxe.draw.box({
            id: control.name+'.visual',
            batcher: render.options.batcher,
            x:control.x,
            y:control.y,
            w:control.w,
            h:control.h,
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

    } //new

    override function ondestroy() {

        visual.drop();
        visual = null;

    } //ondestroy

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
