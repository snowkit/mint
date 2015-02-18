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
    public function render<T:Control>( type:Class<T>, control:T ) {
        trace('$type / $control');
    }

    public function stat() {
        return ' ${Lambda.count(renderers)}';
    }

    function follow( control:Control, renderer:mint.ControlRenderer ) {
        renderers.set(control, renderer);
    }

    @:allow(mint.ControlRenderer)
    function unfollow<T:Control>(control:T, renderer:mint.ControlRenderer) {
        renderers.remove(control);
        renderer = null;
    }

}
