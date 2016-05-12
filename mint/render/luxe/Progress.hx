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
            id: control.name+'.visual',
            batcher: render.options.batcher,
            x: sx,
            y: sy,
            w: sw,
            h: sh,
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
        });

        var _margin = cs(margin);

        bar = Luxe.draw.box({
            id: control.name+'.bar',
            batcher: render.options.batcher,
            x: sx+_margin,
            y: sy+_margin,
            w: get_bar_width(progress.progress),
            h: sh-(_margin*2),
            color: color_bar,
            depth: render.options.depth + control.depth + 0.001,
            visible: control.visible,
        });

        update_clip(scale);

        progress.onchange.listen(function(cur, prev){
            bar.resize_xy(get_bar_width(cur), sh-(cs(margin)*2));
        });

    } //new

    function update_clip(_scale:Float) {
        
        var _clip = Convert.bounds(control.clip_with, _scale);

        visual.clip_rect = _clip;
        bar.clip_rect = _clip;

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {
        
        update_clip(_scale);

    } //onscale

    function get_bar_width(_progress:Float) {

        var _margin = cs(margin);
        var _max_w = (sw - _margin);
        var _width = (sw-(_margin*2)) * _progress;

        _width = Helper.clamp(_width, 1, _max_w);
        // if(_width <= 1) _width = 1;
        // if(_width >= _max_w) _width = _max_w;

        return _width;

    } //get_bar_width

    override function ondestroy() {

        visual.drop();
        bar.drop();
        visual = null;
        bar = null;

    }

    override function onbounds() {

        var _margin = cs(margin);
        
        visual.transform.pos.set_xy(sx, sy);
        visual.resize_xy(sw, sh);
        
        bar.transform.pos.set_xy(sx+_margin, sy+_margin);
        bar.resize_xy(get_bar_width(progress.progress), sh-(_margin*2));

    } //onbounds

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        
        update_clip(scale);

    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = bar.visible = _visible;

    } //onvisible

    override function ondepth( _depth:Float ) {

        visual.depth = render.options.depth + _depth;
        bar.depth = visual.depth + 0.001;

    } //ondepth

} //Progress
