import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Text;
import luxe.Log.def;

import mint.Control;
import mint.types.Types;
import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;
import mint.types.Types.Helper.in_rect;

import mint.layout.margins.Margins;
import mint.focus.Focus;

import JSONLoader;
import EditorRendering.ControlRenderer;

typedef UserConfig = {
    var controls:Array<{ name:String, type:String, image:String }>;
    var resources:{ 
        images:Array<luxe.Parcel.TextureInfo>, 
        json:Array<luxe.Parcel.JSONInfo>, 
    };
}

class Main extends luxe.Game {

    var ui_batch: phoenix.Batcher;
    var ui_canvas: mint.Canvas;
    var ui_render: LuxeMintRender;
    var ui_info: mint.Label;
    
    var ed_canvas: mint.Canvas;
    var ed_render: EditorRendering;

    var layout: Margins;
    var ed_focus: Focus;
    var ui_focus: Focus;
    var drag:util.CameraDrag;

    var control_list: Array<{ name:String, type:String, image:String }> = [];

    override function config(config:luxe.GameConfig) {

        config.window.title = 'minted';

        //required resources

            config.preload.textures.push({ id:'assets/editor/load-96.png' });
            config.preload.textures.push({ id:'assets/editor/save-96.png' });
            config.preload.textures.push({ id:'assets/editor/clear-96.png' });
            config.preload.textures.push({ id:'assets/editor/options-96.png' });
            config.preload.textures.push({ id:'assets/editor/control-96.png' });
            
            config.preload.jsons.push({ id:'assets/editor/tools.mint.json' });
            config.preload.jsons.push({ id:'assets/editor/controls.mint.json' });
            config.preload.jsons.push({ id:'assets/editor/properties.mint.json' });

        //user specified

            var _user:UserConfig = config.user;
            if(_user!=null) {

                //resources
                    if(_user.resources != null) {

                        if(_user.resources.images!=null) {
                            for(_image in _user.resources.images) {
                                config.preload.textures.push(_image);
                            }
                        }

                        if(_user.resources.json!=null) {
                            for(_json in _user.resources.json) {
                                config.preload.jsons.push(_json);
                            }
                        }

                    } //user resources != null

                //controls

                    if(_user.controls != null) {
                        control_list = _user.controls;
                    }

            } //user config != null

        return config;

    } //config

    override function ready() {

        #if js
        untyped window.game = this;
        untyped window.game_ready();
        #end

        // Luxe.snow.windowing.enable_vsync(false);
        Luxe.renderer.clear_color.rgb(0x161619);

        ui_batch = Luxe.renderer.create_batcher({ name:'ui', layer:10 });

        ui_render = new LuxeMintRender({ batcher:ui_batch });
        ed_render = new EditorRendering();

        var _scale = Luxe.screen.device_pixel_ratio;
        ui_canvas = new mint.Canvas({ rendering: ui_render, scale:_scale, w: Luxe.screen.w/_scale, h: Luxe.screen.h/_scale });

        layout = new Margins();
        ui_focus = new Focus(ui_canvas);

        drag = Luxe.camera.add( new util.CameraDrag({name:'drag'}) );
        drag.zoom_speed = 0.05;

        create_tools();
        create_palette();
        create_properties();

        ui_info = new mint.Label({ parent:ui_canvas, text:'...', y:4, align_vertical:top, text_size:16 });
        layout.margin(ui_info, left, fixed, 0);
        layout.margin(ui_info, right, fixed, ui_tools.w);

        ed_canvas = new mint.Canvas({ rendering: ed_render, scale:_scale, user:{type:'mint.Canvas'}, x:2, y:2, w:(Luxe.screen.w/_scale)-ui_tools.w-4, h: (Luxe.screen.h/_scale)-4 });
        ed_focus = new Focus(ed_canvas);

    } //ready`

    var parenting:mint.Control;
    var possible_parent:mint.Control;

    var down_x = 0;
    var down_y = 0;
    var resizing = false;
    var moving = false;
    var rsize = 8;

    function ondown(e:mint.types.MouseEvent,c:mint.Control) {

        e.bubble = false;

        c.capture();

        if( in_rect(e.x, e.y, c.right-rsize, c.bottom-rsize, rsize, rsize) ) {
            resizing = true;    
        } else {
            moving = true;
        }

        down_x = Std.int(e.x);
        down_y = Std.int(e.y);
    }

    function onmove(e:mint.types.MouseEvent, c:mint.Control) {

        if(ed_canvas.captured == c) {
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

    function onup(e:mint.types.MouseEvent,c:mint.Control) {        

        if(ed_canvas.captured != null) {
            ed_canvas.captured.uncapture();
        }
        
        resizing = false;
        moving = false;

    }

    function duplicate(c:mint.Control) {

        var _control = spawn_control('${c.name}.clone', c.user.type, c.x_local+8, c.y_local+8, c.w, c.h );
        
        c.parent.add(_control);

        return _control;

    } //duplicate

    function get_export_node(_control:mint.Control, _root:Bool=false):Dynamic {
        //for now all root items are considered at 0,0
        var _node = haxe.Json.parse(haxe.Json.stringify(_control.user));
            _node.name = _control.name; 
            _node.x = (_root) ? 0 : _control.x_local;
            _node.y = (_root) ? 0 : _control.y_local;
            _node.w = _control.w;
            _node.h = _control.h;

            if(_control.children.length > 0) {
                _node.children = [];
                for(_child in _control.children) {
                    _node.children.push(get_export_node(_child));
                }
            }

        return _node;
    }

    function message(_message:String) {
        ui_info.text = _message;
    }

    function load_string(_name:String, _contents:String) {
        load(_name, haxe.Json.parse(_contents));
    }

    function load_item(_item:Dynamic, _parent:mint.Control, _offset_x:Int=0, _offset_y:Int=0) {
        var _control = spawn_control(_item.name, _item.type, false, _item.x+_offset_x, _item.y+_offset_y, _item.w, _item.h);
        var _fields = Reflect.fields(_item);
        for(_fieldn in _fields) {
            if(_fieldn=='name') continue;
            if(_fieldn=='type') continue;
            if(_fieldn=='children') continue;
            if(_fieldn=='x') continue;
            if(_fieldn=='y') continue;
            if(_fieldn=='w') continue;
            if(_fieldn=='h') continue;
            Reflect.setField(_control.user, _fieldn, Reflect.field(_item, _fieldn));
        }
        if(_item.children != null) {
            var _children:Array<Dynamic> = _item.children;
            for(_child in _children) {
                load_item(_child, _control);
            }
        }
        _parent.add(_control);
    }

    function load(_name:String, _contents:Dynamic) {
        var _list: Array<Dynamic> = _contents;
        if(_list == null) {
            trace('error loading contents for `$_name`!');
            return;
        }

        for(_item in _list) {
            load_item(_item, ed_canvas, 100, 100);
        }
    }

    function export() {

        var _list = [];
        for(_control in ed_canvas.children) {
            _list.push(get_export_node(_control, true));
        }

        return haxe.Json.stringify(_list,null,'  ');

    } //export

    function spawn_control(_name:String, _type:String, _select:Bool=true, ?_x:Float, ?_y:Float, ?_w:Float, ?_h:Float) {

        def(_x, (ed_canvas.w/2)+128);
        def(_y, ed_canvas.h-128);
        def(_w, 128);
        def(_h, 64);

        var control = new mint.Panel({
            parent: ed_canvas, name: _name, user: { type:_type },
            x:_x, y:_y, w:_w, h:_h, w_min:16, h_min:16,
        });

        control.onmousedown.listen(ondown);
        control.onmousemove.listen(onmove);
        control.onmouseup.listen(onup);

        if(_select) select(control);

        return control;

    } //spawn_control

    var ui_tools: mint.Panel;
    var ui_controls: mint.Panel;
    var ui_properties: mint.Panel;

    var ui_tooltip: mint.Label;
    var ui_debug: mint.Label;

    function load_ui_asset(_id:String) {

        if(!Luxe.resources.has(_id)) return null;
        return Luxe.resources.json(_id).asset;

    } //load_ui_asset

    function load_ui(_id:String, _parent:mint.Control, _x:Float, _y:Float) : LoaderItems {
    
        var _asset = load_ui_asset(_id);
    
        if(_asset == null) {
            trace('load_ui failed to find asset `$_id`');
            return null;
        }
    
        return JSONLoader.load(_parent, _asset.id, _asset.json, _x, _y);
    
    } //load_ui

    function create_tools() {

        var _ui = load_ui('assets/editor/tools.mint.json', ui_canvas, 0, 0);

        ui_tools = cast _ui.controls.get('panel.tools');
        ui_tooltip = cast _ui.controls.get('label.tools.tooltip');
        ui_debug = cast _ui.controls.get('label.tools.debug');

        if(ui_tools == null) {
            trace('ui tools is null?');
            return;
        }

        ui_tools.onmouseenter.listen(function(_,_) { ui_tooltip.text = '...'; });
        
        var _clear = _ui.controls.get('image.tools.clear');
        var _load = _ui.controls.get('image.tools.load');
        var _save = _ui.controls.get('image.tools.save');
        var _options = _ui.controls.get('image.tools.options');

        _clear.mouse_input = true;
        _load.mouse_input = true;
        _save.mouse_input = true;
        _options.mouse_input = true;

        _clear.onmouseenter.listen(function(_,_) { ui_tooltip.text = 'clear'; });
        _save.onmouseenter.listen(function(_,_) { ui_tooltip.text = 'save'; });
        _options.onmouseenter.listen(function(_,_) { ui_tooltip.text = 'options'; });
        _load.onmouseenter.listen(function(_,_) { 
            #if js
                ui_tooltip.text = 'drop file on editor to load'; 
            #else
                ui_tooltip.text = 'load'; 
            #end
        });

        _clear.onmouseup.listen(function(_,_) { ui_tooltip.text = 'cleared'; do_clear(); });
        _load.onmouseup.listen(function(_,_) { ui_tooltip.text = '...'; do_load(); });
        _save.onmouseup.listen(function(_,_) { ui_tooltip.text = '...'; do_save(); });
        _options.onmouseup.listen(function(_,_) { ui_tooltip.text = 'todo'; do_options(); });

        ui_tools.mouse_input = true;

        layout.anchor(ui_tools, AnchorType.left, AnchorType.right, -Math.floor(ui_tools.w));

    } //create_tools

    var ed_props: mint.List;

    function create_palette() {

        var _ui = load_ui('assets/editor/controls.mint.json', ui_canvas, 0, ui_tools.bottom+4);

        ui_controls = cast _ui.controls.get('panel.controls');
        
        if(ui_controls == null) {
            trace('ui controls is null?');
            return;
        }

        layout.anchor(ui_controls, AnchorType.left, AnchorType.right, -Math.floor(ui_controls.w));

        var ui_controltip:mint.Label = cast _ui.controls.get('label.controls.tooltip');

        ui_controls.mouse_input = true;
        ui_controls.onmouseenter.listen(function(_,_) { ui_controltip.text = '...'; });

        var _container:mint.List = cast _ui.controls.get('list.controls');
        var _list = control_list;

        var _cols = 4;
        var _rows = Math.ceil(_list.length / _cols);
        for(_i in 0 ... _rows) {
            var _row = new mint.Panel({ parent:ui_canvas, mouse_input:true, x:0, y:0, w:_container.w, h:54 });
            for(_j in 0 ... _cols) {
                var _item = _list[(_i*_cols)+_j];
                if(_item != null) {

                    var _image = 'assets/editor/control-96.png';
                    if(_item.image != '' && _item.image != null) {
                        _image = _item.image;
                    }

                    var _name = _item.name;
                    var _type = _item.type;
                    var _control = new mint.Image({
                        parent: _row,
                        mouse_input: true,
                        name: 'palette.$_name',
                        user: { type:_type, name:_name },
                        path: _image,
                        x: _j*58, y:2, w: 40, h: 40,
                    });
                    
                    _control.onmouseenter.listen(function(_,_) { ui_controltip.text = _name; });
                    _control.onmouseleave.listen(function(_,_) { ui_controltip.text = '...'; });
                    _control.onmouseup.listen(function(_,_) { 
                        spawn_control(_name, _type);
                    });

                } //not null
            }//each column

            _container.add_item(_row);

        } //each row

    } //create_palette

    function create_properties() {

        var _ui = load_ui('assets/editor/properties.mint.json', ui_canvas, 0, ui_controls.bottom+4);

        ui_properties = cast _ui.controls.get('panel.properties');
        if(ui_properties == null) {
            trace('ui properties is null?');
            return;
        }

        layout.anchor(ui_properties, left, right, -Math.floor(ui_properties.w));
        layout.margin(ui_properties, bottom, fixed, 0);

        ui_properties.mouse_input = true;

        ed_props = cast _ui.controls.get('list.properties');

        layout.margin(ed_props, right, fixed, 4);
        layout.margin(ed_props, bottom, fixed, 4);

    } //create_properties

    function prop_onbounds(_control:mint.Control, _xe:mint.TextEdit, _ye:mint.TextEdit, _we:mint.TextEdit, _he:mint.TextEdit) {
        _xe.text = '${_control.x_local}';
        _ye.text = '${_control.y_local}';
        _we.text = '${_control.w}';
        _he.text = '${_control.h}';
    }

    function control_for_node(_parent:mint.Control, node:Node) : mint.Control {
        def(node.x, 0);
        def(node.y, 0);
        def(node.text, 'text');
        var _control = switch(node.type) {
            case 'mint.TextEdit':
                var _edit = new mint.TextEdit({
                    parent:_parent, name: node.name,
                    x:node.x, y:node.y, w:node.w, h:node.h,
                    text: node.text, text_size: node.text_size, 
                    align:node.align,
                }); 

                if(node.reflect!=null && node.target != null) {
                    _edit.onchange.listen(function(t,dt,ft) {
                        Reflect.setField(node.target.user, node.reflect, t);
                    });
                }
                _edit;
            case 'mint.Checkbox': 
                var _check = new mint.Checkbox({
                    parent:_parent, name: node.name,
                    x:node.x, y:node.y, w:node.w, h:node.h,
                    state: node.state,
                });
                if(node.reflect!=null && node.target != null) {
                    _check.onchange.listen(function(_state:Bool,_) {
                        Reflect.setField(node.target.user, node.reflect, _state);
                    });
                }
                _check;
            case 'mint.Slider': 
                var _range = new mint.Slider({
                    parent:_parent, name: node.name,
                    x:node.x, y:node.y, w:node.w-26, h:node.h,
                    value: node.value, min: node.min, max: node.max, step: node.step,
                    // options: { color_bar:new Color().rgb(0x218BA0) }
                });
                var _disp = new mint.Label({
                    parent:_range, name:'${node.name}.label', mouse_input:false,
                    x:node.w-20, y:0, w:14, h:node.h, text:'${node.value}', text_size:11
                });
                if(node.reflect!=null && node.target != null) {
                    _range.onchange.listen(function(_value:Float,_percent:Float) {
                        Reflect.setField(node.target.user, node.reflect, _value);
                        _disp.text = '$_value';
                    });
                }
                _range;
            case 'mint.Label':
                new mint.Label({
                    parent:_parent, name: node.name,
                    x:node.x, y:node.y, w:node.w, h:node.h,
                    text: node.text, text_size: node.text_size, 
                    align:node.align, mouse_input:false
                }); 
            case 'mint.Panel':
                new mint.Panel({
                    parent:_parent, name: node.name,
                    x:node.x, y:node.y, w:node.w, h:node.h,
                }); 
            case 'mint.Control':
                new mint.Control({
                    parent:_parent, name: node.name,
                    x:node.x, y:node.y, w:node.w, h:node.h,
                }); 
            case _: null;
        }

        if(node.children != null) {
            for(_child in node.children) {
                control_for_node(_control, _child);
            }
        }

        return _control;
    }

    function add_tree_to_map(_control:mint.Control, _map:Map<String,mint.Control>) {
        _map.set(_control.name, _control);
        for(_child in _control.children) {
            _map.set(_child.name, _child);
            add_tree_to_map(_child, _map);
        }
    }

    function controls_for_nodes(_parent:mint.Control, nodes:Array<Node>) {

        var _list:Map<String, mint.Control> = new Map();
        var _roots:Array<mint.Control> = [];

        for(_node in nodes) {
            var _control = control_for_node(_parent, _node);
            add_tree_to_map(_control, _list);
            _roots.push(_control);
        }

        return { map:_list, roots:_roots };
    }

    function edit_node(_name:String, _label:String, _text:String, _reflect:String, _target:mint.Control) : Node {
        if(_target != null) {
            var _value = Reflect.field(_target.user, _reflect);
            if(_value != null) _text = '$_value';
            Reflect.setField(_target.user, _reflect, _text);
        }

        var _ww = Std.int(ed_props.w-12);
        var _px = 2;
        var _py = 2;
        var _lh = 22;

        return {
            { name:'$_name.container', type:'mint.Control', x:2, y:4, w:_ww, h:(_lh*2)+(_py*2), 
                children:[
                    { name:'$_name.label', type:'mint.Label', 
                        x:_px, y:_py, w: _ww-(_px*2), h:_lh, text: _label, align:left  },
                    { name:'$_name.edit', type:'mint.TextEdit', reflect:_reflect, target:_target,
                        x:_px, y:_lh+_py, w:_ww-(_px*2), h:_lh, text: _text },
                ]
            }
        }; //
    } //edit_node

    function label_node(_name:String, _label:String, ?_align:TextAlign) : Node {
        def(_align, left);

        var _ww = Std.int(ed_props.w-12);
        var _px = 2;
        var _py = 2;

        return { name:'$_name.label', type:'mint.Label', 
            x:_px, y:_py, w:_ww, h:22, text: _label, align:_align }
    }

    function check_node(_name:String, _label:String, _state:Null<Bool>, _reflect:String, _target:mint.Control) : Node {
        def(_state, false);
        if(_target != null) {
            var _value:Null<Bool> = Reflect.field(_target.user, _reflect);
            if(_value != null) _state = _value;
            Reflect.setField(_target.user, _reflect, _state);
        }

        var _ww = Std.int(ed_props.w-12);
        var _px = 2;
        var _py = 2;
        var _cw = 22;

        return {
            { name:'$_name.container', type:'mint.Control', x:2, y:4, w:178, h:24, 
                children:[
                    { name:'$_name.label', type:'mint.Label', 
                        x:_cw+(_px*4), y:0, w:_ww-(_cw+(_px*6)), h:_cw, text: _label, align:left  },
                    { name:'$_name.check', type:'mint.Checkbox', reflect:_reflect, target:_target,
                        x:_px, y:_py, w:_cw, h:_cw, state: _state },
                ]
            }
        }; //
    } //check_node

    function range_node(_name:String, _label:String, _value:Null<Float>, _min:Null<Float>,_max:Null<Float>,_step:Null<Float>, _reflect:String, _target:mint.Control) : Node {
        def(_value, 0.0);
        if(_target != null) {
            var _val:Null<Float> = Reflect.field(_target.user, _reflect);
            if(_val != null) _value = _val;
            Reflect.setField(_target.user, _reflect, _value);
        }

        var _ww = Std.int(ed_props.w-12);
        var _px = 2;
        var _py = 2;

        return {
            { name:'$_name.container', type:'mint.Control', x:2, y:4, w:_ww, h:42, 
                children:[
                    { name:'$_name.label', type:'mint.Label', 
                        x:_px, y:_py, w:_ww-(_px*2), h:22, text: _label, align:left  },
                    { name:'$_name.slider', type:'mint.Slider', reflect:_reflect, target:_target,
                        x:_px, y:24, w:_ww-(_px*2), h:18, min:_min, max:_max, value:_value, step:_step },
                ]
            }
        }; //
    } //range_node

    function bounds_node(_name:String, _label:String='bounds:') : Node {
        var _ww = Std.int(ed_props.w-12);
        var _px = 2; var _py = 2;
        var _p = 3; 
        var _bw = Math.floor((_ww-(_p*4.5))/4);
        var _yy = 3;

        return { name:'$_name.panel', type:'mint.Panel', 
            x:4, y:0, w:_ww-_px, h:28, children:[
                { name:'$_name.x', type:'mint.TextEdit', 
                    x:_px+(_bw+_p)*0,y:_yy,w:_bw,h:22, text_size:12, text:'0' },
                { name:'$_name.y', type:'mint.TextEdit', 
                    x:_px+(_bw+_p)*1,y:_yy,w:_bw,h:22, text_size:12, text:'0' },
                { name:'$_name.w', type:'mint.TextEdit', 
                    x:_px+(_bw+_p)*2,y:_yy,w:_bw,h:22, text_size:12, text:'0' },
                { name:'$_name.h', type:'mint.TextEdit', 
                    x:_px+(_bw+_p)*3,y:_yy,w:_bw,h:22, text_size:12, text:'0' },
            ] }
    }

    var prop_onbounds_last:Void->Void;
    function refresh_properties(_control:mint.Control, _clear:Bool) {

        ed_props.clear();
        
        if(_clear) {
            _control.onbounds.remove(prop_onbounds_last);
            prop_onbounds_last = null;            
        } else {

            var _nodes:Array<Node> = [
                label_node('parent', 'parent: ' + (_control.parent == null ? 'none' : _control.parent.name)),
                edit_node('name', 'name:', _control.name, null, null),
                label_node('boundslabel', 'bounds:'),
                bounds_node('bounds')
            ];

            var _items = controls_for_nodes(ui_canvas, _nodes);
            for(_item in _items.roots) ed_props.add_item(_item);

            //disable misleading hovers

                _items.map.get('boundslabel.label').mouse_input = false;

            //parent handling

                var _parent = _items.map.get('parent.label');
                    _parent.onmouseup.listen(function(_,_){
                        parenting = _control;
                        ui_info.text = 'select parent...';
                    });

            //name handling

                var _name:mint.TextEdit = cast _items.map.get('name.edit');
                    _name.onkeyup.listen(function(e,_){ 
                        if(e.key == KeyCode.enter) {
                            _control.name = _name.text;
                            _name.unfocus();
                        } else if(e.key == KeyCode.escape) {
                            _name.text = _control.name;
                            _name.unfocus();
                        }
                    });

            //bounds handling

                var _bounds = _items.map.get('bounds.panel');
                var _xe:mint.TextEdit = cast _bounds.children[0];
                var _ye:mint.TextEdit = cast _bounds.children[1];
                var _we:mint.TextEdit = cast _bounds.children[2];
                var _he:mint.TextEdit = cast _bounds.children[3];

                _xe.text = '${_control.x_local}';
                _ye.text = '${_control.y_local}';
                _we.text = '${_control.w}';
                _he.text = '${_control.h}';
                
                prop_onbounds_last = prop_onbounds.bind(_control, _xe,_ye,_we,_he);
                _control.onbounds.listen(prop_onbounds_last);

                _xe.onkeyup.listen(function(e,_){ 
                    if(e.key == KeyCode.enter) { _control.x_local = Std.parseFloat(_xe.text); _xe.unfocus(); } 
                    else if(e.key == KeyCode.escape) { _xe.unfocus(); _xe.text = '${_control.x_local}'; }
                });

                _ye.onkeyup.listen(function(e,_){ 
                    if(e.key == KeyCode.enter) { _control.y_local = Std.parseFloat(_ye.text); _ye.unfocus(); } 
                    else if(e.key == KeyCode.escape) { _ye.unfocus(); _ye.text = '${_control.y_local}'; }
                });
                _we.onkeyup.listen(function(e,_){ 
                    if(e.key == KeyCode.enter) { _control.w = Std.parseFloat(_we.text); _we.unfocus(); } 
                    else if(e.key == KeyCode.escape) { _we.unfocus(); _we.text = '${_control.w}'; }
                });
                _he.onkeyup.listen(function(e,_){ 
                    if(e.key == KeyCode.enter) { _control.h = Std.parseFloat(_he.text); _he.unfocus(); } 
                    else if(e.key == KeyCode.escape) { _he.unfocus(); _he.text = '${_control.h}'; }
                });

            //unique types

            add_nodes_for_type(ed_props, _control);

            //low priority common types

                var _low_nodes:Array<Node> = [
                    label_node('editprops', 'editor properties'),
                    edit_node('depth', 'depth:', '${_control.depth}', null, null),
                    label_node('spacer', ''),
                ];

                var _low_items = controls_for_nodes(ui_canvas, _low_nodes);
                for(_item in _low_items.roots) ed_props.add_item(_item);

                _low_items.map.get('editprops.label').mouse_input = false;
                _low_items.map.get('spacer.label').mouse_input = false;

                //depth handling

                    var _depth:mint.TextEdit = cast _low_items.map.get('depth.edit');
                        _depth.onkeyup.listen(function(e,_){ 
                            if(e.key == KeyCode.enter) {
                                _control.depth = Std.parseFloat(_depth.text);
                                _depth.unfocus();
                            } else if(e.key == KeyCode.escape) {
                                _depth.text = '${_control.depth}';
                                _depth.unfocus();
                            }
                        });

        } //clear

    } //

    function add_nodes_for_type(_into:mint.List, _control:mint.Control) {

        var _name = _control.name;
        var _type = _control.user.type;
        var _json_name = 'assets/inspector/${_type}.nodes.json';
        var _res = app.resources.json(_json_name);
        if(_res == null) {
            trace('inspector: no nodes file for `$_type` ($_json_name)');
            return;
        }

        var _list:Array<Dynamic> = _res.asset.json;
        if(_list == null) {
            trace('inspector: invalid nodes file for `$_type` ($_json_name), should be array of node descriptors.');
            return;
        }

        var _nodes:Array<Node> = [];

        for(_node in _list) {

            var _item:Node = switch(_node.type) {
                
                case 'edit': edit_node(_node.name, _node.label, _node.text, _node.reflect, _control);
                case 'check': check_node(_node.name, _node.label, _node.state, _node.reflect, _control);
                case 'range': range_node(_node.name, _node.label, _node.value, _node.min, _node.max, _node.step, _node.reflect, _control);

                case _: {
                    trace('inspector: unknown node type `${_node.type}` ($_json_name)');
                    null;
                }
            }

            if(_item != null) _nodes.push(_item);

        } //_node in _list

        var _items = controls_for_nodes(ui_canvas, _nodes);
        for(_item in _items.roots) _into.add_item(_item);

    } //nodes_for_type

    function select(control:mint.Control) {
        if(ed_canvas.focused!=null) deselect(ed_canvas.focused);
        control.focus();
        refresh_properties(control, false);
    }

    function deselect(control:mint.Control) {
        control.unfocus();
        refresh_properties(control, true);
    }

    override function onwindowsized(event:luxe.Screen.WindowEvent) {

        Luxe.camera.viewport = new luxe.Rectangle(0, 0, Luxe.screen.w, Luxe.screen.h);
        
        var _scale = Luxe.screen.device_pixel_ratio;

        ui_canvas.scale = _scale;
        ed_canvas.scale = _scale;

        ui_canvas.set_size(Luxe.screen.w/_scale, Luxe.screen.h/_scale);
        ed_canvas.set_size((Luxe.screen.w/_scale)-ui_tools.w-4, (Luxe.screen.h/_scale)-4);

    } //onwindowsized

    override function onmousemove(e) {

        if(!moving) ui_canvas.mousemove( Convert.mouse_event(e, ui_canvas.scale) );
        if(ui_canvas.marked == null) {

            if(parenting != null) {

                if(possible_parent != null) {
                    ui_info.text = 'select parent...';
                    (cast possible_parent.renderer:ControlRenderer).light.visible = false;
                    possible_parent = null;
                }

                var _possible = ed_canvas.topmost_at_point(e.x, e.y);
                if(_possible != null && 
                    _possible != parenting) 
                {
                    ui_info.text = 'parent to `${_possible.user.type}( ${_possible.name} )`?';
                    (cast _possible.renderer:ControlRenderer).light.visible = true;
                    possible_parent = _possible;
                }

            } else {

                ed_canvas.mousemove( Convert.mouse_event(e, ed_canvas.scale, Luxe.renderer.batcher.view) );

                var _display = ed_canvas.marked;
                if(_display == null) _display = ed_canvas.focused;

                if(_display != null) {
                    ui_info.text = '${_display.user.type}(${_display.name})\n${_display.x_local}, ${_display.y_local}, ${_display.w}, ${_display.h}';
                } else {
                    ui_info.text = '...';
                }

            }
        }

    }

    override function onmousewheel(e) {

        if(!moving) ui_canvas.mousewheel( Convert.mouse_event(e) );
        if(ui_canvas.marked == null) ed_canvas.mousewheel( Convert.mouse_event(e, ed_canvas.scale, Luxe.renderer.batcher.view) );

    }

    override function onmouseup(e) {

        if(!moving) ui_canvas.mouseup( Convert.mouse_event(e, ui_canvas.scale) );
        if(ui_canvas.marked == null) {

            if(parenting != null) {

                var _parent = possible_parent == null ? ed_canvas : possible_parent;
                if(_parent != null) {
                    var _child = parenting;
                    var _x = _child.x; 
                    var _y = _child.y;
                    _parent.add(_child);
                    _child.x = _x;
                    _child.y = _y;
                    (cast _parent.renderer:ControlRenderer).light.visible = false;
                    _parent = possible_parent = null;
                } 

                (cast parenting.renderer:ControlRenderer).light.visible = false;
                select(parenting);
                parenting = null;
                ui_info.text = '...';

            } else {
                ed_canvas.mouseup( Convert.mouse_event(e, ed_canvas.scale, Luxe.renderer.batcher.view) );
            }
        }

    }

    override function onmousedown(e) {

        ui_canvas.mousedown( Convert.mouse_event(e, ui_canvas.scale) );
        if(ui_canvas.marked == null && parenting == null) {

            if(ed_canvas.marked != null) {
                if(ed_canvas.focused!=ed_canvas.marked) {                    
                    select(ed_canvas.marked);
                }
            } else {
                if(ed_canvas.focused != null) {
                    deselect(ed_canvas.focused);
                }
            }
            
            ed_canvas.mousedown( Convert.mouse_event(e, ed_canvas.scale, Luxe.renderer.batcher.view) );

        }

    } //onmousedown

    override function onkeydown(e:luxe.Input.KeyEvent) {

        ui_canvas.keydown( Convert.key_event(e) );
        ed_canvas.keydown( Convert.key_event(e) );

    } //onkeydown

    override function ontextinput(e:luxe.Input.TextEvent) {

        ui_canvas.textinput( Convert.text_event(e) );
        ed_canvas.textinput( Convert.text_event(e) );

    } //ontextinput

    function do_options() {



    } //do_options

    function do_clear() {
        
        if(parenting != null) {
            (cast parenting.renderer:ControlRenderer).light.visible = false;
            parenting = null;
            ui_info.text = '...';
        }

        if(ed_canvas.focused!=null) {
            deselect(ed_canvas.focused);
        }

        ed_canvas.destroy_children();
        ed_canvas.unfocus();

    } //do_clear

    function do_load() {
        #if cpp
            var _path = dialogs.Dialogs.open('load mint json', [{ext:'json', desc:'mint json file'}]);
            if(_path != null && _path != '') {
                var _str = sys.io.File.getContent(_path);
                if(_str != null && _str.length > 0) {
                    load_string(_path, _str);
                } else {
                    trace('invalid file from path: $_path');
                }
            }
        #end
    }

    function do_save() {
        var _str = export();
        #if js
            var win = js.Browser.window.open('data:text/json,' + untyped encodeURIComponent(_str), "_blank");
            win.focus();
        #end
        #if cpp
            var _path = dialogs.Dialogs.save('save mint json', {ext:'json', desc:'mint json file'});
            if(_path != null && _path != '') {
                sys.io.File.saveContent(_path, _str);
            }
        #end
        trace('\n\n$_str\n\n');
    } //do_save

    var ui_preview: LoaderItems;
    function recursive_mouse_input(_control:mint.Control, _state:Bool) {
        _control.mouse_input = _state;
        for(_child in _control.children) recursive_mouse_input(_child, _state);
    }
    function do_preview() {
        if(ui_preview != null) {
            for(_item in ui_preview.roots) _item.destroy();
            ui_preview = null;
        } else {
            var _view_w = ui_canvas.w - ui_tools.w;
            var _view_h = ui_canvas.h;
            ui_preview = JSONLoader.parse(ui_canvas, 'preview', export(), 0, 0);
            var _root = ui_preview.roots[0];
            if(_root == null) {
                ui_preview = null;
                return;
            }
            if(_root.w < _view_w) _root.x_local = (_view_w/2)-(_root.w/2);
            if(_root.h < _view_h) _root.y_local = (_view_h/2)-(_root.h/2);
            recursive_mouse_input(_root, true);
        }
    }

    override function onkeyup(e:luxe.Input.KeyEvent) {

        if(e.keycode == Key.escape && parenting!=null) {
            (cast parenting.renderer:ControlRenderer).light.visible = false;
            parenting = null;
            ui_info.text = '...';
        }

        if(e.keycode == Key.key_p && (e.mod.ctrl || e.mod.meta)) {
            do_preview();
        }

        if(e.keycode == Key.escape && e.mod.shift) {
            Luxe.shutdown();
            return;
        }

        if(e.keycode == Key.key_9 && e.mod.ctrl) {
            ed_canvas.scale -= 0.1; 
            ui_canvas.scale -= 0.1;
        }

        if(e.keycode == Key.key_0 && e.mod.ctrl) {
            ed_canvas.scale += 0.1; 
            ui_canvas.scale += 0.1;
        }

        if(e.keycode == Key.key_s && (e.mod.ctrl || e.mod.meta)) {
            do_save();
        }

        if(e.keycode == Key.key_o && (e.mod.ctrl || e.mod.meta)) {
            do_load();
        }

        if(e.keycode == Key.key_d) {
            if(e.mod.meta || e.mod.ctrl) {
                if(ed_canvas.focused != null) {
                    duplicate(ed_canvas.focused);
                }
            }
        }

        if(e.keycode == Key.delete || e.keycode == Key.backspace) {
            if(ed_canvas.focused != null && 
                ed_canvas.captured == null && 
               ui_canvas.marked==null && 
               ui_canvas.focused==null &&
               ui_canvas.captured==null) {
                var _control = ed_canvas.focused;
                deselect(_control);
                _control.destroy();
                ed_canvas.unfocus();
            }
        }

        ui_canvas.keyup( Convert.key_event(e) );
        ed_canvas.keyup( Convert.key_event(e) );

    } //onkeyup

    override function onrender() {

        ui_canvas.render();
        ed_canvas.render();

    } //onrender

    override function update(dt:Float) {

        ui_canvas.update(dt);
        ed_canvas.update(dt);

        drag.zoomable = ui_canvas.marked == null;

    } //update

} //Main

typedef Node = {
    name: String,
    type: String,
    ?x:Int, ?y:Int,
    ?w:Int, ?h:Int,
    ?text:String, ?text_size:Int, ?align:TextAlign,
    ?reflect:String, ?target:mint.Control, ?state:Bool,
    ?min:Float, ?max:Float, ?value:Float, ?step:Float, 
    ?children:Array<Node>
}