package mint;

import mint.Types;
import mint.Control;
import mint.Signal;

typedef CheckboxOptions = {
    > ControlOptions,
    ? state : Bool,
    ? oncheck : Bool->Bool->Void
}

class Checkbox extends Control {

    var check_options: CheckboxOptions;

    @:isVar public var state (default, set) : Bool = true;

    @:allow(mint.ControlRenderer)
        var oncheck: Signal<Bool->Bool->Void>;

    public function new(_options:CheckboxOptions) {

        oncheck = new Signal();
        check_options = _options;

        super(_options);

        if(check_options.mouse_enabled == null){
            mouse_enabled = true;
        }

        canvas.renderer.render(Checkbox, this);

        mouseup.listen(onclick);

        if(check_options.state != null) {
            state = check_options.state;
        }

        if(check_options.oncheck != null) {
            oncheck.listen( check_options.oncheck );
        }

    } //new

    function onclick(_, _) {

        state = !state;

    } //onclick

    function set_state( _b:Bool ) {

        var prev = state;
        state = _b;

        oncheck.emit(state, prev);

        return state;

    } //set_state

} //Panel