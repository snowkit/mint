package mint.render.luxe;

import luxe.Vector;
import mint.types.Types;
import mint.core.Macros.*;
import mint.render.Rendering;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import phoenix.geometry.LineGeometry;
import luxe.Color;

private typedef LuxeMintTextEditOptions = {
    var color: Color;
    var color_hover: Color;
    var color_cursor: Color;
}

class TextEdit extends mint.render.Render {

    public var textedit : mint.TextEdit;
    public var visual : QuadGeometry;
    public var cursor : LineGeometry;

    public var color: Color;
    public var color_hover: Color;
    public var color_cursor: Color;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.TextEdit ) {

        textedit = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintTextEditOptions = textedit.options.options;

        color = def(_opt.color, new Color().rgb(0x646469));
        color_hover = def(_opt.color_hover, new Color().rgb(0x444449));
        color_cursor = def(_opt.color_cursor, new Color().rgb(0x9dca63));

        visual = Luxe.draw.box({
            batcher: render.options.batcher,
            x:control.x,
            y:control.y,
            w:control.w,
            h:control.h,
            color: color,
            depth: render.options.depth + control.depth,
            group: render.options.group,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        cursor = Luxe.draw.line({
            batcher: render.options.batcher,
            p0: new Vector(0,0),
            p1: new Vector(0,0),
            color: color_cursor,
            depth: render.options.depth + control.depth+0.001,
            group: render.options.group,
            visible: false,
            clip_rect: Convert.bounds(control.clip_with)
        });

        textedit.onmouseenter.listen(function(e,c) {
            visual.color = color_hover;
            start_cursor();
        });

        textedit.onmouseleave.listen(function(e,c) {
            visual.color = color;
            stop_cursor();
        });

        textedit.onchangeindex.listen(function(index:Int) {
            update_cursor();
        });

        textedit.onrender.listen(function() {

            if(textedit.isfocused) {
                Luxe.draw.rectangle({
                    batcher: render.options.batcher,
                    x:textedit.x,
                    y:textedit.y,
                    w:textedit.w,
                    h:textedit.h,
                    immediate: true,
                    color: color_cursor,
                    depth: render.options.depth+textedit.depth+0.001,
                    group: render.options.group
                });
            }
        });

    } //new

    var timer: snow.api.Timer;
    function start_cursor() {
        cursor.visible = true;
        update_cursor();
        timer = Luxe.timer.schedule(0.5, blink_cursor, true);
    }

    function stop_cursor() {
        if(timer != null) timer.stop();
        timer = null;
        cursor.visible = false;
    }

    function blink_cursor() {
        if(timer == null) return;
        cursor.visible = !cursor.visible;
    }

    function update_cursor() {

        var text = (cast textedit.label.renderer:mint.render.luxe.Label).text;
        var _t = textedit.before(textedit.index);

        var _tw = text.font.width_of(textedit.edit, text.point_size, text.letter_spacing);
        var _twh = _tw/2.0;
        var _w = text.font.width_of(_t, text.point_size, text.letter_spacing);

        var _th = text.font.height_of(_t, text.point_size);
        var _thh = _th/2.0;

        var _x = _w;
        var _y = 0.0;

        _x -= switch(text.align) {
            case luxe.Text.TextAlign.center: _twh;
            case luxe.Text.TextAlign.right: _tw;
            case _: 0.0;
        }

        _y += _th * 0.2;

        var _xx = textedit.label.x + _x;
        var _yy = textedit.label.y + 2;

        cursor.p0 = new Vector(_xx, _yy);
        cursor.p1 = new Vector(_xx, _yy + textedit.label.h - 4);

    } //

    override function ondestroy() {
        visual.drop();
        visual = null;
    }

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.resize_xy( control.w, control.h );
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip_rect = null;
        } else {
            visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = _visible;

        if(!_visible) {
            stop_cursor();
        } else if(_visible && textedit.isfocused) {
            start_cursor();
        }

    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.depth = render.options.depth+_depth;
        cursor.depth = visual.depth+0.001;
    } //ondepth

} //TextEdit
