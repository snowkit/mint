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

        bounds = Luxe.draw.rectangle({ x:control.x, y:control.y, w:control.w, h:control.h, color:color });
        resizer = Luxe.draw.rectangle({ x:control.right-rsize, y:control.bottom-rsize, w:rsize, h:rsize, color:color });
        select = Luxe.draw.rectangle({ x:control.x-2, y:control.y-2, w:control.w+4, h:control.h+4, color:colorsel, visible:false });
        light = Luxe.draw.rectangle({ x:control.x+1, y:control.y+1, w:control.w-2, h:control.h-2, color:colorlit, visible:false });

        text = new luxe.Text({
            batcher: render.options.batcher,
            bounds: new luxe.Rectangle(control.x, control.y, control.w, control.h),
            color: color,
            text: '${control.user.type}(${control.name})\n${control.x_local},${control.y_local},${control.w},${control.h}',
            point_size: 12,
            align: center,
            align_vertical: center,
            depth: render.options.depth + control.depth,
            visible: control.visible,
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
        text = null;
    }

    override function onbounds() {
        bounds.set_xywh(control.x, control.y, control.w, control.h);
        select.set_xywh(control.x-2, control.y-2, control.w+4, control.h+4);
        light.set_xywh(control.x+1, control.y+1, control.w-2, control.h-2);
        resizer.set_xywh(control.right-rsize, control.bottom-rsize, rsize, rsize);
        text.bounds = new luxe.Rectangle(control.x, control.y, control.w, control.h);
        text.text = '${control.user.type}(${control.name})\n${control.x_local},${control.y_local},${control.w},${control.h}';
    }

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
