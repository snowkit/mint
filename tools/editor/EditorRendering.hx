import luxe.Color;
import luxe.Vector;
import luxe.Log.*;

class ControlRenderer extends mint.render.Render {

    public var select : phoenix.geometry.RectangleGeometry;
    public var light : phoenix.geometry.RectangleGeometry;
    public var bounds : phoenix.geometry.RectangleGeometry;
    public var resizer : phoenix.geometry.RectangleGeometry;

    public var color : luxe.Color;
    public var colorsel : luxe.Color;
    public var colorlit : luxe.Color;
    public var text : luxe.Text;
    var render : EditorRendering;
    var rsize = 8;

    public function new( _render:EditorRendering, _control:mint.Control ) {

        render = _render;

        super(_render, _control);

        color = new Color(1,1,1,0.8);
        colorsel = new Color(1,0.2,0.1,1);
        colorlit = new Color(1,0.2,0.1,1);

        var _inner = cs(1);
        var _outer = cs(2);

        bounds = Luxe.draw.rectangle({ x:sx, y:sy, w:sw, h:sh, color:color });
        resizer = Luxe.draw.rectangle({ x:cs(control.right-rsize), y:cs(control.bottom-rsize), w:cs(rsize), h:cs(rsize), color:color });
        select = Luxe.draw.rectangle({ x:sx-_outer, y:sy-_outer, w:sw+(_outer*2), h:sh+(_outer*2), color:colorsel, visible:false });
        light = Luxe.draw.rectangle({ x:sx+_inner, y:sy+_inner, w:sw-(_inner*2), h:sh-(_inner*2), color:colorlit, visible:false });

        text = new luxe.Text({
            batcher: render.options.batcher,
            bounds: new luxe.Rectangle(sx, sy, sw, sh),
            color: color,
            text: '${control.user.type}(${control.name})\n${control.x_local},${control.y_local},${control.w},${control.h}',
            point_size: cs(12),
            align: center,
            align_vertical: center,
            depth: render.options.depth + control.depth,
            visible: false,
        });

        control.mouse_input = true;
        control.onmouseenter.listen(function(_,_){ text.visible = true || control.isfocused; color.a = 1;  });
        control.onmouseleave.listen(function(_,_){ text.visible = false || control.isfocused; color.a = 0.7;  });
        control.onfocused.listen(function(state:Bool) { 
            select.visible = state; 
            text.visible = state;
            for(_child in control.children) {
                var r:ControlRenderer = cast _child.renderer;
                r.light.visible = state;
            }
        });

        control.onrenamed.listen(function(_prev:String,_name:String) { 
            text.text = '${control.user.type}(${_name})\n${control.x_local},${control.y_local},${control.w},${control.h}';
        });

    } //new

    override function ondestroy() {

        bounds.drop();
        resizer.drop();
        select.drop();
        light.drop();
        text.destroy();

        bounds = null;
        resizer = null;
        select = null;
        light = null;
        text = null;

    } //ondestroy

    override function onbounds() {

        var _inner = cs(1);
        var _outer = cs(2);

        bounds.set_xywh(sx, sy, sw, sh);
        select.set_xywh(sx-_outer, sy-_outer, sw+(_outer*2), sh+(_outer*2));
        light.set_xywh(sx+_inner, sy+_inner, sw-(_inner*2), sh-(_inner*2));
        resizer.set_xywh(cs(control.right-rsize), cs(control.bottom-rsize), cs(rsize), cs(rsize));

        text.bounds = new luxe.Rectangle(sx, sy, sw, sh);
        text.text = '${control.user.type}(${control.name})\n${control.x_local},${control.y_local},${control.w},${control.h}';

    } //onbounds

    override function onvisible( _visible:Bool ) {
        bounds.visible = text.visible = _visible;
    }

    override function ondepth( _depth:Float ) {
        bounds.depth = text.depth =  _depth;
    }


}

class EditorRendering extends mint.render.Rendering {

    public var options: luxe.options.RenderProperties;

    public function new( ?_options:luxe.options.RenderProperties ) {

        super();

        options = def(_options, {});
        def(options.batcher, Luxe.renderer.batcher);
        def(options.depth, 0);
        def(options.immediate, false);
        def(options.visible, true);

    } //new

    override function get<T:mint.Control, T1>( type:Class<T>, control:T ) : T1 {
        return cast switch(type) {
            case _: new ControlRenderer(this, cast control);
        }
    } //get

} //EditorRendering
