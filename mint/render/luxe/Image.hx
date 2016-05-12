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
    @:optional var color: luxe.Color;
    @:optional var sizing: String; //:todo: type
}

class Image extends mint.render.Render {

    public var image : mint.Image;
    public var visual : Sprite;
    public var color : Color;

    var ratio_w : Float = 1.0;
    var ratio_h : Float = 1.0;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Image ) {

        image = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintImageOptions = image.options.options;

        var _texture = Luxe.resources.texture(image.options.path);
        
        if(_texture != null && _opt.sizing != null) {

            switch(_opt.sizing) {
                
                //sets the uv to be the size on the longest edge
                //possibly leaving whitespace on the sides (pillarbox) or top (letterbox)
                case 'fit': {
                    if(_texture.width > _texture.height) {
                        ratio_h = _texture.height/_texture.width;
                    } else {
                        ratio_w = _texture.width/_texture.height;
                    }
                } //fit

                    // cover the viewport with the size (possible cropping)
                case 'cover': {
                    var _rx = 1.0;
                    var _ry = 1.0;
                    if(_texture.width > _texture.height) {
                        _rx = _texture.height/_texture.width;
                    } else {
                        _ry = _texture.width/_texture.height;
                    }
                    _opt.uv = new luxe.Rectangle(0,0,_texture.width*_rx,_texture.height*_ry);
                } //cover

            } //switch sizing

        } //if opt.sizing != null

        visual = new luxe.Sprite({
            name: control.name+'.visual',
            batcher: render.options.batcher,
            centered: false,
            no_scene: true,
            texture: _texture,
            pos: new Vector(sx, sy),
            size: new Vector(sw*ratio_w, sh*ratio_h),
            depth: render.options.depth + control.depth,
            visible: control.visible,
            uv: _opt.uv,
            color: _opt.color
        });

        visual.clip_rect = Convert.bounds(control.clip_with, scale);

    } //new

    override function onscale(_scale:Float, _prev_scale:Float) {
        
        visual.clip_rect = Convert.bounds(control.clip_with, _scale);
        visual.pos.set_xy(sx, sy);
        visual.size.set_xy(sw*ratio_w, sh*ratio_h);

    } //onscale

    override function onbounds() {

        visual.transform.pos.set_xy(sx, sy);
        visual.geometry_quad.resize_xy(sw*ratio_w, sh*ratio_h);

    } //onbounds

    override function ondestroy() {

        visual.destroy();
        visual = null;

    } //ondestroy

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {

        visual.clip_rect = Convert.bounds(control.clip_with, scale);

    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = _visible;

    } //onvisible

    override function ondepth( _depth:Float ) {

        visual.depth = render.options.depth + _depth;

    } //ondepth

} //Image
