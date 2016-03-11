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

        var get = Luxe.resources.load_texture(image.options.path);

        get.then(function(texture:phoenix.Texture){

            if(_opt.sizing != null) {

                switch(_opt.sizing) {
                        //sets the uv to be the size on the longest edge
                        //possibly leaving whitespace on the sides (pillarbox) or top (letterbox)
                    case 'fit': {
                        if(texture.width > texture.height) {
                            ratio_h = texture.height/texture.width;
                        } else {
                            ratio_w = texture.width/texture.height;
                        }
                    } //fit

                        // cover the viewport with the size (possible cropping)
                    case 'cover': {
                        var _rx = 1.0;
                        var _ry = 1.0;
                        if(texture.width > texture.height) {
                            _rx = texture.height/texture.width;
                        } else {
                            _ry = texture.width/texture.height;
                        }
                        _opt.uv = new luxe.Rectangle(0,0,texture.width*_rx,texture.height*_ry);
                    }

                }
            }

            visual = new luxe.Sprite({
                name: control.name+'.visual',
                batcher: render.options.batcher,
                centered: false,
                no_scene: true,
                texture: texture,
                pos: new Vector(control.x, control.y),
                size: new Vector(control.w*ratio_w, control.h*ratio_h),
                depth: render.options.depth + control.depth,
                visible: control.visible,
                uv: _opt.uv,
                color: _opt.color
            });

            visual.clip_rect = Convert.bounds(control.clip_with);

        }); //get

    } //new

    override function onbounds() {

        if(visual != null) {
            visual.transform.pos.set_xy(control.x, control.y);
            visual.geometry_quad.resize_xy( control.w*ratio_w, control.h*ratio_h );
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
