package mint;

import mint.Types;
import mint.Control;
import mint.Macros.*;

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

    public function new( _options:PanelOptions ) {

        options = _options;

        def(options.name, 'panel');

        super(options);

        renderinst = render_service.render(Panel, this);

    } //new

} //Panel
