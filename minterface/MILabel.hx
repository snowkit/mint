package minterface;

import minterface.MITypes;
import minterface.MIControl;

class MILabel extends MIControl {
	
	@:isVar public var text(get,set) : String;

	public function new(_options:Dynamic) {		

		super(_options);

		_options.bounds = real_bounds;

			//disable mouse input by default
		mouse_enabled = false;

		if(_options.mouse_enabled != null) { mouse_enabled = _options.mouse_enabled; }
		if(_options.align == null) { _options.align = MITextAlign.center; }
		if(_options.align_vertical == null) { _options.align_vertical = MITextAlign.center; }
		if(_options.text_size != null) { _options.size = _options.text_size; }	
		if(_options.color == null) { _options.color = new MIColor().rgb(0x999999); }	
		if(_options.padding == null) { _options.padding = new MIRectangle(); }

		if(_options.onclick != null) {
			mouse_enabled = true;
			mousedown = _options.onclick;
		}	

		_options.pos = new MIPoint(real_bounds.x, real_bounds.y);
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

	public override function translate( ?_x : Float = 0, ?_y : Float = 0 ) {
		super.translate(_x,_y);		
		renderer.label.translate(this, _x, _y);		
	}

	public override function set_clip( ?_clip_rect:MIRectangle = null ) {

		super.set_clip( _clip_rect );
		renderer.label.set_clip( this, _clip_rect );
		
	} // 

	public override function onmousemove(e) {
		super.onmousemove(e);
	} //onmousemove

	public override function set_visible( ?_visible:Bool = true ) {
		super.set_visible(_visible);
		renderer.label.set_visible(this, _visible);
	} //set_visible

	private override function set_depth( _depth:Float ) : Float {

		renderer.label.set_depth(this, _depth);

		return depth = _depth;

	} //set_depth

}