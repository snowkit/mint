package minterface;

import luxe.Text;
import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;

import minterface.MIControl;

class MILabel extends MIControl {
	
	public var _text : Text;

	public function new(_options:Dynamic) {		

		super(_options);

		_options.bounds = real_bounds;

		if(_options.align == null) { _options.align = TextAlign.center; }
		if(_options.align_vertical == null) { _options.align_vertical = TextAlign.center; }
		if(_options.text_size != null) { _options.size = _options.text_size; }		

		_options.pos = new Vector(real_bounds.x, real_bounds.y);
			
			//adjust for label
		_options = options_plus(_options, {depth : 2});
			//create it
		renderer.label.init(this,_options);
			//debug color
		debug_color = new Color(0,1,0.6,0.5);

		clip_with_closest_to_canvas();

	} //new

	public override function translate( ?_x : Float = 0, ?_y : Float = 0 ) {
		super.translate(_x,_y);		
		renderer.label.translate(this, _x, _y);
		clip_with_closest_to_canvas();
	}

	public override function set_clip( ?_clip_rect:Rectangle = null ) {

		super.set_clip( _clip_rect );
		renderer.label.set_clip( this, _clip_rect );
		
	} // 

}