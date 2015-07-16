package mint.render;

import luxe.Vector;
import mint.Types;
import mint.Renderer;

import mint.render.LuxeMintRender;
import mint.render.Convert;

import phoenix.geometry.QuadGeometry;
import luxe.Color;
import luxe.Log.log;
import luxe.Log._debug;

class Canvas extends mint.render.Base {

    var canvas : mint.Canvas;
    var visual : QuadGeometry;

    public function new( _render:Renderer, _control:mint.Canvas ) {

        super(_render, _control);
        canvas = _control;

        _debug('create / ${control.name}');
        visual = Luxe.draw.box({
            x:control.real_bounds.x,
            y:control.real_bounds.y,
            w:control.real_bounds.w,
            h:control.real_bounds.h,
            color: new Color(0,0,0,0).rgb(0x0c0c0c),
            depth: control.depth,
            visible: control.visible,
            clip_rect: Convert.rect(control.clip_rect),
        });

        connect();

    } //new

    override function ondestroy() {
        _debug('destroy');

        disconnect();

        visual.drop();
        visual = null;

        destroy();
    }

    override function onbounds() {
        visual.transform.pos.set_xy(control.real_bounds.x, control.real_bounds.y);
        visual.resize( new Vector(control.real_bounds.w, control.real_bounds.h) );
    }

    override function onclip( _rect:Rect ) {
        _debug('clip / $_rect');
        if(_rect == null) {
            visual.clip_rect = null;
        } else {
            visual.clip_rect.set(_rect.x, _rect.y, _rect.w, _rect.h);
        }
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        _debug('translate / $_x / $_y / $_offset / ${control.real_bounds}');
        visual.transform.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        _debug('visible / $_visible');
        visual.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        _debug('depth / $_depth');
        visual.depth = _depth;
    } //ondepth

} //Canvas
