
import MintParser;
import mint.Control;
import mint.Types;
import mint.render.LuxeMintRender;

class MintFormat {

    var controls:Map<String,Control>;

    public function new() {

        controls = new Map();

        var file_string = Luxe.loadText('assets/test.mint').text;
        var ctrls = new MintParser(byte.ByteData.ofString(file_string), 'assets/test.mint').parse();

        trace(ctrls);

        create(ctrls);

    }

    function create(ctrls:Array<Ctrl>, ?parent:Control) {
        for(ctrl in ctrls) {
            var type = ctrl.type.charAt(0).toUpperCase() + ctrl.type.substr(1);
                type = 'mint.$type';
            var exists = Type.resolveClass(type);
            if(exists != null) {
                trace('Found $type');

                var control:Control = null;

                if(type == 'mint.Canvas') {
                    var render = new LuxeMintRenderer();
                    var args = { renderer:render, bounds:new Rect(0,0,512,512) };
                    control = Type.createInstance(exists, [args]);
                } else {
                    var args : Dynamic = {};
                    for(field in ctrl.fields) {
                        Reflect.setField(args, field.key, field.val);
                    }
                        args.parent = parent;
                        args.bounds = new Rect(10,10,64,32);
                    control = Type.createInstance(exists, [args]);
                }

                if(control != null)
                    create(ctrl.children, control);

            } else {
                trace('Ignoring unknown control type $type');
            }
        }
    }
}