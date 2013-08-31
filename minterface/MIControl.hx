package minterface;

import luxe.Rectangle;
import luxe.Color;
import luxe.Vector;
import luxe.Input;

	//base class for all controls
	//handles propogation of events,
	//mouse handling, alignment, so on

typedef ChildBounds = {
	var x : Float;
	var y : Float;
	var w : Float;
	var h : Float;
	var realy : Float;
	var realx : Float;
}

class MIControl {
	
	public var name : String = 'control';

		//parent canvas that this element belongs to
	public var canvas : MICanvas;
		//the renderer that is handling the canvas
	public var renderer : MIRenderer;
		//the top most control below the canvas that holds us
	public var closest_to_canvas : MIControl;

		//the items specific to rendering this item
	public var render_items : Map<String, Dynamic>;

	public var bounds : Rectangle;
	public var real_bounds : Rectangle;
	@:isVar public var parent(get,set) : MIControl;
	public var children : Array<MIControl>;

	@:isVar public var mousedown(get,set) : MIControl->?MouseEvent->Void;
	var mouse_down_handlers : Array<MIControl->?MouseEvent->Void>;

	public var isfocused : Bool = false;
	public var ishovered : Bool = false;
	public var mouse_enabled : Bool = true;

	public var debug_color : Color;

	@:isVar public var depth(default,default) : Float = 0;

	public function new(_options:Dynamic) {

		debug_color = new Color(0.5,0.3,0.2,0.8);		

		render_items = new Map<String,Dynamic>();
		
		bounds = _options.bounds == null ? new Rectangle(0,0,32,32) : _options.bounds;
		real_bounds = bounds.clone();

		if(_options.name != null) { name = _options.name; }

		children = [];
		mouse_down_handlers = [];

		if(_options.parent != null) {

			renderer = _options.parent.renderer;
			canvas = _options.parent.canvas;
			_options.parent.add(this);			
			depth = canvas.next_depth();
			trace('depth : ' + name + ' ' + depth);

		} else { //parent != null

			if( !Std.is(this, MICanvas) && canvas == null) {
				throw "Control without a canvas " + _options;
			} //canvas
		}

			//closest_to_canvas
		closest_to_canvas = find_top_parent();

	} //new

	function clip_with_closest_to_canvas() {
		if(closest_to_canvas != null) {
			set_clip( closest_to_canvas.real_bounds );
		}
	} //clip_with_closest_to_canvas

	function find_top_parent( ?_from:MIControl = null ) {

		var _target = (_from == null) ? this : _from;

		if(_target == null || _target.parent == null) {
			return null;
		}

			//if the parent of the target is not canvas, 
			//keep escalating until it is
		if( Std.is( _target.parent, MICanvas ) ) {
			return _target;
		} else { //is
			return parent.find_top_parent( this );
		} 

	} //find_top_parent

	function get_mousedown() {
		return mouse_down_handlers[0];
	}

	function set_mousedown( listener: MIControl->?MouseEvent->Void ) {
		mouse_down_handlers.push(listener);
		return listener;
	}

	public function add( child:MIControl ) {
		if(child.parent != this) {
			child.parent = this;
			children.push(child);
		}
	}

	public function translate( ?_x : Float = 0, ?_y : Float = 0 ) {

		real_bounds.x += _x;
		real_bounds.y += _y;

		for(child in children) {
			child.translate( _x, _y );
		}

	}

	public function set_clip( ?_clip_rect:Rectangle = null ) {
		//temporarily, all children clip by their parent clip

		for(_child in children) {
			_child.set_clip( _clip_rect );
		}

	} //set clip

	private function options_plus(options:Dynamic, plus:Dynamic) {
		var _fields = Reflect.fields(plus);
		
		for(_field in _fields) {
			Reflect.setField(options, _field, Reflect.field( plus, _field ) );
		}

		return options;
	}

	public function width() {
		return bounds.w;
	}
	public function height() {
		return bounds.h;
	}

	public function right() {
		return bounds.x + bounds.w;
	}
	public function bottom() {
		return bounds.y + bounds.h;
	}

	public function children_bounds() : ChildBounds {

		if(children.length == 0) {
			return {x:0,y:0,w:0,h:0,realx:real_bounds.x,realy:real_bounds.y};
		} //no children

		var _first_child = children[0];
		var _current_x : Float = _first_child.bounds.x; 
		var _current_y : Float = _first_child.bounds.y;
		var _current_w : Float = _first_child.right();
		var _current_h : Float = _first_child.bottom();
		var _real_x : Float = _first_child.real_bounds.x;
		var _real_y : Float = _first_child.real_bounds.y;

		for(child in children) {

			_current_x = Math.min( child.bounds.x, _current_x );
			_current_y = Math.min( child.bounds.y, _current_y );
			_current_w = Math.max( _current_w , child.right() );
			_current_h = Math.max( _current_h, child.bottom() );

			_real_x = Math.min( child.real_bounds.x, _real_x );
			_real_y = Math.min( child.real_bounds.y, _real_y );
			
		}

		return { x:_current_x, y:_current_y, w:_current_w, h:_current_h, realx:_real_x, realy:_real_y };

	} //children_bounds

	private function set_parent(p:MIControl) {
		if(p != null) {
			real_bounds.set( p.real_bounds.x+bounds.x, p.real_bounds.y+bounds.y, bounds.w, bounds.h);
		} else {
			real_bounds.set(bounds.x, bounds.y, bounds.w, bounds.h);
		}

		return parent = p;
	} //set_parent

	private function get_parent() {
		return parent;
	}
		
	public function onmousemove( e:MouseEvent ) {
		if(real_bounds.point_inside(new Vector(e.x,e.y))) {
			if(!ishovered) {				
				onmouseenter(e);
			} else {				
				for(child in children) {
					child.onmousemove(e);
				}
			}
		} else {
			if(ishovered) {
				onmouseleave(e);
			}
		}	

	} //mousemove

	public function onmouseup( e:MouseEvent ) {
		if(!mouse_enabled) return;

		if(ishovered) {
			for(child in children) {
				child.onmouseup(e);
			}
		}

	}
	public function onmousedown( e:MouseEvent ) {
		if(!mouse_enabled) return;

		if(ishovered) {
			
			if(e.button == MouseButton.left) {
				for(handler in mouse_down_handlers) {
					handler(this, e);
				}
			}

			for(child in children) {
				child.onmousedown(e);
			}
		}
	}
	public function onmouseenter( e:MouseEvent ) {
		if(!ishovered) {
			ishovered = true;
			// trace('mouse enter ' + name);
		}

			//other stuff must be after this
		if(!mouse_enabled) return;
	}

	public function onmouseleave( e:MouseEvent ) {		
		if(ishovered) {
			ishovered = false;
			// trace('mouse leave ' + name);
		}

			//other stuff must be after this
		if(!mouse_enabled) return;
	}

	public function _debug() {
		// Luxe.draw.rectangle({
		// 	immediate : true,
		// 	color : debug_color,
		// 	x : real_bounds.x, y:real_bounds.y, w:real_bounds.w, h:real_bounds.h
		// });
		// for(control in children) {
		// 	control._debug();
		// }		
	}	

}