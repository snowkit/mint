package minterface;

import luxe.Input.MouseButton;
import luxe.Text;
import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;

import minterface.MIControl;

class MILabel extends MIControl {
	
	public var text : String;

	public function new(_options:Dynamic) {		

		super(_options);

		_options.bounds = real_bounds;

			//disable mouse input by default
		mouse_enabled = false;

		if(_options.mouse_enabled != null) { mouse_enabled = _options.mouse_enabled; }
		if(_options.align == null) { _options.align = TextAlign.center; }
		if(_options.align_vertical == null) { _options.align_vertical = TextAlign.center; }
		if(_options.text_size != null) { _options.size = _options.text_size; }	
		if(_options.color != null) { _options.color = new Color().rgb(0x999999); }	

		if(_options.onclick != null) {
			mouse_enabled = true;
			mousedown = _options.onclick;
		}	

		_options.pos = new Vector(real_bounds.x, real_bounds.y);
			//store the text
		text = _options.text;
			
			//adjust for label
		_options.depth = depth;
			//create it
		renderer.label.init(this,_options);
			//debug color
		debug_color = new Color(0,1,0.6,0.5);

		set_clip( clip_rect );

	} //new


	public override function translate( ?_x : Float = 0, ?_y : Float = 0 ) {
		super.translate(_x,_y);		
		renderer.label.translate(this, _x, _y);		
	}

	public override function set_clip( ?_clip_rect:Rectangle = null ) {

		super.set_clip( _clip_rect );
		renderer.label.set_clip( this, _clip_rect );
		
	} // 

	public override function set_visible( ?_visible:Bool = true ) {
		super.set_visible(_visible);
		renderer.label.set_visible(this, _visible);
	} //set_visible

}