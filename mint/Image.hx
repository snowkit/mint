package mint;

import mint.Types;
import mint.Control;

/** Options for constructing an Image */
typedef ImageOptions = {

    > ControlOptions,

        /** The image path/id.
            The renderer should translate this as is appropriate. */
    path: String,

} //ImageOptions

/**
    A simple image control
    Additional Signals: onchange
*/
@:allow(mint.ControlRenderer)
class Image extends Control {

    var options: ImageOptions;

        /** The current image path/id. Read/Write */
    @:isVar public var path (default, set) : String = '';

        /** Emitted whenever the path/id is changed.
            `function(new_path:String)` */
    public var onchange: Signal<String->Void>;


    public function new(_options:ImageOptions) {

        options = _options;

        mouse_enabled = false;

        super(_options);

        canvas.renderer.render(Image, this);

    } //new

//Internal

    function set_path( _p:String ) {

        path = _p;

        onchange.emit(path);

        return path;

    } //set_path

} //Image
