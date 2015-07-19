package mint.render;


/** A rendering provider for a mint Control.
    Controls will typically ask the rendering provider
    for a concrete control `Renderer` instance to associate
    with a given control. Framework specific rendering providers
    will extend this class and return a `Renderer` instance for
    the requested type. i.e `if(type == mint.Canvas) return MyCanvasRenderer()` */
class Rendering {

    public function new() {}

        /** Overridden in subclass.
            Asks the Rendering service for a Renderer instance,
            For a given control class type and instance. */
    public function get<T:mint.Control, T1>( type:Class<T>, control:T ) : T1 {

        trace('$type / $control / This is probably not expected : landed in root Rendering class.');

        return null;

    } //get

} //Rendering
