package minterface;

import minterface.MILabel;
import minterface.MITypes;
import minterface.MIControl;

class MINumber extends MIControl {
	
	@:isVar public var value(get,set) : Float;

	public var max : Float = 1;
	public var min : Float = 0;

	public var precision : Int = 4;
	public var steps : Int = 200;

	public var label : MILabel;

	var can_change : Bool = false;
	var _current : Float = 0.0;
	var startdrag : Int = 0;

	public var on_change : MIControl->Float->Void;

	public function new(_options:Dynamic) {
		
		super(_options);

		mouse_enabled = true;

		if(_options.value == null) { _options.value = 0.0; }
		if(_options.align == null) { _options.align = MITextAlign.center; }
		if(_options.align_vertical == null) { _options.align_vertical = MITextAlign.center; }
		if(_options.text_size != null) { _options.size = _options.text_size; }
		if(_options.mouse_enabled != null) { mouse_enabled = _options.mouse_enabled; }

		var _value = _options.value;

		label = new MILabel({
			parent : this,
			bounds : _options.bounds.clone().set(0,0),
			text: Std.string(_value),
			text_size:_options.text_size,
			name : name + '.label'
		});

		// mouse_enabled = true;
		label.mouse_enabled = mouse_enabled;

	} //new

	public function set_value(_v:Float) : Float {

		value = _v;

		label.set_text( Std.string(_v) );

		return value;

	} //set_text

	public function get_value() : Float {
		return value;
	}

	public override function onmousedown(e:MIMouseEvent) {
		super.onmousedown(e);
		if(!can_change) {
			can_change = true;
			_current = 			
			canvas.dragged = this;
		}
	}

	public override function onmouseup(e:MIMouseEvent) {
		super.onmouseup(e);
		if(can_change) {
			can_change = false;
			canvas.dragged = null;
		}
	}

	public override function onmousemove(e:MIMouseEvent) {
		super.onmousemove(e);
		if(can_change) {
			var diff = Std.int(e.x) - startdrag;
			var d = diff*0.0001;
			var _value = value + d;
			if(_value <= min) { _value = min; startdrag = Std.int(e.x); }
			if(_value >= max) { _value = max; startdrag = Std.int(e.x); }

			_value = phoenix.utils.Maths.fixed(_value, precision);
			if(on_change != null) {
				on_change(this, _value);
			}

			value = _value;
		}
	} //onmousemove

	public override function destroy() {
		super.destroy();
	}

}