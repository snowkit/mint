package minterface;


enum MITextAlign {
    left;
    right;
    center;
    top;
    bottom;
}

/** A typed state for mouse, touch, or pressed/similar */
enum MIInteractState {

/** An unknown state */
    unknown;
/** An none state */
    none;
/** In a pressed state */
    down;
/** In a released state */
    up;
/** In a moving state */
    move;
/** A mouse wheel state */
    wheel;
/** A gamepad axis state */
    axis;

} //InteractState

/** A typed mouse button id */
enum MIMouseButton {

/** no mouse buttons */
    none;
/** left mouse button */
    left;
/** middle mouse button */
    middle;
/** right mouse button */
    right;
/** extra button pressed (4) */
    extra1;
/** extra button pressed (5) */
    extra2;

} //MouseButton

typedef MIMouseEvent = {

        /** The time in seconds when this touch event occurred, use for deltas */
    var timestamp : Float;
        /** The window id this event originated from */
    var window_id : Int;
        /** The state this event is in */
    var state : MIInteractState;
        /** The button id, if the event `state` is `down` or `up` */
    var button : MIMouseButton;
        /** The x position in the window of the mouse event */
    var x : Int;
        /** The y position in the window of the mouse event */
    var y : Int;
        /** The relative x position if `state` is `move` or a window has grabbed state */
    var xrel : Int;
        /** The relative y position if `state` is `move` or a window has grabbed state */
    var yrel : Int;
        /** Whether or not the event should bubble further. set to false to stop propagation */
    var bubble : Bool;

} //MouseEvent


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
