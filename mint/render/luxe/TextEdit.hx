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
    @:optional var cursor_blink_rate: Float;
}

class TextEdit extends mint.render.Render {

    public var textedit : mint.TextEdit;
    public var visual : QuadGeometry;
    public var cursor : LineGeometry;

    public var color: Color;
    public var color_hover: Color;
    public var color_cursor: Color;
    public var cursor_blink_rate: Float = 0.5;

    var render: LuxeMintRender;

    public function new( _render:LuxeMintRender, _control:mint.TextEdit ) {

        textedit = _control;
        render = _render;

        super(render, _control);

        var _opt: LuxeMintTextEditOptions = textedit.options.options;

        color = def(_opt.color, new Color().rgb(0x646469));
        color_hover = def(_opt.color_hover, new Color().rgb(0x444449));
        color_cursor = def(_opt.color_cursor, new Color().rgb(0x9dca63));
        cursor_blink_rate = def(_opt.cursor_blink_rate, 0.5);

        visual = Luxe.draw.box({
            id: control.name+'.visual',
            batcher: render.options.batcher,
            x:control.x,
            y:control.y,
            w:control.w,
            h:control.h,
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
            clip_rect: Convert.bounds(control.clip_with)
        });

        cursor = Luxe.draw.line({
            id: control.name+'.cursor',
            batcher: render.options.batcher,
            p0: new Vector(0,0),
            p1: new Vector(0,0),
            color: color_cursor,
            depth: render.options.depth + control.depth+0.001,
            visible: false,
            clip_rect: Convert.bounds(control.clip_with)
        });

        textedit.onmouseenter.listen(function(e,c) {
            visual.color = color_hover;
        });

        textedit.onmouseleave.listen(function(e,c) {
            visual.color = color;
        });

        textedit.ontextinput.listen(function(_,_) {
            if(textedit.isfocused || textedit.iscaptured) {
                #if (linc_sdl && cpp)
                    sdl.SDL.setTextInputRect(Std.int(textedit.x),Std.int(textedit.y),Std.int(textedit.w),Std.int(textedit.h));
                #end
            }
        });

        textedit.onfocused.listen(function(state:Bool) {
            if(state) {
                start_cursor();
                #if (linc_sdl && cpp)
                sdl.SDL.startTextInput();
                    sdl.SDL.setTextInputRect(Std.int(textedit.x),Std.int(textedit.y),Std.int(textedit.w),Std.int(textedit.h));
                #end
            } else {
                stop_cursor();
                #if (linc_sdl && cpp)
                    sdl.SDL.stopTextInput();
                    sdl.SDL.setTextInputRect(0,0,0,0);
                #end
            }
        });

        textedit.onchangeindex.listen(function(index:Int) {
            update_cursor();
        });

        textedit.onrender.listen(function() {

            if(textedit.isfocused) {
                Luxe.draw.rectangle({
                    id: control.name+'.border',
                    batcher: render.options.batcher,
                    x:textedit.x,
                    y:textedit.y,
                    w:textedit.w,
                    h:textedit.h,
                    immediate: true,
                    color: color_cursor,
                    depth: render.options.depth+textedit.depth+0.001,
                });
            }
        });

    } //new

    var timer: snow.api.Timer;
    function start_cursor() {
        cursor.visible = true;
        update_cursor();
        timer = Luxe.timer.schedule(cursor_blink_rate, blink_cursor, true);
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

    inline function reset_cursor() {
        if(timer != null) {
            cursor.visible = true;
            timer.fire_at = Luxe.time + cursor_blink_rate;
        }
    }

    function update_cursor() {

        var text = (cast textedit.label.renderer:mint.render.luxe.Label).text;
        var _t = textedit.before_display(textedit.index);

        var _tw = text.font.width_of(textedit.edit, text.point_size, text.letter_spacing);
        var _twh = _tw/2.0;
        var _w = text.font.width_of(_t, text.point_size, text.letter_spacing);

        var _th = text.font.height_of(_t, text.point_size);
        var _thh = _th/2.0;

        var _left = switch(text.align) {
            case luxe.Text.TextAlign.center: textedit.label.x+(textedit.label.w/2);
            case luxe.Text.TextAlign.right: textedit.label.w;
            case _: textedit.label.x;
        }

        var _x = _w;
        var _y = 0.0;

        _x -= switch(text.align) {
            case luxe.Text.TextAlign.center: _twh;
            case luxe.Text.TextAlign.right: _tw;
            case _: 0.0;
        }

        _y += _th * 0.2;

        var _xx = _left + _x;
        var _yy = textedit.label.y + 2;

        cursor.p0 = new Vector(_xx, _yy);
        cursor.p1 = new Vector(_xx, _yy + textedit.label.h - 4);
        reset_cursor();

    } //

    override function ondestroy() {
        stop_cursor();
        cursor.drop();
        visual.drop();
        visual = null;
        cursor = null;
    }

    override function onbounds() {
        visual.transform.pos.set_xy(control.x, control.y);
        visual.resize_xy( control.w, control.h );
        reset_cursor();
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
