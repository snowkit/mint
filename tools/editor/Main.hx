import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Text;

import mint.Types;
import mint.Control;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import mint.layout.margins.Margins;

class Main extends luxe.Game {

    var canvas: mint.Canvas;
    var render: LuxeMintRender;
    var layout: Margins;

    override function config(config:luxe.AppConfig) {

        config.preload.textures.push({ id:'assets/960.png' });
        config.preload.textures.push({ id:'assets/transparency.png' });
        config.preload.textures.push({ id:'assets/mint.box.png' });

        return config;
    }

    override function ready() {

        // Luxe.snow.windowing.enable_vsync(false);
        Luxe.renderer.clear_color.rgb(0x161619);

        new luxe.Sprite({ texture:Luxe.resources.texture('assets/960.png'), centered:false, depth:-1 });

        render = new LuxeMintRender();
        layout = new Margins();

        canvas = new mint.Canvas({
            renderer: render,
            x: 0, y:0, w: 960, h: 640
        });

    }

    override function onmousemove(e) {

        if(canvas!=null) canvas.mousemove( Convert.mouse_event(e) );

    }

    override function onmousewheel(e) {

        if(canvas!=null) canvas.mousewheel( Convert.mouse_event(e) );

    }

    override function onmouseup(e) {

        if(canvas!=null) canvas.mouseup( Convert.mouse_event(e) );

    }

    override function onmousedown(e) {

        if(canvas!=null) canvas.mousedown( Convert.mouse_event(e) );

    } //onmousedown

    override function onkeydown(e:luxe.Input.KeyEvent) {

        if(canvas!=null) canvas.keydown( Convert.key_event(e) );

    } //onkeydown

    override function ontextinput(e:luxe.Input.TextEvent) {

        if(canvas!=null) canvas.textinput( Convert.text_event(e) );

    } //ontextinput

    override function onkeyup(e:luxe.Input.KeyEvent) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
            return;
        }

        if(canvas!=null) canvas.keyup( Convert.key_event(e) );

    } //onkeyup

    override function onrender() {

        canvas.render();

    } //onrender

    override function update(dt:Float) {

        if(canvas!=null) canvas.update(dt);

    } //update

} //Main
