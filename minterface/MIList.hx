package minterface;

import luxe.Input.MouseButton;
import luxe.Input.MouseEvent;
import minterface.MIControl;

import luxe.Rectangle;
import luxe.Color;

class MIList extends MIControl {
	
	public var view : MIScrollArea;
	public var items : Array<MIControl>;
	public var multiselect : Bool = false;
	public var onselect : MIList->?MouseEvent->Void;

	public function new(_options:Dynamic) {
			
			//create the base control
		super(_options);
			//
		multiselect = (_options.multiselect == null) ? false : _options.multiselect;
		onselect = (_options.onselect == null) ? null : _options.onselect;

		view = new MIScrollArea({
			parent : this,
			bounds : _options.bounds.clone().set(0,0),
			name : name + '.view',
			onscroll : function(){}
		});

	}

	private function onscroll(_x:Float=0, _y:Float=0) {
		
		// renderer.list.scroll(this, _x, _y);

	} //onscroll

	public function add_item( _item:String ) {

		var _childbounds = view.children_bounds();

		var l = new MILabel({
			text : _item,
			onclick : label_selected,
			name : name + '.item.' + _item,
			bounds : new Rectangle(0, _childbounds.h, bounds.w, 30),			
			parent : view,
			color : new Color(0,0,0,0.2).rgb(0x999999),
			text_size : 18,
		});
		
	} //add_item

	private function label_selected(_control:MIControl, e:MouseEvent) {
		
		var _label:MILabel = cast _control;
		renderer.list.select_item(this, _control);

		//call callback
		if(onselect != null) {
			onselect(this, e);
		}

	} //label_selected

	public function add_items( _items:Array<String> ) {
		for(_item in _items) {
			add_item(_item);
		}
	} //add_items

	public override function onmouseup(e) {
		super.onmouseup(e);
	}
}