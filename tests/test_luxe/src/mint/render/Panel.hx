package mint.render;

import mint.Types;
import mint.Renderer;

import mint.render.LuxeMintRender;
import mint.render.Convert;

import phoenix.geometry.QuadGeometry;
import luxe.Color;
import luxe.Log.log;
import luxe.Log._debug;

class Panel extends mint.render.Base {

    var panel : mint.Panel;
    var back : QuadGeometry;

    public function new( _render:Renderer, _control:mint.Panel ) {

        super(_render, _control);
        panel = _control;

        _debug('create / ${control.name}');
        back = Luxe.draw.box({
            x:control.real_bounds.x,
            y:control.real_bounds.y,
            w:control.real_bounds.w,
            h:control.real_bounds.h,
            color: new Color(0,0,0,1).rgb(0x242424),
            depth: control.depth,
            visible: control.visible,
            clip_rect: Convert.rect(control.clip_rect)
        });

        connect();

    } //new

    override function ondestroy() {
        _debug('destroy');

        disconnect();

        back.drop();
        back = null;

        destroy();
    }

    override function onclip( _rect:Rect ) {
        _debug('clip / $_rect');
        if(_rect == null) {
            back.clip_rect = null;
        } else {
            back.clip_rect.set(_rect.x, _rect.y, _rect.w, _rect.h);
        }
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        _debug('translate / $_x / $_y / $_offset');
        back.transform.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        _debug('visible / $_visible');
        back.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        _debug('depth / $_depth');
        back.depth = _depth;
    } //ondepth

} //Canvas
