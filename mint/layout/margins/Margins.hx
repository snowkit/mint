package mint.layout.margins;


import mint.Control;
import mint.Macros.*;

class Margins {

    var margins : Map<Control, Array<Margin> >;
    var anchors : Map<Control, Array<Anchor> >;
    var sizers : Map<Control, Array<Sizer> >;

    public function new() {

        margins = new Map();
        anchors = new Map();
        sizers = new Map();

    } //new

    public function size( self:Control, ?other:Control, target:SizeTarget, value:Float ) {

        assertnull(self);
        def(other, self.parent);

        var list = sizers.get(self);
        if(list == null) list = [];

        list.push({
            target: target,
            value: value,
            other: other
        });

        sizers.set(self, list);

        other.onbounds.listen(function(){
            update_sizers(self);
        });

        update_sizers(self);

    } //size

    public function anchor( self:Control, ?other:Control, self_anchor:AnchorType, other_anchor:AnchorType ) {

        assertnull(self);
        def(other, self.parent);

        var list = anchors.get(self);
        if(list == null) list = [];

        list.push({
            self_anchor: self_anchor,
            other_anchor: other_anchor,
            other: other
        });

        anchors.set(self, list);

        other.onbounds.listen(function(){
            update_anchors(self);
        });

        update_anchors(self);

    } //anchor

    public function margin( self:Control, ?other:Control, target:MarginTarget, type:MarginType, value:Float ) {

        assertnull(self);
        def(other, self.parent);

        var list = margins.get(self);
        if(list == null) list = [];

        list.push({
            target: target,
            type: type,
            value: value,
            other: other
        });

        margins.set(self, list);

        other.onbounds.listen(function(){
            update_margins(self);
        });

        update_margins(self);

    } //margin

//Internal

    function update_sizers( child:Control ) {

        var list = sizers.get(child);
        if(list != null) {
            for(sizer in list) {
                var per = (sizer.value/100);
                switch(sizer.target) {
                    case width:   child.w = (child.parent.w * per);
                    case height:  child.h = (child.parent.h * per);
                }
            } //each sizer
        } //list

    } //update_sizers

    function update_anchors(self:Control) {

        var list = anchors.get(self);
        if(list != null) {
            for(anchor in list) {
                var ref = switch(anchor.other_anchor) {
                    case center_x:  anchor.other.x + (anchor.other.w/2);
                    case center_y:  anchor.other.y + (anchor.other.h/2);
                    case right:     anchor.other.right;
                    case bottom:    anchor.other.bottom;
                    case left:      anchor.other.x;
                    case top:       anchor.other.y;
                }

                switch(anchor.self_anchor) {
                    case center_x:  self.x = ref - (self.w/2);
                    case center_y:  self.y = ref - (self.h/2);
                    case right:     self.x = ref - self.w;
                    case bottom:    self.y = ref - self.h;
                    case left:      self.x = ref;
                    case top:       self.y = ref;
                }
            }
        } //list

    } //update_anchors

    function update_margins( self:Control ) {

        var list = margins.get(self);
        if(list != null) {
            for(info in list) {
                switch(info.type) {
                    case fixed: {
                        switch(info.target) {
                            case left:   self.x = Math.abs(info.other.x+info.value);
                            case top:    self.y = Math.abs(info.other.y+info.value);
                            case right:  self.w = Math.abs((info.other.right-info.value) - self.x);
                            case bottom: self.h = Math.abs((info.other.bottom-info.value) - self.y);
                        }
                    }
                    case percent: {
                        var per = (info.value/100);
                        switch(info.target) {
                            case left:   self.x = Math.abs(info.other.x+(info.other.w*per));
                            case top:    self.y = Math.abs(info.other.y+(info.other.h*per));
                            case right:  self.w = Math.abs((info.other.right-(info.other.w*per)) - self.x);
                            case bottom: self.h = Math.abs((info.other.bottom-(info.other.h*per)) - self.y);
                        }
                    }
                } //type
            } //each info
        } //list

    } //update_margins

} //Margins


@:enum abstract AnchorType(Int) from Int to Int {
    var center_x    = 1;
    var center_y    = 2;
    var left        = 3;
    var right       = 4;
    var top         = 5;
    var bottom      = 6;
}

@:enum abstract MarginType(Int) from Int to Int {
    var percent     = 1;
    var fixed       = 2;
}


@:enum abstract SizeTarget(Int) from Int to Int {
    var width       = 1;
    var height      = 2;
}

@:enum abstract MarginTarget(Int) from Int to Int {
    var left        = 1;
    var right       = 2;
    var top         = 3;
    var bottom      = 4;
}

//Internal

private typedef Margin = {
    type: MarginType,
    target: MarginTarget,
    value: Float,
    other: Control
}

private typedef Sizer = {
    target: SizeTarget,
    value: Float,
    other: Control
}

private typedef Anchor = {
    other_anchor: AnchorType,
    self_anchor: AnchorType,
    other: Control
}