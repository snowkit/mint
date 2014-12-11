
import luxe.Color;
import luxe.Vector;
import luxe.Input;

import mint.Types;
import mint.render.LuxeMintRender;
import mint.render.Convert;

class Main extends luxe.Game {

    var canvas: mint.Canvas;
    var label: mint.Label;
    var button: mint.Button;
    var image: mint.Image;
    var image2: mint.Image;
    var scroll: mint.ScrollArea;

    var render: LuxeMintRenderer;

    override function ready() {

        Luxe.renderer.clear_color.rgb(0x373737);

        render = new LuxeMintRenderer();
        canvas = new mint.Canvas({
            renderer: render,
            bounds: new Rect(10,10,512,512)
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

        scroll = new mint.ScrollArea({
            parent: canvas,
            name: 'scroll1',
            bounds: new Rect(10, 180, 128, 128),
        });

        image = new mint.Image({
            parent: scroll,
            name: 'image2',
            bounds: new Rect(0,0,256,256),
            path: 'assets/transparency.png'
        });

        trace(canvas.nodes);

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


