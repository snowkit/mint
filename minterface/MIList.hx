package minterface;

import luxe.Input.MouseButton;
import luxe.Input.MouseEvent;
import luxe.Text.TextAlign;
import minterface.MIControl;

import luxe.Rectangle;
import luxe.Color;

class MIList extends MIControl {
	
	public var view : MIScrollArea;
	public var items : Array<MIControl>;
	public var multiselect : Bool = false;
	public var onselect : String->MIList->?MouseEvent->Void;
	public var _options : Dynamic;

	public function new(__options:Dynamic) {
			
			//create the base control
		super(__options);
			//
		multiselect = (__options.multiselect == null) ? false : __options.multiselect;
		onselect = (__options.onselect == null) ? null : __options.onselect;

		view = new MIScrollArea({
			parent : this,
			bounds : __options.bounds.clone().set(0,0),
			name : name + '.view',
			onscroll : function(){}
		});

		_options = __options;
		if(_options.align == null) {
			_options.align = TextAlign.center;
		}

	} //new

	private function onscroll(_x:Float=0, _y:Float=0) {
		
		renderer.list.scroll(this, _x, _y);

	} //onscroll

	public function add_item( _item:String ) {

		var _childbounds = view.children_bounds();

		var l = new MILabel({
			text : _item,
			onclick : label_selected,
			name : name + '.item.' + _item,
			bounds : new Rectangle(0, _childbounds.h, bounds.w, 30),			
			parent : view,
			color : new Color(0,0,0,1).rgb(0x999999),
			text_size : 18,
			align : _options.align
		});

			//clip the label by the scroll view's bounds
		l.clip_with(view);
		
	} //add_item

	public override function translate(?_x:Float=0, ?_y:Float=0) {
		
		super.translate(_x,_y);

		for(_item in view.children) {
			_item.clip_with(view);
		}

	}

	private function label_selected(_control:MIControl, e:MouseEvent) {
		
		var _label:MILabel = cast _control;
		renderer.list.select_item(this, _control);

		//call callback
		if(onselect != null) {
			onselect(_label.text, this, e);
		}

	} //label_selected

	public function add_items( _items:Array<String> ) {
		for(_item in _items) {
			add_item(_item);
		}
	} //add_items

	public override function set_visible( ?_visible:Bool = true ) {
		
		super.set_visible(_visible);

		renderer.list.set_visible(this,_visible);

	} //set_visible


	public override function onmouseup(e) {
		super.onmouseup(e);
	}
}