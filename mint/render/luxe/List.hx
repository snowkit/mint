package mint.render.luxe;

import mint.Types;
import mint.Renderer;

import mint.render.luxe.LuxeMintRender;
import mint.render.luxe.Convert;

import luxe.Text;
import luxe.Color;
import phoenix.geometry.RectangleGeometry;

class List extends mint.render.Base {

    public var list : mint.List;
    public var text : Text;

    public var selected_color: Int = 0x9dca63;
    public var hover_color: Int = 0xffffff;

    // public var select_rects: Array<RectangleGeometry>;
    // public var hover_rect: RectangleGeometry;

    public function new( _render:Renderer, _control:mint.List ) {

        super(_render, _control);
        list = _control;

        list.onitementer.listen(onitementer);
        list.onitemleave.listen(onitemleave);
        list.onselect.listen(onselect);

        // select_rects = [];

        // hover_rect = Luxe.draw.rectangle({
        //     color: new Color(1,1,1,0.1).rgb(hover_color),
        //     x: 0, y:0, w:0, h:0, depth:_control.depth
        // });

        // var r = Luxe.draw.rectangle({
        //     color: new Color(1,1,1,1).rgb(selected_color),
        //     x: 0, y:0, w:0, h:0, depth:_control.depth
        // });
        // select_rects.push(r);

        connect();
    }

    function onitementer(idx, ctrl:mint.Control, e) {
        if(!selected) {
            // var r = Convert.rect(ctrl.real_bounds);
            // hover_rect.set({ rect:r, color:new Color(1,1,1,0.2) });
            // hover_rect.color.tween(0.5,{a:0.1});
            // hover_rect.depth = ctrl.depth+(ctrl.nodes*0.001)+0.00001;
        }
    }

    function onitemleave(idx, ctrl, e) {
        // if(!selected) hover_rect.color.tween(0.5,{a:0});
    }

    var selected = false;
    function onselect(idx, ctrl:Control, e) {
        selected = (null != ctrl);
        // trace("SELECT " + selected + "/" + (ctrl != null ? ctrl.name : 'null'));
        // if(selected) {
        //     var r = Convert.rect(ctrl.real_bounds);
        //     select_rects[0].set({ rect:r, color:new Color(1,1,1,1).rgb(selected_color) });
        //     select_rects[0].depth = ctrl.depth+(ctrl.nodes*0.001)+0.00002;
        // } else {
        //     trace('lose selection');
        //     select_rects[0].color.tween(0.5,{a:0});
        // }
    }

    override function ondestroy() {
        disconnect();
        destroy();

        // hover_rect.drop();
        // select_rects[0].drop();
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            // visual.clip_rect = null;
        } else {
            // visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        }
    } //onclip


    override function onvisible( _visible:Bool ) {
        // hover_rect.visible = _visible;
        // select_rects[0].visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        // select_rects[0].depth = list.depth+(list.nodes*0.001)+0.00002;
        // hover_rect.depth = list.depth+(list.nodes*0.001)+0.00002;
    } //ondepth

} //List
