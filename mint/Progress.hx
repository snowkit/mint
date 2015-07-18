package mint;

import mint.Types;
import mint.Control;
import mint.Macros.*;

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
@:allow(mint.ControlRenderer)
class Progress extends Control {

    @:isVar public var progress (default, set) : Float = 0.5;

    public var onchange: Signal<Float->Float->Void>;

    var options: ProgressOptions;

    public function new( _options:ProgressOptions ) {

        options = _options;

        def(options.name, 'progress');

        super(options);

        onchange = new Signal();

        progress = def(options.progress, 0.5);

        renderinst = render_service.render(Progress, this);

    } //new

    function set_progress(_value:Float) : Float {

        var prev = progress;

        _value = Utils.clamp(_value, 0.0, 1.0);

        progress = _value;

        onchange.emit(progress, prev);

        return progress;

    } //set_progress

} //Progress
