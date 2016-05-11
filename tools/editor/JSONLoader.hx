
import mint.types.Types;
import mint.Control;
import mint.core.Macros.*;

class JSONLoader {

    public static function parse(_parent:mint.Control, _name:String, _json:String, _offset_x:Int=0, _offset_y:Int=0) {
        
        load(_parent, _name, haxe.Json.parse(_json), _offset_x, _offset_y);

    } //parse

    public static function load(_parent:mint.Control, _name:String, _json:Dynamic, _offset_x:Int=0, _offset_y:Int=0) {

        var _list:Array<Dynamic> = _json;

        for(_node in _list) {
            load_control(_parent, _name, _node, _offset_x, _offset_y);
        }

    } //

    static function load_control(_parent:mint.Control, _source:String, _node:Dynamic, _offset_x:Int=0, _offset_y:Int=0) : mint.Control {

        var _options:Dynamic = {}

        var _class = Type.resolveClass(_node.type);
        if(_class == null) {
            trace('Unknown type found, `${_node.type}`, ignoring. found in `$_source`');
            return null;
        }

        var _fields = Reflect.fields(_node);
        for(_fieldn in _fields) {
            if(_fieldn=='type') continue;
            if(_fieldn=='children') continue;
            var _value:Dynamic = Reflect.field(_node, _fieldn);
            if(_fieldn=='align'||_fieldn=='align_vertical') {
                _value = switch(_value) {
                    case 'bottom' : TextAlign.bottom;
                    case 'center' : TextAlign.center;
                    case 'left'   : TextAlign.left;
                    case 'right'  : TextAlign.right;
                    case 'top'    : TextAlign.top;
                    case _        : TextAlign.center;
                }
            }
            Reflect.setField(_options, _fieldn, _value);
        }


        def(_options.x, 0);
        def(_options.y, 0);
        _options.x += _offset_x;
        _options.y += _offset_y;

        _options.parent = _parent;

        var _control:mint.Control = Type.createInstance(_class, [_options]);

            if(_node.children != null) {
                var _children:Array<Dynamic> = _node.children;
                for(_child in _children) {
                    load_control(_control, _source, _child);
                }
            }

        return _control;

    } //load_control

} //JSONLoader