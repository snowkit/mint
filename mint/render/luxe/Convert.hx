package mint.render.luxe;

import mint.Types;
import mint.render.luxe.Convert;

import luxe.Rectangle;
import luxe.Vector;
import luxe.Text;
import luxe.Input;

class Convert {

        /** from mint.TextAlign to luxe.Text.TextAlign */
    public static function text_align( _align:mint.TextAlign ) : TextAlign {

        return switch(_align) {
            case mint.TextAlign.right:  TextAlign.right;
            case mint.TextAlign.center: TextAlign.center;
            case mint.TextAlign.top:    TextAlign.top;
            case mint.TextAlign.bottom: TextAlign.bottom;
            case _:                     TextAlign.left;
        }

    } //text_align

        /** from mint.Rect to luxe.Rectangle */
    public static function rect( _rect:Rect ) : Rectangle {

        if(_rect == null) return null;

        return new Rectangle( _rect.x, _rect.y, _rect.w, _rect.h );

    } //rect

        /** from mint.Point to luxe.Vector */
    public static function point( _point:Point ) : Vector {

        if(_point == null) return null;

        return new Vector( _point.x, _point.y );

    } //point

        /** from luxe.Input.InteractState to mint.InteractState */
    public static function interact_state( _state:InteractState ) : mint.InteractState {

        return switch(_state) {
            case InteractState.unknown: mint.InteractState.unknown;
            case InteractState.none:    mint.InteractState.none;
            case InteractState.down:    mint.InteractState.down;
            case InteractState.up:      mint.InteractState.up;
            case InteractState.move:    mint.InteractState.move;
            case InteractState.wheel:   mint.InteractState.wheel;
            case InteractState.axis:    mint.InteractState.axis;
        } //state

    } //interact_state

        /** from luxe.Input.MouseButton to mint.MouseButton */
    public static function mouse_button( _button:MouseButton ) : mint.MouseButton {

        return switch(_button) {
            case MouseButton.none:      mint.MouseButton.none;
            case MouseButton.left:      mint.MouseButton.left;
            case MouseButton.middle:    mint.MouseButton.middle;
            case MouseButton.right:     mint.MouseButton.right;
            case MouseButton.extra1:    mint.MouseButton.extra1;
            case MouseButton.extra2:    mint.MouseButton.extra2;
        } //state

    } //mouse_button

        /** from luxe.Input.Key to mint.KeyCode */
    public static function key_code( _keycode:Int ) : mint.KeyCode {

        return switch(_keycode) {

            case Key.left:      mint.KeyCode.left;
            case Key.right:     mint.KeyCode.right;
            case Key.up:        mint.KeyCode.up;
            case Key.down:      mint.KeyCode.down;
            case Key.backspace: mint.KeyCode.backspace;
            case Key.delete:    mint.KeyCode.delete;
            case Key.tab:       mint.KeyCode.tab;
            case Key.enter:     mint.KeyCode.enter;
            case _:             mint.KeyCode.unknown;

        } //_keycode

    } //key_code

    public static function text_event_type( _type:TextEventType ) : mint.TextEventType {

        return switch(_type) {
            case TextEventType.unknown: mint.TextEventType.unknown;
            case TextEventType.edit:    mint.TextEventType.edit;
            case TextEventType.input:   mint.TextEventType.input;
        }

    } //text_event_type

        /** from luxe.Input.ModState to mint.ModState */
    public static function mod_state( _mod:ModState ) : mint.ModState {

        return {
            none:   _mod.none,
            lshift: _mod.lshift,
            rshift: _mod.rshift,
            lctrl:  _mod.lctrl,
            rctrl:  _mod.rctrl,
            lalt:   _mod.lalt,
            ralt:   _mod.ralt,
            lmeta:  _mod.lmeta,
            rmeta:  _mod.rmeta,
            num:    _mod.num,
            caps:   _mod.caps,
            mode:   _mod.mode,
            ctrl:   _mod.ctrl,
            shift:  _mod.shift,
            alt:    _mod.alt,
            meta:   _mod.meta,
        };

    } //mod_state

        /** from luxe.Input.MouseEvent to mint.MouseEvent */
    public static function mouse_event( _event:MouseEvent ) : mint.MouseEvent {

        return {
            state       : interact_state(_event.state),
            button      : mouse_button(_event.button),
            timestamp   : _event.timestamp,
            x           : _event.x,
            y           : _event.y,
            xrel        : _event.xrel,
            yrel        : _event.yrel,
            bubble      : true
        };

    } //mouse_event

        /** from luxe.Input.KeyEvent to mint.KeyEvent */
    public static function key_event( _event:KeyEvent ) : mint.KeyEvent {

        return {
            state       : interact_state(_event.state),
            keycode     : _event.keycode,
            timestamp   : _event.timestamp,
            key         : key_code(_event.keycode),
            mod         : mod_state(_event.mod),
            bubble      : true
        };

    } //key_event

        /** from luxe.Input.TextEvent to mint.TextEvent */
    public static function text_event( _event:TextEvent ) : mint.TextEvent {

        return {
            text      : _event.text,
            type      : text_event_type(_event.type),
            timestamp : _event.timestamp,
            start     : _event.start,
            length    : _event.length,
            bubble    : true
        };

    } //mouse_event

} //Convert
