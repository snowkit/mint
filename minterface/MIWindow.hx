package minterface;

import minterface.MITypes;
import minterface.MIControl;
import minterface.MILabel;

class MIWindow extends MIControl {
	
	public var title_bounds : MIRectangle;
	public var view_bounds : MIRectangle;

	public var title : MILabel;

	public var moveable : Bool = true;
	public var dragging : Bool = false;
	
	public var drag_start : MIPoint;
	public var down_start : MIPoint;

	public function new(_options:Dynamic) {		

		super(_options);

		_options.bounds = real_bounds;

		drag_start = new MIPoint();
		down_start = new MIPoint();

		if(_options.align == null) { _options.align = MITextAlign.center; }
		if(_options.align_vertical == null) { _options.align_vertical = MITextAlign.center; }
		if(_options.title_size != null) { _options.size = _options.title_size; }		
		if(_options.title != null) { _options.text = _options.title; }		
		if(_options.moveable != null) { moveable = _options.moveable; }

		title_bounds = new MIRectangle(6, 6, bounds.w-12, 20 );
		view_bounds = new MIRectangle(32, 32, bounds.w - 64, bounds.h - 64 );

		_options.pos = new MIPoint(real_bounds.x, real_bounds.y);
			
			//create the title label
		title = new MILabel({
			parent : this,
			bounds : title_bounds,
			text:_options.text,
			text_size:_options.title_size,
			name : name + '.titlelabel'
		});

			//update
		renderer.window.init( this, _options );

	} //new
 
	public override function onmousemove(e:MIMouseEvent)  {
		
		super.onmousemove(e);

		var _m : MIPoint = new MIPoint(e.x,e.y);
		if(dragging) {

			var diff_x = _m.x - drag_start.x;
			var diff_y = _m.y - drag_start.y;

			drag_start = _m.clone();

			translate(diff_x, diff_y);
			
		} //dragging
	} //onmousemove

	public override function onmousedown(e:MIMouseEvent)  {

		super.onmousedown(e);

		var _m : MIPoint = new MIPoint(e.x,e.y);

			if(!dragging && moveable) {
				if( title.real_bounds.point_inside(_m) ) {			
					dragging = true;		
					drag_start = _m.clone();
					down_start = new MIPoint(real_bounds.x, real_bounds.y);
					canvas.dragged = this;
				} //if inside title bounds
			} //!dragging

	} //onmousedown

	public override function onmouseup(e:MIMouseEvent)  {

		super.onmouseup(e);

		var _m : MIPoint = new MIPoint(e.x,e.y);
		if(dragging) {
			dragging = false;
			canvas.dragged = null;
		} //dragging
	} //onmouseup

	public override function translate( ?_x : Float = 0, ?_y : Float = 0 ) {

		super.translate(_x,_y);
		
		title_bounds = new MIRectangle(real_bounds.x, real_bounds.y, bounds.w, 30 );		
		
		renderer.window.translate( this, _x, _y );

	} //translate

	public override function set_visible( ?_visible:Bool = true ) {
		super.set_visible(_visible);
		renderer.window.set_visible(this, _visible);
	} //set_visible


	private override function set_depth( _depth:Float ) : Float {

		renderer.window.set_depth(this, _depth);

		return depth = _depth;

	} //set_depth	

}