package mint;

import mint.Control;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a Panel */
typedef PanelOptions = {

    > ControlOptions,

} //PanelOptions


/**
    A simple blank panel control
    Additional Signals: none
*/
@:allow(mint.render.Renderer)
class Panel extends Control {

    var options: PanelOptions;

    public function new( _options:PanelOptions ) {

        options = _options;

        def(options.name, 'panel.${Helper.uniqueid()}');

        super(options);

        renderer = rendering.get(Panel, this);

        oncreate.emit();

    } //new

} //Panel
