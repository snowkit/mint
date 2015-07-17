
import luxe.Color;
import luxe.Vector;
import luxe.Input;

import mint.Types;
import mint.Control;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

class Main extends luxe.Game {

    var canvas: mint.Canvas;
    var label: mint.Label;
    var check: mint.Checkbox;
    var button: mint.Button;
    var image: mint.Image;
    var scroll: mint.ScrollArea;
    var panel: mint.Panel;
    var list: mint.List;
    var window: mint.Window;
    var window2: mint.Window;

    var render: LuxeMintRender;

    var debug : Bool = false;

    override function ready() {

        Luxe.renderer.clear_color.rgb(0x161619);

        var te = Luxe.resources.load_texture('assets/transparency.png');
        te.then(function(t) {

            render = new LuxeMintRender();

            canvas = new mint.Canvas({
                renderer: render,
                bounds: new Rect(10,10,900,512)
            });

            label = new mint.Label({
                parent: canvas,
                name: 'label1',
                bounds: new Rect(10,10,100,32),
                text: 'hello mint',
                point_size: 14,
                onclick: function(e,c) {trace('hello mint! ${Luxe.time}' );}
            });

            check = new mint.Checkbox({
                parent: canvas,
                name: 'check1',
                bounds: new Rect(120,16,24,24)
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

            panel = new mint.Panel({
                parent: canvas,
                name: 'panel1',
                bounds: new Rect(84,102,64,64),
            });

            scroll = new mint.ScrollArea({
                parent: canvas,
                name: 'scroll1',
                bounds: new Rect(10, 180, 128, 128),
            });

            new mint.Image({
                parent: scroll,
                name: 'image2',
                bounds: new Rect(0,100,256,256),
                path: 'assets/transparency.png'
            });


            window = new mint.Window({
                parent: canvas,
                name: 'window1',
                title: 'window',
                bounds: new Rect(200,10,256,400)
            });

            window2 = new mint.Window({
                parent: canvas,
                name: 'window2',
                title: 'window',
                bounds: new Rect(460,10,256,95)
            });

            new mint.TextEdit({
                parent: window2,
                name: 'textedit1',
                text: 'type anything',
                bounds: new Rect(10,32,256-10-10,22)
            });

            new mint.TextEdit({
                parent: window2,
                name: 'textnumbersonly',
                text: 'numbers only',
                bounds: new Rect(10,32+22+10,256-10-10,22),
                filter: new EReg('[0-9]+','gi'),
            });

            list = new mint.List({
                parent: window,
                name: 'list1',
                bounds: new Rect(4,28,248,400-28-4)
            });

            for(i in 0 ... 5) {
                list.add_item( create_block(i) );
            } //for

            trace(canvas.nodes);

        });


    } //ready

    function create_block(idx:Int) {

        var titles = ['Sword of Extraction', 'Fortitude', 'Wisdom stone', 'Cursed Blade', 'Risen Staff' ];
        var desc = ['Steals 30% life of every hit from the target',
                    '3 second Invulnerability', 'Passive: intelligence +5',
                    'Each attack deals 1 damage to the weilder', 'Undead staff deals 3x damage to human enemies' ];

        var _panel = new mint.Panel({
            parent: list,
            name: 'panel_${idx}',
            bounds: new Rect(2,4,236,96),
        });

        new mint.Image({
            name: 'icon_${idx}',
            parent: _panel,
            mouse_enabled:true,
            bounds: new Rect(8,8,80,80),
            path: 'assets/transparency.png'
        });

        new mint.Label({
            name: 'label_${idx}',
            parent: _panel,
            mouse_enabled:true,
            bounds: new Rect(96,8,148,18),
            point_size: 16,
            align: TextAlign.left,
            align_vertical: TextAlign.top,
            text: titles[idx]
        });

        new mint.Label({
            name: 'desc_${idx}',
            parent: _panel,
            mouse_enabled:true,
            bounds_wrap: true,
            bounds: new Rect(96,30,132,18),
            point_size: 12,
            align: TextAlign.left,
            align_vertical: TextAlign.top,
            text: desc[idx]
        });

        return _panel;
    }

    override function onmousemove(e) {
        if(canvas!=null) canvas.onmousemove( Convert.mouse_event(e) );
    }

    override function onmousewheel(e) {
        if(canvas!=null) canvas.onmousewheel( Convert.mouse_event(e) );
    }

    override function onmouseup(e) {
        if(canvas!=null) canvas.onmouseup( Convert.mouse_event(e) );
    }

    override function onmousedown(e) {
        if(canvas!=null) canvas.onmousedown( Convert.mouse_event(e) );
    }

    override function onkeydown(e:luxe.Input.KeyEvent) {
        if(canvas!=null) canvas.onkeydown( Convert.key_event(e) );
    }

    override function ontextinput(e:luxe.Input.TextEvent) {
        if(canvas!=null) canvas.ontextinput( Convert.text_event(e) );
    }

    override function onkeyup(e:luxe.Input.KeyEvent) {

        if(e.keycode == Key.key_1) {
            if(window != null) window.open();
        }
        if(e.keycode == Key.key_2) {
            if(window2 != null) window2.open();
        }

        if(e.keycode == Key.key_d && e.mod.ctrl) {
            debug = !debug;
        }

        if(e.keycode == Key.key_v && e.mod.ctrl) {
            if(canvas!=null) canvas.visible = !canvas.visible;
        }

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

        if(canvas!=null) canvas.onkeyup( Convert.key_event(e) );

    } //onkeyup

    function drawc(control:Control) {

        if(!control.visible) return;

        Luxe.draw.rectangle({
            depth: 1000,
            x: control.real_bounds.x,
            y: control.real_bounds.y,
            w: control.real_bounds.w,
            h: control.real_bounds.h,
            color: new Color(1,0,0,0.5),
            immediate: true
        });

        for(c in control.children) {
            drawc(c);
        }

    } //drawc

    override function update(dt:Float) {
        if(canvas!=null) {
            canvas.update(dt);
        }

        if(debug) {
            for(c in canvas.children) {
                drawc(c);
            }
        }
    } //update

    override function ondestroy() {
    } //shutdown

} //Main


