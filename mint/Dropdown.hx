package mint;

import mint.Types;
import mint.Control;
import mint.Label;
import mint.List;
import mint.Macros.*;

/** Options for constructing a Button */
typedef DropdownOptions = {

    > LabelOptions,

} //DropdownOptions



class Dropdown extends Control {

    public var list : List;
    public var selected_label : Label;

    public var is_open : Bool = false;

    var _point_size : Float = 14;
    var _height : Float = 110;

    var options: DropdownOptions;

    public function new( _options:DropdownOptions ) {

        options = _options;

        def(options.name, 'dropdown');

            //create the base control
        super(options);
            //dropdowns can be clicked
        mouse_input = true;
            //set the text size from the default or the options
        if(options.point_size != null) _point_size = options.point_size;

            //create the list
        list = new List({
            parent : this,
            name : name + '.list',
            x: 0, y: options.h+8, w: w-1, h: _height,
            visible : options.visible
        });

        list.onselect.listen(onselected);

        selected_label = new Label({
            parent : this,
            x:5, y:0, w:w-10, h:h,
            text: options.text,
            point_size: _point_size,
            name : name + '.selected_label',
            align : TextAlign.left,
            visible : options.visible
        });

        renderinst = render_service.render( Dropdown, this );

            //the list is hidden at start
        list.set_visible(false);

    } //new

    public function select(index:Int) {

        // list.select(index);

    }

    function onselected(idx:Int, c:Control, e:MouseEvent) {

        trace('selected $idx');
        selected_label.text = '$idx';
        close_list();

    } //onselected

    public function add_item( _item:Control, offset_x:Float = 0.0, offset_y:Float = 0.0 ) {
        list.add_item(_item, offset_x, offset_y);
        list.set_visible(is_open);
    }

    public function close_list() {

        canvas.modal = null;
        h = options.h;

        list.set_visible(false);
        list.depth = depth+0.001;
        is_open = false;

    } //close_list

    public function open_list() {

            //make sure it's always on top
        list.depth = canvas.next_depth();
        canvas.modal = list;

            //make it visible
        list.set_visible(true);

            //adjust the bounds so we get mouse events still
        h = options.h + 9 + list.h;

            //and flag it
        is_open = true;

    } //open_list

    public override function mousedown(e) {

        super.mousedown(e);

        if(e.button == MouseButton.left) {

            if(is_open) {
                close_list();
                return;
            }

            if( selected_label.contains(e.x, e.y) ) {
                open_list();
            }

        }//mouse left

    } //onmousedown

    override function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0, ?_offset:Bool = false ) {

        super.bounds_changed(_dx, _dy, _dw, _dh, _offset);

        if(list != null) list.set_size(w, list.h);
        if(selected_label != null) selected_label.set_size(w, h);

    } //bounds_changed

} //Dropdown
