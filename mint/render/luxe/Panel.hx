package mint.render.luxe;

import luxe.Vector;
import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import luxe.Color;
import luxe.Log.log;
import luxe.Log._debug;

class Panel extends mint.render.Base {

    var panel : mint.Panel;
    public var visual : QuadGeometry;

    public function new( _render:Renderer, _control:mint.Panel ) {

        super(_render, _control);
        panel = _control;

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
    }

    override function onclip( _rect:Rect ) {
        _debug('clip / ${control.name} / $_rect');
        if(_rect == null) {
            visual.clip_rect = null;
        } else {
            visual.clip_rect = Convert.rect(_rect);
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

} //Panel
