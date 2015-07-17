package mint.render.luxe;

import luxe.Vector;
import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import phoenix.geometry.RectangleGeometry;
import luxe.Color;
import luxe.Log.log;
import luxe.Log._debug;

class Window extends mint.render.Base {

    var window : mint.Window;
    var visual : QuadGeometry;
    var top : QuadGeometry;
    var border : RectangleGeometry;

    public function new( _render:Renderer, _control:mint.Window ) {

        super(_render, _control);
        window = _control;

        _debug('create / ${control.name}');
        visual = Luxe.draw.box({
            x:control.real_bounds.x,
            y:control.real_bounds.y,
            w:control.real_bounds.w,
            h:control.real_bounds.h,
            color: new Color(0,0,0,1).rgb(0x242424),
            depth: control.depth,
            visible: control.visible,
            clip_rect: Convert.rect(control.clip_rect)
        });

        top = Luxe.draw.box({
            x: window.title.real_bounds.x,
            y:window.title.real_bounds.y,
            w:window.title.real_bounds.w,
            h:window.title.real_bounds.h,
            color: new Color(0,0,0,1).rgb(0x373737),
            depth: window.depth,
            visible: window.visible,
            clip_rect: Convert.rect(window.clip_rect)
        });

        border = Luxe.draw.rectangle({
            x: window.real_bounds.x,
            y: window.real_bounds.y,
            w: window.real_bounds.w,
            h: window.real_bounds.h,
            color: new Color(0,0,0,1).rgb(0x373739),
            depth: window.depth+0.001,
            visible: window.visible,
            clip_rect: Convert.rect(window.clip_rect)
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
        visual.resize_xy( control.real_bounds.w, control.real_bounds.h );
        top.transform.pos.set_xy(window.title.real_bounds.x, window.title.real_bounds.y);
        top.resize_xy( window.title.real_bounds.w, window.title.real_bounds.h );
        border.set({ x:control.real_bounds.x, y:control.real_bounds.y, w:control.real_bounds.w, h:control.real_bounds.h, color:border.color });
    }

    override function onclip( _rect:Rect ) {
        _debug('clip / ${control.name} / $_rect');
        if(_rect == null) {
            visual.clip_rect = null;
            top.clip_rect = null;
            border.clip_rect = null;
        } else {
            var cr = Convert.rect(_rect);
            visual.clip_rect = cr;
            top.clip_rect = cr;
            border.clip_rect = cr;
        }
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        _debug('translate / ${control.name} / $_x / $_y / $_offset');
        visual.transform.pos.add_xyz(_x, _y);
        top.transform.pos.add_xyz(_x, _y);
        border.transform.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        _debug('visible / $_visible');
        visual.visible = _visible;
        top.visible = _visible;
        border.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        _debug('depth / $_depth');
        visual.depth = _depth;
        top.depth = _depth;
        border.depth = _depth+0.001;
    } //ondepth

} //Window
