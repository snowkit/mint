package mint;

import mint.Control;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a Checkbox */
typedef CheckboxOptions = {

    > ControlOptions,

        /** The initial state of the checkbox */
    @:optional var state : Bool;

        /** A signal handler for when the checkbox state changes.
            The handler is `function(_new_state:Bool, _prev_state:Bool)` */
    @:optional var onchange : Bool->Bool->Void;

} //CheckboxOptions


/**
    A checkbox is a simple true or false switch.
    Changing the state will trigger the signal.
    Additional Signals: onchange
*/
@:allow(mint.render.Renderer)
class Checkbox extends Control {

        /** The current state. Read/Write */
    @:isVar public var state (default, set) : Bool = true;

        /** Emitted whenever state is changed.
            `function(new_state:Bool, prev_state:Bool)` */
    public var onchange: Signal<Bool->Bool->Void>;

    var options: CheckboxOptions;

    public function new( _options:CheckboxOptions ) {

        options = _options;

        def(options.name, 'checkbox.${Helper.uniqueid()}');
        def(options.mouse_input, true);

        super(_options);

        onchange = new Signal();


        if(options.state != null) {
            state = options.state;
        }

        renderer = rendering.get(Checkbox, this);

        if(options.onchange != null) {
            onchange.listen( options.onchange );
        }

        onmouseup.listen(onclick);

        oncreate.emit();

    } //new

    public override function destroy() {
        
        super.destroy();

        onchange.clear();
        onchange = null;
        
    }

//Internal

    function onclick(_, _) {

        state = !state;

    } //onclick

    function set_state( _b:Bool ) {

        var prev = state;

        state = _b;

        onchange.emit(state, prev);

        return state;

    } //set_state

} //Checkbox
