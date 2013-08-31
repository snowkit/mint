package minterface;

import luxe.Rectangle;
import luxe.NineSlice;
import luxe.Text.TextAlign;
import luxe.Vector;
import luxe.Color;
import luxe.Input;

import minterface.MIControl;
import minterface.MILabel;
import minterface.MIList;


class MIDropdown extends MIControl {
	
	public var list : MIList;	
	public var selected_label : MILabel;	

	public var is_open : Bool = false;

	public function new(_options:Dynamic) {
			
			//create the base control
		super(_options);
			//dropdowns can be clicked
		mouse_enabled = true;
			//create the list
		list = new MIList({
            parent : this,
            name : name + '.list',
            bounds : new Rectangle( 0, bounds.h, bounds.w, 110 ),
            align : TextAlign.left,
            onselect : onselect
        });        

        selected_label = new MILabel({
			parent : this,
			bounds : new Rectangle(0,0,bounds.w, bounds.h),
			text:_options.text,
			text_size: (_options.text_size == null) ? 18 : _options.text_size,
			name : name + '.selected_label',
			align : TextAlign.left,
			color : new Color(0,0,0,1).rgb(0x999999)
		});

		renderer.dropdown.init( this, _options );

			//the list is hidden
		list.set_visible(false);

	} //new

	private function onselect(v:String, l:MIList, e:Dynamic) {
		
		trace("selected :" + v);

	} //onselect

	public function add_item( _item:String ) {
		list.add_item(_item);
		list.set_visible(is_open);
	}

	public function add_items( _items:Array<String> ) {
		list.add_items(_items);
		list.set_visible(is_open);
	}

	public override function translate(?_x:Float = 0, ?_y:Float = 0) {
		super.translate(_x,_y);		
		renderer.dropdown.translate( this, _x, _y );
		// clip_with_closest_to_canvas();
	}

	public override function set_visible( ?_visible:Bool = true ) {
		super.set_visible(_visible);
		renderer.dropdown.set_visible(this,_visible);
	}

	public override function set_clip( ?_clip_rect:Rectangle = null ) {
		super.set_clip(_clip_rect);
		renderer.dropdown.set_clip(this,_clip_rect);
	}

	public function close_list() {
		list.set_visible(false);
		trace('closing list');

		is_open = false;
	}	

	public function open_list() {
		list.set_visible(true);
		trace('opening list');

		is_open = true;
	}

	public override function onmousedown(e) {

		super.onmousedown(e);

			//propogate the message to the child list
		if(is_open) {
			list.onmousedown(e);
		}

		if(e.button == MouseButton.left) {

			if(is_open) {
				close_list();
				return;
			}

			var m = new Vector(e.x, e.y);

			if( selected_label.real_bounds.point_inside(m) ) {
				open_list();
			}
		}//mouse left

	} //onmousedown
	
	public override function onmouseup(e) {
		super.onmouseup(e);
	}

}