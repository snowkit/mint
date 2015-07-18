package mint.render.luxe;

import luxe.Vector;
import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import phoenix.geometry.RectangleGeometry;
import luxe.Color;

class Window extends mint.render.Base {

    public var window : mint.Window;
    public var visual : QuadGeometry;
    public var top : QuadGeometry;
    public var border : RectangleGeometry;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Window ) {

        window = _control;
        render = _render;

        super(render, _control);

        visual = Luxe.draw.box({
            batcher: render.options.batcher,
            x:window.x,
            y:window.y,
            w:window.w,
            h:window.h,
            color: new Color(0,0,0,1).rgb(0x242424),
            depth: render.options.depth + window.depth,
            group: render.options.group,
            visible: window.visible,
            clip_rect: Convert.bounds(window.clip_with)
        });

        top = Luxe.draw.box({
            batcher: render.options.batcher,
            x: window.title.x,
            y:window.title.y,
            w:window.title.w,
            h:window.title.h,
            color: new Color(0,0,0,1).rgb(0x373737),
            depth: render.options.depth + window.depth,
            group: render.options.group,
            visible: window.visible,
            clip_rect: Convert.bounds(window.clip_with)
        });

        border = Luxe.draw.rectangle({
            batcher: render.options.batcher,
            x: window.x,
            y: window.y,
            w: window.w,
            h: window.h,
            color: new Color(0,0,0,1).rgb(0x373739),
            depth: render.options.depth + window.depth+0.001,
            group: render.options.group,
            visible: window.visible,
            clip_rect: Convert.bounds(window.clip_with)
        });

        connect();

    } //new

    override function ondestroy() {
        disconnect();

        visual.drop();
        visual = null;

        destroy();
    }

    override function onbounds() {
        visual.transform.pos.set_xy(window.x, window.y);
        visual.resize_xy(window.w, window.h);
        top.transform.pos.set_xy(window.title.x, window.title.y);
        top.resize_xy(window.title.w, window.title.h);
        border.set({ x:window.x, y:window.y, w:window.w, h:window.h, color:border.color });
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = null;
            top.clip_rect = null;
            border.clip_rect = null;
        } else {
            visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
            top.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
            border.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip

    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        top.visible = _visible;
        border.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
        top.depth = render.options.depth + _depth;
        border.depth = render.options.depth + _depth+0.001;
    } //ondepth

} //Window
