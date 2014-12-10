package mint.render;

import mint.Types;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Input;

class LuxeMintRenderer extends Renderer {

    override function render<T:Control>( type:Class<T>, control:T ) {
        switch(type) {
            case mint.Canvas: follow(control, new mint.render.Canvas(this, cast control));
            case mint.Label: follow(control, new mint.render.Label(this, cast control));
            case mint.Button: follow(control, new mint.render.Button(this, cast control));
            case mint.Image: follow(control, new mint.render.Image(this, cast control));
        }
    } //render

} //LuxeMintRender


class Convert {

    public static function text_align( _align:mint.TextAlign ) : TextAlign {

        switch(_align) {
            case mint.TextAlign.left:
                return TextAlign.left;
            case mint.TextAlign.right:
                return TextAlign.right;
            case mint.TextAlign.center:
                return TextAlign.center;
            case mint.TextAlign.top:
                return TextAlign.top;
            case mint.TextAlign.bottom:
                return TextAlign.bottom;
            case _:
        }

        return TextAlign.left;

    } //text_align

    public static function rect( _rect:Rect ) : Rectangle {
        if(_rect != null) return new Rectangle( _rect.x, _rect.y, _rect.w, _rect.h );
        return null;
    } //rect

    public static function point( _point:Point ) : Vector {
        if(_point != null) return new Vector( _point.x, _point.y );
        return null;
    } //point

    public static function interact_state( _state:InteractState ) : mint.InteractState {
        switch(_state) {
            case InteractState.unknown:
                return mint.InteractState.unknown;
            case InteractState.none:
                return mint.InteractState.none;
            case InteractState.down:
                return mint.InteractState.down;
            case InteractState.up:
                return mint.InteractState.up;
            case InteractState.move:
                return mint.InteractState.move;
            case InteractState.wheel:
                return mint.InteractState.wheel;
            case InteractState.axis:
                return mint.InteractState.axis;
        } //state
    } //interact_state

    public static function mouse_button( _button:MouseButton ) : mint.MouseButton {
        switch(_button) {
            case MouseButton.none:
                return mint.MouseButton.none;
            case MouseButton.left:
                return mint.MouseButton.left;
            case MouseButton.middle:
                return mint.MouseButton.middle;
            case MouseButton.right:
                return mint.MouseButton.right;
            case MouseButton.extra1:
                return mint.MouseButton.extra1;
            case MouseButton.extra2:
                return mint.MouseButton.extra2;
        } //state
    } //mouse_button

    public static function mouse_event( _event:MouseEvent ) : mint.MouseEvent {
        return {
            state : interact_state(_event.state),
            button : mouse_button(_event.button),
            window_id : _event.window_id,
            timestamp : _event.timestamp,
            x : _event.x,
            y : _event.y,
            xrel : _event.xrel,
            yrel : _event.yrel,
            bubble : true
        };
    } //mouse_event

} //Convert