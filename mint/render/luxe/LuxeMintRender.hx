package mint.render.luxe;

import mint.Types;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Input;
import luxe.Log.*;

class LuxeMintRender extends mint.Renderer {

    public var options: luxe.options.RenderProperties;

    public function new( ?_options:luxe.options.RenderProperties ) {

        super();

        options = def(_options, {});
        def(options.batcher, Luxe.renderer.batcher);
        def(options.depth, 0);
        def(options.group, 0);
        def(options.immediate, false);
        def(options.visible, true);

    } //new

    override function render<T:Control, T1>( type:Class<T>, control:T ) : T1 {
        return cast switch(type) {
            case mint.Canvas:       follow(control, new mint.render.luxe.Canvas(this, cast control));
            case mint.Label:        follow(control, new mint.render.luxe.Label(this, cast control));
            case mint.Button:       follow(control, new mint.render.luxe.Button(this, cast control));
            case mint.Image:        follow(control, new mint.render.luxe.Image(this, cast control));
            case mint.List:         follow(control, new mint.render.luxe.List(this, cast control));
            case mint.ScrollArea:   follow(control, new mint.render.luxe.Scroll(this, cast control));
            case mint.Panel:        follow(control, new mint.render.luxe.Panel(this, cast control));
            case mint.Checkbox:     follow(control, new mint.render.luxe.Checkbox(this, cast control));
            case mint.Window:       follow(control, new mint.render.luxe.Window(this, cast control));
            case mint.TextEdit:     follow(control, new mint.render.luxe.TextEdit(this, cast control));
            case mint.Dropdown:     follow(control, new mint.render.luxe.Dropdown(this, cast control));
            case _:                 null;
        }
    } //render

} //LuxeMintRender