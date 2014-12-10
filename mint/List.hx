package mint;

import mint.Types;
import mint.Control;

class List extends Control {
#if no

    public var view : ScrollArea;
    public var items : Array<Control>;
    public var multiselect : Bool = false;
    public var onselect : String->Control->?MouseEvent->Void;
    public var _options : Dynamic;

    var _point_size : Float = 14;

    public function new(__options:Dynamic) {

        items = [];

            //create the base control
        super(__options);
            //
        renderer.list.init(this, __options);
            //
        multiselect = (__options.multiselect == null) ? false : __options.multiselect;
        onselect = (__options.onselect == null) ? null : __options.onselect;
            //set the text size from the default or the options
        if(__options.point_size != null) _point_size = __options.point_size;

        var _bounds = __options.bounds.clone();

            _bounds.x = 0;
            _bounds.y = 0;

        view = new ScrollArea({
            parent : this,
            bounds : _bounds,
            name : name + '.view',
            onscroll : onscroll
        });

        _options = __options;
        if(_options.align == null) {
            _options.align = TextAlign.center;
        }

    } //new

    private function onscroll( _x:Float = 0, _y:Float = 0 ) {

        renderer.list.scroll(this, _x, _y);

    } //onscroll

    public function clear() {

        for(item in items) {
            item.destroy();
            item = null;
        }

        items = null;
        items = [];

        renderer.list.select_item(this, null);

    } //clear

    public function select( _index:Int ) {

        if(_index < items.length) {
            label_selected(items[_index], null);
        }

    } //select

    public function add_item( _item:String, ?_name:String ) {

        var _childbounds = view.children_bounds;

        var l = new Label({
            text : _item,
            onclick : label_selected,
            name : _name == null ? name + '.item.' + _item : _name,
            bounds : new Rect(0, _childbounds.bottom, bounds.w, 30),
            parent : view,
            depth : depth,
            point_size : _point_size,
            align : _options.align
        });

            //clip the label by the scroll view's bounds
        l.clip_with(view);
        l.mouse_enabled = true;

        items.push(l);

    } //add_item

    public override function translate(?_x:Float=0, ?_y:Float=0, ?_offset:Bool = false ) {

        super.translate( _x,_y, _offset );

        renderer.list.translate( this, _x, _y, _offset );

        for(_item in view.children) {
            _item.clip_with(view);
        } //_item in children

    } //translate

    private function label_selected(_control:Control, e:MouseEvent) {

        var _label:Label = cast _control;
        renderer.list.select_item(this, _control);

        //call callback
        if(onselect != null) {
            onselect(_label.text, _label, e);
        } //onselect

    } //label_selected

    public function add_items( _items:Array<String> ) {
        for(_item in _items) {
            add_item(_item);
        } //item
    } //add_items

    public override function set_visible( ?_visible:Bool = true ) {

        super.set_visible(_visible);

        renderer.list.set_visible(this,_visible);

    } //set_visible


    private override function set_depth( _depth:Float ) : Float {

        super.set_depth(_depth);

        renderer.list.set_depth(this, _depth);

        return depth;

    } //set_depth

#end
} //List
