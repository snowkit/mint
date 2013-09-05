package ;

import minterface.MIRenderer;

import minterface.MIRenderer.MICanvasRenderer;
import minterface.MIRenderer.MILabelRenderer;
import minterface.MIRenderer.MIButtonRenderer;

import minterface.MIControl;
import minterface.MILabel;
import minterface.MICanvas;
import minterface.MIButton;
import minterface.MIList;
import minterface.MIScrollArea;
import minterface.MIImage;
import minterface.MIWindow;
import minterface.MIDropdown;
import minterface.MITypes;

import luxe.Text;
import luxe.Color;
import luxe.Vector;
import luxe.Sprite;
import luxe.Input;
import luxe.Rectangle;

import phoenix.geometry.QuadGeometry;
import phoenix.geometry.RectangleGeometry;

import luxe.NineSlice;


//temp copy paste base
// class MIREPLACEMELuxeRenderer extends MIREPLACEMERenderer {
//  public override function init( _control:MIREPLACEME, _options:Dynamic ) { } //init
//  public override function translate( _control:MIREPLACEME, _x:Float, _y:Float ) { } //translate
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

    public static function color( _color:MIColor ) : Color {
        if(_color == null){ throw "Color passed in as null"; }
        return new Color( _color.r, _color.g, _color.b, _color.a );
    } //vector

    public static function mouse_state( _state:MouseState ) : MIMouseState {
        switch(_state) {
            case MouseState.down:
                return MIMouseState.down;
            case MouseState.move:
                return MIMouseState.move;
            case MouseState.up:
                return MIMouseState.up;
        } //state
    } //mouse_state

    public static function mouse_button( _button:MouseButton ) : MIMouseButton {
        switch(_button) {
            case MouseButton.move:
                return MIMouseButton.move;
            case MouseButton.left:
                return MIMouseButton.left;
            case MouseButton.middle:
                return MIMouseButton.middle;
            case MouseButton.right:
                return MIMouseButton.right;
            case MouseButton.wheel_up:
                return MIMouseButton.wheel_up;
            case MouseButton.wheel_down:
                return MIMouseButton.wheel_down;
        } //state
    } //mouse_state

    public static function mouse_event( _event:MouseEvent ) : MIMouseEvent {
        return {
            state : mouse_state(_event.state),
            flags : _event.flags,
            button : mouse_button(_event.button),
            x : _event.x,
            y : _event.y,
            deltaX : _event.deltaY,
            deltaY : _event.deltaX,
            shift_down : _event.shift_down,
            ctrl_down : _event.ctrl_down, 
            alt_down : _event.alt_down,
            meta_down : _event.meta_down
        };
    } //mouse_event

}

class MILuxeRenderer extends MIRenderer {

    public function new() {
        
        super();

        canvas = new MICanvasLuxeRenderer();
        label = new MILabelLuxeRenderer();
        button = new MIButtonLuxeRenderer();
        list = new MIListLuxeRenderer();
        scroll = new MIScrollAreaLuxeRenderer();
        image = new MIImageLuxeRenderer();
        window = new MIWindowLuxeRenderer();
        dropdown = new MIDropdownLuxeRenderer();

    } //new

} //MIRenderer

class MICanvasLuxeRenderer extends MICanvasRenderer {
    
    public override function init( _control:MICanvas, _options:Dynamic ) {

        var back = new QuadGeometry({           
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1),
            depth : _control.depth
        });

        back.texture = Luxe.loadTexture('assets/transparency.png');
        back.uv(new Rectangle(0,0,960,640));

        back.id = _control.name + '.back';

        Luxe.addGeometry( back );

            //store inside the element  
        _control.render_items.set('back', back);

    } //init

    public override function set_visible( _control:MICanvas, ?_visible:Bool=true ) { 
        
        var back:QuadGeometry = cast _control.render_items.get('back');  
        
            back.enabled = _visible;

    } //set_visible   

    public override function set_depth( _control:MICanvas, ?_depth:Float=0.0 ) {

        var back:QuadGeometry = cast _control.render_items.get('back');

            if(back != null) {
                // back.depth = _depth;
            }

    } //set_depth


} //MICanvasLuxeRenderer

class MILabelLuxeRenderer extends MILabelRenderer {


    public override function init( _control:MILabel, _options:Dynamic ) {
           
        if(_options.bounds != null) {
            _options.bounds = LuxeMIConverter.rectangle( _options.bounds );
        }

        if(_options.pos != null) {
            _options.pos = LuxeMIConverter.vector( _options.pos );
        }

        if(_options.color != null) {
            _options.color = LuxeMIConverter.color( _options.color );
        }

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

        var text = new Text( _options );

            _control.render_items.set('text', text);

        // var bounds = Luxe.draw.rectangle({
        //     color:_control.debug_color,
        //     depth: 200,
        //     x:_control.real_bounds.x,
        //     y:_control.real_bounds.y,
        //     w:_control.real_bounds.w,
        //     h:_control.real_bounds.h,
        // });
        // _control.render_items.set('bounds', bounds);

        for(_g in text.geometry.geometry) {
        	_g.id = _control.name + '.text';
        } 

    } //init

    public override function translate( _control:MILabel, _x:Float, _y:Float ) {

        var text:Text = cast _control.render_items.get('text');

            text.pos = new Vector( text.pos.x + _x, text.pos.y + _y );

        // var bounds:RectangleGeometry = cast _control.render_items.get('bounds');
        
            // bounds.pos = new Vector( bounds.pos.x + _x, bounds.pos.y + _y );
        
    } //translate

    public override function set_clip( _control:MILabel, ?_clip_rect : MIRectangle = null ) {

        var text:Text = cast _control.render_items.get('text');

        if(_clip_rect == null) {
            text.geometry.clip = false;
        } else {
            if(text != null && text.geometry != null) {
                text.geometry.clip = true;
                text.geometry.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
            }
        }

    } //set clip

    public override function set_visible( _control:MILabel, ?_visible:Bool=true ) { 
        
        var text:Text = cast _control.render_items.get('text');  

            text.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MILabel, ?_depth:Float=0.0 ) {

        var text:Text = cast _control.render_items.get('text'); 

            if(text != null) {
                text.geometry.depth = _depth;
            }

    } //set_depth

    public override function set_text( _control:MILabel, ?_text:String='label' ) {

    	var text:Text = cast _control.render_items.get('text');            

    	if(text != null) {
            text.text_options.bounds = LuxeMIConverter.rectangle( _control.real_bounds );
    		text.text = _text;
            text.geometry.depth = _control.depth+1;
	    }

    } //set_text 

} //MILabelLuxeRenderer

class MIButtonLuxeRenderer extends MIButtonRenderer {

    public override function init( _control:MIButton, _options:Dynamic ) {
        
        var geom = new NineSlice({
            texture : Luxe.loadTexture('default_ui_button'),
            depth : _control.depth,
            top : 8, left : 8, right : 8, bottom : 8,
        });
        
        geom.pos = new Vector( _control.real_bounds.x, _control.real_bounds.y );
        geom.create( new Vector( _control.real_bounds.x, _control.real_bounds.y), _control.real_bounds.w, _control.real_bounds.h );
        
        geom.color = new Color(1,1,1,1);

        geom._geometry.id = _control.name + '.button';

        _control.render_items.set('geom', geom);

    } //init

    public override function translate( _control:MIButton, _x:Float, _y:Float ) {
        
        var geom : NineSlice = cast _control.render_items.get('geom');

            geom.pos = new Vector( geom.pos.x + _x, geom.pos.y + _y );

    } //translate

    public override function set_clip( _control:MIButton, ?_clip_rect:MIRectangle=null ) {
        
        var geom : NineSlice = cast _control.render_items.get('geom');

        if(_clip_rect == null) {
            geom.clip = false;
        } else {
            if(geom != null) {
                geom.clip = true;
                geom.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
            }
        }

    } //set_clip


    public override function set_visible( _control:MIButton, ?_visible:Bool=true ) { 
        
        var geom : NineSlice = cast _control.render_items.get('geom');

            geom.visible = _visible;

    } //set_visible    

    public override function set_depth( _control:MIButton, ?_depth:Float=0.0 ) {

        var geom : NineSlice = cast _control.render_items.get('geom');

            if(geom != null) {
                geom.depth = _depth;
            }

    } //set_depth

} //MIButtonLuxeRenderer

class MIListLuxeRenderer extends MIListRenderer {

    public override function init( _control:MIList, _options:Dynamic ) {
    } //init
    
    public override function translate( _control:MIList, _x:Float, _y:Float ) {

    } //translate

    public override function set_clip( _control:MIList, ?_clip_rect:MIRectangle=null ) {
    } //set_clip
    
    public override function scroll(_control:MIList, _x:Float, _y:Float) {
        
        if(_control.multiselect) {
            var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
            if(_existing_selections != null) {
                for(_geom in _existing_selections) {
                    _geom.pos = new Vector(_geom.pos.x + _x, _geom.pos.y + _y);
                }
            }
        } else {
            var _select : QuadGeometry = _control.render_items.get('select');
            if(_select != null) {
                _select.pos = new Vector(_select.pos.x + _x, _select.pos.y + _y);
            }
        }   

    } //

    public override function select_item( _control:MIList, _selected:MIControl ) {

		if(_selected == null) {

			if(_control.multiselect) {
				var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
				for(_select in _existing_selections) {
					_select.drop();
				}
			} else {
				var _select : QuadGeometry = _control.render_items.get('select');
				if(_select != null) {
					_select.drop();
				}
			}

			return;
		}

        if(!_control.multiselect) {

            //normal single select
            var _select : QuadGeometry = _control.render_items.get('select');
            if(_select != null) {

                _select.pos = new Vector(_selected.real_bounds.x, _selected.real_bounds.y);
                _control.render_items.set('select', _select);

            } else {

                var _geom = new QuadGeometry({
                    depth : _control.depth+1.1,
                    x: _selected.real_bounds.x,
                    y: _selected.real_bounds.y,
                    w: _selected.real_bounds.w,
                    h: _selected.real_bounds.h,
                    color : new Color().rgb(0x262626)
                });

                _geom.clip = true;
                _geom.clip_rect = new Rectangle( _control.real_bounds.x, _control.real_bounds.y, _control.real_bounds.w, _control.real_bounds.h );

                Luxe.addGeometry( _geom );

                _control.render_items.set('select', _geom);
            }

        } else {

            var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');

            if(_existing_selections == null) {
                _existing_selections = new Array<QuadGeometry>();
            }

            if(_selected == null) {
                for(_geom in _existing_selections) {
                    _geom.drop();
                    _geom = null;
                } //for each
            } else { //if disabling all selections

                var _geom = new QuadGeometry({
                    depth : _control.depth+1.1,
                    x: _selected.real_bounds.x,
                    y: _selected.real_bounds.y,
                    w: _selected.real_bounds.w,
                    h: _selected.real_bounds.h,
                    color : new Color().rgb(0x262626)
                });

                _geom.clip = true;
                _geom.clip_rect = new Rectangle( _control.real_bounds.x, _control.real_bounds.y, _control.real_bounds.w, _control.real_bounds.h );

                Luxe.addGeometry( _geom );

                _existing_selections.push(_geom);

            } //if not

            _control.render_items.set('existing_selections', _existing_selections);

        } //multiselect

    } //select item

    public override function set_visible( _control:MIList, ?_visible:Bool=true ) { 

    	if(_control.multiselect) {
			
			var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
			for(_select in _existing_selections) {
				_select.enabled = _visible;
			}

    	} else {
    		
    		var _select : QuadGeometry = _control.render_items.get('select');
    		if(_select != null) {
    			_select.enabled = _visible;
    		}

    	}
    } //set_visible  

    public override function set_depth( _control:MIList, ?_depth:Float=0.0 ) {


        if(_control.multiselect) {
            
            var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
            for(_select in _existing_selections) {
                _select.depth = _depth;
            }

        } else {
            
            var _select : QuadGeometry = _control.render_items.get('select');
            if(_select != null) {
                _select.depth = _depth;
            }

        }

    } //set_depth

} //MIListLuxeRenderer


class MIScrollAreaLuxeRenderer extends MIScrollAreaRenderer {
    
    public override function init( _control:MIScrollArea, _options:Dynamic ) {
        var back = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x121212)
        });
        var sliderv = new QuadGeometry({
            depth : _control.depth+2,
            x: (_control.real_bounds.x+_control.real_bounds.w - 4),
            y: _control.real_bounds.y + ((_control.real_bounds.h-10) * _control.scroll_percent.y),
            w: 3,
            h: 10,
            color : new Color().rgb(0x999999),
            enabled : false
        });
        var sliderh = new QuadGeometry({
            depth : _control.depth+2,
            x: _control.real_bounds.x + ((_control.real_bounds.w-10) * _control.scroll_percent.x),
            y: (_control.real_bounds.y+_control.real_bounds.h - 4),
            w: 10,
            h: 3,
            color : new Color().rgb(0x999999),
            enabled : false
        });

        back.id = _control.name + '.back';
        sliderh.id = _control.name + '.sliderh';
        sliderv.id = _control.name + '.sliderv';


        Luxe.addGeometry( back );
        Luxe.addGeometry( sliderh );
        Luxe.addGeometry( sliderv );

        _control.render_items.set('back', back);
        _control.render_items.set('sliderh', sliderh);
        _control.render_items.set('sliderv', sliderv);

    } //init

    public override function translate( _control:MIScrollArea, _x:Float, _y:Float ) {
        
        var back:QuadGeometry = cast _control.render_items.get('back');     
        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

        back.pos = new Vector( back.pos.x + _x, back.pos.y + _y );
        sliderh.pos = new Vector( sliderh.pos.x + _x, sliderh.pos.y + _y );
        sliderv.pos = new Vector( sliderv.pos.x + _x, sliderv.pos.y + _y );

    } //translate 

    public override function set_clip( _control:MIScrollArea, ?_clip_rect:MIRectangle=null ) {
        
        
    } //set_clip

    public override function refresh_scroll( _control:MIScrollArea, shx:Float, shy:Float, svx:Float, svy:Float, hv:Bool, vv:Bool ) {

        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

        sliderh.pos = new Vector( shx, shy );
        sliderv.pos = new Vector( svx, svy );

        sliderh.enabled = hv;
        sliderv.enabled = vv;
    }


    public override function set_visible( _control:MIScrollArea, ?_visible:Bool=true ) { 

        var back:QuadGeometry = cast _control.render_items.get('back');      
        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

            back.enabled = _visible;
            sliderh.enabled = _visible;
            sliderv.enabled = _visible;

    } //set_visible

    public override function set_depth( _control:MIScrollArea, ?_depth:Float=0.0 ) {

        var back:QuadGeometry = cast _control.render_items.get('back');      
        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

            if(back != null) {
                back.depth = _depth;
            }

            if(sliderh != null) {
                sliderh.depth = _depth+2;
            }

            if(sliderv != null) {
                sliderv.depth = _depth+2;
            }

    } //set_depth

} //MIScrollAreaLuxeRenderer

class MIImageLuxeRenderer extends MIImageRenderer {

    public override function init( _control:MIImage, _options:Dynamic ) {

        if(_options.pos != null) {
            _options.pos = LuxeMIConverter.vector( _options.pos );
        }

        if(_options.size != null) {
            _options.size = LuxeMIConverter.vector( _options.size );
        }

            //create the image
        var image = new Sprite(_options);
            //store for later
        _control.render_items.set('image', image);
            //clip the geometry
        set_clip( _control, _control.parent.real_bounds );

        // image.geometry.id = _control.name + '.image';

    } //init

    public override function translate( _control:MIImage, _x:Float, _y:Float ) {
        
        var image:Sprite = cast _control.render_items.get('image');

            image.pos = image.pos.add( new Vector(_x,_y) );

    } //translate

    public override function set_clip( _control:MIImage, ?_clip_rect:MIRectangle=null ) {

        var image:Sprite = cast _control.render_items.get('image');

        if(image.texture.loaded) {

            if(_clip_rect == null) {
                image.geometry.clip = false;
            } else {
                image.geometry.clip = true;
                image.geometry.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
            }

        } 

    } //set_clip


    public override function set_visible( _control:MIImage, ?_visible:Bool=true ) { 

        var image:Sprite = cast _control.render_items.get('image');

            image.visible = _visible;

    } //set_visible 

    public override function set_depth( _control:MIImage, ?_depth:Float=0.0 ) {
    
        var image:Sprite = cast _control.render_items.get('image');

            if(image != null) {
                image.depth = _depth;
            }

    } //set_depth

} //MIImageLuxeRenderer

class MIWindowLuxeRenderer extends MIWindowRenderer {

    public override function init( _control:MIWindow, _options:Dynamic ) {

        var geom = new NineSlice({
            texture : Luxe.loadTexture('default_ui_box'),
            depth : _control.depth,
            top : 32, left : 32, right : 32, bottom : 32,
        });

        geom.pos = new Vector( _control.real_bounds.x, _control.real_bounds.y );
        geom.create( new Vector( _control.real_bounds.x, _control.real_bounds.y ), _control.real_bounds.w, _control.real_bounds.h );

        _options.depth = _control.depth+0.01;

        geom.color = new Color(1,1,1,1);

        geom._geometry.id = _control.name + '.window';

        _control.render_items.set('geom', geom);
        
    } //init

    public override function translate( _control:MIWindow, _x:Float, _y:Float ) {
        
        var geom : NineSlice = cast _control.render_items.get('geom'); 

        geom.pos = new Vector( geom.pos.x + _x, geom.pos.y + _y );

    } //translate

    public override function set_clip( _control:MIWindow, ?_clip_rect:MIRectangle=null ) { 

    } //set_clip

    public override function set_visible( _control:MIWindow, ?_visible:Bool=true ) { 

        var geom : NineSlice = cast _control.render_items.get('geom'); 

            geom.visible = _visible;

    } //set_visible

    public override function set_depth( _control:MIWindow, ?_depth:Float=0.0 ) {

        var geom : NineSlice = cast _control.render_items.get('geom'); 

            if(geom != null) {
                geom.depth = _depth;
            }

    } //set_depth

} //MIWindowLuxeRenderer

class MIDropdownLuxeRenderer extends MIDropdownRenderer {

    public override function init( _control:MIDropdown, _options:Dynamic ) {
        
        var back = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x0d0d0d)
        });

        Luxe.addGeometry( back );

        _control.render_items.set('back', back);

    } //init

    public override function translate( _control:MIDropdown, _x:Float, _y:Float ) {
        
        var back:QuadGeometry = cast _control.render_items.get('back');

            back.pos = new Vector( back.pos.x + _x, back.pos.y + _y );

    } //translate

    public override function set_clip( _control:MIDropdown, ?_clip_rect:MIRectangle=null ) {

    } //set_clip

    public override function set_visible( _control:MIDropdown, ?_visible:Bool=true ) { 

        var back:QuadGeometry = cast _control.render_items.get('back');

            back.enabled = _visible;

    } //set_visible

    public override function set_depth( _control:MIDropdown, ?_depth:Float=0.0 ) {
    
        var back:QuadGeometry = cast _control.render_items.get('back');

            if(back != null) {
                back.depth = _depth;
            }

    } //set_depth


} //MIDropdownLuxeRenderer

