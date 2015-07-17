package mint.layout.margins;


import mint.Control;

class Margins {

    var margins : Map<Control, Array<Margin> >;

    public function new() {

        margins = new Map();

    }

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
            update_child(child);
        });

        update_child(child);

    } //margin

    function update_child( child:Control ) {

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

    } //update_child

}

typedef Margin = {
    type: MarginType,
    target: MarginTarget,
    value: Float
}

@:enum abstract MarginType(Int) from Int to Int {

    var percent = 1;
    var fixed = 2;

}

@:enum abstract MarginTarget(Int) from Int to Int {

    var right = 1;
    var bottom = 2;

}