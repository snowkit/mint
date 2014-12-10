package mint.render;

import mint.Types;
import mint.Renderer;

import mint.render.LuxeMintRender;
import phoenix.geometry.QuadGeometry;
import luxe.Color;

class Canvas extends mint.render.Base {

    var canvas : mint.Canvas;
    var back : QuadGeometry;

    public function new( _render:Renderer, _control:mint.Canvas ) {

        super(_render, _control);
        canvas = _control;

        trace('canvas create / ${control.name}');
        back = Luxe.draw.box({
            x:control.real_bounds.x,
            y:control.real_bounds.y,
            w:control.real_bounds.w,
            h:control.real_bounds.h,
            color: new Color(0,0,0,1).rgb(0x0c0c0c),
            depth: control.depth,
            visible: control.visible,
            clip_rect: Convert.rect(control.clip_rect)
        });

        connect();

    } //new

    override function ondestroy() {
        trace('canvas / destroy');

        disconnect();

        back.drop();
        back = null;

        destroy();
    }

    override function onclip( _rect:Rect ) {
        trace('canvas / clip / $_rect');
        if(_rect == null) {
            back.clip_rect = null;
        } else {
            back.clip_rect.set(_rect.x, _rect.y, _rect.w, _rect.h);
        }
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        trace('canvas / translate / $_x / $_y / $_offset');
        back.transform.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        trace('canvas / visible / $_visible');
        back.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        trace('canvas / depth / $_depth');
        back.depth = _depth;
    } //ondepth

} //Canvas
