package minterface;

import luxe.Input.MouseButton;
import minterface.MIControl;

import luxe.Rectangle;
import luxe.Color;

class MIList extends MIControl {
	
	public var view : MIScrollArea;
	public var items : Array<MIControl>;

	public function new(_options:Dynamic) {
			
			//create the base control
		super(_options);
			//
		// _options.depth = _depth;

		view = new MIScrollArea({
			parent : this,
			bounds : _options.bounds.clone().set(0,0),
			name : name + '.view'
		});

	}

	public function add_item( _item:String ) {

		var _childbounds = view.children_bounds();

		var l = new MILabel({
			text : _item,
			name : name + '.item.' + _item,
			bounds : new Rectangle(0, _childbounds.h, bounds.w, 30),			
			parent : view,
			color : new Color().rgb(0x999999),
			text_size : 18,
		});
		
	} //add_item

	public function add_items( _items:Array<String> ) {
		for(_item in _items) {
			add_item(_item);
		}
	} //add_items

	public override function onmousedown(e) {
		super.onmousedown(e);

		if(e.button == MouseButton.left) {

			var _rel_mouse_x = e.x - real_bounds.x;
			var _rel_mouse_y = e.y - real_bounds.y;
			var _childbounds = view.children_bounds();
			
			_rel_mouse_y += (_childbounds.h * view.scroll_percent.y);
			trace(_rel_mouse_y);
			
		}

	}

	public override function onmouseup(e) {
		super.onmouseup(e);
	}
}