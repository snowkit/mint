package mint.render;

import mint.Types;
import mint.Renderer;

import mint.render.LuxeMintRender;
import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

class Image extends mint.render.Base {

    var image : mint.Image;
    var visual : Sprite;

    public function new( _render:Renderer, _control:mint.Image ) {

        super(_render, _control);
        image = _control;

        trace('image create / ${control.name}');
        visual = new luxe.Sprite({
            centered: false,
            texture: Luxe.loadTexture(image.image_options.path),
            pos: new Vector(control.real_bounds.x, control.real_bounds.y),
            size: new Vector(control.real_bounds.w, control.real_bounds.h),
            depth: control.depth,
            visible: control.visible,
        });

        visual.clip_rect = Convert.rect(control.clip_rect);

        connect();
    }

    override function ondestroy() {
        disconnect();

        visual.destroy();
        visual = null;

        destroy();
    }

    override function onclip( _rect:Rect ) {
        trace('image / clip / $_rect');
        if(_rect == null) visual.clip_rect = null;
        else visual.clip_rect = Convert.rect(_rect);
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        trace('image / translate / $_x / $_y / $_offset');
        visual.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        trace('image / visible / $_visible');
        visual.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        trace('image / depth / $_depth');
        visual.depth = _depth;
    } //ondepth

} //Button
