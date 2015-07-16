package mint.render.luxe;

import mint.Types;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Input;

class LuxeMintRender extends mint.Renderer {

    override function render<T:Control>( type:Class<T>, control:T ) {
        switch(type) {
            case mint.Canvas:       follow(control, new mint.render.luxe.Canvas(this, cast control));
            case mint.Label:        follow(control, new mint.render.luxe.Label(this, cast control));
            case mint.Button:       follow(control, new mint.render.luxe.Button(this, cast control));
            case mint.Image:        follow(control, new mint.render.luxe.Image(this, cast control));
            case mint.List:         follow(control, new mint.render.luxe.List(this, cast control));
            case mint.ScrollArea:   follow(control, new mint.render.luxe.Scroll(this, cast control));
            case mint.Panel:        follow(control, new mint.render.luxe.Panel(this, cast control));
            case mint.Checkbox:     follow(control, new mint.render.luxe.Checkbox(this, cast control));
            case mint.Window:       follow(control, new mint.render.luxe.Window(this, cast control));
        }
    } //render

} //LuxeMintRender