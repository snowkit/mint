package mint;

import mint.Types;

class Renderer {

    public var canvas   : CanvasRenderer;
    public var label    : LabelRenderer;
    public var button   : ButtonRenderer;
    public var list     : ListRenderer;
    public var scroll   : ScrollAreaRenderer;
    public var image    : ImageRenderer;
    public var window   : WindowRenderer;
    public var dropdown : DropdownRenderer;
    public var panel    : PanelRenderer;
    public var checkbox : CheckboxRenderer;

    public function new() {
        //this should stay blank to not needlessly create instances
    } //new

} //Renderer

class CanvasRenderer {
    public function new(){}
    public function init( _control:Canvas, _options:Dynamic ) { } //init
    public function destroy( _control:Canvas ) {}
    public function translate( _control:Canvas, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:Canvas, _clip_rect:Rect ) { } //set_clip
    public function set_visible( _control:Canvas, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:Canvas, ?_depth:Float=0.0 ) { } //set_depth
} //CanvasRenderer

class LabelRenderer {
    public function new(){}
    public function init( _control:Label, _options:Dynamic ) { } //init
    public function destroy( _control:Label ) {}
    public function translate( _control:Label, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:Label, ?_clip_rect:Rect=null ) { } //set_clip
    public function set_visible( _control:Label, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:Label, ?_depth:Float=0.0 ) { } //set_depth
    public function set_text( _control:Label, ?_text:String='label' ) { } //set_text
} //LabelRenderer


class ButtonRenderer {
    public function new(){}
    public function init( _control:Button, _options:Dynamic ) { } //init
    public function destroy( _control:Button ) {}
    public function translate( _control:Button, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:Button, ?_clip_rect:Rect=null ) { } //set_clip
    public function set_visible( _control:Button, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:Button, ?_depth:Float=0.0 ) { } //set_depth
} //ButtonRenderer

class ListRenderer {
    public function new(){}
    public function init( _control:List, _options:Dynamic ) { } //init
    public function destroy( _control:List ) {}
    public function translate( _control:List, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:List, ?_clip_rect:Rect=null ) { } //set_clip
    public function select_item( _control:List, _selected:Control ) { } //select_item
    public function scroll( _control:List, _x:Float, _y:Float ) { } //scroll
    public function set_visible( _control:List, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:List, ?_depth:Float=0.0 ) { } //set_depth
} //List

class ImageRenderer {
    public function new(){}
    public function init( _control:Image, _options:Dynamic ) { } //init
    public function destroy( _control:Image ) {}
    public function translate( _control:Image, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:Image, ?_clip_rect:Rect=null ) { } //set_clip
    public function set_visible( _control:Image, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:Image, ?_depth:Float=0.0 ) { } //set_depth
} //ImageRenderer

class WindowRenderer {
    public function new(){}
    public function init( _control:Window, _options:Dynamic ) { } //init
    public function destroy( _control:Window ) {}
    public function translate( _control:Window, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:Window, ?_clip_rect:Rect=null ) { } //set_clip
    public function set_visible( _control:Window, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:Window, ?_depth:Float=0.0 ) { } //set_depth
} //WindowRenderer

class ScrollAreaRenderer {
    public function new(){}
    public function init( _control:ScrollArea, _options:Dynamic ) { } //init
    public function destroy( _control:ScrollArea ) {}
    public function translate( _control:ScrollArea, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:ScrollArea, ?_clip_rect:Rect=null ) { } //set_clip
    public function refresh_scroll( _control:ScrollArea, shx:Float, shy:Float, svx:Float, svy:Float, hv:Bool, vv:Bool ) { } //refresh_scroll
    public function set_visible( _control:ScrollArea, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:ScrollArea, ?_depth:Float=0.0 ) { } //set_depth
    public function get_handle_bounds( _control:mint.ScrollArea, ?vertical:Bool=true ) : Rect { return new Rect(); }
} //ScrollAreaRenderer

class DropdownRenderer {
    public function new(){}
    public function init( _control:Dropdown, _options:Dynamic ) { } //init
    public function destroy( _control:Dropdown ) {}
    public function translate( _control:Dropdown, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:Dropdown, ?_clip_rect:Rect=null ) { } //set_clip
    public function set_visible( _control:Dropdown, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:Dropdown, ?_depth:Float=0.0 ) { } //set_depth
} //DropdownRenderer

class PanelRenderer {
    public function new(){}
    public function init( _control:Panel, _options:Dynamic ) { } //init
    public function destroy( _control:Panel ) {}
    public function translate( _control:Panel, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:Panel, ?_clip_rect:Rect=null ) { } //set_clip
    public function set_visible( _control:Panel, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:Panel, ?_depth:Float=0.0 ) { } //set_depth
} //PanelRenderer

class CheckboxRenderer {
    public function new(){}
    public function init( _control:Checkbox, _options:Dynamic ) { } //init
    public function destroy( _control:Checkbox ) {}
    public function translate( _control:Checkbox, _x:Float, _y:Float, ?_offset:Bool = false ) { } //translate
    public function set_clip( _control:Checkbox, ?_clip_rect:Rect=null ) { } //set_clip
    public function set_visible( _control:Checkbox, ?_visible:Bool=true ) { } //set_visible
    public function set_depth( _control:Checkbox, ?_depth:Float=0.0 ) { } //set_depth
} //CheckboxRenderer
