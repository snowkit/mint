package mint.render.luxe;

import luxe.Vector;
import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import phoenix.geometry.QuadGeometry;
import phoenix.geometry.LineGeometry;
import luxe.Color;
import luxe.Log.log;
import luxe.Log._debug;

class TextEdit extends mint.render.Base {

    var textedit : mint.TextEdit;
    public var visual : QuadGeometry;
    public var cursor : LineGeometry;

    public function new( _render:Renderer, _control:mint.TextEdit ) {

        super(_render, _control);
        textedit = _control;

        _debug('create / ${control.name}');
        visual = Luxe.draw.box({
            x:control.real_bounds.x,
            y:control.real_bounds.y,
            w:control.real_bounds.w,
            h:control.real_bounds.h,
            color: new Color(0,0,0,1).rgb(0x646469),
            depth: control.depth,
            visible: control.visible,
            clip_rect: Convert.rect(control.clip_rect)
        });

        cursor = Luxe.draw.line({
            p0: new Vector(0,0),
            p1: new Vector(0,0),
            color: new Color(0,0,0,1).rgb(0x9dca63),
            depth: control.depth+0.0001,
            visible: false,
            clip_rect: Convert.rect(control.clip_rect)
        });

        connect();

        textedit.mouseenter.listen(function(e,c) {
            visual.color.rgb(0x444449);
            start_cursor();
        });

        textedit.mouseleave.listen(function(e,c) {
            visual.color.rgb(0x646469);
            stop_cursor();
        });

        textedit.onchangeindex.listen(function(index:Int) {
            update_cursor();
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
        cursor.visible = !cursor.visible;
    }

    function update_cursor() {

        var text = (cast textedit.label.render:mint.render.luxe.Label).text;
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

        var _xx = textedit.label.real_bounds.x + _x;
        var _yy = textedit.label.real_bounds.y + 2;

        cursor.p0 = new Vector(_xx, _yy);
        cursor.p1 = new Vector(_xx, _yy + textedit.label.real_bounds.h - 4);

    } //

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
    }

    override function onclip( _rect:Rect ) {
        _debug('clip / ${control.name} / $_rect');
        if(_rect == null) {
            visual.clip_rect = null;
        } else {
            visual.clip_rect = Convert.rect(_rect);
        }
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        _debug('translate / ${control.name} / $_x / $_y / $_offset');
        visual.transform.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        _debug('visible / $_visible');
        visual.visible = _visible;
        if(!_visible) {
            stop_cursor();
        } else if(_visible && textedit.isfocused) {
            start_cursor();
        }
    } //onvisible

    override function ondepth( _depth:Float ) {
        _debug('depth / $_depth');
        visual.depth = _depth;
        cursor.depth = _depth+0.0001;
    } //ondepth

} //TextEdit
