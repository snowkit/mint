
import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Text;

import mint.Control;
import mint.types.Types;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;
import mint.layout.margins.Margins;

class Main extends luxe.Game {

    var state : luxe.States;
    var current : Int = 0;
    var count : Int = 0;

    public static var disp : Text;
    public static var canvas: mint.Canvas;
    public static var rendering: LuxeMintRender;
    public static var layout: Margins;

    var canvas_debug : Text;
    var debug : Bool = false;

    override function ready() {

        Luxe.renderer.clear_color.rgb(0x121219);

        rendering = new LuxeMintRender();
        layout = new Margins();

        canvas = new mint.Canvas({
            name:'canvas',
            rendering: rendering,
            options: { color:new Color(1,1,1,0.0) },
            x: 0, y:0, w: 960, h: 640
        });

        disp = new Text({
            name:'display.text',
            pos: new Vector(Luxe.screen.w-10, Luxe.screen.h-10),
            align: luxe.TextAlign.right,
            align_vertical: luxe.TextAlign.bottom,
            point_size: 15,
            text: 'usage text goes here'
        });

        canvas_debug = new Text({
            name:'debug.text',
            text: 'debug:  (${Luxe.snow.os} / ${Luxe.snow.platform})',
            point_size: 14,
            pos: new Vector(950, 10),
            align: right,
            depth: 999,
            color: new Color()
        });

        state = new luxe.States();

        state.add( new tests.KitchenSink({ name:'state0' }) );
        state.add( new tests.Scrolling({ name:'state1' }) );
        state.add( new tests.Depth({ name:'state2' }) );

        count = Lambda.count( state._states );

        state.set( 'state0' );

    } //ready

    function change(to:String) {

        disp.text = '';

        canvas.destroy_children();
        state.set(to);

    } //change

    override function config(config:luxe.AppConfig) {

        config.preload.textures.push({ id:'assets/960.png' });
        config.preload.textures.push({ id:'assets/transparency.png' });
        config.preload.textures.push({ id:'assets/mint.box.png' });

        return config;

    } //config

    override function onrender() {

        canvas.render();

        if(debug) {
            for(c in canvas.children) {
                drawc(c);
            }
        }

    } //onrender

    override function update(dt:Float) {

        canvas.update(dt);

    } //update

    override function onmousemove(e) {

        canvas.mousemove( Convert.mouse_event(e) );

        var s = 'debug:  (${Luxe.snow.os} / ${Luxe.snow.platform})\n';

        s += 'canvas nodes: ' + (canvas != null ? '${canvas.nodes}' : 'none');
        s += '\n';
        s += 'focused: ' + (canvas.focused != null ? '${canvas.focused.name} [${canvas.focused.nodes}]' : 'none');
        s += (canvas.focused != null ? ' / depth: '+canvas.focused.depth : '');
        s += '\n';
        s += 'modal: ' + (canvas.modal != null ?  canvas.modal.name : 'none');
        s += '\n';
        s += 'dragged: ' + (canvas.dragged != null ? canvas.dragged.name : 'none');
        s += '\n\n';

        canvas_debug.text = s;

    } //onmousemove

    override function onmousewheel(e) {
        canvas.mousewheel( Convert.mouse_event(e) );
    }

    override function onmouseup(e) {
        canvas.mouseup( Convert.mouse_event(e) );
    }

    override function onmousedown(e) {
        canvas.mousedown( Convert.mouse_event(e) );
    }

    override function onkeydown(e:luxe.Input.KeyEvent) {
        canvas.keydown( Convert.key_event(e) );
    }

    override function ontextinput(e:luxe.Input.TextEvent) {
        canvas.textinput( Convert.text_event(e) );
    }


    override function onkeyup(e:luxe.Input.KeyEvent) {

        if(e.keycode == Key.key_d && e.mod.ctrl) { debug = !debug; trace('debug: $debug'); }
        if(e.keycode == Key.key_v && e.mod.ctrl) canvas.visible = !canvas.visible;

        if(e.keycode == Key.key_9) {
            current--;
            if(current < 0) current = count-1;
            change('state$current');
        }

        if(e.keycode == Key.key_0) {
            current++;
            if(current >= count) current = 0;
            change('state$current');
        }

        canvas.keyup( Convert.key_event(e) );

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

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

} //Main

