package mint.renderer;

import mint.Renderer;

import mint.Control;
import mint.Label;
import mint.Canvas;
import mint.Button;
import mint.List;
import mint.ScrollArea;
import mint.Image;
import mint.Window;
import mint.Dropdown;
import mint.Panel;
import mint.Checkbox;
import mint.Number;

import mint.Types;

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


class LuxeRenderer extends Renderer {

    public function new() {

        super();

        canvas = new CanvasLuxeRenderer();
        label = new LabelLuxeRenderer();
        button = new ButtonLuxeRenderer();
        list = new ListLuxeRenderer();
        scroll = new ScrollAreaLuxeRenderer();
        image = new ImageLuxeRenderer();
        window = new WindowLuxeRenderer();
        dropdown = new DropdownLuxeRenderer();
        panel = new PanelLuxeRenderer();
        checkbox = new CheckboxLuxeRenderer();

    } //new

} //Renderer

class CanvasLuxeRenderer extends CanvasRenderer {

    var back : QuadGeometry;

    public override function init( _control:Canvas, _options:Dynamic ) {

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

    public override function set_visible( _control:Canvas, ?_visible:Bool=true ) {

        back.visible = _visible;

    } //set_visible

    public override function set_depth( _control:Canvas, ?_depth:Float=0.0 ) {

        if(back != null) {
            // back.depth = _depth;
        }

    } //set_depth


} //CanvasLuxeRenderer

class LabelLuxeRenderer extends LabelRenderer {


    public override function init( _control:Label, _options:Dynamic ) {

        if(_options.bounds != null) {
            _options.bounds = Convert.rect( _options.bounds );
        }

        if(_options.pos != null) {
            _options.pos = Convert.point( _options.pos );
        }

                    //store the old parent as Text will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

            //if there is padding, we change the bounds
        if( _options.padding.x != 0 ) { _options.bounds.x += _options.padding.x; }
        if( _options.padding.y != 0 ) { _options.bounds.y += _options.padding.y; }
        if( _options.padding.w != 0 ) { _options.bounds.w -= _options.padding.w*2; }
        if( _options.padding.h != 0 ) { _options.bounds.h -= _options.padding.h*2; }

        if( _options.align != null) {
            _options.align = Convert.text_align( _options.align );
        }

        if( _options.align_vertical != null) {
            _options.align_vertical = Convert.text_align( _options.align_vertical );
        }

        _options.color = new Color(0,0,0,1).rgb(0x999999);

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


        _options.parent = _oldp;

    } //init

    public override function translate( _control:Label, _x:Float, _y:Float, ?_offset:Bool = false ) {

        var text : Text = cast _control.render_items.get('text');

            text.pos = new Vector( text.pos.x + _x, text.pos.y + _y );

        // var bounds:RectangleGeometry = cast _control.render_items.get('bounds');

            // bounds.pos = new Vector( bounds.pos.x + _x, bounds.pos.y + _y );

    } //translate

    public override function set_clip( _control:Label, ?_clip_rect : Rect = null ) {

        var text:Text = cast _control.render_items.get('text');

        if(_clip_rect == null) {
            text.geometry.clip_rect = null;
        } else {
            if(text != null && text.geometry != null) {
                text.geometry.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
            }
        }

    } //set clip

    public override function set_visible( _control:Label, ?_visible:Bool=true ) {

        var text:Text = cast _control.render_items.get('text');

            text.visible = _visible;

    } //set_visible

    public override function set_depth( _control:Label, ?_depth:Float=0.0 ) {

        var text:Text = cast _control.render_items.get('text');

            if(text != null) {
                text.geometry.depth = _depth;
            }

    } //set_depth

    public override function set_text( _control:Label, ?_text:String='label' ) {

        var text:Text = cast _control.render_items.get('text');

        if(text != null) {
            text.text_options.bounds = Convert.rect( _control.real_bounds );
            text.text = _text;
            text.geometry.depth = _control.depth+0.1;
        }

    } //set_text

    public override function destroy( _control:Label ) {
        var text:Text = cast _control.render_items.get('text');
            _control.render_items.remove('text');
            text.destroy();
            text = null;
    }

} //LabelLuxeRenderer

class ButtonLuxeRenderer extends ButtonRenderer {

    public override function init( _control:Button, _options:Dynamic ) {


        //store the old parent as NineSlice will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

        var geom = new NineSlice({
            texture : Luxe.loadTexture('tiny.button.png'),
            depth : _control.depth,
            top : 8, left : 8, right : 8, bottom : 8,
        });

        geom.pos = new Vector( _control.real_bounds.x, _control.real_bounds.y );
        geom.create( new Vector( _control.real_bounds.x, _control.real_bounds.y), _control.real_bounds.w, _control.real_bounds.h );

        geom.color = new Color(1,1,1,1);

        geom._geometry.id = _control.name + '.button';

        _control.render_items.set('geom', geom);

        _options.parent = _oldp;

    } //init

    public override function translate( _control:Button, _x:Float, _y:Float, ?_offset:Bool = false ) {

        var geom : NineSlice = cast _control.render_items.get('geom');

            geom.pos = new Vector( geom.transform.pos.x + _x, geom.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:Button, ?_clip_rect:Rect=null ) {

        var geom : NineSlice = cast _control.render_items.get('geom');

        if(_clip_rect == null) {
            geom.clip_rect = null;
        } else {
            if(geom != null) {
                geom.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w,_clip_rect.h);
            }
        }

    } //set_clip


    public override function set_visible( _control:Button, ?_visible:Bool=true ) {

        var geom : NineSlice = cast _control.render_items.get('geom');

            geom.visible = _visible;

    } //set_visible

    public override function set_depth( _control:Button, ?_depth:Float=0.0 ) {

        var geom : NineSlice = cast _control.render_items.get('geom');

            if(geom != null) {
                geom.depth = _depth;
            }

    } //set_depth

} //ButtonLuxeRenderer

class ListLuxeRenderer extends ListRenderer {

    public override function init( _control:List, _options:Dynamic ) {
    } //init

    public override function translate( _control:List, _x:Float, _y:Float, ?_offset:Bool = false ) {
        if(_control.multiselect) {
            var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
            if(_existing_selections != null) {
                for(_geom in _existing_selections) {
                    _geom.transform.pos = new Vector(_geom.transform.pos.x + _x, _geom.transform.pos.y + _y);
                    if(_geom.clip_rect != null) {
                        _geom.clip_rect.x = _control.clip_rect.x;
                        _geom.clip_rect.y = _control.clip_rect.y;
                        _geom.clip_rect.w = _control.clip_rect.w;
                        _geom.clip_rect.h = _control.clip_rect.h;
                    }
                }
            }
        } else {
            var _select : QuadGeometry = _control.render_items.get('select');
            if(_select != null) {
                _select.transform.pos = new Vector(_select.transform.pos.x + _x, _select.transform.pos.y + _y);
                if(_select.clip_rect != null) {
                    _select.clip_rect.x = _select.clip_rect.x + _x;
                    _select.clip_rect.y = _select.clip_rect.y + _y;
                }
            }
        }

    } //translate

    public override function set_clip( _control:List, ?_clip_rect:Rect=null ) {

    } //set_clip

    public override function scroll(_control:List, _x:Float, _y:Float) {

        if(_control.multiselect) {
            var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
            if(_existing_selections != null) {
                for(_geom in _existing_selections) {
                    _geom.transform.pos = new Vector(_geom.transform.pos.x + _x, _geom.transform.pos.y + _y);
                }
            }
        } else {
            var _select : QuadGeometry = _control.render_items.get('select');
            if(_select != null) {
                _select.transform.pos = new Vector(_select.transform.pos.x + _x, _select.transform.pos.y + _y);
            }
        }

    } //

    public override function select_item( _control:List, _selected:Control ) {

        if(_selected == null) {

            if(_control.multiselect) {
                var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
                for(_select in _existing_selections) {
                    _select.drop();
                }
                _control.render_items.set('existing_selections', null);
            } else {
                var _select : QuadGeometry = _control.render_items.get('select');
                if(_select != null) {
                    _select.drop();
                }

                _control.render_items.set('select', null);
            }

            return;
        }

        if(!_control.multiselect) {

            //normal single select
            var _select : QuadGeometry = _control.render_items.get('select');
            if(_select != null) {

                _select.transform.pos = new Vector(_selected.real_bounds.x, _selected.real_bounds.y);

            } else {

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

            _control.render_items.set('existing_selections', _existing_selections);

        } //multiselect

    } //select item

    public override function set_visible( _control:List, ?_visible:Bool=true ) {

        if(_control.multiselect) {

            var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
            for(_select in _existing_selections) {
                _select.visible = _visible;
            }

        } else {

            var _select : QuadGeometry = _control.render_items.get('select');
            if(_select != null) {
                _select.visible = _visible;
            }

        }

    } //set_visible

    public override function set_depth( _control:List, ?_depth:Float=0.0 ) {

        if(_control.multiselect) {

            var _existing_selections : Array<QuadGeometry> = _control.render_items.get('existing_selections');
            for(_select in _existing_selections) {
                _select.depth = _control.view.depth+0.001;
            }

        } else {

            var _select : QuadGeometry = _control.render_items.get('select');
            if(_select != null) {
                _select.depth = _control.view.depth+0.001;
            }

        }

    } //set_depth

} //ListLuxeRenderer


class ScrollAreaLuxeRenderer extends ScrollAreaRenderer {

    public override function init( _control:ScrollArea, _options:Dynamic ) {

        var back = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x0d0d0d),
            batcher : Luxe.renderer.batcher
        });

        var box = Luxe.draw.rectangle({
            depth : _control.depth+(0.01+_control.children.length*0.001),
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x181818),
            batcher : Luxe.renderer.batcher
        });

        var sliderv = new QuadGeometry({
            depth : _control.depth+(0.01+_control.children.length*0.001),
            x: (_control.real_bounds.x+_control.real_bounds.w - 4),
            y: _control.real_bounds.y + ((_control.real_bounds.h-10) * _control.scroll_percent.y),
            w: 3,
            h: 10,
            color : new Color().rgb(0x999999),
            visible : false,
            batcher : Luxe.renderer.batcher
        });

        var sliderh = new QuadGeometry({
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

        _control.render_items.set('back', back);
        _control.render_items.set('box', box);
        _control.render_items.set('sliderh', sliderh);
        _control.render_items.set('sliderv', sliderv);

    } //init

    public override function get_handle_bounds( _control:mint.ScrollArea, ?vertical:Bool=true ) : Rect {

        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

        var res : Rect = null;

        if(vertical) {
            res = new Rect( sliderv.transform.pos.x, sliderv.transform.pos.y, 5, 10 );
        } else {
            res = new Rect( sliderh.transform.pos.x, sliderh.transform.pos.y, 10, 5 );
        }

        return res;

    } //get_handle_size

    public override function translate( _control:ScrollArea, _x:Float, _y:Float, ?_offset:Bool = false ) {

        var back:QuadGeometry = cast _control.render_items.get('back');
        var box:Geometry = cast _control.render_items.get('box');
        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

        back.transform.pos = new Vector( back.transform.pos.x + _x, back.transform.pos.y + _y );
        box.transform.pos = new Vector( box.transform.pos.x + _x, box.transform.pos.y + _y );
        sliderh.transform.pos = new Vector( sliderh.transform.pos.x + _x, sliderh.transform.pos.y + _y );
        sliderv.transform.pos = new Vector( sliderv.transform.pos.x + _x, sliderv.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:ScrollArea, ?_clip_rect:Rect=null ) {


    } //set_clip

    public override function refresh_scroll( _control:ScrollArea, shx:Float, shy:Float, svx:Float, svy:Float, hv:Bool, vv:Bool ) {

        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

        sliderh.transform.pos = new Vector( shx, shy );
        sliderv.transform.pos = new Vector( svx, svy );

        sliderh.visible = hv;
        sliderv.visible = vv;
    }


    public override function set_visible( _control:ScrollArea, ?_visible:Bool=true ) {

        var back:QuadGeometry = cast _control.render_items.get('back');
        var box:Geometry = cast _control.render_items.get('box');
        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

            back.visible = _visible;
            box.visible = _visible;
            sliderh.visible = _visible;
            sliderv.visible = _visible;

    } //set_visible

    public override function set_depth( _control:ScrollArea, ?_depth:Float=0.0 ) {

        var back:QuadGeometry = cast _control.render_items.get('back');
        var box:Geometry = cast _control.render_items.get('box');
        var sliderh:QuadGeometry = cast _control.render_items.get('sliderh');
        var sliderv:QuadGeometry = cast _control.render_items.get('sliderv');

            if(back != null) {
                back.depth = _depth;
            }

            if(box != null) {
                box.depth = _depth+(0.001+_control.children.length*0.001);
            }

            if(sliderh != null) {
                sliderh.depth = _depth+(0.001+_control.children.length*0.001);
            }

            if(sliderv != null) {
                sliderv.depth = _depth+(0.001+_control.children.length*0.001);
            }

    } //set_depth

} //ScrollAreaLuxeRenderer

class ImageLuxeRenderer extends ImageRenderer {

    public override function init( _control:Image, _options:Dynamic ) {

        if(_options.pos != null) {
            _options.pos = Convert.point( _options.pos );
        }

        if(_options.size != null) {
            _options.size = Convert.point( _options.size );
        }

            //store the old parent as Sprite will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

            //create the image
        var image = new Sprite(_options);
            //store for later
        _control.render_items.set('image', image);
            //clip the geometry
        set_clip( _control, _control.parent.real_bounds );
            //reassign
        _options.parent = _oldp;

        // image.geometry.id = _control.name + '.image';

    } //init

    public override function translate( _control:Image, _x:Float, _y:Float, ?_offset:Bool = false ) {

        var image:Sprite = cast _control.render_items.get('image');

            image.pos = image.pos.add( new Vector(_x,_y) );

            if(image.geometry.clip) {
                image.geometry.clip_rect.x = _control.clip_rect.x;
                image.geometry.clip_rect.y = _control.clip_rect.y;
                image.geometry.clip_rect.w = _control.clip_rect.w;
                image.geometry.clip_rect.h = _control.clip_rect.h;
            }

    } //translate

    public override function set_clip( _control:Image, ?_clip_rect:Rect=null ) {

        var image:Sprite = cast _control.render_items.get('image');

        if(image.texture != null && image.texture.loaded) {

            if(_clip_rect == null) {
                image.geometry.clip_rect = null;
            } else {
                image.geometry.clip_rect = new Rectangle(_clip_rect.x,_clip_rect.y,_clip_rect.w-1,_clip_rect.h-1);
            }

        }

    } //set_clip


    public override function set_visible( _control:Image, ?_visible:Bool=true ) {

        var image:Sprite = cast _control.render_items.get('image');

            image.visible = _visible;

    } //set_visible

    public override function set_depth( _control:Image, ?_depth:Float=0.0 ) {

        var image:Sprite = cast _control.render_items.get('image');

            if(image != null) {
                image.depth = _depth;
            }

    } //set_depth

    public override function destroy( _control:Image ) {

        var image:Sprite = cast _control.render_items.get('image');

        if(image != null) {
            image.destroy();
        }

        image = null;

        _control.render_items.remove('image');

    } //destroy


} //ImageLuxeRenderer

class WindowLuxeRenderer extends WindowRenderer {

    public override function init( _control:Window, _options:Dynamic ) {


            //store the old parent as Sprite will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

        var geom = new NineSlice({
            texture : Luxe.loadTexture('tiny.ui.png'),
            depth : _control.depth,
            top : 32, left : 32, right : 32, bottom : 32,
        });

        geom.pos = new Vector( _control.real_bounds.x, _control.real_bounds.y );
        geom.create( new Vector( _control.real_bounds.x, _control.real_bounds.y ), _control.real_bounds.w, _control.real_bounds.h );

        _options.depth = _control.depth;

        geom.color = new Color(1,1,1,1);

        geom._geometry.id = _control.name + '.window';

        _control.render_items.set('geom', geom);

        _options.parent = _oldp;

    } //init

    public override function translate( _control:Window, _x:Float, _y:Float, ?_offset:Bool = false ) {

        var geom : NineSlice = cast _control.render_items.get('geom');

        geom.pos = new Vector( geom.pos.x + _x, geom.pos.y + _y );

    } //translate

    public override function set_clip( _control:Window, ?_clip_rect:Rect=null ) {

    } //set_clip

    public override function set_visible( _control:Window, ?_visible:Bool=true ) {

        var geom : NineSlice = cast _control.render_items.get('geom');

            geom.visible = _visible;

    } //set_visible

    public override function set_depth( _control:Window, ?_depth:Float=0.0 ) {

        var geom : NineSlice = cast _control.render_items.get('geom');

            if(geom != null) {
                geom.depth = _depth;
            }

    } //set_depth

} //WindowLuxeRenderer

class DropdownLuxeRenderer extends DropdownRenderer {

    public override function init( _control:Dropdown, _options:Dynamic ) {

        var back = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x0d0d0d),
            batcher : Luxe.renderer.batcher
        });

        _control.render_items.set('back', back);

    } //init

    public override function translate( _control:Dropdown, _x:Float, _y:Float, ?_offset:Bool = false ) {

        var back:QuadGeometry = cast _control.render_items.get('back');

            back.transform.pos = new Vector( back.transform.pos.x + _x, back.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:Dropdown, ?_clip_rect:Rect=null ) {

    } //set_clip

    public override function set_visible( _control:Dropdown, ?_visible:Bool=true ) {

        var back:QuadGeometry = cast _control.render_items.get('back');

            back.visible = _visible;

    } //set_visible

    public override function set_depth( _control:Dropdown, ?_depth:Float=0.0 ) {

        var back:QuadGeometry = cast _control.render_items.get('back');

            if(back != null) {
                back.depth = _depth;
            }

    } //set_depth


} //DropdownLuxeRenderer

class PanelLuxeRenderer extends PanelRenderer {

    public override function init( _control:Panel, _options:Dynamic ) {

                    //store the old parent as Sprite will think we want it to be using parenting
        var _oldp = _options.parent;
            _options.parent = null;

        var geom = new NineSlice({
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

        _control.render_items.set('geom', geom);

        var bary = _control.real_bounds.y + _control.real_bounds.h;

        if(_options.bar != null) {
            if(_options.bar == 'top') {
                bary = _control.real_bounds.y-3;
            }
        }

        var bar = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x, y: bary,
            w: _control.real_bounds.w, h: 3,
            color : new Color(1,1,1,1).rgb(0x030303),
            batcher : Luxe.renderer.batcher
        });

        _control.render_items.set('bar', bar);

        _options.parent = _oldp;

    } //init

    public override function translate( _control:Panel, _x:Float, _y:Float, ?_offset:Bool = false ) {

        var geom : NineSlice = cast _control.render_items.get('geom');
        var bar : QuadGeometry = cast _control.render_items.get('bar');

            geom.pos = new Vector( geom.pos.x + _x, geom.pos.y + _y );
            bar.transform.pos = new Vector( bar.transform.pos.x + _x, bar.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:Panel, ?_clip_rect:Rect=null ) {

        var geom : NineSlice = cast _control.render_items.get('geom');
        var bar : QuadGeometry = cast _control.render_items.get('bar');

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

    public override function set_visible( _control:Panel, ?_visible:Bool=true ) {

        var geom : NineSlice = cast _control.render_items.get('geom');
        var bar : Geometry = cast _control.render_items.get('bar');

            geom.visible = _visible;
            bar.visible = _visible;

    } //set_visible

    public override function set_depth( _control:Panel, ?_depth:Float=0.0 ) {

        var geom : NineSlice = cast _control.render_items.get('geom');
        var bar : NineSlice = cast _control.render_items.get('bar');

            if(geom != null) {
                geom.depth = _depth;
            }

            if(bar != null) {
                bar.depth = _depth;
            }

    } //set_depth

} //PanelRenderer

class CheckboxLuxeRenderer extends CheckboxRenderer {

    public override function init( _control:Checkbox, _options:Dynamic ) {

        var back = new QuadGeometry({
            depth : _control.depth,
            x: _control.real_bounds.x,
            y: _control.real_bounds.y,
            w: _control.real_bounds.w,
            h: _control.real_bounds.h,
            color : new Color(1,1,1,1).rgb(0x0d0d0d),
            batcher : Luxe.renderer.batcher
        });

        _control.render_items.set('back', back);

    } //init

    public override function translate( _control:Checkbox, _x:Float, _y:Float, ?_offset:Bool = false ) {

        var back:QuadGeometry = cast _control.render_items.get('back');

            back.transform.pos = new Vector( back.transform.pos.x + _x, back.transform.pos.y + _y );

    } //translate

    public override function set_clip( _control:Checkbox, ?_clip_rect:Rect=null ) {

    } //set_clip

    public override function set_visible( _control:Checkbox, ?_visible:Bool=true ) {

        var back:QuadGeometry = cast _control.render_items.get('back');

            back.visible = _visible;

    } //set_visible

    public override function set_depth( _control:Checkbox, ?_depth:Float=0.0 ) {

        var back:QuadGeometry = cast _control.render_items.get('back');

            if(back != null) {
                back.depth = _depth;
            }

    } //set_depth

} //CheckboxRenderer

