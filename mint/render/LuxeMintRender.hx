package mint.render;

import mint.Types;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Input;

class LuxeMintRender extends mint.Renderer {

    override function render<T:Control>( type:Class<T>, control:T ) {
        switch(type) {
            case mint.Canvas:       follow(control, new mint.render.Canvas(this, cast control));
            case mint.Label:        follow(control, new mint.render.Label(this, cast control));
            case mint.Button:       follow(control, new mint.render.Button(this, cast control));
            case mint.Image:        follow(control, new mint.render.Image(this, cast control));
            case mint.List:         follow(control, new mint.render.List(this, cast control));
            case mint.ScrollArea:   follow(control, new mint.render.Scroll(this, cast control));
            case mint.Panel:        follow(control, new mint.render.Panel(this, cast control));
            case mint.Checkbox:     follow(control, new mint.render.Checkbox(this, cast control));
            case mint.Window:       follow(control, new mint.render.Window(this, cast control));
        }
    } //render

} //LuxeMintRender