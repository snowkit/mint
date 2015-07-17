package mint;

import mint.Types;
import mint.Control;
import mint.Macros.*;

/** Options for constructing an Image */
typedef ImageOptions = {

    > ControlOptions,

        /** The image path/id.
            The renderer should translate the id as needed. */
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

        def(options.name, 'image');

        super(_options);

        mouse_input = def(options.mouse_input, false);

        renderinst = canvas.renderer.render(Image, this);

    } //new

//Internal

    function set_path( _p:String ) {

        path = _p;

        onchange.emit(path);

        return path;

    } //set_path

} //Image
