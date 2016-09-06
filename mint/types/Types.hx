package mint.types;

@:enum
abstract TextAlign(Int) from Int to Int {

        /** An unknown alignment */
    var unknown = 0;
        /** (horizontal) Left aligned */
    var left = 1;
        /** (horizontal) Right aligned */
    var right = 2;
        /** (horizontal/vertical) Center aligned */
    var center = 3;
        /** (vertical) Top aligned */
    var top = 4;
        /** (vertical) Bottom aligned */
    var bottom = 5;

} //TextAlign

/** A typed state for mouse, touch, or pressed/similar */
@:enum
abstract InteractState(Int) from Int to Int {

        /** An unknown state */
    var unknown = 0;
        /** An none state */
    var none = 1;
        /** In a pressed state */
    var down = 2;
        /** In a released state */
    var up = 3;
        /** In a moving state */
    var move = 4;
        /** A mouse wheel state */
    var wheel = 5;
        /** A gamepad axis state */
    var axis = 6;

} //InteractState

/** A typed mouse button id */
@:enum
abstract MouseButton(Int) from Int to Int {

        /** no mouse buttons */
    var none = -1;
        /** left mouse button */
    var left = 0;
        /** middle mouse button */
    var middle = 1;
        /** right mouse button */
    var right = 2;
        /** extra button pressed  */
    var extra1 = 3;
        /** extra button pressed  */
    var extra2 = 4;

} //MouseButton

/** A typed key id */
@:enum
abstract KeyCode(Int) from Int to Int {

        /** no known key */
    var unknown = -1;
        /** left arrow key */
    var left = 0;
        /** right arrow key */
    var right = 1;
        /** up arrow key */
    var up = 2;
        /** down arrow key */
    var down = 3;
        /** the backspace key */
    var backspace = 4;
        /** the delete key */
    var delete = 5;
        /** the tab key */
    var tab = 6;
        /** the enter key */
    var enter = 7;
        /** the escape key */
    var escape = 8;

} //KeyCode

/** Input modifier state */
typedef ModState = {

        /** no modifiers are down */
    var none : Bool;
        /** left shift key is down */
    var lshift : Bool;
        /** right shift key is down */
    var rshift : Bool;
        /** left ctrl key is down */
    var lctrl : Bool;
        /** right ctrl key is down */
    var rctrl : Bool;
        /** left alt/option key is down */
    var lalt : Bool;
        /** right alt/option key is down */
    var ralt : Bool;
        /** left windows/command key is down */
    var lmeta : Bool;
        /** right windows/command key is down */
    var rmeta : Bool;
        /** numlock is enabled */
    var num : Bool;
        /** capslock is enabled */
    var caps : Bool;
        /** mode key is down */
    var mode : Bool;
        /** left or right ctrl key is down */
    var ctrl : Bool;
        /** left or right shift key is down */
    var shift : Bool;
        /** left or right alt/option key is down */
    var alt : Bool;
        /** left or right windows/command key is down */
    var meta : Bool;

} //ModState


typedef MouseEvent = {

        /** The time in seconds when this mouse event occurred, useful for deltas */
    var timestamp : Float;
        /** The state this event is in */
    var state : InteractState;
        /** The button id, if the event `state` is `down` or `up` */
    var button : MouseButton;
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

/** A mint specific key event */
typedef KeyEvent = {

        /** The time in seconds when this key event occurred, useful for deltas */
    var timestamp : Float;
        /** The state this event is in */
    var state : InteractState;
        /** The raw keycode of the event */
    var keycode : Int;
        /** The typed mint key for the event */
    var key : KeyCode;
        /** The modifier state */
    var mod : ModState;
        /** Whether or not the event should bubble further. set to false to stop propagation */
    var bubble : Bool;

} //KeyEvent

/** Information about a text input event */
typedef TextEvent = {

        /** The text that this event has generated */
    var text : String;
        /** The type of text event */
    var type : TextEventType;
        /** The time in seconds when this touch event occurred, use for deltas */
    var timestamp : Float;
        /** The start position, if the `type` is `edit` */
    var start : Int;
        /** The length position, if the `type` is `edit` */
    var length : Int;
        /** Whether or not the event should bubble further. set to false to stop propagation */
    var bubble : Bool;

} //TextEvent

/** A typed text event type */
enum TextEventType {

        /** An unknown event */
    unknown;
        /** An edit text typing event */
    edit;
        /** An input text typing event */
    input;

} //TextEventType


/** A simple set of static helper functions for mint controls to use */
class Helper {

    static public inline function clamp (value:Float, a:Float, b:Float) : Float {
        return ( value < a ) ? a : ( ( value > b ) ? b : value );
    }

    static inline public function sign(x:Float) : Int {
        return (x < 0) ? -1 : ((x > 0) ? 1 : 0);
    } //sign

    static public function in_rect(x:Float, y:Float, rx:Float, ry:Float, rw:Float, rh:Float) {

            if(x < rx) return false;
            if(y < ry) return false;
            if(x > rx+rw) return false;
            if(y > ry+rh) return false;

        return true;

    } //in_rect

    static public function uniqueid(?val:Null<Int>) : String {

        if(val == null) val = Std.random(0x7fffffff);

        function to_char(value:Int) : String {
            if (value > 9) {
                var ascii = (65 + (value - 10));
                if (ascii > 90) { ascii += 6; }
                return String.fromCharCode(ascii);
            } else return Std.string(value).charAt(0);
        } //to_char

        var r = Std.int(val % 62);
        var q = Std.int(val / 62);
        if (q > 0) return uniqueid(q) + to_char(r);
        else return Std.string(to_char(r));

    } //uniqueid

} //Helper
