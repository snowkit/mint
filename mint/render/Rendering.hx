package mint.render;

class Rendering {

        /** A list of Renderers, mapped to unique control instances.
            Modify this via follow/unfollow. */
    public var renderers : Map<mint.Control, mint.render.Renderer>;

    public function new() {

        renderers = new Map();

    } //new

        /** Overridden in subclass, tells this Rendering to render this control */
    public function render<T:mint.Control, T1>( type:Class<T>, control:T ) : T1 {

        trace('$type / $control in base Rendering implementation. This is probably not expected');

        return null;

    } //render

    public inline function stat() {

        return ' ${Lambda.count(renderers)}';

    } //state

    public function follow<T:mint.Control, TR:mint.render.Renderer>( control:T, renderer:TR ) {

        renderers.set( control, renderer );

        return renderer;

    } //follow

    public function unfollow<T:mint.Control, TR:mint.render.Renderer>( control:T, renderer:TR ) {

        renderers.remove( control );

        renderer = null;

    } //unfollow

} //Rendering
