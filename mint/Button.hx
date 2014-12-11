package mint;

import mint.Types;
import mint.Control;
import mint.Label;

typedef ButtonOptions = {
    > LabelOptions,
}

class Button extends Control {

    public var label : Label;

    @:allow(mint.ControlRenderer)
        var button_options: ButtonOptions;

    public function new(_options:Dynamic) {

        button_options = _options;
        super(button_options);

        if(button_options.mouse_enabled == null){
            mouse_enabled = true;
        }

        label = new Label({
            parent : this,
            bounds : button_options.bounds.clone().set(0,0),
            text: button_options.text,
            point_size: button_options.point_size,
            name : name + '.label',
            mouse_enabled: false
        });

        if(button_options.onclick != null) {
            mousedown.listen(button_options.onclick);
        }

        canvas.renderer.render( Button, this );

    } //new

} //Control