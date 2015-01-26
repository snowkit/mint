package mint;

import mint.Types;
import mint.Control;
import mint.Signal;

typedef ListOptions = {
    > ControlOptions,
    ? multiselect: Bool,
    ? onselect: Int->MouseEvent->Void,
}

class List extends Control {

    public var view : ScrollArea;
    public var items : Array<Control>;
    public var multiselect : Bool = false;
    public var onselect : Signal<Int->MouseEvent->Void>;
    public var list_options : ListOptions;

    public function new( _options:ListOptions ) {

        items = [];
        list_options = _options;

        super(list_options);

        if(list_options.mouse_enabled == null){
            mouse_enabled = true;
        }

        if(list_options.multiselect != null) {
            multiselect = list_options.multiselect;
        }

        var view_bounds = list_options.bounds.clone();
            view_bounds.x = 0; view_bounds.y = 0;

        view = new ScrollArea({
            parent : this,
            bounds : view_bounds,
            name : name + '.view',
            // onscroll : onscroll
        });

        // _options = __options;
        // if(_options.align == null) {
        //     _options.align = TextAlign.center;
        // }

    } //new

    public function add_item( item:Control ) {

        var _childbounds = view.children_bounds;

        item.bounds = new Rect(item.bounds.x, item.bounds.y+_childbounds.bottom, item.bounds.w, item.bounds.h);
        view.add(item);

        items.push(item);

    } //add_item

    // public function clear() {

        //     for(item in items) {
        //         item.destroy();
        //         item = null;
        //     }

        //     items = null;
        //     items = [];

        //     renderer.list.select_item(this, null);

        // } //clear

        // public function select( _index:Int ) {

        //     if(_index < items.length) {
        //         label_selected(items[_index], null);
        //     }

        // } //select

   

        // public override function translate(?_x:Float=0, ?_y:Float=0, ?_offset:Bool = false ) {

        //     super.translate( _x,_y, _offset );

        //     renderer.list.translate( this, _x, _y, _offset );

        //     for(_item in view.children) {
        //         _item.clip_with(view);
        //     } //_item in children

        // } //translate

        // function label_selected(_control:Control, e:MouseEvent) {

        //     var _label:Label = cast _control;
        //     renderer.list.select_item(this, _control);

        //     //call callback
        //     if(onselect != null) {
        //         onselect(_label.text, _label, e);
        //     } //onselect

        // } //label_selected

        // public function add_items( _items:Array<String> ) {
        //     for(_item in _items) {
        //         add_item(_item);
        //     } //item
        // } //add_items

} //List
