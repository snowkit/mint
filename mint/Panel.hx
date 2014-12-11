package mint;

import mint.Types;
import mint.Control;

typedef PanelOptions = {
    > ControlOptions,
}

class Panel extends Control {

    @:allow(mint.ControlRenderer)
        var panel_options: PanelOptions;

    public function new(_options:Dynamic) {

        panel_options = _options;
        super(panel_options);

        canvas.renderer.render(Panel, this);

    } //new

} //Panel