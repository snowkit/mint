package mint;

import mint.Types;
import mint.Control;

class Image extends Control {

    public function new(_options:Dynamic) {

            //create the base control
        super(_options);
            //image size to the parent,
        _options.centered = false;
        _options.pos = new Point(real_bounds.x, real_bounds.y);
        _options.depth = depth + 0.1;

            //disable mouse input,todo optionify
        mouse_enabled = false;

        renderer.image.init(this, _options);

    } //new

    public override function destroy() {
        super.destroy();
        renderer.image.destroy(this);
    }

    public override function translate( ?_x : Float = 0, ?_y : Float = 0, ?_offset:Bool = false  ) {

        super.translate( _x, _y, _offset);
        renderer.image.translate( this, _x, _y, _offset );

    } //translate

    public override function set_visible( ?_visible:Bool = true ) {
        super.set_visible(_visible);
        renderer.image.set_visible(this,_visible);
    } //set_visible


    private override function set_depth( _depth:Float ) : Float {

        super.set_depth(_depth);

        renderer.image.set_depth(this, _depth);

        return depth;

    } //set_depth

}