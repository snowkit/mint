import luxe.Color;
import luxe.Vector;
import luxe.Log.*;

class ControlRenderer extends mint.render.Render {

    var bounds : phoenix.geometry.RectangleGeometry;
    var resizer : phoenix.geometry.RectangleGeometry;

    var color : luxe.Color;
    var text : luxe.Text;
    var render : EditorRendering;
    var rsize = 8;

    public function new( _render:EditorRendering, _control:mint.Control ) {

        render = _render;

        super(_render, _control);

        var rect = new luxe.Rectangle(control.x, control.y, control.w, control.h);
        var resizerect = new luxe.Rectangle(control.right-rsize, control.bottom-rsize, rsize, rsize);
        color = new Color(1,1,1,0.8);

        bounds = Luxe.draw.rectangle({ rect:rect, color:color });
        resizer = Luxe.draw.rectangle({ rect:resizerect, color:color });

        text = new luxe.Text({
            batcher: render.options.batcher,
            bounds: new luxe.Rectangle(control.x, control.y, control.w, control.h),
            color: color,
            text: '${control.name} ${control.x},${control.y},${control.w},${control.h}',
            point_size: 14,
            depth: render.options.depth + control.depth,
            group: render.options.group,
            visible: control.visible,
        });

        control.mouse_input = true;
        control.onmouseenter.listen(function(_,_){  color.a = 1;  });
        control.onmouseleave.listen(function(_,_){  color.a = 0.8;  });

    } //new

    override function ondestroy() {
        bounds.drop();
        resizer.drop();
        text.destroy();
        bounds = null;
        resizer = null;
        text = null;
    }

    override function onbounds() {
        bounds.set({ x:control.x, y:control.y, w:control.w, h:control.h, color:color, visible:control.visible });
        resizer.set({ x:control.right-rsize, y:control.bottom-rsize, w:rsize, h:rsize, color:color, visible:control.visible });
        text.bounds = new luxe.Rectangle(control.x, control.y, control.w, control.h);
        text.text = '${control.name} ${control.x},${control.y},${control.w},${control.h}';
    }

    override function onvisible( _visible:Bool ) {
        bounds.visible = text.visible = _visible;
    }

    override function ondepth( _depth:Float ) {
        bounds.depth = text.depth = _depth;
    }


}

class EditorRendering extends mint.render.Rendering {

    public var options: luxe.options.RenderProperties;

    public function new( ?_options:luxe.options.RenderProperties ) {

        super();

        options = def(_options, {});
        def(options.batcher, Luxe.renderer.batcher);
        def(options.depth, 0);
        def(options.group, 0);
        def(options.immediate, false);
        def(options.visible, true);

    } //new

    override function get<T:mint.Control, T1>( type:Class<T>, control:T ) : T1 {
        return cast switch(type) {
            case _: new ControlRenderer(this, cast control);
        }
    } //get

} //EditorRendering
