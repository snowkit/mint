package tests;

import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Text;
import luxe.States;

import mint.Control;
import mint.types.Types;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;
import mint.render.luxe.Label;

import mint.layout.margins.Margins;

class Scrolling extends State {

    var scroll: mint.Scroll;
    var scroll2: mint.Scroll;

    override function onenter<T>(_:T) {

        Main.disp.text = 'Test: Scrolling';

        scroll = new mint.Scroll({
            parent: Main.canvas,
            options: { color_handles:new Color().rgb(0xf6007b) },
            x:10, y:10, w: 256, h: 256
        });

        new mint.Image({
            parent: scroll,
            x:0, y:0, w:512, h: 512,
            path: 'assets/image.png'
        });

        scroll2 = new mint.Scroll({
            parent: Main.canvas,
            options: { color_handles:new Color().rgb(0xcc0000) },
            x:320, y:10, w: 256, h: 256
        });

        new mint.Image({
            parent: scroll2,
            x:0, y:0, w:128, h: 128,
            path: 'assets/image.png'
        });

    } //onenter

    override function onleave<T>(_:T) {

    } //onleave


} //Scrolling