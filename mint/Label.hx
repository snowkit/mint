package mint;

import mint.Types;
import mint.Control;

class Label extends Control {

    @:isVar public var text(get,set) : String;

    public function new(_options:Dynamic) {

        super(_options);

        _options.bounds = real_bounds;

            //disable mouse input by default
        mouse_enabled = false;

        if(_options.mouse_enabled != null) { mouse_enabled = _options.mouse_enabled; }
        if(_options.align == null) { _options.align = TextAlign.center; }
        if(_options.align_vertical == null) { _options.align_vertical = TextAlign.center; }
        if(_options.point_size != null) { _options.point_size = _options.point_size; }
        if(_options.padding == null) { _options.padding = new Rect(); }

        if(_options.onclick != null) {
            mouse_enabled = true;
            mousedown = _options.onclick;
        }

            //store the text
        text = _options.text;
            //adjust for label
        _options.depth = depth;
            //create it
        renderer.label.init(this,_options);

        set_clip( clip_rect );

    } //new

    public function set_text(_s:String) : String {

        renderer.label.set_text(this, _s);

        return text = _s;

    } //set_text

    public function get_text() : String {

        return text;

    } //get_text

    public override function translate( ?_x : Float = 0, ?_y : Float = 0, ?_offset:Bool = false ) {
        super.translate( _x, _y, _offset );
        renderer.label.translate( this, _x, _y, _offset );
    }

    public override function set_clip( ?_clip_rect:Rect = null ) {

        super.set_clip( _clip_rect );
        renderer.label.set_clip( this, _clip_rect );

    } //

    public override function onmousemove(e) {
        super.onmousemove(e);
    } //onmousemove

    public override function destroy() {
        super.destroy();
        renderer.label.destroy(this);
    }

    public override function set_visible( ?_visible:Bool = true ) {
        super.set_visible(_visible);
        renderer.label.set_visible(this, _visible);
    } //set_visible

    private override function set_depth( _depth:Float ) : Float {

        super.set_depth(_depth);

        renderer.label.set_depth(this, _depth);

        return depth;

    } //set_depth

}