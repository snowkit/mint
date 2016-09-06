package mint;

import mint.Control;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


typedef ListOptions = {
    > ControlOptions,
}

class List extends Control {

    public var view : Scroll;
    public var items : Array<Control>;
    public var options : ListOptions;

    public var onselect : Signal<Int->Control->MouseEvent->Void>;
    public var onitementer : Signal<Int->Control->MouseEvent->Void>;
    public var onitemleave : Signal<Int->Control->MouseEvent->Void>;

    public function new( _options:ListOptions ) {

        items = [];
        options = _options;

        def(options.name, 'list.${Helper.uniqueid()}');
        def(options.mouse_input, true);

        super(options);

        onselect = new Signal();
        onitemleave = new Signal();
        onitementer = new Signal();

        view = new Scroll({
            parent : this,
            x: 0, y: 0, w: w, h: h,
            name : name + '.view',
            options: options.options.view,
            internal_visible: options.visible
        });

        renderer = rendering.get(List, this);

        oncreate.emit();

    } //new

    public function add_item( item:Control, offset_x:Float = 0.0, offset_y:Float = 0.0 ) {

        var _childbounds = view.container.children_bounds;

        item.y_local += _childbounds.bottom + offset_y;
        item.x_local += offset_x;

        view.add(item);

        item.mouse_input = true;
        items.push(item);

        item.onmouseup.listen(item_mousedown);
        item.onmouseenter.listen(item_mouseenter);
        item.onmouseleave.listen(item_mouseleave);

    } //add_item

    function item_mouseenter(event:MouseEvent, ctrl:Control ) {
        var idx = items.indexOf(ctrl);
        onitementer.emit(idx, ctrl, event);
    }

    function item_mouseleave(event:MouseEvent, ctrl:Control ) {
        var idx = items.indexOf(ctrl);
        onitemleave.emit(idx, ctrl, event);
    }

    function item_mousedown(event:MouseEvent, ctrl:Control ) {
        var idx = items.indexOf(ctrl);
        onselect.emit(idx, ctrl, event);
    }

    public function clear() {

        for(item in items) {
            item.destroy();
            item = null;
        }

        items = null;
        items = [];

        view.refresh_scroll();
        onselect.emit(-1, null, null);

    } //clear

    public override function destroy() {

        super.destroy();

        onselect.clear();
        onselect = null;
        onitementer.clear();
        onitementer = null;
        onitemleave.clear();
        onitemleave = null;

    } //destroy


    override function bounds_changed(_dx:Float=0.0, _dy:Float=0.0, _dw:Float=0.0, _dh:Float=0.0) {

        super.bounds_changed(_dx, _dy, _dw, _dh);

        if(view != null) view.set_size(w, h);

    } //bounds_changed

} //List
