package mint;

import mint.Types;
import mint.Control;

/** Options for constructing a Panel */
typedef PanelOptions = {

    > ControlOptions,

} //PanelOptions

/**
    A simple blank panel control
    Additional Signals: none
*/
@:allow(mint.ControlRenderer)
class Panel extends Control {

    var options: PanelOptions;

    public function new(_options:Dynamic) {

        options = _options;

        super(options);

        canvas.renderer.render(Panel, this);

    } //new

} //Panel
