package mint.layout.margins;


import mint.Control;
import mint.core.Macros.*;

typedef Layouts = {
    margins: Array<Margin>,
    anchors: Array<Anchor>,
    sizers: Array<Sizer>
}

class Margins {

    var observed : Map<Control, Layouts>;

    public function new() {

        observed = new Map();

    } //new

    public function size( self:Control, ?other:Control, target:SizeTarget, value:Float ) {

        assertnull(self);
        def(other, self.parent);

        var lay = get(other);

        var sizer: Sizer = {
            target: target,
            value: value,
            self: self,
            other: other
        };

        lay.sizers.push( sizer );
        update_sizer( sizer );

        self.ondestroy.listen(function(){
            lay.sizers.remove(sizer);
        });

    } //size

    public function anchor( self:Control, ?other:Control, self_anchor:AnchorType, other_anchor:AnchorType, offset:Int=0 ) {

        assertnull(self);
        def(other, self.parent);

        var lay = get(other);

        var anchor: Anchor = {
            self_anchor: self_anchor,
            other_anchor: other_anchor,
            self: self,
            other: other,
            offset: offset
        };

        lay.anchors.push( anchor );
        update_anchor( anchor );

        self.ondestroy.listen(function(){
            lay.anchors.remove(anchor);
        });

    } //anchor

    public function margin( self:Control, ?other:Control, target:MarginTarget, type:MarginType, value:Float ) {

        assertnull(self);
        def(other, self.parent);

        var lay = get(other);

        var margin: Margin = {
            target: target,
            type: type,
            value: value,
            self: self,
            other: other
        };

        lay.margins.push( margin );
        update_margin( margin );

        self.ondestroy.listen(function(){
            lay.margins.remove(margin);
        });

    } //margin

//Internal

    function get(other:Control) : Layouts {

        if(observed.exists(other)) {
            return observed.get(other);
        }

        var ref = { margins:[], anchors:[], sizers:[] };

        observed.set(other, ref);
        other.ondestroy.listen(function(){
            observed.remove(other);
            ref.anchors = null;
            ref.margins = null;
            ref.sizers = null;
        });
        other.onbounds.listen( update_layout.bind(other) );

        return ref;

    } //get

    function update_layout(other:Control) {

        var lay = observed.get(other);

        if(lay.margins.length > 0) for(m in lay.margins) update_margin(m);
        if(lay.anchors.length > 0) for(a in lay.anchors) update_anchor(a);
        if(lay.sizers.length > 0)  for(s in lay.sizers)  update_sizer(s);

    } //update_layout

    function update_margin(margin:Margin) {

        var self = margin.self;
        var other = margin.other;
        var value = margin.value;
        var target = margin.target;

        switch(margin.type) {
            case fixed: {
                switch(target) {
                    case left:   self.x = Math.abs(other.x+value);
                    case top:    self.y = Math.abs(other.y+value);
                    case right:  self.w = Math.abs((other.right-value) - self.x);
                    case bottom: self.h = Math.abs((other.bottom-value) - self.y);
                }
            }
            case percent: {
                var per = (value/100);
                switch(target) {
                    case left:   self.x = Math.abs(other.x+(other.w*per));
                    case top:    self.y = Math.abs(other.y+(other.h*per));
                    case right:  self.w = Math.abs((other.right-(other.w*per)) - self.x);
                    case bottom: self.h = Math.abs((other.bottom-(other.h*per)) - self.y);
                }
            }
        } //type

    } //update_margin

    function update_anchor(anchor:Anchor) {

        var other = anchor.other;
        var self = anchor.self;

        var ref = switch(anchor.other_anchor) {
            case center_x:  other.x + (other.w/2);
            case center_y:  other.y + (other.h/2);
            case right:     other.right;
            case bottom:    other.bottom;
            case left:      other.x;
            case top:       other.y;
        }

        ref += anchor.offset;

        switch(anchor.self_anchor) {
            case center_x:  self.x = ref - (self.w/2);
            case center_y:  self.y = ref - (self.h/2);
            case right:     self.x = ref - self.w;
            case bottom:    self.y = ref - self.h;
            case left:      self.x = ref;
            case top:       self.y = ref;
        }

    } //update_anchor

    function update_sizer(sizer:Sizer) {

        var self = sizer.self;
        var other = sizer.other;
        var per = (sizer.value/100);

        switch(sizer.target) {
            case width:   self.w = (other.w * per);
            case height:  self.h = (other.h * per);
        }

    } //update_sizer

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
    self: Control,
    other: Control
}

private typedef Sizer = {
    target: SizeTarget,
    value: Float,
    self: Control,
    other: Control
}

private typedef Anchor = {
    other_anchor: AnchorType,
    self_anchor: AnchorType,
    self: Control,
    other: Control,
    offset: Int
}