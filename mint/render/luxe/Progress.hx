package mint.render.luxe;

import luxe.Vector;
import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import luxe.Color;
import luxe.Log.*;

private typedef LuxeMintProgressOptions = {
    var color: Color;
    var color_bar: Color;
}

class Progress extends mint.render.Render {

    public var progress : mint.Progress;
    public var visual : QuadGeometry;
    public var bar : QuadGeometry;

    public var color: Color;
    public var color_bar: Color;

    var render: LuxeMintRender;
    var margin: Float = 2.0;

    public function new( _render:LuxeMintRender, _control:mint.Progress ) {

        progress = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintProgressOptions = progress.options.options;

        color = def(_opt.color, new Color().rgb(0x242424));
        color_bar = def(_opt.color_bar, new Color().rgb(0x9dca63));

        visual = Luxe.draw.box({
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

        bar = Luxe.draw.box({
            batcher: render.options.batcher,
            x:control.x+margin,
            y:control.y+margin,
            w:get_bar_width(progress.progress),
            h:control.h-(margin*2),
            color: color_bar,
            depth: render.options.depth + control.depth + 0.001,
            group: render.options.group,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        progress.onchange.listen(function(cur, prev){
            bar.resize_xy(get_bar_width(cur), control.h-(margin*2));
        });

    } //new

    function get_bar_width(_progress:Float) {
        var _width = (control.w-(margin*2)) * _progress;
        if(_width <= 1) _width = 1;
        var _control_w = (control.w - margin);
        if(_width >= _control_w) _width = _control_w;
        return _width;
    }

    override function ondestroy() {

        visual.drop();
        visual = null;

    }

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.resize_xy(control.w, control.h);
        bar.transform.pos.set_xy(control.x+margin, control.y+margin);
        bar.resize_xy(get_bar_width(progress.progress), control.h-(margin*2));
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = null;
            bar.clip_rect = null;
        } else {
            visual.clip_rect = bar.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip

    override function onvisible( _visible:Bool ) {
        visual.visible = bar.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
        bar.depth = visual.depth + 0.001;
    } //ondepth

} //Progress
