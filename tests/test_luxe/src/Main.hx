
import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Text;

import mint.Control;
import mint.types.Types;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;
import mint.layout.margins.Margins;
import mint.focus.Focus;

    //auto canvas helper
import AutoCanvas;

class Main extends luxe.Game {

    var state : luxe.States;
    var current : Int = 0;
    var count : Int = 0;

    public static var disp : Text;
    public static var canvas: mint.Canvas;
    public static var rendering: LuxeMintRender;
    public static var layout: Margins;
    public static var focus: Focus;

    var canvas_debug : Text;
    var debug : Bool = false;

    override function ready() {

        Luxe.renderer.clear_color.rgb(0x121219);

        rendering = new LuxeMintRender();
        layout = new Margins();

        //instead of mint.Canvas,
        //we're using AutoCanvas to automatically bind the luxe events directly
        //without it, it would be like this:
            // var canvas = new mint.Canvas({
            //     name:'canvas',
            //     rendering: rendering,
            //     options: { color:new Color(1,1,1,0.0) },
            //     x: 0, y:0, w: 960, h: 640
            // });

        var _scale = Luxe.screen.device_pixel_ratio;
        var auto_canvas = new AutoCanvas({
            name:'canvas',
            rendering: rendering,
            options: { color:new Color(1,1,1,0.0) },
            scale: _scale,
            x: 0, y:0, w: Luxe.screen.w/_scale, h: Luxe.screen.h/_scale
        });

        trace('canvas scale: $_scale');

        auto_canvas.auto_listen();
        canvas = auto_canvas;
        
            //this is required to handle input focus in the default way
        focus = new Focus(canvas);

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
        state.add( new tests.Focus({ name:'state3' }) );

        count = Lambda.count( state._states );

        state.set( 'state0' );

    } //ready

    function change(to:String) {

        disp.text = '';

        canvas.destroy_children();
        state.set(to);

    } //change

    override function config(config:luxe.GameConfig) {

        config.preload.textures.push({ id:'assets/960.png' });
        config.preload.textures.push({ id:'assets/transparency.png' });
        config.preload.textures.push({ id:'assets/mint.box.png' });
        config.preload.textures.push({ id:'assets/image.png' });

        return config;

    } //config

    override function onrender() {

        if(debug) {
            for(c in canvas.children) {
                drawc(c);
            }
        }

    } //onrender

    override function onmousemove(e) {

        var _me = Convert.mouse_event(e, canvas.scale);
        canvas_mouse_pos = '${_me.x}, ${_me.y} window:${e.x},${e.y}';

        debugtext();

    } //onmousemove

    var canvas_mouse_pos:String = '';

    public function debugtext() {

        var s = 'debug:  (${Luxe.snow.os} / ${Luxe.snow.platform})\n';

        s += 'canvas scale: ' + (canvas != null ? '${canvas.scale}' : '1') + '\n';
        s += 'canvas mouse: $canvas_mouse_pos\n';
        s += 'canvas nodes: ' + (canvas != null ? '${canvas.nodes}' : 'none') + '\n';

        s += 'captured: ' + (canvas.captured != null ? '${canvas.captured.name} [${canvas.captured.nodes}]' : 'none');
        s += (canvas.captured != null ? ' / depth: '+canvas.captured.depth : '');
        s += '\n';
        s += 'marked: ' + (canvas.marked != null ?  canvas.marked.name : 'none');
        s += '\n';
        s += 'focused: ' + (canvas.focused != null ? canvas.focused.name : 'none');
        s += '\n\n';

        canvas_debug.text = s;

    }

    override function onkeyup(e:luxe.Input.KeyEvent) {

        if(e.keycode == Key.key_6) {
            canvas.scale -= 0.1; 
        }

        if(e.keycode == Key.key_7) {
            canvas.scale += 0.1; 
        }

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

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

        debugtext();

    } //onkeyup

    function drawc(control:Control) {

        if(!control.visible) return;

        Luxe.draw.rectangle({
            depth: 1000,
            x: canvas.scale * control.x,
            y: canvas.scale * control.y,
            w: canvas.scale * control.w,
            h: canvas.scale * control.h,
            color: new Color(1,0,0,0.5),
            immediate: true
        });

        for(c in control.children) {
            drawc(c);
        }

    } //drawc

} //Main

