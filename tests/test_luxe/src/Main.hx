
import luxe.Color;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Input;
import luxe.Sprite;

import phoenix.BitmapFont.TextAlign;
import phoenix.Rectangle;

import mint.Types;
import mint.Control;
import mint.Canvas;
import mint.Button;
import mint.Image;
import mint.ScrollArea;
import mint.List;
import mint.Window;
import mint.Dropdown;
import mint.Panel;
import mint.Checkbox;
import mint.Number;

import mint.renderer.LuxeRenderer;


class Main extends luxe.Game {

    public var renderer : LuxeRenderer;

    public var canvas : Canvas;
    public var button : Button;
    public var button1 : Button;
    public var image : Image;
    public var scroller : ScrollArea;
    public var scroller1 : ScrollArea;
    public var itemlist : List;
    public var window1 : Window;
    public var window : Window;
    public var selector : Dropdown;
    public var selector2 : Dropdown;
    public var panel : Panel;
    public var panel2 : Panel;
    public var number : Number;

    var s : Sprite;

    override function ready() {

        Luxe.renderer.clear_color.set(1,1,1);

        renderer = new LuxeRenderer();

        canvas  = new Canvas({
            bounds : new Rectangle( 0, 0, Luxe.screen.w, Luxe.screen.h ),
            renderer : renderer,
            depth : 100
        });

        button = new Button({
            parent : canvas,
            name : 'click',
            bounds : new Rectangle( 10, 60, 100, 35 ),
            text : 'click me',
            text_size : 15,
            onclick : function(){ trace('hello world'); }
        });

        itemlist = new List({
            parent : canvas,
            name : 'list1',
            bounds : new Rectangle(10, 100, 100,380)
        });

        itemlist.add_item('items one');
        itemlist.add_items(['item','blah','some more','longer item','short','when do','iam','one','two','three','four','five','six','seven','eight','nine']);

        var tt = Luxe.loadTexture('assets/image.png');

        tt.onload = function(t_) {

            window1 = new Window({
                parent : canvas,
                name : 'image view',
                title : 'Image view',
                title_size : 13,
                bounds : new Rectangle(430, 60, 300, 360)
            });

            scroller1 = new ScrollArea({
                parent : window1,
                name : 'scrollarea1',
                bounds : new Rectangle( 10, 40, 280, 300 )
            });

            image = new Image({
                parent : scroller1,
                name : 'image',
                bounds : new Rectangle( 0, 0, tt.width, tt.height ),
                texture : tt
            });

            window = new Window({
                parent : canvas,
                name : 'builder',
                title : 'Export Build',
                title_size : 13,
                bounds : new Rectangle(750, 70, 200, 300)
            });

            button1 = new Button({
                parent : window,
                name : 'buildbutton',
                bounds : new Rectangle( 20, 245, 160, 35 ),
                text : 'Make Build',
                text_size : 13,
                onclick : function(){ trace('FAKE build'); }
            });

            selector = new Dropdown({
                parent : window,
                name : 'selector',
                bounds : new Rectangle( 20, 40, 160, 30 ),
                text : 'Select output target'
            });

            selector2 = new Dropdown({
                parent : window,
                name : 'selector2',
                bounds : new Rectangle( 20, 80, 160, 30 ),
                text : 'Select build format'
            });

            selector.add_items(['Mac', 'Windows', 'Linux', 'HTML5', 'Android', 'iOS']);
            selector2.add_items(['zip', 'folder']);

             number = new Number({
                parent : window,
                name : 'number',
                bounds : new Rectangle( 20, 140, 160, 30 ),
                value : 0.0
            });
        }

        scroller = new ScrollArea({
            parent : canvas,
            name : 'scrollarea',
            bounds : new Rectangle( 120, 60, 300, 360 )
        });

        for(i in 0 ... 5) {
            var l = new Button({
                parent : scroller,
                name : 'button' + (i+1),
                bounds : new Rectangle(50, i * 100, 100, 100 ),
                text : 'click me + '+ (i+1),
                text_size : 15,
                onclick : function(){ trace('click me + '+ (i+1)); }
            });
        }

        panel = new Panel({
            parent : canvas,
            name : 'panel',
            bounds : new Rectangle(0, 0, canvas.bounds.w, 48)
        });

        panel2 = new Panel({
            parent : canvas,
            name : 'panel2',
            bar : 'top',
            bounds : new Rectangle(0, canvas.bounds.h-20, canvas.bounds.w, 20)
        });

       

    } //ready

    override function onmousemove(e) {
        var _e = Convert.mouse_event(e);
        canvas.onmousemove(_e);
    }

    override function onmousewheel(e) {
        var _e = Convert.mouse_event(e);
        canvas.onmousewheel(_e);
    }

    override function onmouseup(e) {
        var _e = Convert.mouse_event(e);
        canvas.onmouseup(_e);
    }

    override function onmousedown(e) {
        var _e = Convert.mouse_event(e);
        canvas.onmousedown(_e);
    }

    override function onkeyup(e:KeyEvent) {

        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    } //onkeyup

    override function update(dt:Float) {
        canvas.update(dt);
    } //update

    override function ondestroy() {

    } //shutdown
}


