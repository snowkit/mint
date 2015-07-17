package mint.layout.margins;


import mint.Control;

class Margins {

    var margins : Map<Control, Array<Margin> >;
    var anchors : Map<Control, Array<Anchor> >;

    public function new() {

        margins = new Map();
        anchors = new Map();

    }

    public function anchor( child:Control, child_anchor:AnchorType, parent_anchor:AnchorType ) {

        var list = anchors.get(child);
        if(list == null) list = [];

        list.push({
            child_anchor: child_anchor,
            parent_anchor: parent_anchor
        });

        anchors.set(child, list);

        child.parent.onbounds.listen(function(){
            update_anchors(child);
        });

        update_anchors(child);

    } //anchor

    function update_anchors(child:Control) {

        var list = anchors.get(child);
        if(list != null) {
            for(anchor in list) {
                var ref = 0.0;
                switch(anchor.parent_anchor) {
                    case center_x:  ref = child.parent.x + (child.parent.w/2);
                    case center_y:  ref = child.parent.y + (child.parent.h/2);
                    case right:     ref = child.parent.right;
                    case bottom:    ref = child.parent.bottom;
                    case left:      ref = child.parent.x;
                    case top:       ref = child.parent.y;
                    case _:
                }

                switch(anchor.child_anchor) {
                    case center_x:  child.x = ref - (child.w/2);
                    case center_y:  child.y = ref - (child.h/2);
                    case right:     child.x = ref - child.w;
                    case bottom:    child.y = ref - child.h;
                    case left:      child.x = ref;
                    case top:       child.y = ref;
                    case _:
                }
            }
        } //list

    } //update_anchors

    public function margin( child:Control, target:MarginTarget, type:MarginType, value:Float ) {

        var list = margins.get(child);
        if(list == null) list = [];

        list.push({
            target: target,
            type: type,
            value: value
        });

        margins.set(child, list);

        child.parent.onbounds.listen(function(){
            update_margins(child);
        });

        update_margins(child);

    } //margin

    function update_margins( child:Control ) {

        var list = margins.get(child);
        if(list != null) {
            for(info in list) {
                switch(info.type) {
                    case fixed: {
                        switch(info.target) {
                            case right:
                                child.w = Math.abs((child.parent.right-info.value) - child.x);
                            case bottom:
                                child.h = Math.abs((child.parent.bottom-info.value) - child.y);
                        }
                    }
                    case percent: {
                        var per = (info.value/100);
                        switch(info.target) {
                            case right:
                                child.w = Math.abs((child.parent.right-(child.parent.w*per)) - child.x);
                            case bottom:
                                child.h = Math.abs((child.parent.bottom-(child.parent.h*per)) - child.y);
                        }
                    }
                } //type
            } //each info
        } //list

    } //update_margins

}

typedef Margin = {
    type: MarginType,
    target: MarginTarget,
    value: Float
}

typedef Anchor = {
    parent_anchor: AnchorType,
    child_anchor: AnchorType
}

@:enum abstract AnchorType(Int) from Int to Int {
    var center_x  = 1;
    var center_y  = 2;
    var left    = 3;
    var right   = 4;
    var top     = 5;
    var bottom  = 6;
}

@:enum abstract MarginType(Int) from Int to Int {

    var percent = 1;
    var fixed = 2;

}

@:enum abstract MarginTarget(Int) from Int to Int {

    var right = 1;
    var bottom = 2;

}