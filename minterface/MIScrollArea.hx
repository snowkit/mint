package minterface;

import luxe.Vector;
import luxe.Color;
import phoenix.geometry.QuadGeometry;

import minterface.MIControl;

class MIScrollArea extends MIControl {
	

	public var can_scroll_h : Bool = true;
	public var can_scroll_v : Bool = true;

	public var scroll_amount : Vector;
	public var scroll_percent : Vector;
	public var child_bounds : Dynamic;

	public var onscroll : Float -> Float -> Void;

	public function new(_options:Dynamic) {

		super(_options);

		scroll_amount = new Vector();
		scroll_percent = new Vector();

		onscroll = _options.onscroll;

		renderer.scroll.init( this, _options );

		refresh_scroll();
		
	} //new

	public override function add(child:MIControl) {
		
		super.add(child);
		refresh_scroll();	

		child.clip_with( this );	
		
	}

	public override function onmousedown(e) {
			//forward to 
		super.onmousedown(e);
		
		if(e.button == lime.InputHandler.MouseButton.wheel_up) {
			if(e.ctrl_down) {
            	scrollx(-10);
            } else {
            	scrolly(-10);
            }
        } else if(e.button == lime.InputHandler.MouseButton.wheel_down) {
			if(e.ctrl_down) {
            	scrollx(10);
            } else {
            	scrolly(10);
            }
        }

	}

	public override function translate(?_x:Float = 0, ?_y:Float = 0) {
		super.translate(_x,_y);
		renderer.scroll.translate(this,_x,_y);
	}

	public function scrolly(diff:Float) {

		if(diff > 0 && scroll_percent.y <= 0) return;
		if(diff < 0 && scroll_percent.y >= 1) return;

		for(child in children) {
			child.translate(0, diff);
		}

		if(onscroll != null && diff != 0) {
			onscroll(0,diff);
		}

		refresh_scroll();
	}

	public function scrollx(diff:Float) {

		if(!can_scroll_h) return;

		if(diff > 0 && scroll_percent.x <= 0) return;
		if(diff < 0 && scroll_percent.x >= 1) return;

		for(child in children) {
			child.translate(diff, 0);
		}

		if(onscroll != null && diff != 0) {
			onscroll(diff,0);
		}

		refresh_scroll();
	}

	public function refresh_scroll() {

			//get child bounds
		child_bounds = children_bounds();

		var slider_h_visible = false;
		var slider_v_visible = false;

			//if the children bounds are < our size, it can't scroll
		if(child_bounds.w < real_bounds.w) {
			can_scroll_h = false;
			slider_h_visible = false;
		} else {
			can_scroll_h = true;
			slider_h_visible = true;
		}

		if(child_bounds.h < real_bounds.h) {
			can_scroll_v = false;
			slider_v_visible = false;
		} else {
			can_scroll_v = true;
			slider_v_visible = true;
		} 
		
		if(can_scroll_h) {

			var _diff_x = (real_bounds.x - child_bounds.realx);
			scroll_percent.x = (_diff_x / (child_bounds.w - bounds.w));
			scroll_percent.x = Luxe.utils.clamp( scroll_percent.x, 0, 1);	

		} //can_scroll_h

		if(can_scroll_v) {

			var _diff_y = (real_bounds.y - child_bounds.realy);
			scroll_percent.y = (_diff_y / (child_bounds.h - bounds.h));
			scroll_percent.y = Luxe.utils.clamp( scroll_percent.y, 0, 1);
			

		} //can_scroll_v

		var sliderh_x = real_bounds.x + ( (real_bounds.w-10) * scroll_percent.x );
		var sliderh_y = ( real_bounds.y + real_bounds.h - 4 );
		var sliderv_x = ( real_bounds.x + real_bounds.w - 4 );
		var sliderv_y = real_bounds.y + ( (real_bounds.h-10) * scroll_percent.y );

		renderer.scroll.refresh_scroll( this, sliderh_x, sliderh_y, sliderv_x, sliderv_y, slider_h_visible, slider_v_visible );

	} // refresh_scroll

	public override function set_visible( ?_visible:Bool = true ) {
		super.set_visible(_visible);
		renderer.scroll.set_visible(this, _visible);
	} //set_visible


	private override function set_depth( _depth:Float ) : Float {

		renderer.scroll.set_depth(this, _depth);

		return depth = _depth;

	} //set_depth
}