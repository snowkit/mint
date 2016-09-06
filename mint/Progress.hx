package mint;

import mint.Control;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a Progress */
typedef ProgressOptions = {

    > ControlOptions,

        /** The default progress */
    @:optional var progress : Float;

} //ProgressOptions


/**
    A simple progress control, ranging from 0 to 1.
    Additional Signals: onchange
*/
@:allow(mint.render.Renderer)
class Progress extends Control {

    @:isVar public var progress (default, set) : Float = 0.5;

    public var onchange: Signal<Float->Float->Void>;

    var options: ProgressOptions;

    public function new( _options:ProgressOptions ) {

        options = _options;

        def(options.name, 'progress.${Helper.uniqueid()}');

        super(options);

        onchange = new Signal();

        progress = def(options.progress, 0.5);

        renderer = rendering.get(Progress, this);

        oncreate.emit();

    } //new

    public override function destroy() {

        super.destroy();

        onchange.clear();
        onchange = null;

    } //destroy

    function set_progress(_value:Float) : Float {

        var prev = progress;

        _value = Helper.clamp(_value, 0.0, 1.0);

        progress = _value;

        onchange.emit(progress, prev);

        return progress;

    } //set_progress

} //Progress
