package minterface;


enum MITextAlign {
    left;
    right;
    center;
    top;
    bottom;
}

enum MIMouseState {
    down;
    move;
    up;
}

enum MIMouseButton {
    move;
    left;
    middle;
    right;
    wheel_up;
    wheel_down;
}

typedef MIMouseEvent = { 
    var state : MIMouseState;
    var flags : Int;
    var button : MIMouseButton;
    var x : Float;
    var y : Float;
    var deltaX : Float;
    var deltaY : Float;
    var shift_down : Bool;
    var ctrl_down : Bool;
    var alt_down : Bool;
    var meta_down : Bool;
}

class MIColor {

	public var r : Float = 1.0;
	public var g : Float = 1.0;
	public var b : Float = 1.0;
	public var a : Float = 1.0;

	public function new(_r:Float = 1.0, _g:Float = 1.0, _b:Float = 1.0, _a:Float = 1.0) {
		
		r = _r;
		g = _g;
		b = _b;
		a = _a;

	} //new

	public function set( ?_r : Float, ?_g : Float, ?_b : Float, ?_a : Float ) : MIColor {

		var _setr = r;
		var _setg = g;
		var _setb = b;
		var _seta = a;
			
				//assign new values
			if(_r != null) _setr = _r;
			if(_g != null) _setg = _g;
			if(_b != null) _setb = _b;
			if(_a != null) _seta = _a;

		r = _setr;
		g = _setg;
		b = _setb;
		a = _seta;

		return this;

	} //set

	public function clone() : MIColor {

		return new MIColor(r,g,b,a);

	} //clone

	public function rgb( ?_rgb:Int = 0xFFFFFF ) : MIColor {

		return from_int( _rgb );

	} //rgb

	private function from_int( _i:Int ) : MIColor {

		var _r = _i >> 16;
		var _g = _i >> 8 & 0xFF;
		var _b = _i & 0xFF;
		
			//convert to 0-1
		r = _r / 255; 
		g = _g / 255;
		b = _b / 255;

			//alpha not specified in 0xFFFFFF
			//but we don't need to clobber it, 
			//if it was set in the member list

		// a = 1.0;

		return this;

	} //from_int

	public function toString() : String {

		return "{ r:"+r+" , g:"+g+" , b:"+b+" , a:"+a+" }";

	} //toString

} //MIColor


class MIPoint {

	public var x : Float;
	public var y : Float;

	public function new( _x:Float = 0, _y:Float = 0) {

		x = _x;
		y = _y;

	} //new
	
	public function set( ?_x:Float, ?_y:Float ) : MIPoint {
		
		var _setx = x;
		var _sety = y;
			
				//assign new values
			if(_x != null) _setx = _x;
			if(_y != null) _sety = _y;

		x = _setx;
		y = _sety;

		return this;

	} //set

	public function clone() : MIPoint {

		return new MIPoint(x,y);

	} //clone

	public function toString() : String {

		return "{ x:"+x + ", y:" + y + " }" ;

	} //toString

} //MIPoint

class MIRectangle {

    public var x:Float;
    public var y:Float;
    public var w:Float;
    public var h:Float;

    public function new( ?_x:Float = 0,?_y:Float = 0,?_w:Float = 0,?_h : Float = 0 ) {

        x = _x; 
        y = _y; 
        w = _w; 
        h = _h; 

    } //new

    public function set( ?_x:Float, ?_y:Float, ?_w:Float, ?_h:Float ) : MIRectangle  {

        var _setx = x;
        var _sety = y;
        var _setw = w;
        var _seth = h;
            
	            //assign new values
	        if(_x != null) _setx = _x;
	        if(_y != null) _sety = _y;
	        if(_w != null) _setw = _w;
	        if(_h != null) _seth = _h;

        x = _setx;
        y = _sety;
        w = _setw;
        h = _seth;

        return this;

    } //set


    public function clone() : MIRectangle {

        return new MIRectangle(x,y,w,h);

    } //clone

    public function point_inside( _p:MIPoint ) : Bool {

	        if(_p.x < x) return false;
	        if(_p.y < y) return false;
	        if(_p.x > x+w) return false;
	        if(_p.y > y+h) return false;

        return true;

    } //point_inside


    public function toString() : String {

        return "{ x:"+x + ", y:" + y + ", w:" + w  + ", h:" + h  + " }" ;

    } //toString


}
