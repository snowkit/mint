package mint;

interface ControlRenderer {
    @:allow(Renderer)
    private var renderer : Renderer;
}

class Renderer {

        /** A list of ControlRenderers, mapped to unique control instances. */
    @:noCompletion
    public var renderers : Map<Control, mint.ControlRenderer>;

    public function new(){
        renderers = new Map();
    }

        /** Overridden in subclass, tells this Renderer to render this control */
    public function render<T:Control, T1>( type:Class<T>, control:T ) : T1 {
        trace('$type / $control');
        return null;
    }

    public function stat() {
        return ' ${Lambda.count(renderers)}';
    }

    public function follow<T:Control, TR:mint.ControlRenderer>( control:T, renderer:TR ) {
        renderers.set( control, renderer );
        return renderer;
    }

    public function unfollow<T:Control, TR:mint.ControlRenderer>( control:T, renderer:TR ) {
        renderers.remove( control );
        renderer = null;
    }

}
