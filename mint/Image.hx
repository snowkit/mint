package mint;

import mint.Types;
import mint.Control;

typedef ImageOptions = {
    > ControlOptions,
    path: String,
}

class Image extends Control {

    @:allow(mint.ControlRenderer)
        var image_options: ImageOptions;

    public function new(_options:ImageOptions) {

        image_options = _options;
        mouse_enabled = false;

            //create the base control
        super(_options);

        canvas.renderer.render(Image, this);

    } //new

} //Image