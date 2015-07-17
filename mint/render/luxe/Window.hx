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
            x:control.x,
            y:control.y,
            w:control.w,
            h:control.h,
            color: new Color(0,0,0,1).rgb(0x242424),
            depth: control.depth,
            visible: control.visible,
            clip_rect: Convert.rect(control.clip_rect)
        });

        top = Luxe.draw.box({
            x: window.title.x,
            y:window.title.y,
            w:window.title.w,
            h:window.title.h,
            color: new Color(0,0,0,1).rgb(0x373737),
            depth: window.depth,
            visible: window.visible,
            clip_rect: Convert.rect(window.clip_rect)
        });

        border = Luxe.draw.rectangle({
            x: window.x,
            y: window.y,
            w: window.w,
            h: window.h,
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
        visual.transform.pos.set_xy(control.x, control.y);
        visual.resize_xy(control.w, control.h);
        top.transform.pos.set_xy(window.title.x, window.title.y);
        top.resize_xy(window.title.w, window.title.h);
        border.set({ x:control.x, y:control.y, w:control.w, h:control.h, color:border.color });
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
