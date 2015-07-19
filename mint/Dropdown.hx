package mint;

import mint.Control;
import mint.Label;
import mint.List;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing a Dropdown */
typedef DropdownOptions = {

    > LabelOptions,

} //DropdownOptions


class Dropdown extends Control {

    public var list : List;
    public var label : Label;
    public var is_open : Bool = false;

    public var onselect : Signal<Int->Control->MouseEvent->Void>;

    var _height : Float = 110;

    var options: DropdownOptions;

    public function new( _options:DropdownOptions ) {

        options = _options;

        def(options.name, 'dropdown');

            //create the base control
        super(options);

        onselect = new Signal();

        mouse_input = true;

        def(options.align, TextAlign.left);
        def(options.align_vertical, TextAlign.center);
        def(options.text_size, 14);

        list = new List({
            parent : this,
            name : name + '.list',
            x: 0, y: options.h+1, w: w-1, h: _height,
            visible : options.visible
        });

        list.onselect.listen(onselected);

        label = new Label({
            parent : this,
            x:5, y:0, w:w-10, h:h,
            text: options.text,
            text_size: options.text_size,
            name : name + '.label',
            align : options.align,
            align_vertical : options.align_vertical,
            visible : options.visible
        });

        renderer = rendering.get( Dropdown, this );

        list.set_visible(false);

        oncreate.emit();

    } //new

    public function select(index:Int) {

        // list.select(index);

    }

    function onselected(idx:Int, c:Control, e:MouseEvent) {

        onselect.emit(idx, c, e);
        close_list();

    } //onselected

    public function add_item( _item:Control, offset_x:Float = 0.0, offset_y:Float = 0.0 ) {
        list.add_item(_item, offset_x, offset_y);
        list.set_visible(is_open);
    }

    public function close_list() {

        canvas.modal = null;

        list.set_visible(false);
        list.depth = depth+0.001;
        is_open = false;

    } //close_list

    public function open_list() {

        list.depth = canvas.next_depth();
        canvas.modal = list;

        list.set_visible(true);

        is_open = true;

    } //open_list

    var skip_mouse_up = false;

    public override function mousedown(e) {

        super.mousedown(e);

        if(e.button == MouseButton.left) {

            if( contains(e.x, e.y) && !is_open ) {
                open_list();
                skip_mouse_up = true;
            }

        }//mouse left

    } //onmousedown

    public override function mouseup(e) {

        super.mouseup(e);

        if(e.button == MouseButton.left) {

            if(is_open && !skip_mouse_up) {
                close_list();
                return;
            }

            skip_mouse_up = false;

        }//mouse left

    } //onmousedown

    override function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0, ?_offset:Bool = false ) {

        super.bounds_changed(_dx, _dy, _dw, _dh, _offset);

        if(list != null) list.set_size(w, list.h);
        if(label != null) label.set_size(w-1, h);

    } //bounds_changed

} //Dropdown
