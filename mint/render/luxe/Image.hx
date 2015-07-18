package mint.render.luxe;

import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

class Image extends mint.render.Base {

    public var image : mint.Image;
    public var visual : Sprite;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Image ) {

        image = _control;
        render = _render;

        super(render, _control);

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
            });

            visual.clip_rect = Convert.bounds(control.clip_with);

            connect();

        }); //

    }

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.geometry_quad.resize_xy( control.w, control.h );
    }

    override function ondestroy() {
        disconnect();

        visual.destroy();
        visual = null;

        destroy();
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

} //Image
