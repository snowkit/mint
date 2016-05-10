package mint.render.luxe;

import luxe.Vector;
import mint.types.Types;
import mint.core.Macros.*;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import phoenix.geometry.RectangleGeometry;
import phoenix.geometry.Geometry;
import luxe.Color;

private typedef LuxeMintWindowOptions = {
    @:optional var color: Color;
    @:optional var color_titlebar: Color;
    @:optional var color_border: Color;
    @:optional var color_collapse: Color;
    @:optional var color_collapse_hover: Color;
    @:optional var color_close: Color;
    @:optional var color_close_hover: Color;
    @:optional var size_close: Float;
}

class Window extends mint.render.Render {

    public var window : mint.Window;
    public var visual : QuadGeometry;
    public var top : QuadGeometry;
    public var collapse : Geometry;
    public var close : Geometry;
    public var border : RectangleGeometry;

    public var color: Color;
    public var color_titlebar: Color;
    public var color_border: Color;
    public var color_close: Color;
    public var color_collapse: Color;
    public var color_close_hover: Color;
    public var color_collapse_hover: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.Window ) {

        window = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintWindowOptions = window.options.options;

        color = def(_opt.color, new Color().rgb(0x242424));
        color_border = def(_opt.color_border, new Color().rgb(0x373739));
        color_titlebar = def(_opt.color_titlebar, new Color().rgb(0x373737));
        color_close = def(_opt.color_close, new Color().rgb(0x666666));
        color_collapse = def(_opt.color_collapse, new Color().rgb(0x666666));
        color_close_hover = def(_opt.color_close_hover, new Color().rgb(0x999999));
        color_collapse_hover = def(_opt.color_collapse_hover, new Color().rgb(0x999999));

        visual = Luxe.draw.box({
            id: control.name+'.visual',
            batcher: render.options.batcher,
            x:window.x,
            y:window.y,
            w:window.w,
            h:window.h,
            color: color,
            depth: render.options.depth + window.depth,
            visible: window.visible,
            clip_rect: Convert.bounds(window.clip_with)
        });

        top = Luxe.draw.box({
            id: control.name+'.top',
            batcher: render.options.batcher,
            x: window.title.x,
            y:window.title.y,
            w:window.title.w,
            h:window.title.h,
            color: color_titlebar,
            depth: render.options.depth + window.depth+0.001,
            visible: window.visible,
            clip_rect: Convert.bounds(window.clip_with)
        });

        border = Luxe.draw.rectangle({
            id: control.name+'.border',
            batcher: render.options.batcher,
            x: window.x,
            y: window.y,
            w: window.w+1,
            h: window.h,
            color: color_border,
            depth: render.options.depth + window.depth+0.002,
            visible: window.visible,
            clip_rect: Convert.bounds(window.clip_with)
        });

        collapse = Luxe.draw.ngon({
            id: control.name+'.border',
            batcher: render.options.batcher,
            r: 5,
            solid: true,
            angle: 180,
            sides: 3,
            color: color_collapse,
            depth: render.options.depth + window.depth+0.003,
            visible: window.collapsible && window.visible,
            clip_rect: Convert.bounds(window.clip_with)
        });

        var _close_poly = [
            new Vector( 0.00,  0.00),
            new Vector(-0.50,  0.33),
            new Vector(-0.17,  0.00),
            new Vector(-0.50, -0.33),
            new Vector(-0.33, -0.50),
            new Vector( 0.00, -0.17),
            new Vector( 0.33, -0.50),
            new Vector( 0.50, -0.33),
            new Vector( 0.17,  0.00),
            new Vector( 0.50,  0.33),
            new Vector( 0.33,  0.50),
            new Vector( 0.00,  0.17),
            new Vector(-0.33,  0.50),
            new Vector(-0.50,  0.33),
        ];

        var _close_size = def(_opt.size_close, 10); 
        for(_point in _close_poly) _point.multiplyScalar(_close_size);

        close = Luxe.draw.poly({
            id: control.name+'.border',
            batcher: render.options.batcher,
            points: _close_poly,
            close: true,
            solid: true,
            color: color_close,
            depth: render.options.depth + window.depth+0.004,
            visible: window.closable && window.visible,
            clip_rect: Convert.bounds(window.clip_with)
        });

        var _closer = window.close_handle;
        close.transform.pos.set_xy(_closer.x+(_closer.w/2), _closer.y+(_closer.h/2));
        _closer.onmouseenter.listen(function(_,_){ close.color = color_close_hover; });
        _closer.onmouseleave.listen(function(_,_){ close.color = color_close; });
        _closer.onbounds.listen(function(){ close.transform.pos.set_xy(_closer.x+(_closer.w/2), _closer.y+(_closer.h/2)); });
        _closer.onvisible.listen(function(_visible:Bool){ close.visible = _visible; });

        var _collapser = window.collapse_handle;
        collapse.transform.pos.set_xy(_collapser.x+(_collapser.w/2), _collapser.y+(_collapser.h/2));
        _collapser.onmouseenter.listen(function(_,_){ collapse.color = color_collapse_hover; });
        _collapser.onmouseleave.listen(function(_,_){ collapse.color = color_collapse; });
        _collapser.onbounds.listen(function(){ collapse.transform.pos.set_xy(_collapser.x+(_collapser.w/2), _collapser.y+(_collapser.h/2)); });
        _collapser.onvisible.listen(function(_visible:Bool){ collapse.visible = _visible; });

        window.oncollapse.listen(oncollapse);

    } //new

    override function ondestroy() {

        visual.drop();
        top.drop();
        border.drop();
        collapse.drop();
        close.drop();
        visual = null;
        top = null;
        border = null;
        collapse = null;
        close = null;

    } //ondestroy

    override function onbounds() {
        visual.transform.pos.set_xy(window.x, window.y);
        visual.resize_xy(window.w, window.h);
        top.transform.pos.set_xy(window.title.x, window.title.y);
        top.resize_xy(window.title.w, window.title.h);
        border.set_xywh(window.x, window.y, window.w+1, window.h);
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = null;
            top.clip_rect = null;
            border.clip_rect = null;
            collapse.clip_rect = null;
            close.clip_rect = null;
        } else {
            visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
            top.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
            border.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
            collapse.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
            close.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip

    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        top.visible = _visible;
        border.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth + _depth;
        top.depth = visual.depth+0.001;
        border.depth = visual.depth+0.002;
        collapse.depth = visual.depth+0.003;
        close.depth = visual.depth+0.004;
    } //ondepth

    function oncollapse(state:Bool) {

        var a = (state) ? -90 : 0;
        collapse.transform.rotation.setFromEuler(new Vector(0,0,luxe.utils.Maths.radians(a)));

    }

} //Window
