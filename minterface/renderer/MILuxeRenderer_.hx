package minterface.renderer;

import minterface.MIRenderer;

import minterface.MIControl;
import minterface.MILabel;
import minterface.MICanvas;
import minterface.MIButton;
import minterface.MIList;
import minterface.MIScrollArea;
import minterface.MIImage;
import minterface.MIWindow;
import minterface.MIDropdown;
import minterface.MIPanel;
import minterface.MICheckbox;
import minterface.MINumber;

import minterface.MITypes;

import luxe.Text;
import luxe.Color;
import luxe.Vector;
import luxe.Sprite;
import luxe.Input;
import luxe.Rectangle;

import phoenix.geometry.Geometry;
import phoenix.geometry.QuadGeometry;
import phoenix.geometry.RectangleGeometry;

import luxe.NineSlice;


//temp copy paste base
// class MIREPLACEMELuxeRenderer extends MIREPLACEMERenderer {
//  public override function init( _control:MIREPLACEME, _options:Dynamic ) { } //init
//  public override function translate( _control:MIREPLACEME, _x:Float, _y:Float ) { } //translate, ?_offset:Bool = false
//  public override function set_clip( _control:MIREPLACEME, ?_clip_rect:Rectangle=null ) { } //set_clip
// } //MIREPLACEMELuxeRenderer

class LuxeMIConverter {
    public static function text_align( _align:MITextAlign ) : TextAlign {

        if(_align == null) {
           throw "align passed in as null";
        }

        switch(_align) {
            case MITextAlign.left:
                return TextAlign.left;

            case MITextAlign.right:
                return TextAlign.right;

            case MITextAlign.center:
                return TextAlign.center;

            case MITextAlign.top:
                return TextAlign.top;

            case MITextAlign.bottom:
                return TextAlign.bottom;
        }

        return TextAlign.left;

    } //text_align

    public static function rectangle( _rect:MIRectangle ) : Rectangle {
        if(_rect == null){ throw "Rectangle passed in as null"; }
        return new Rectangle( _rect.x, _rect.y, _rect.w, _rect.h );
    } //rectangle

    public static function vector( _point:MIPoint ) : Vector {
        if(_point == null){ throw "Point passed in as null"; }
        return new Vector( _point.x, _point.y );
    } //vector

/*
    unknown;
    none;
    down;
    up;
    move;
    wheel;
    axis;
*/
    public static function interact_state( _state:InteractState ) : MIInteractState {
        switch(_state) {
            case InteractState.unknown:
                return MIInteractState.unknown;
            case InteractState.none:
                return MIInteractState.none;
            case InteractState.down:
                return MIInteractState.down;
            case InteractState.up:
                return MIInteractState.up;
            case InteractState.move:
                return MIInteractState.move;
            case InteractState.wheel:
                return MIInteractState.wheel;
            case InteractState.axis:
                return MIInteractState.axis;
        } //state
    } //interact_state

    public static function mouse_button( _button:MouseButton ) : MIMouseButton {
        switch(_button) {
            case MouseButton.none:
                return MIMouseButton.none;
            case MouseButton.left:
                return MIMouseButton.left;
            case MouseButton.middle:
                return MIMouseButton.middle;
            case MouseButton.right:
                return MIMouseButton.right;
            case MouseButton.extra1:
                return MIMouseButton.extra1;
            case MouseButton.extra2:
                return MIMouseButton.extra2;
        } //state
    } //mouse_button

    public static function mouse_event( _event:MouseEvent ) : MIMouseEvent {
        return {
            state : interact_state(_event.state),
            button : mouse_button(_event.button),
            window_id : _event.window_id,
            timestamp : _event.timestamp,
            x : _event.x,
            y : _event.y,
            xrel : _event.xrel,
            yrel : _event.yrel,
            bubble : true
        };
    } //mouse_event

}

class MILuxeRenderer extends MIRenderer {

    public var batcher:phoenix.Batcher;

    public function new( ?_batcher:phoenix.Batcher ) {

        if(_batcher != null) {
            batcher = _batcher;
        } else {
            batcher = Luxe.renderer.batcher;
        }

        super();

        canvas = new MICanvasLuxeRenderer();
        label = new MILabelLuxeRenderer();
        button = new MIButtonLuxeRenderer();
        list = new MIListLuxeRenderer();
        scroll = new MIScrollAreaLuxeRenderer();
        image = new MIImageLuxeRenderer();
        window = new MIWindowLuxeRenderer();
        dropdown = new MIDropdownLuxeRenderer();
        panel = new MIPanelLuxeRenderer();
        checkbox = new MICheckboxLuxeRenderer();

    } //new

} //MIRenderer

class MICanvasLuxeRenderer extends MICanvasRenderer {

    var back : QuadGeometry;

    public override function init( _control:MICanvas, _options:Dynamic ) {

        back = new QuadGeometry({
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x0c0c0c),
            depth : _control.depth,
            batcher : Luxe.renderer.batcher
        });

        // back.texture = Luxe.loadTexture('assets/transparency.png');
        // back.uv(new Rectangle(0,0,960,640));

        back.id = _control.name + '.back';

    } //init

    public override function set_visible( _control:MICanvas, ?_visible:Bool=true ) {

        back.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MICanvas, ?_depth:Float=0.0 ) {

        // back.depth = _depth;

    } //set_depth

} //MICanvasLuxeRenderer

class MILabelLuxeRenderer extends MILabelRenderer {

    var text:Text;

    public override function init( _control:MILabel, _options:Dynamic ) {

        if(_options.bounds != null) {
            _options.bounds = LuxeMIConverter.rectangle( _options.bounds );
        }

        if(_options.pos != null) {
            _options.pos = LuxeMIConverter.vector( _options.pos );
        }

                    //store the old parent as Sprite will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

            //if there is padding, we change the bounds
        if( _options.padding.x != 0 ) { _options.bounds.x += _options.padding.x; }
        if( _options.padding.y != 0 ) { _options.bounds.y += _options.padding.y; }
        if( _options.padding.w != 0 ) { _options.bounds.w -= _options.padding.w*2; }
        if( _options.padding.h != 0 ) { _options.bounds.h -= _options.padding.h*2; }

        if( _options.align != null) {
            _options.align = LuxeMIConverter.text_align( _options.align );
        }

        if( _options.align_vertical != null) {
            _options.align_vertical = LuxeMIConverter.text_align( _options.align_vertical );
        }

        _options.color = new Color(0,0,0,1).rgb(0x999999);

        // _options.batcher = _control.renderer.batcher;

        text = new Text( _options );

        // var bounds = Luxe.draw.rectangle({
        //     color:_control.debug_color,
        //     depth: 200,
        //     x:_control.real_bounds.x,
        //     y:_control.real_bounds.y,
        //     w:_control.real_bounds.w,
        //     h:_control.real_bounds.h,
        // });

        _options.parent = _oldp;

    } //init

    public override function translate( _control:MILabel, _x:Float, _y:Float, ?_offset:Bool = false ) {

        text.pos = new Vector( text.pos.x + _x, text.pos.y + _y );

        // bounds.pos = new Vector( bounds.pos.x + _x, bounds.pos.y + _y );

    } //translate

    public override function set_clip( _control:MILabel, ?_clip_rect : MIRectangle = null ) {

        if(_clip_rect == null) {
            text.geometry.clip_rect = null;
        } else {
            if(text != null && text.geometry != null) {
                text.geometry.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
            }
        }

    } //set clip

    public override function set_visible( _control:MILabel, ?_visible:Bool=true ) {

        text.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MILabel, ?_depth:Float=0.0 ) {

        if(text != null) {
            text.depth = _depth;
        }

    } //set_depth

    public override function set_text( _control:MILabel, ?_text:String='label' ) {

        if(text != null) {
            text.text_options.bounds = LuxeMIConverter.rectangle( _control.real_bounds );
            text.text = _text;
            text.depth = _control.depth+0.1;
        }

    } //set_text

    public override function destroy( _control:MILabel ) {

        text.destroy();
        text = null;

    } //destroy

} //MILabelLuxeRenderer

class MIButtonLuxeRenderer extends MIButtonRenderer {

    var geom : NineSlice;

    public override function init( _control:MIButton, _options:Dynamic ) {


            //store the old parent as NineSlice will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

        geom = new NineSlice({
            texture : Luxe.loadTexture('tiny.button.png'),
            depth : _control.depth,
            top : 8, left : 8, right : 8, bottom : 8,
        });

        geom.pos = new Vector( _control.real_bounds.x, _control.real_bounds.y );
        geom.create( new Vector( _control.real_bounds.x, _control.real_bounds.y), _control.real_bounds.w, _control.real_bounds.h );

        geom.color = new Color(1,1,1,1);

        geom._geometry.id = _control.name + '.button';

        _options.parent = _oldp;

    } //init

    public override function translate( _control:MIButton, _x:Float, _y:Float, ?_offset:Bool = false ) {

        geom.pos = new Vector( geom.transform.pos.x + _x, geom.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:MIButton, ?_clip_rect:MIRectangle=null ) {

        if(_clip_rect == null) {
            geom.clip_rect = null;
        } else {
            if(geom != null) {
                geom.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
            }
        }

    } //set_clip


    public override function set_visible( _control:MIButton, ?_visible:Bool=true ) {

        geom.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MIButton, ?_depth:Float=0.0 ) {

        if(geom != null) {
            geom.depth = _depth;
        }

    } //set_depth

} //MIButtonLuxeRenderer

class MIListLuxeRenderer extends MIListRenderer {

    var _existing_selections : Array<QuadGeometry>;

    public override function init( _control:MIList, _options:Dynamic ) {
        _existing_selections = [];
    } //init

    public override function translate( _control:MIList, _x:Float, _y:Float, ?_offset:Bool = false ) {
        if(_control.multiselect) {
            for(_geom in _existing_selections) {
                _geom.transform.pos = new Vector(_geom.transform.pos.x + _x, _geom.transform.pos.y + _y);
                if(_geom.clip_rect != null) {
                    _geom.clip_rect.x = _control.clip_rect.x;
                    _geom.clip_rect.y = _control.clip_rect.y;
                    _geom.clip_rect.w = _control.clip_rect.w;
                    _geom.clip_rect.h = _control.clip_rect.h;
                }
            }
        } else {

            if(_existing_selections.length > 0) {

                var _select : QuadGeometry = _existing_selections[0];
                    _select.transform.pos = new Vector(_select.transform.pos.x + _x, _select.transform.pos.y + _y);
                    if(_select.clip_rect != null) {
                        _select.clip_rect.x = _select.clip_rect.x + _x;
                        _select.clip_rect.y = _select.clip_rect.y + _y;
                    }

            } //existing selections

        }

    } //translate

    public override function set_clip( _control:MIList, ?_clip_rect:MIRectangle=null ) {

    } //set_clip

    public override function scroll(_control:MIList, _x:Float, _y:Float) {

        for(_geom in _existing_selections) {
            _geom.transform.pos = new Vector(_geom.transform.pos.x + _x, _geom.transform.pos.y + _y);
        }

    } //

    public override function select_item( _control:MIList, _selected:MIControl ) {

        if(_existing_selections == null) {
            _existing_selections = [];
        }

        if(_selected == null) {

            for(_select in _existing_selections) {
                _select.drop();
            }

            _existing_selections = null;
            _existing_selections = [];

            return;

        } //deselected

        if(!_control.multiselect) {

            //normal single select

            if(_existing_selections.length == 0) {

                var _geom = new QuadGeometry({
                    depth : _control.view.depth+0.001,
                    x: _selected.real_bounds.x,
                    y: _selected.real_bounds.y,
                    w: _selected.real_bounds.w,
                    h: _selected.real_bounds.h,
                    color : new Color().rgb(0x262626),
                    batcher : Luxe.renderer.batcher
                });

                _geom.clip_rect = new Rectangle( _control.real_bounds.x, _control.real_bounds.y, _control.real_bounds.w-1, _control.real_bounds.h-1 );

                _existing_selections.push(_geom);

            } else {

                var _select : QuadGeometry = _existing_selections[0];
                    _select.transform.pos = new Vector(_selected.real_bounds.x, _selected.real_bounds.y);

            }

        } else {

            if(_selected == null) {

                for(_geom in _existing_selections) {
                    _geom.drop();
                    _geom = null;
                } //for each

                _existing_selections = null;
                _existing_selections = [];

            } else { //if disabling all selections

                var _geom = new QuadGeometry({
                    depth : _control.view.depth+0.001,
                    x: _selected.real_bounds.x,
                    y: _selected.real_bounds.y,
                    w: _selected.real_bounds.w,
                    h: _selected.real_bounds.h,
                    color : new Color().rgb(0x262626),
                    batcher : Luxe.renderer.batcher
                });

                _geom.clip_rect = new Rectangle( _control.real_bounds.x, _control.real_bounds.y, _control.real_bounds.w, _control.real_bounds.h );

                _existing_selections.push(_geom);

            } //if not

        } //multiselect

    } //select item

    public override function set_visible( _control:MIList, ?_visible:Bool=true ) {

        for(_select in _existing_selections) {
            _select.visible = _visible;
        }

    } //set_visible

    public override function set_depth( _control:MIList, ?_depth:Float=0.0 ) {

        if(_existing_selections != null) {
            for(_select in _existing_selections) {
                _select.depth = _control.view.depth+0.001;
            }
        }

    } //set_depth

} //MIListLuxeRenderer


class MIScrollAreaLuxeRenderer extends MIScrollAreaRenderer {

    var back : QuadGeometry;
    var box : RectangleGeometry;
    var sliderv : QuadGeometry;
    var sliderh : QuadGeometry;

    public override function init( _control:MIScrollArea, _options:Dynamic ) {

        back = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x0d0d0d),
            batcher : Luxe.renderer.batcher
        });

        box = Luxe.draw.rectangle({
            depth : _control.depth+(0.01+_control.children.length*0.001),
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x181818),
            batcher : Luxe.renderer.batcher
        });

        sliderv = new QuadGeometry({
            depth : _control.depth+(0.01+_control.children.length*0.001),
            x: (_control.real_bounds.x+_control.real_bounds.w - 4),
            y: _control.real_bounds.y + ((_control.real_bounds.h-10) * _control.scroll_percent.y),
            w: 3,
            h: 10,
            color : new Color().rgb(0x999999),
            visible : false,
            batcher : Luxe.renderer.batcher
        });

        sliderh = new QuadGeometry({
            depth : _control.depth+(0.01+_control.children.length*0.001),
            x: _control.real_bounds.x + ((_control.real_bounds.w-10) * _control.scroll_percent.x),
            y: (_control.real_bounds.y+_control.real_bounds.h - 4),
            w: 10,
            h: 3,
            color : new Color().rgb(0x999999),
            visible : false,
            batcher : Luxe.renderer.batcher
        });

        back.id = _control.name + '.back';
        box.id = _control.name + '.box';
        sliderh.id = _control.name + '.sliderh';
        sliderv.id = _control.name + '.sliderv';

    } //init

    public override function get_handle_bounds( _control:minterface.MIScrollArea, ?vertical:Bool=true ) : MIRectangle {

        var res : MIRectangle = null;

        if(vertical) {
            res = new MIRectangle( sliderv.transform.pos.x, sliderv.transform.pos.y, 5, 10 );
        } else {
            res = new MIRectangle( sliderh.transform.pos.x, sliderh.transform.pos.y, 10, 5 );
        }

        return res;

    } //get_handle_size

    public override function translate( _control:MIScrollArea, _x:Float, _y:Float, ?_offset:Bool = false ) {

        back.transform.pos = new Vector( back.transform.pos.x + _x, back.transform.pos.y + _y );
        box.transform.pos = new Vector( box.transform.pos.x + _x, box.transform.pos.y + _y );
        sliderh.transform.pos = new Vector( sliderh.transform.pos.x + _x, sliderh.transform.pos.y + _y );
        sliderv.transform.pos = new Vector( sliderv.transform.pos.x + _x, sliderv.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:MIScrollArea, ?_clip_rect:MIRectangle=null ) {


    } //set_clip

    public override function refresh_scroll( _control:MIScrollArea, shx:Float, shy:Float, svx:Float, svy:Float, hv:Bool, vv:Bool ) {

        sliderh.transform.pos = new Vector( shx, shy );
        sliderv.transform.pos = new Vector( svx, svy );

        sliderh.visible = hv;
        sliderv.visible = vv;
    }


    public override function set_visible( _control:MIScrollArea, ?_visible:Bool=true ) {

            back.visible = _visible;
            box.visible = _visible;
            sliderh.visible = _visible;
            sliderv.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MIScrollArea, ?_depth:Float=0.0 ) {

        if(back == null) {
            return;
        }

        back.depth = _depth;

        box.depth = _depth+(0.001+_control.children.length*0.001);
        sliderh.depth = _depth+(0.001+_control.children.length*0.001);
        sliderv.depth = _depth+(0.001+_control.children.length*0.001);

    } //set_depth

} //MIScrollAreaLuxeRenderer

class MIImageLuxeRenderer extends MIImageRenderer {

    var image : Sprite;

    public override function init( _control:MIImage, _options:Dynamic ) {

        if(_options.pos != null) {
            _options.pos = LuxeMIConverter.vector( _options.pos );
        }

        if(_options.size != null) {
            _options.size = LuxeMIConverter.vector( _options.size );
        }

            //store the old parent as Sprite will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

            //create the image
        image = new Sprite(_options);
            //clip the geometry
        set_clip( _control, _control.parent.real_bounds );
            //reassign
        _options.parent = _oldp;

        // image.geometry.id = _control.name + '.image';

    } //init

    public override function translate( _control:MIImage, _x:Float, _y:Float, ?_offset:Bool = false ) {

            image.pos = image.pos.add( new Vector(_x,_y) );

            if(image.geometry.clip) {
                image.geometry.clip_rect.x = _control.clip_rect.x;
                image.geometry.clip_rect.y = _control.clip_rect.y;
                image.geometry.clip_rect.w = _control.clip_rect.w;
                image.geometry.clip_rect.h = _control.clip_rect.h;
            }

    } //translate

    public override function set_clip( _control:MIImage, ?_clip_rect:MIRectangle=null ) {

        if(image.texture != null && image.texture.loaded) {

            if(_clip_rect == null) {
                image.geometry.clip_rect = null;
            } else {
                image.geometry.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w-1,_clip_rect.h-1);
            }

        }

    } //set_clip


    public override function set_visible( _control:MIImage, ?_visible:Bool=true ) {

        if(image != null) {
            image.visible = _visible;
        }

    } //set_visible

    public override function set_depth( _control:MIImage, ?_depth:Float=0.0 ) {

        if(image != null) {
            image.depth = _depth;
        }

    } //set_depth

    public override function destroy( _control:MIImage ) {

        if(image != null) {
            image.destroy();
        }

        image = null;

    } //destroy


} //MIImageLuxeRenderer

class MIWindowLuxeRenderer extends MIWindowRenderer {

    var geom : NineSlice;

    public override function init( _control:MIWindow, _options:Dynamic ) {


            //store the old parent as Sprite will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

        geom = new NineSlice({
            texture : Luxe.loadTexture('tiny.ui.png'),
            depth : _control.depth,
            top : 32, left : 32, right : 32, bottom : 32,
        });

        geom.pos = new Vector( _control.real_bounds.x, _control.real_bounds.y );
        geom.create( new Vector( _control.real_bounds.x, _control.real_bounds.y ), _control.real_bounds.w, _control.real_bounds.h );

        _options.depth = _control.depth;

        geom.color = new Color(1,1,1,1);

        geom._geometry.id = _control.name + '.window';

        _options.parent = _oldp;

    } //init

    public override function translate( _control:MIWindow, _x:Float, _y:Float, ?_offset:Bool = false ) {

        geom.pos = new Vector( geom.pos.x + _x, geom.pos.y + _y );

    } //translate

    public override function set_clip( _control:MIWindow, ?_clip_rect:MIRectangle=null ) {

    } //set_clip

    public override function set_visible( _control:MIWindow, ?_visible:Bool=true ) {

        geom.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MIWindow, ?_depth:Float=0.0 ) {

        if(geom != null) {
            geom.depth = _depth;
        }

    } //set_depth

} //MIWindowLuxeRenderer

class MIDropdownLuxeRenderer extends MIDropdownRenderer {

    var back : QuadGeometry;

    public override function init( _control:MIDropdown, _options:Dynamic ) {

        back = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x0d0d0d),
            batcher : Luxe.renderer.batcher
        });

    } //init

    public override function translate( _control:MIDropdown, _x:Float, _y:Float, ?_offset:Bool = false ) {

        back.transform.pos = new Vector( back.transform.pos.x + _x, back.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:MIDropdown, ?_clip_rect:MIRectangle=null ) {

    } //set_clip

    public override function set_visible( _control:MIDropdown, ?_visible:Bool=true ) {

        back.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MIDropdown, ?_depth:Float=0.0 ) {

        if(back != null) {
            back.depth = _depth;
        }

    } //set_depth


} //MIDropdownLuxeRenderer

class MIPanelLuxeRenderer extends MIPanelRenderer {

    var geom : NineSlice;
    var bar : QuadGeometry;

    public override function init( _control:MIPanel, _options:Dynamic ) {

                    //store the old parent as Sprite will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

        geom = new NineSlice({
            texture : Luxe.loadTexture('tiny.ui.png'),
            depth : _control.depth,
            top : 4, left : 16, right : 16, bottom : 16,
            source_x : 6, source_y : 108, source_w : 64, source_h : 14
        });

        geom.transform.pos = new Vector( _control.real_bounds.x, _control.real_bounds.y );
        geom.create( new Vector( _control.real_bounds.x, _control.real_bounds.y), _control.real_bounds.w, _control.real_bounds.h );

        geom.color = new Color(1,1,1,1);

        geom._geometry.id = _control.name + '.button';

        // 090909

        var bary = _control.real_bounds.y + _control.real_bounds.h;

        if(_options.bar != null) {
            if(_options.bar == 'top') {
                bary = _control.real_bounds.y-3;
            }
        }

        bar = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x, y: bary,
            w: _control.real_bounds.w, h: 3,
            color : new Color(1,1,1,1).rgb(0x030303),
            batcher : Luxe.renderer.batcher
        });

        _options.parent = _oldp;

    } //init

    public override function translate( _control:MIPanel, _x:Float, _y:Float, ?_offset:Bool = false ) {

        geom.pos = new Vector( geom.pos.x + _x, geom.pos.y + _y );
        bar.transform.pos = new Vector( bar.transform.pos.x + _x, bar.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:MIPanel, ?_clip_rect:MIRectangle=null ) {

        if(_clip_rect == null) {
            geom.clip_rect = null;
            bar.clip_rect = null;
        } else {
            if(geom != null) {
                geom.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
                bar.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
            }
        }

    } //set_clip

    public override function set_visible( _control:MIPanel, ?_visible:Bool=true ) {

        geom.visible = _visible;
        bar.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MIPanel, ?_depth:Float=0.0 ) {

        if(geom != null) {
            geom.depth = _depth;
        }

        if(bar != null) {
            bar.depth = _depth;
        }

    } //set_depth

} //MIPanelRenderer

class MICheckboxLuxeRenderer extends MICheckboxRenderer {

    var back : QuadGeometry;

    public override function init( _control:MICheckbox, _options:Dynamic ) {

        back = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x0d0d0d),
            batcher : Luxe.renderer.batcher
        });

    } //init

    public override function translate( _control:MICheckbox, _x:Float, _y:Float, ?_offset:Bool = false ) {

        back.transform.pos = new Vector( back.transform.pos.x + _x, back.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:MICheckbox, ?_clip_rect:MIRectangle=null ) {

    } //set_clip

    public override function set_visible( _control:MICheckbox, ?_visible:Bool=true ) {

        back.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MICheckbox, ?_depth:Float=0.0 ) {

        if(back != null) {
            back.depth = _depth;
        }

    } //set_depth

} //MICheckboxRenderer

