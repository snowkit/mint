package mint;

import mint.Types;
import mint.Control;
import mint.Label;
import mint.List;

class Dropdown extends Control {
#if no

    public var list : List;
    public var selected_label : Label;
    public var selected : String = '';

    public var is_open : Bool = false;

    public var onselect : String->Control->?MouseEvent->Void;

    var _point_size : Float = 14;
    var _height : Float = 110;

    public function new(_options:Dynamic) {

        options = _options;

        def(options.name, 'dropdown');

            //create the base control
        super(_options);
            //dropdowns can be clicked
        mouse_enabled = true;
            //set the text size from the default or the options
        if(_options.point_size != null) _point_size = _options.point_size;
        if(_options.height != null) _height = _options.height;

            //create the list
        list = new List({
            parent : this,
            name : name + '.list',
            x: 0, y: h, w: w, h: _height,
            align : TextAlign.left,
            point_size : _point_size,
            onselect : onselected
        });

        selected_label = new Label({
            parent : this,
            bounds : new Rect(5,0,bounds.w-10, bounds.h),
            text:_options.text,
            point_size: _point_size,
            name : name + '.selected_label',
            align : TextAlign.left
        });

        render = renderer.dropdown.init( this, _options );

            //the list is hidden at start
        list.set_visible(false);

    } //new

    public function select(index:Int) {

        list.select(index);

    }

    function onselected(v:String, l:List, e:MouseEvent) {

        selected = v;
        selected_label.text = selected;
        close_list();

        if(onselect != null) {
            onselect(selected, this, e);
        }

    } //onselect

    public function add_item( _item:String ) {
        list.add_item(_item);
        list.set_visible(is_open);
    }

    public function add_items( _items:Array<String> ) {
        list.add_items(_items);
        list.set_visible(is_open);
    }

    override function set_depth( _depth:Float ) : Float {

        super.set_depth(_depth);

        renderer.dropdown.set_depth(this, _depth);

        return depth;

    } //set_depth

    public override function set_visible( ?_visible:Bool = true ) {
        super.set_visible(_visible);
        renderer.dropdown.set_visible(this,_visible);
    }

    public override function set_clip( ?_clip_rect:Rect = null ) {
        super.set_clip(_clip_rect);
        renderer.dropdown.set_clip(this,_clip_rect);
    }

    public function close_list() {

        canvas.modal = null;
        real_bounds.h = bounds.h;

        list.set_visible(false);
        list.depth = depth+0.001;
        is_open = false;

    } //close_list

    public function open_list() {

            //make sure it's always on top
        list.depth = canvas.depth+1;
        canvas.modal = list;

            //make it visible
        list.set_visible(true);

            //adjust the bounds so we get mouse events still
        real_bounds.h = bounds.h + list.bounds.h;

            //and flag it
        is_open = true;

    } //open_list

    public override function onmousedown(e) {

        super.onmousedown(e);

        if(e.button == MouseButton.left) {

            if(is_open) {
                close_list();
                return;
            }

            var m = new Point(e.x, e.y);

            if( selected_label.contains(m.x, m.y) ) {
                open_list();
            }

        }//mouse left

    } //onmousedown

    public override function onmouseup(e) {
        super.onmouseup(e);
    }

#end
}