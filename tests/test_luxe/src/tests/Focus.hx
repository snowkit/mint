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

class Focus extends State {

    var scroll: mint.Scroll;
    var scroll2: mint.Scroll;

    override function onenter<T>(_:T) {

        Main.disp.text = 'Test: Focus';

        var _r0 = new mint.Scroll({
            parent: Main.canvas, name:'r0',
            x:20, y:20, w:256, h: 256,
            options: { color:new Color().rgb(0x000000) }
        });

        var _l0 = new mint.Label({
            parent: _r0, name:'l0',
            x:0, y:0, w:256, h:264,
            options: {},
            mouse_input: true,
            text: 'HOVERS'
        });

        _l0.onmouseenter.listen(function(_,_) { trace('enter ' + Luxe.time); });
        _l0.onmouseleave.listen(function(_,_) { trace('leave ' + Luxe.time); });


    } //onenter

    override function onleave<T>(_:T) {

    } //onleave


} //Focus