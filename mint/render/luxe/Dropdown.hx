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
            x: sx,
            y: sy,
            w: sw,
            h: sh,
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
        });

        border = Luxe.draw.rectangle({
            id: control.name+'.border',
            batcher: render.options.batcher,
            x: sx,
            y: sy,
            w: sw,
            h: sh,
            color: color_border,
            depth: render.options.depth + control.depth+0.001,
            visible: control.visible,
        });

        update_clip(scale);

    } //new

    function update_clip(_scale:Float) {

        var _clip = Convert.clip_bounds(control.clip_with, render.options.batcher.view, _scale);

        visual.clip_rect = _clip;
        border.clip_rect = _clip;

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {
        
        update_clip(_scale);

    } //onscale

    override function ondestroy() {

        visual.drop();
        border.drop();
        
        visual = null;
        border = null;

    } //ondestroy

    override function onbounds() {

        visual.transform.pos.set_xy(sx, sy);
        visual.resize_xy(sw, sh);
        border.set_xywh(sx, sy, sw+1, sh);

    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        
        update_clip(scale);

    } //onclip

    override function onvisible(_visible:Bool) {

        visual.visible = border.visible = _visible;

    } //onvisible

    override function ondepth(_depth:Float) {

        visual.depth = render.options.depth + _depth;
        border.depth = visual.depth+0.001;

    } //ondepth


} //Dropdown
