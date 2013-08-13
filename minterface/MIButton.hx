package minterface;

import luxe.Rectangle;
import luxe.utils.NineSlice;
import luxe.Vector;
import luxe.Color;

import minterface.MIControl;


class MIButton extends MIControl {
	
	public var label : MILabel;	

	public function new(_options:Dynamic) {
			
			//create the base control
		super(_options);
			//buttons can be clicked
		mouse_enabled = true;
			//create the label
		label = new MILabel({
			parent : this,
			bounds : _options.bounds.clone().set(0,0),
			text:_options.text,
			text_size:_options.text_size,
			name : name + '.label',
			depth : 4.1,
			color : new Color().rgb(0x999999)
		});

		if(_options.onclick != null) {
			mousedown = _options.onclick;
		}
		
		renderer.button.init( this, _options );
	}

	public override function translate(?_x:Float = 0, ?_y:Float = 0) {
		super.translate(_x,_y);		
		renderer.button.translate( this, _x, _y );
	}


	public override function set_clip( ?_clip_rect:Rectangle = null ) {
		super.set_clip(_clip_rect);
		renderer.button.set_clip(this,_clip_rect);
	}

	public override function onmousedown(e) {
		super.onmousedown(e);
	}
	
	public override function onmouseup(e) {
		super.onmouseup(e);
	}

}