package mint.render;

import mint.Types;
import mint.Renderer;

import mint.render.LuxeMintRender;
import mint.render.Convert;

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

        var get = Luxe.resources.load_texture(image.image_options.path);

        get.then(function(texture){

            _debug('create / ${control.name}');
            visual = new luxe.Sprite({
                centered: false,
                // color: Color.random(),
                texture: texture,
                pos: new Vector(control.real_bounds.x, control.real_bounds.y),
                size: new Vector(control.real_bounds.w, control.real_bounds.h),
                depth: control.depth,
                visible: control.visible,
            });

            visual.clip_rect = Convert.rect(control.clip_rect);

            connect();

        }); //

    }

    override function onbounds() {
        visual.transform.pos.set_xy(control.real_bounds.x, control.real_bounds.y);
        visual.geometry_quad.resize( new Vector(control.real_bounds.w, control.real_bounds.h) );
    }

    override function ondestroy() {
        disconnect();

        visual.destroy();
        visual = null;

        destroy();
    }

    override function onclip( _rect:Rect ) {
        _debug('clip / $_rect');
        if(_rect == null) visual.clip_rect = null;
        else visual.clip_rect = Convert.rect(_rect);
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        _debug('translate / $_x / $_y / $_offset');
        visual.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        _debug('visible / $_visible');
        visual.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        _debug('depth / $_depth');
        visual.depth = _depth;
    } //ondepth

} //Button
