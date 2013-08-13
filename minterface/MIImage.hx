package minterface;

import luxe.Sprite;
import luxe.Vector;

import minterface.MIControl;

class MIImage extends MIControl {
	
	public function new(_options:Dynamic) {
			
			//create the base control
		super(_options);
			//image size to the parent,
		_options.centered = false;
		_options.pos = new Vector(real_bounds.x, real_bounds.y);
		_options.depth = depth + 0.2;

		renderer.image.init(this, _options);

	} //new

	public override function translate( ?_x : Float = 0, ?_y : Float = 0 ) {

		super.translate(_x,_y);
		renderer.image.translate(this, _x, _y);

	} //translate

}