package mint.render.luxe;

import mint.types.Types;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Text;
import luxe.Color;
import luxe.Log.*;

private typedef LuxeMintLabelOptions = {
    var color: Color;
    var color_hover: Color;
}

class Label extends mint.render.Render {

    public var label : mint.Label;
    public var text : Text;

    public var color_hover: Color;
    public var color: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Label ) {

        label = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintLabelOptions = label.options.options;

        color = def(_opt.color, new Color().rgb(0xffffff));
        color_hover = def(_opt.color_hover, new Color().rgb(0x9dca63));

        text = new luxe.Text({
            name: control.name+'.text',
            batcher: render.options.batcher,
            bounds: new luxe.Rectangle(sx, sy, sw, sh),
            no_scene: true,
            color: color,
            text: label.text,
            bounds_wrap: label.options.bounds_wrap,
            align: Convert.text_align(label.options.align),
            align_vertical: Convert.text_align(label.options.align_vertical),
            point_size: cs(label.options.text_size),
            depth: render.options.depth + control.depth,
            visible: control.visible
        });

        update_clip(scale);

        label.onchange.listen(ontext);

        control.onmouseenter.listen(function(e,c){ text.color = color_hover; });
        control.onmouseleave.listen(function(e,c){ text.color = color; });

    }

    function update_clip(_scale:Float) {
        
        text.clip_rect = Convert.clip_bounds(control.clip_with, render.options.batcher.view, _scale);

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {

        update_clip(_scale);
        text.point_size = cs(label.options.text_size);

    } //onscale

    override function onbounds() {

        text.bounds = new luxe.Rectangle(sx, sy, sw, sh);

    } //onbounds

    function ontext(_text:String) {

        text.text = _text;

    } //ontext

    override function ondestroy() {

        label.onchange.remove(ontext);

        text.destroy();
        text = null;

    } //ondestroy

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        
        update_clip(scale);

    } //onclip


    override function onvisible(_visible:Bool) {

        text.visible = _visible;

    } //onvisible

    override function ondepth(_depth:Float) {

        text.depth = render.options.depth + _depth;

    } //ondepth

} //Label
