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
    wheel;
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
    var bubble : Bool;
}

class MIUtils {
    static public function clamp (value:Float, a:Float, b:Float) : Float {
        return ( value < a ) ? a : ( ( value > b ) ? b : value );
    }
}

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
