package mint.render;

import mint.Types;
import mint.Renderer;

import mint.render.LuxeMintRender;
import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

class Button extends mint.render.Base {

    var button : mint.Button;
    var visual : Sprite;

    public function new( _render:Renderer, _control:mint.Button ) {

        super(_render, _control);
        button = _control;

        trace('button create / ${control.name}');
        visual = new luxe.Sprite({
            centered: false,
            pos: new Vector(control.real_bounds.x, control.real_bounds.y),
            size: new Vector(control.real_bounds.w, control.real_bounds.h),
            color: new Color().rgb(0x242424),
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
        trace('button / clip / $_rect');
        if(_rect == null) visual.clip_rect = null;
        else visual.clip_rect = Convert.rect(_rect);
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        trace('button / translate / $_x / $_y / $_offset');
        visual.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        trace('button / visible / $_visible');
        visual.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        trace('button / depth / $_depth');
        visual.depth = _depth;
    } //ondepth

} //Button
