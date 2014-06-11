package minterface;

import minterface.MITypes;
import minterface.MIControl;
import minterface.MILabel;
import minterface.MIList;

class MIDropdown extends MIControl {

    public var list : MIList;
    public var selected_label : MILabel;
    public var selected : String = '';

    public var is_open : Bool = false;

    public var onselect : String->MIControl->?MIMouseEvent->Void;

    public function new(_options:Dynamic) {

            //create the base control
        super(_options);
            //dropdowns can be clicked
        mouse_enabled = true;
            //create the list
        list = new MIList({
            parent : this,
            name : name + '.list',
            bounds : new MIRectangle( 0, bounds.h, bounds.w, 110 ),
            align : MITextAlign.left,
            onselect : onselected
        });

        selected_label = new MILabel({
            parent : this,
            bounds : new MIRectangle(5,0,bounds.w-10, bounds.h),
            text:_options.text,
            text_size: (_options.text_size == null) ? 14 : _options.text_size,
            name : name + '.selected_label',
            align : MITextAlign.left
        });

        renderer.dropdown.init( this, _options );

            //the list is hidden at start
        list.set_visible(false);

    } //new

    public function select(index:Int) {

        list.select(index);

    }

    private function onselected(v:String, l:MIList, e:MIMouseEvent) {

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

    public override function translate(?_x:Float = 0, ?_y:Float = 0, ?_offset:Bool = false ) {
        super.translate( _x, _y, _offset);
        renderer.dropdown.translate( this, _x, _y, _offset );
    }

    private override function set_depth( _depth:Float ) : Float {

        super.set_depth(_depth);

        renderer.dropdown.set_depth(this, _depth);

        return depth;

    } //set_depth

    public override function set_visible( ?_visible:Bool = true ) {
        super.set_visible(_visible);
        renderer.dropdown.set_visible(this,_visible);
    }

    public override function set_clip( ?_clip_rect:MIRectangle = null ) {
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

        if(e.button == MIMouseButton.left) {

            if(is_open) {
                close_list();
                return;
            }

            var m = new MIPoint(e.x, e.y);

            if( selected_label.real_bounds.point_inside(m) ) {
                open_list();
            }

        }//mouse left

    } //onmousedown

    public override function onmouseup(e) {
        super.onmouseup(e);
    }

}