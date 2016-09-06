package mint;

import mint.Control;

import mint.types.Types;
import mint.core.Signal;
import mint.core.Macros.*;


/** Options for constructing an Image */
typedef ImageOptions = {

    > ControlOptions,

        /** The image path/id.
            The rendering should translate the id as needed. */
    path: String,

} //ImageOptions


/**
    A simple image control
    Additional Signals: onchange
*/
@:allow(mint.render.Renderer)
class Image extends Control {

    var options: ImageOptions;

        /** The current image path/id. Read/Write */
    @:isVar public var path (default, set) : String;

        /** Emitted whenever the path/id is changed.
            `function(new_path:String)` */
    public var onchange: Signal<String->Void>;


    public function new(_options:ImageOptions) {

        options = _options;

        def(options.name, 'image.${Helper.uniqueid()}');

        super(_options);

        onchange = new Signal();

        path = def(options.path, '');

        renderer = rendering.get(Image, this);

        oncreate.emit();

    } //new

    public override function destroy() {

        super.destroy();

        onchange.clear();
        onchange = null;

    } //destroy

//Internal

    function set_path( _p:String ) {

        if(path == null) return path = _p;

        path = _p;

        onchange.emit(path);

        return path;

    } //set_path

} //Image
