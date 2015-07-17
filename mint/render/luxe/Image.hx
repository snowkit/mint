package mint.render.luxe;

import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.Log.log;
import luxe.Log._debug;

class Image extends mint.render.Base {

    var image : mint.Image;
    var visual : Sprite;

    public function new( _render:Renderer, _control:mint.Image ) {

        super(_render, _control);
        image = _control;

        var get = Luxe.resources.load_texture(image.options.path);

        get.then(function(texture){

            _debug('create / ${control.name}');
            visual = new luxe.Sprite({
                centered: false,
                // color: Color.random(),
                texture: texture,
                pos: new Vector(control.x, control.y),
                size: new Vector(control.w, control.h),
                depth: control.depth,
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
        _debug('visible / $_visible');
        visual.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        _debug('depth / $_depth');
        visual.depth = _depth;
    } //ondepth

} //Image
