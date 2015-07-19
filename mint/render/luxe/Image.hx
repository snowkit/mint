package mint.render.luxe;

import mint.types.Types;
import mint.core.Macros.*;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

private typedef LuxeMintImageOptions = {
    @:optional var uv: luxe.Rectangle;
}

class Image extends mint.render.Render {

    public var image : mint.Image;
    public var visual : Sprite;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Image ) {

        image = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintImageOptions = image.options.options;

        var get = Luxe.resources.load_texture(image.options.path);

        get.then(function(texture){

            visual = new luxe.Sprite({
                batcher: render.options.batcher,
                centered: false,
                texture: texture,
                pos: new Vector(control.x, control.y),
                size: new Vector(control.w, control.h),
                depth: render.options.depth + control.depth,
                group: render.options.group,
                visible: control.visible,
                uv: _opt.uv
            });

            visual.clip_rect = Convert.bounds(control.clip_with);

        }); //get

    } //new

    override function onbounds() {

        if(visual != null) {
            visual.transform.pos.set_xy(control.x, control.y);
            visual.geometry_quad.resize_xy( control.w, control.h );
        }

    } //onbounds

    override function ondestroy() {

        if(visual != null) {
            visual.destroy();
            visual = null;
        }

    } //ondestroy

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {

        if(visual != null) {
            if(_disable) {
                visual.clip_rect = null;
            } else {
                visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
            }
        }

    } //onclip

    override function onvisible( _visible:Bool ) {

        if(visual != null) {
            visual.visible = _visible;
        }

    } //onvisible

    override function ondepth( _depth:Float ) {

        if(visual != null) {
            visual.depth = render.options.depth + _depth;
        }

    } //ondepth

} //Image
