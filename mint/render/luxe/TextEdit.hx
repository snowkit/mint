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
import phoenix.geometry.RectangleGeometry;

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
    public var focus : RectangleGeometry;

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
            x: sx,
            y: sy,
            w: sw,
            h: sh,
            color: color,
            depth: render.options.depth + control.depth,
            visible: control.visible,
        });

        focus = Luxe.draw.rectangle({
            id: control.name+'.focus',
            batcher: render.options.batcher,
            x: sx,
            y: sy,
            w: sw,
            h: sh,
            color: color_cursor,
            depth: render.options.depth + control.depth+0.001,
            visible: false,
        });

        cursor = Luxe.draw.line({
            id: control.name+'.cursor',
            batcher: render.options.batcher,
            p0: new Vector(0,0),
            p1: new Vector(0,0),
            color: color_cursor,
            depth: render.options.depth + control.depth+0.002,
            visible: false,
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
                    sdl.SDL.setTextInputRect(Std.int(textedit.x*scale),Std.int(textedit.y*scale),Std.int(textedit.w*scale),Std.int(textedit.h*scale));
                #end
            }
        });

        textedit.onfocused.listen(function(state:Bool) {
            focus.visible = state;
            if(state) {
                start_cursor();
                #if (linc_sdl && cpp)
                sdl.SDL.startTextInput();
                    sdl.SDL.setTextInputRect(Std.int(textedit.x*scale),Std.int(textedit.y*scale),Std.int(textedit.w*scale),Std.int(textedit.h*scale));
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

        update_clip(scale);

    } //new

    function update_clip(_scale:Float) {
        
        var _clip = Convert.bounds(control.clip_with, _scale);

        visual.clip_rect = _clip;
        focus.clip_rect = _clip;
        cursor.clip_rect = _clip;

    } //update_clip

    override function onscale(_scale:Float, _prev_scale:Float) {
            
        update_clip(_scale);
        update_cursor();

    } //onscale

    //cursor

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

            var _text_visual = (cast textedit.label.renderer:mint.render.luxe.Label).text;
            var _font = _text_visual.font;
            var _point_size = _text_visual.point_size;
            var _letter_space = cs(_text_visual.letter_spacing);

            var _text_before = textedit.before_display(textedit.index);
            var _text_all = textedit.edit;

            var _text_width = _font.width_of(_text_all, _point_size, _letter_space);
            var _text_height = _font.height_of(_text_before, _point_size);

            var _label_x = cs(textedit.label.x);
            var _label_y = cs(textedit.label.y);
            var _label_w = cs(textedit.label.w);
            var _label_h = cs(textedit.label.h);

            var _x = _font.width_of(_text_before, _point_size, _letter_space);
            var _y = _text_height * 0.2;
            var _left = _label_x;

            switch(_text_visual.align) {
                case center: 
                    _x -= _text_width/2.0;
                    _left = _label_x+(_label_w/2);

                case right:
                    _x -= _text_width;
                    _left = _label_w;

                case _:
            }

            var _cursor_pad = cs(2);
            var _cursor_x = _left + _x;
            var _cursor_y = _label_y + _cursor_pad;

            cursor.p0 = new Vector(_cursor_x, _cursor_y);
            cursor.p1 = new Vector(_cursor_x, _cursor_y + _label_h - (_cursor_pad*2));
            
            reset_cursor();

        } //

    override function ondestroy() {

        stop_cursor();

        cursor.drop();
        visual.drop();
        focus.drop();

        visual = null;
        cursor = null;
        focus = null;

    } //ondestroy

    override function onbounds() {

        visual.transform.pos.set_xy(sx, sy);
        visual.resize_xy(sw, sh);

        focus.transform.pos.set_xy(sx, sy);
        focus.set_xywh(sx, sy, sw, sh);

        reset_cursor();
        update_cursor();

    } //onbounds

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        
        update_clip(scale);

    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = _visible;

        if(!_visible) {
            stop_cursor();
            focus.visible = false;
        } else if(_visible && textedit.isfocused) {
            start_cursor();
            focus.visible = true;
        }

    } //onvisible

    override function ondepth( _depth:Float ) {

        visual.depth = render.options.depth+_depth;
        focus.depth = visual.depth+0.001;
        cursor.depth = visual.depth+0.002;

    } //ondepth

} //TextEdit
