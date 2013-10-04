
import luxe.Color;
import luxe.Rectangle;
import luxe.Text;
import luxe.Vector;
import luxe.Input;
import luxe.Sprite;

import phoenix.BitmapFont.TextAlign;
import phoenix.Rectangle;

import minterface.MITypes;
import minterface.MIControl;
import minterface.MICanvas;
import minterface.MIButton;
import minterface.MIImage;
import minterface.MIScrollArea;
import minterface.MIList;
import minterface.MIWindow;
import minterface.MIDropdown;
import minterface.MIPanel;
import minterface.MICheckbox;
import minterface.MINumber;

import MILuxeRenderer;

class Main extends luxe.Game {

    public var renderer : MILuxeRenderer;

    public var canvas : MICanvas;
    public var button : MIButton;
    public var button1 : MIButton;
    public var image : MIImage;
    public var scroller : MIScrollArea;
    public var scroller1 : MIScrollArea;
    public var itemlist : MIList;
    public var window : MIWindow;
    public var selector : MIDropdown;
    public var selector2 : MIDropdown;
    public var panel : MIPanel;
    public var panel2 : MIPanel;
    public var number : MINumber;

    var s : Sprite;

    public function ready() {
        
        Luxe.renderer.clear_color.set(1,1,1);

        renderer = new MILuxeRenderer();

        canvas  = new MICanvas({
            bounds : new MIRectangle( 0, 0, Luxe.screen.w, Luxe.screen.h ),
            renderer : renderer,
            depth : 100
        });

        button = new MIButton({
            parent : canvas,
            name : 'click',
            bounds : new MIRectangle( 10, 60, 100, 35 ),
            text : 'click me',
            text_size : 15,
            onclick : function(){ trace('hello world'); }
        });

        itemlist = new MIList({
            parent : canvas,
            name : 'list1',
            bounds : new MIRectangle(10, 100, 100,380)
        });

        itemlist.add_item('items one');     
        itemlist.add_items(['item','blah','some more','longer item','short','when do','iam','one','two','three','four','five','six','seven','eight','nine']);

        scroller = new MIScrollArea({
            parent : canvas,
            name : 'scrollarea',
            bounds : new MIRectangle( 120, 60, 300, 360 )
        });        


        var tt = Luxe.loadTexture('assets/image.png');

        tt.onload = function(t_) {

            scroller1 = new MIScrollArea({
                parent : canvas,
                name : 'scrollarea1',
                bounds : new MIRectangle( 430, 60, 300, 360 )
            });

            image = new MIImage({
                parent : scroller1,
                name : 'image',
                bounds : new MIRectangle( 0, 0, 1280, 720 ),
                texture : tt
            });

            scroller1.scrolly(-180);

            window = new MIWindow({
                parent : canvas,
                name : 'builder',
                title : 'Export Build',
                title_size : 15,
                bounds : new MIRectangle(750, 70, 200, 300)
            });

            button1 = new MIButton({
                parent : window,
                name : 'buildbutton',
                bounds : new MIRectangle( 20, 245, 160, 35 ),
                text : 'Make Build',
                text_size : 15,
                onclick : function(){ trace('FAKE build'); }
            });

            selector = new MIDropdown({
                parent : window,
                name : 'selector',
                bounds : new MIRectangle( 20, 40, 160, 30 ),
                text : 'Select output target'
            });

            selector2 = new MIDropdown({
                parent : window,
                name : 'selector2',
                bounds : new MIRectangle( 20, 80, 160, 30 ),
                text : 'Select build format'
            });

            selector.add_items(['Mac', 'Windows', 'Linux', 'HTML5', 'Android', 'iOS']);
            selector2.add_items(['zip', 'folder']);            
        }        

        for(i in 0 ... 5) {
            var l = new MIButton({
                parent : scroller,
                name : 'button' + (i+1),
                bounds : new MIRectangle(50, i * 100, 100, 100 ),
                text : 'click me + '+ (i+1),
                text_size : 18,
                onclick : function(){ trace('click me + '+ (i+1)); }
            });
        }

        

        panel = new MIPanel({
            parent : canvas,
            name : 'panel',
            bounds : new MIRectangle(0, 0, canvas.bounds.w, 48)
        });

        panel2 = new MIPanel({
            parent : canvas,
            name : 'panel2',
            bar : 'top',
            bounds : new MIRectangle(0, canvas.bounds.h-20, canvas.bounds.w, 20)
        });

        number = new MINumber({
            parent : window,
            name : 'number',
            bounds : new MIRectangle( 20, 140, 160, 30 ),
            value : 0.0
        });

    } //ready
    
    public function onmousemove(e) {
        var _e = LuxeMIConverter.mouse_event(e);
        canvas.onmousemove(_e);
    }

    public function onmouseup(e) {
        var _e = LuxeMIConverter.mouse_event(e);
        canvas.onmouseup(_e);
    }

    public function onmousedown(e) {
        var _e = LuxeMIConverter.mouse_event(e);
        canvas.onmousedown(_e);
    }

    public function onkeyup(e) {
        if(e.value == Input.Keys.escape) {
            Luxe.shutdown();
        }
    } //onkeyup

    public function update(dt:Float) {
        canvas.update(dt);
    } //update

    public function shutdown() {

    } //shutdown
}


