
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
    var label: mint.Label;
    var check: mint.Checkbox;
    var button: mint.Button;
    var image: mint.Image;
    var scroll: mint.ScrollArea;
    var panel: mint.Panel;
    var list: mint.List;
    var window: mint.Window;
    var window2: mint.Window;
    var customwindow: mint.Window;
    var progress: mint.Progress;

    var render: LuxeMintRender;
    var layout: Margins;

    var debug : Bool = false;
    var td : Text;

    override function config(config:luxe.AppConfig) {

        config.preload.textures.push({ id:'assets/960.png' });
        config.preload.textures.push({ id:'assets/transparency.png' });
        config.preload.textures.push({ id:'assets/mint.box.png' });

        return config;
    }

    override function ready() {

        // Luxe.snow.windowing.enable_vsync(false);

        new luxe.Sprite({ texture:Luxe.resources.texture('assets/960.png'), centered:false, depth:-1 });

        Luxe.renderer.clear_color.rgb(0x161619);

        render = new LuxeMintRender();
        layout = new Margins();

        canvas = new mint.Canvas({
            renderer: render,
            x: 0, y:0, w: 960, h: 640
        });

        td = new Text({
            text: 'debug:  (${Luxe.snow.os} / ${Luxe.snow.platform})',
            point_size: 14,
            pos: new Vector(950, 10),
            align: right,
            depth: 999,
            color: new Color()
        });

        test1();

    } //ready

    var progress_dir = -1;

    function test1() {

        label = new mint.Label({
            parent: canvas,
            name: 'label1',
            x:10, y:10, w:100, h:32,
            text: 'hello mint',
            text_size: 14,
            onclick: function(e,c) {trace('hello mint! ${Luxe.time}' );}
        });

        check = new mint.Checkbox({
            parent: canvas,
            name: 'check1',
            x: 120, y: 16, w: 24, h: 24
        });

        new mint.Checkbox({
            parent: canvas,
            name: 'check2',
            options: {
                color_node: new Color().rgb(0xf6007b),
                color_node_off: new Color().rgb(0xcecece),
                color_normal: new Color().rgb(0xefefef),
                color_hover: new Color().rgb(0xffffff),
                color_node_hover: new Color().rgb(0xe2005a)
            },
            x: 120, y: 48, w: 24, h: 24
        });

        progress = new mint.Progress({
            parent: canvas,
            name: 'progress1',
            progress: 0.2,
            x: 10, y:95 , w:128, h: 16
        });

        var sh1 = new mint.Slider({
            parent: canvas,
            name: 'slider1',
            min: 0,
            max: 100,
            step: 10,
            x: 10, y:330 , w: 128, h: 24
        });

        var sh2 = new mint.Slider({
            parent: canvas,
            name: 'slider2',
            min: 0, max: 100, step: 1,
            x:10, y:357, w:128, h:24
        });

        var sh3 = new mint.Slider({
            parent: canvas,
            name: 'slider3',
            x:10, y:385, w:128, h:24
        });

        (cast sh1.bar.renderinst:mint.render.luxe.Panel).visual.color.rgb(0x9dca63);
        (cast sh2.bar.renderinst:mint.render.luxe.Panel).visual.color.rgb(0x9dca63);
        (cast sh3.bar.renderinst:mint.render.luxe.Panel).visual.color.rgb(0xf6007b);

        var sv1 = new mint.Slider({
            parent: canvas,
            name: 'slider1',
            vertical: true,
            min: 0, max: 100, step: 10,
            x:14, y:424 , w:32, h:128
        });

        var sv2 = new mint.Slider({
            parent: canvas,
            name: 'slider2',
            vertical: true,
            min: 0, max: 100, step: 1,
            x:56, y:424, w:32, h:128
        });

        var sv3 = new mint.Slider({
            parent: canvas,
            name: 'slider3',
            vertical: true,
            x:98, y:424, w:32, h:128
        });

        (cast sv1.bar.renderinst:mint.render.luxe.Panel).visual.color.rgb(0x9dca63);
        (cast sv2.bar.renderinst:mint.render.luxe.Panel).visual.color.rgb(0x9dca63);
        (cast sv3.bar.renderinst:mint.render.luxe.Panel).visual.color.rgb(0xf6007b);

        button = new mint.Button({
            parent: canvas,
            name: 'button1',
            x: 10, y: 52, w: 60, h: 32,
            text: 'mint',
            text_size: 14,
            onclick: function(e,c) {trace('mint button! ${Luxe.time}' );}
        });

        new mint.Button({
            parent: canvas,
            name: 'button2',
            x: 76, y: 52, w: 32, h: 32,
            text: 'O',
            options: { color_hover: new Color().rgb(0xf6007b) },
            text_size: 16,
            onclick: function(e,c) {trace('mint button! ${Luxe.time}' );}
        });

        image = new mint.Image({
            parent: canvas,
            name: 'image1',
            x: 10, y: 120, w: 64, h: 64,
            path: 'assets/transparency.png'
        });

        panel = new mint.Panel({
            parent: canvas,
            name: 'panel1',
            x:84, y:120, w:64, h: 64,
        });

        scroll = new mint.ScrollArea({
            parent: canvas,
            name: 'scroll1',
            x:16, y:190, w: 128, h: 128,
        });

        new mint.Image({
            parent: scroll,
            name: 'image2',
            x:0, y:100, w:256, h: 256,
            path: 'assets/transparency.png'
        });

        var a = new mint.Image({
            parent: canvas,
            name: 'image2',
            x:0, y:400, w:32, h: 32,
            path: 'assets/transparency.png'
        });

        window = new mint.Window({
            parent: canvas,
            name: 'window1',
            title: 'window',
            x:160, y:10, w:256, h: 400,
            w_min: 256, h_min:256
        });

        window2 = new mint.Window({
            parent: canvas,
            name: 'window2',
            title: 'window',
            x:500, y:10, w:256, h: 131,
            h_max: 131, h_min: 131, w_min: 131
        });

        layout.anchor(a, window2, left, right);
        layout.anchor(a, window2, top, top);

        customwindow = new mint.Window({
            parent: canvas,
            name: 'customwindow',
            title: 'custom window',
            text_size: 13,
            renderer: new CustomWindowRender(),
            x:500, y:150, w:256, h:180+42+32,
            w_min: 128, h_min:128
        });

        //reach into the rendering specifics and change stuff
        var _title_render = (cast customwindow.title.renderinst:mint.render.luxe.Label);
            _title_render.text.color.rgb(0x7d5956);

        var _close_render = (cast customwindow.close_button.renderinst:mint.render.luxe.Label);
            _close_render.text.color.rgb(0x7d5956);
            _close_render.color_normal.rgb(0x7d5956);
            _close_render.color_hover.rgb(0xf6007b);
            _close_render.text.point_size = 16;

        var platform = new mint.Dropdown({
            parent: window2,
            name: 'dropdown',
            text: 'Platform...',
            x:10, y:32+22+10+32, w:256-10-10, h:24,
        });

        layout.margin(platform, right, fixed, 10);

        inline function add_plat(name:String, first:Bool = false) {
            platform.add_item(
                new mint.Label({
                    parent: canvas,
                    align: TextAlign.left,
                    text: '$name',
                    name: 'plat-$name',
                    w:225, h:24, text_size: 14
                }),
                10, (first) ? 0 : 10
            );
        }

        var plist = ['windows', 'linux', 'ios', 'android', 'web'];
        var f = true;
        for(p in plist) {
            add_plat(p, f);
            f = false;
        }

        platform.onselect.listen(function(idx,_,_){
            platform.label.text = plist[idx];
        });

        var p1 = new mint.Panel({ parent: customwindow, name: 'p1', x: 32, y: 120, w: 32, h: 32 });
        var p2 = new mint.Panel({ parent: customwindow, name: 'p2', x: 32, y: 36, w: 8, h: 8 });

        layout.anchor(p1, center_x, center_x);
        layout.anchor(p1, center_y, center_y);

        layout.size(p2, width, 50);
        layout.anchor(p2, center_x, center_x);

        var list2 = new mint.List({
            parent: customwindow,
            name: 'list',
            x: 10, y: 50, w: 236, h: 64
        });

        for(i in 0 ... 20) {
            list2.add_item(
                new mint.Label({
                    parent: list2,
                    align: TextAlign.left,
                    options: {
                        color_normal: new Color().rgb(0xf6007b),
                        color_hover: new Color().rgb(0xffffff)
                    },
                    name: 'label$i',
                    w:100, h:30,
                    text: 'label $i',
                    text_size: 14
                }),
                10, i == 0 ? 0 : 10
            );
        }

        layout.margin(list2, right, fixed, 10);

        var text1 = new mint.TextEdit({
            parent: window2,
            name: 'textedit1',
            text: 'snõwkit / mínt',
            does_render: true,
            x: 10, y:32, w: 256-10-10, h: 22
        });

        layout.margin(text1, right, fixed, 10);

        var text2 = new mint.TextEdit({
            parent: window2,
            name: 'textnumbersonly',
            text: 'numbers only',
            x: 10, y:32+22+10, w: 256-10-10, h: 22,
            filter: new EReg('[0-9]+','gi'),
        });

        layout.margin(text2, right, fixed, 10);

        list = new mint.List({
            parent: window,
            name: 'list1',
            x: 4, y: 28, w: 248, h: 400-28-4
        });

        layout.margin(list, right, fixed, 4);
        layout.margin(list, bottom, fixed, 4);

        for(i in 0 ... 5) {
            list.add_item( create_block(i) );
        } //for


    } //test1

    function create_block(idx:Int) {

        var titles = ['Sword of Extraction', 'Fortitude', 'Wisdom stone', 'Cursed Blade', 'Risen Staff' ];
        var desc = ['Steals 30% life of every hit from the target',
                    '3 second Invulnerability', 'Passive: intelligence +5',
                    'Each attack deals 1 damage to the weilder', 'Undead staff deals 3x damage to human enemies' ];

        var _panel = new mint.Panel({
            parent: list,
            name: 'panel_${idx}',
            x:2, y:4, w:236, h:96,
        });

        layout.margin(_panel, right, fixed, 2);

        var _icon = new mint.Image({
            name: 'icon_${idx}',
            parent: _panel,
            mouse_input:true,
            x:8, y:8, w:80, h:80,
            path: 'assets/transparency.png'
        });

        var _title = new mint.Label({
            name: 'label_${idx}',
            parent: _panel,
            mouse_input:true,
            x:96, y:8, w:148, h:18,
            text_size: 16,
            align: TextAlign.left,
            align_vertical: TextAlign.top,
            text: titles[idx]
        });

        layout.margin(_title, right, fixed, 8);

        var _desc = new mint.Label({
            name: 'desc_${idx}',
            parent: _panel,
            mouse_input:true,
            bounds_wrap: true,
            x:96, y:30, w:132, h:18,
            text_size: 12,
            align: TextAlign.left,
            align_vertical: TextAlign.top,
            text: desc[idx]
        });

        layout.margin(_desc, right, fixed, 8);

        return _panel;

    }

    override function onmousemove(e) {

        if(canvas!=null) {
            canvas.mousemove( Convert.mouse_event(e) );

            var s = 'debug:  (${Luxe.snow.os} / ${Luxe.snow.platform})\n';

            s += 'canvas nodes: ' + (canvas != null ? '${canvas.nodes}' : 'none');
            s += '\n';
            s += 'canvas depth_seq: ' + (canvas != null ? @:privateAccess canvas.depth_seq + '' : 'none');
            s += '\n';
            s += 'focused: ' + (canvas.focused != null ? canvas.focused.name : 'none');
            s += (canvas.focused != null ? ' / depth: '+canvas.focused.depth : '');
            s += '\n';
            s += 'modal: ' + (canvas.modal != null ?  canvas.modal.name : 'none');
            s += '\n';
            s += 'dragged: ' + (canvas.dragged != null ? canvas.dragged.name : 'none');
            s += '\n';

            td.text = s;

        }

    }

    override function onmousewheel(e) {
        if(canvas!=null) canvas.mousewheel( Convert.mouse_event(e) );
    }

    override function onmouseup(e) {
        if(canvas!=null) canvas.mouseup( Convert.mouse_event(e) );
    }

    override function onmousedown(e) {
        if(canvas!=null) canvas.mousedown( Convert.mouse_event(e) );
    }

    override function onkeydown(e:luxe.Input.KeyEvent) {
        if(canvas!=null) canvas.keydown( Convert.key_event(e) );
    }

    override function ontextinput(e:luxe.Input.TextEvent) {
        if(canvas!=null) canvas.textinput( Convert.text_event(e) );
    }

    override function onkeyup(e:luxe.Input.KeyEvent) {

        if(e.keycode == Key.key_1) {
            if(window != null) window.open();
        }
        if(e.keycode == Key.key_2) {
            if(window2 != null) window2.open();
        }
        if(e.keycode == Key.key_3) {
            if(customwindow != null) customwindow.open();
        }
        if(e.keycode == Key.key_4) {
            if(check != null) check.visible = !check.visible;
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

        if(canvas!=null) canvas.keyup( Convert.key_event(e) );

    } //onkeyup

    function drawc(control:Control) {

        if(!control.visible) return;

        Luxe.draw.rectangle({
            depth: 1000,
            x: control.x,
            y: control.y,
            w: control.w,
            h: control.h,
            color: new Color(1,0,0,0.5),
            immediate: true
        });

        for(c in control.children) {
            drawc(c);
        }

    } //drawc

    override function onrender() {

        canvas.render();

    } //onrender

    override function update(dt:Float) {
        if(canvas!=null) {
            canvas.update(dt);
        }

        progress.progress += (0.2 * dt) * progress_dir;
        if(progress.progress >= 1) progress_dir = -1;
        if(progress.progress <= 0) progress_dir = 1;

        if(debug) {
            for(c in canvas.children) {
                drawc(c);
            }
        }
    } //update

    override function ondestroy() {
    } //shutdown

} //Main



class CustomWindow extends mint.render.Base {

    var window : mint.Window;
    var visual : luxe.NineSlice;

    public function new( _render:mint.Renderer, _control:mint.Window ) {

        super(_render, _control);
        window = _control;

        connect();

        visual = new luxe.NineSlice({
            texture : Luxe.resources.texture('assets/mint.box.png'),
            top : 32, left : 32, right : 32, bottom : 32,
        });

        visual.create(new Vector(window.x, window.y), window.w, window.h);

        window.title.y_local += 3;
        window.close_button.y_local += 1;

    } //new

    override function ondestroy() {
        disconnect();
        visual.destroy();
        visual = null;
        destroy();
    }

    override function onbounds() {
        visual.pos = new Vector(control.x, control.y);
        visual.size = new Vector(control.w, control.h);
    }

    override function onvisible( _visible:Bool ) visual.visible = _visible;
    override function ondepth( _depth:Float ) visual.depth = _depth;

}

class CustomWindowRender extends mint.Renderer {

    override function render<T:Control, T1>( type:Class<T>, control:T ) : T1 {
        return cast switch(type) {
            case mint.Window:       follow(control, new CustomWindow(this, cast control));
            case _:                 null;
        }
    } //render

} //CustomWindowRender
