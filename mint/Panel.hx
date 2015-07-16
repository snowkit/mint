package mint;

import mint.Types;
import mint.Control;

typedef PanelOptions = {
    > ControlOptions,
}

class Panel extends Control {

    @:allow(mint.ControlRenderer)
        var options: PanelOptions;

    public function new(_options:Dynamic) {

        options = _options;
        super(options);

        canvas.renderer.render(Panel, this);

    } //new

} //Panel