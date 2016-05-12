package mint.render.luxe;

import luxe.Vector;
import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import luxe.Color;
import luxe.Log.*;

private typedef LuxeMintSliderOptions = {
    var color: Color;
    var color_bar: Color;
    var color_bar_hover: Color;
}

class Slider extends mint.render.Render {

    public var slider : mint.Slider;

    public var visual : QuadGeometry;
    public var bar : QuadGeometry;

    public var color: Color;
    public var color_bar: Color;
    public var color_bar_hover: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Slider ) {

        slider = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintSliderOptions = slider.options.options;

        color = def(_opt.color, new Color().rgb(0x373739));
        color_bar = def(_opt.color_bar, new Color().rgb(0x9dca63));
        color_bar_hover = def(_opt.color_bar_hover, new Color().rgb(0xb5d789));

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

        bar = Luxe.draw.box({
            id: control.name+'.bar',
            batcher: render.options.batcher,
            x: sx + cs(slider.bar_x),
            y: sy + cs(slider.bar_y),
            w: cs(slider.bar_w),
            h: cs(slider.bar_h),
            color: color_bar,
            depth: render.options.depth + control.depth + 0.001,
            visible: control.visible,
        });

        update_clip(scale);

        slider.onchange.listen(onchange);
        slider.onmouseenter.listen(function(_,_) { bar.color = color_bar_hover; });
        slider.onmouseleave.listen(function(_,_) { bar.color = color_bar; });

    } //new

    function update_clip(_scale:Float) {

        var _clip = Convert.bounds(control.clip_with, _scale);

        visual.clip_rect = _clip;
        bar.clip_rect = _clip;

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {

        update_clip(_scale);

    } //onscale

    function onchange(value:Float, prev_value:Float) {

        bar.transform.pos.set_xy(sx + cs(slider.bar_x), sy + cs(slider.bar_y));
        bar.resize_xy(cs(slider.bar_w), cs(slider.bar_h));

    } //onchange

    override function ondestroy() {

        visual.drop();
        bar.drop();
        visual = null;
        bar = null;

    } //ondestroy

    override function onbounds() {

        visual.transform.pos.set_xy(sx, sy);
        visual.resize_xy(sw, sh);

        bar.transform.pos.set_xy(sx+cs(slider.bar_x), sy+cs(slider.bar_y));
        bar.resize_xy(cs(slider.bar_w), cs(slider.bar_h));

    } //onbounds

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {

        update_clip(scale);

    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = _visible;
        bar.visible = _visible;

    } //onvisible

    override function ondepth( _depth:Float ) {

        visual.depth = render.options.depth + _depth;
        bar.depth = visual.depth + 0.001;

    } //ondepth

} //Slider
