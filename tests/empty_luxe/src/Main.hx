
import luxe.Input;
import luxe.Color;
import luxe.Vector;

import mint.Control;
import mint.types.Types;
import mint.render.luxe.*;
import mint.layout.margins.Margins;
import mint.focus.Focus;

import AutoCanvas;

class Main extends luxe.Game {

    var focus: Focus;
    var layout: Margins;
    var canvas: AutoCanvas;
    var rendering: LuxeMintRender;

    override function config(config:luxe.AppConfig) {

        return config;

    } //config

    override function ready() {

        rendering = new LuxeMintRender();
        layout = new Margins();
        
        canvas = new AutoCanvas({
            name:'canvas',
            rendering: rendering,
            options: { color:new Color(1,1,1,0) },
            x: 0, y:0, w: Luxe.screen.w, h: Luxe.screen.h
        });

        focus = new Focus(canvas);
        canvas.auto_listen();

            //optional!
        new mint.Button({
            parent: canvas,
            name: 'button',
            x: 90, y: 40, w: 60, h: 32,
            text: 'mint',
            text_size: 14,
            options: { label: { color:new Color().rgb(0x9dca63) } },
            onclick: function(e,c) { trace('mint button! ${Luxe.time}' ); }
        });

    } //ready

    override function onkeyup( e:luxe.KeyEvent ) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

} //Main
