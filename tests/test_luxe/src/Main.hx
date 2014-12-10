
import luxe.Color;
import luxe.Vector;
import luxe.Input;

import mint.Types;
import mint.render.LuxeMintRender;

class Main extends luxe.Game {

    var canvas: mint.Canvas;
    var label: mint.Label;
    var button: mint.Button;
    var image: mint.Image;

    var render: LuxeMintRenderer;

    override function ready() {

        Luxe.renderer.clear_color.rgb(0x373737);

        render = new LuxeMintRenderer();
        canvas = new mint.Canvas({
            renderer: render,
            bounds: new Rect(10,10,500,300)
        });

        label = new mint.Label({
            parent: canvas,
            name: 'label1',
            bounds: new Rect(10,10,100,32),
            text: 'hello mint',
            point_size: 14,
            onclick: function(e,c) {trace('hello mint! ${Luxe.time}' );}
        });

        button = new mint.Button({
            parent: canvas,
            name: 'button1',
            bounds: new Rect(10,52,100,32),
            text: 'mint button',
            point_size: 14,
            onclick: function(e,c) {trace('mint button! ${Luxe.time}' );}
        });

        image = new mint.Image({
            parent: canvas,
            name: 'image1',
            bounds: new Rect(10,102,64,64),
            path: 'assets/transparency.png'
        });


    } //ready

    override function onmousemove(e) {
        canvas.onmousemove( Convert.mouse_event(e) );
    }

    override function onmousewheel(e) {
        canvas.onmousewheel( Convert.mouse_event(e) );
    }

    override function onmouseup(e) {
        canvas.onmouseup( Convert.mouse_event(e) );
    }

    override function onmousedown(e) {
        canvas.onmousedown( Convert.mouse_event(e) );
    }

    override function onkeyup(e:KeyEvent) {

        if(e.keycode == Key.right) {
            canvas.translate(100,0);
        }
        if(e.keycode == Key.left) {
            canvas.translate(-100,0);
        }

        if(e.keycode == Key.key_v) {
            canvas.visible = !canvas.visible;
        }

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(dt:Float) {
        canvas.update(dt);
    } //update

    override function ondestroy() {
    } //shutdown

} //Main


