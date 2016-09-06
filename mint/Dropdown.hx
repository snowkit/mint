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

/** A simple dropdown control that can contain any other controls
    Additional signals: onselect */
@:allow(mint.render.Renderer)
class Dropdown extends Control {

    public var list : List;
    public var label : Label;
    public var is_open : Bool = false;

    public var onselect : Signal<Int->Control->MouseEvent->Void>;

    var _height : Float = 110;

    var options: DropdownOptions;

    public function new( _options:DropdownOptions ) {

        options = _options;

        def(options.name, 'dropdown.${Helper.uniqueid()}');
        def(options.mouse_input, true);

            //create the base control
        super(options);

        onselect = new Signal();

        def(options.align, TextAlign.left);
        def(options.align_vertical, TextAlign.center);
        def(options.text_size, 14);

        list = new List({
            parent : this,
            name : name + '.list',
            x: 0, y: options.h+1, w: w-1, h: _height,
            options: options.options.list,
            internal_visible : options.visible
        });

        list.onselect.listen(onselected);
        list.onmousedown.listen(ondeselect);

        label = new Label({
            parent : this,
            x:5, y:0, w:w-10, h:h,
            text: options.text,
            text_size: options.text_size,
            name : name + '.label',
            options: options.options.label,
            align : options.align,
            align_vertical : options.align_vertical,
            internal_visible : options.visible
        });

        renderer = rendering.get( Dropdown, this );

        list.set_visible(false);

        oncreate.emit();

    } //new

    function ondeselect(e:MouseEvent, c:Control) {

        if(!list.contains(e.x,e.y)) {
            close_list();
        }

    } //ondeselect

    function onselected(idx:Int, c:Control, e:MouseEvent) {

        onselect.emit(idx, c, e);
        close_list();

    } //onselected

    public function add_item( _item:Control, offset_x:Float = 0.0, offset_y:Float = 0.0 ) {
        list.add_item(_item, offset_x, offset_y);
        list.set_visible(is_open);
    }

    public function close_list() {

        list.uncapture();
        list.set_visible(false);

        //since removed by bring to front, readd
        list.x = 0;
        list.y = h+1;
        add(list);
        
        is_open = false;

    } //close_list

    public function open_list() {

        list.set_visible(true);

        //bring above everything
        canvas.bring_to_front(list);
        //move to absolute space
        list.x = x;
        list.y = y+h+1;

        list.capture();

        is_open = true;

    } //open_list

    public override function destroy() {

        super.destroy();

        onselect.clear();
        onselect = null;

    } //destroy

    var skip_mouse_up = false;

    public override function mousedown(e) {

        super.mousedown(e);

        if(e.button == MouseButton.left) {

            var _inside = contains(e.x, e.y);
            if(_inside) {
                
                if(!is_open) {
                    open_list();
                    skip_mouse_up = true;
                } else {
                    close_list();
                }

            } //!inside

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

    override function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0) {

        super.bounds_changed(_dx, _dy, _dw, _dh);

        if(list != null) {
            if(is_open) list.set_pos(x, y+h+1);
            list.set_size(w, list.h);
        }

        if(label != null) label.set_size(w-1, h);

    } //bounds_changed

} //Dropdown
