import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Text;
import luxe.Log.def;

import mint.types.Types;
import mint.Control;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;
import mint.types.Types.Helper.in_rect;

import mint.layout.margins.Margins;

typedef Ctrl = {
    id:Int,
    type:String,
    tag:luxe.Text,
    parent:Null<Int>,
    bounds:luxe.Rectangle,
    vis:phoenix.geometry.RectangleGeometry 
};

class Main extends luxe.Game {

    var ui_batch: phoenix.Batcher;
    var ui_canvas: mint.Canvas;
    var ui_render: LuxeMintRender;
    var editor_canvas: mint.Canvas;
    var editor_render: EditorRendering;

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

        ui_batch = Luxe.renderer.create_batcher({ name:'ui', layer:10 });

        ui_render = new LuxeMintRender({ batcher:ui_batch });
        editor_render = new EditorRendering();

        ui_canvas = new mint.Canvas({ rendering: ui_render, w: Luxe.screen.w, h: Luxe.screen.h });
        editor_canvas = new mint.Canvas({ rendering: editor_render, w: Luxe.screen.w, h: Luxe.screen.h });

        layout = new Margins();

        new luxe.Sprite({ texture:Luxe.resources.texture('assets/960.png'), centered:false, depth:-1 });
        var drag = Luxe.camera.add( new util.CameraDrag({name:'drag'}) );
            drag.zoom_speed = 0.05;

        controls = new Map();
        create_palette();

    } //ready

    var controls: Map<Int, Ctrl>;

    var down_x = 0;
    var down_y = 0;
    var resizing = false;
    var moving = false;
    var rsize = 8;

    function ondown(e:mint.types.MouseEvent,c:mint.Control) {

        editor_canvas.modal = c;

        if( in_rect(e.x, e.y, c.right-rsize, c.bottom-rsize, rsize, rsize) ) {
            resizing = true;
        } else {
            moving = true;
        }

        down_x = Std.int(e.x);
        down_y = Std.int(e.y);
    }

    function onmove(e:mint.types.MouseEvent, c:mint.Control) {
        if(editor_canvas.modal == c) {

            if(moving) {
                c.set_pos(c.x + (e.x - down_x), c.y + (e.y - down_y));
            } else if(resizing) {
                var ww = c.w + (e.x - down_x);
                var hh = c.h + (e.y - down_y);
                var resized = false;
                if(ww >= c.w_min || ww <= c.w_max) { down_x = Std.int(e.x); resized = true; }
                if(hh >= c.h_min || hh <= c.h_max) { down_y = Std.int(e.y); resized = true; }
                if(resized) c.set_size(ww, hh);
            }

            down_x = Std.int(e.x);
            down_y = Std.int(e.y);
        }
    }

    function onup(_,_) {
        editor_canvas.modal = null;
        resizing = false;
        moving = false;
    }

    function duplicate(c:mint.Control) {

        spawn_control(c.name, c.x+16, c.y+16, c.w, c.h );

    } //duplicate

    function spawn_control(type:String, ?_x:Float, ?_y:Float, ?_w:Float, ?_h:Float) {

        def(_x, Luxe.screen.mid.x-128);
        def(_y, Luxe.screen.h-128);
        def(_w, 256);
        def(_h, 64);

        var control = new mint.Panel({
            name:'$type',
            w_min: 16, h_min: 16,
            parent:editor_canvas,
            x:_x, y:_y, w:_w, h:_h
        });

        control.onmousedown.listen(ondown);
        control.onmousemove.listen(onmove);
        control.onmouseup.listen(onup);

    } //spawn_control

    var ed_palette: mint.Window;
    var ed_controls: mint.List;

    function create_palette() {

        ed_palette = new mint.Window({
            parent: ui_canvas,
            x: Luxe.screen.w * 0.05,
            y: Luxe.screen.h * 0.2,
            w: Luxe.screen.w * 0.2,
            h: Luxe.screen.w * 0.4,
            title: 'Controls',
            closable: false,
            moveable: false,
            resizable: false
        });

        ed_controls = new mint.List({
            parent: ed_palette,
            x: 4, y: 30
        });

        layout.margin(ed_controls, right, fixed, 4);
        layout.margin(ed_controls, bottom, fixed, 4);

        var list = [
            'Panel',
            'Label',
            'Button',
            'Image',
            'List',
            'Slider',
            'Scroll',
            'Checkbox',
            'Dropdown',
            'TextEdit',
            'Progress',
            'Window',
        ];

        ed_controls.onselect.listen(function(idx:Int, ctrl:Control, _) {
            spawn_control(list[idx]);
        });

        for(name in list) {
            var label = new mint.Label({
                parent: ui_canvas,
                name: 'palette.$name',
                text: name,
                text_size: 16,
                h: 32,
            });
            ed_controls.add_item(label, 0, 8);
            layout.size(label, width, 100);
        }

    } //create_palette

    override function onwindowsized(event:luxe.Screen.WindowEvent) {

        Luxe.camera.viewport = new luxe.Rectangle(0, 0, Luxe.screen.w, Luxe.screen.h);
        ui_canvas.set_size(Luxe.screen.w, Luxe.screen.h);
        editor_canvas.set_size(Luxe.screen.w, Luxe.screen.h);

    } //onwindowsized

    override function onmousemove(e) {

        if(!moving) ui_canvas.mousemove( Convert.mouse_event(e) );
        editor_canvas.mousemove( Convert.mouse_event(e, Luxe.renderer.batcher.view) );

    }

    override function onmousewheel(e) {

        if(!moving) ui_canvas.mousewheel( Convert.mouse_event(e) );
        if(ui_canvas.focused == null) editor_canvas.mousewheel( Convert.mouse_event(e, Luxe.renderer.batcher.view) );

    }

    override function onmouseup(e) {

        if(!moving) ui_canvas.mouseup( Convert.mouse_event(e) );
        if(ui_canvas.focused == null) editor_canvas.mouseup( Convert.mouse_event(e, Luxe.renderer.batcher.view) );

    }

    override function onmousedown(e) {

        ui_canvas.mousedown( Convert.mouse_event(e) );
        if(ui_canvas.focused == null) editor_canvas.mousedown( Convert.mouse_event(e, Luxe.renderer.batcher.view) );

    } //onmousedown

    override function onkeydown(e:luxe.Input.KeyEvent) {

        ui_canvas.keydown( Convert.key_event(e) );
        editor_canvas.keydown( Convert.key_event(e) );

    } //onkeydown

    override function ontextinput(e:luxe.Input.TextEvent) {

        ui_canvas.textinput( Convert.text_event(e) );
        editor_canvas.textinput( Convert.text_event(e) );

    } //ontextinput

    override function onkeyup(e:luxe.Input.KeyEvent) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
            return;
        }

        if(e.keycode == Key.key_d) {
            if(e.mod.meta || e.mod.ctrl) {
                if(editor_canvas.focused != null) {
                    duplicate(editor_canvas.focused);
                }
            }
        }

        if(e.keycode == Key.delete || e.keycode == Key.backspace) {
            if(editor_canvas.focused != null) {
                editor_canvas.focused.destroy();
                editor_canvas.reset_focus();
            }
        }

        ui_canvas.keyup( Convert.key_event(e) );
        editor_canvas.keyup( Convert.key_event(e) );

    } //onkeyup

    override function onrender() {

        ui_canvas.render();
        editor_canvas.render();

    } //onrender

    override function update(dt:Float) {

        ui_canvas.update(dt);
        editor_canvas.update(dt);

    } //update

} //Main
