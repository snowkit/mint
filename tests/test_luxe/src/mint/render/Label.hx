package mint.render;

import mint.Types;
import mint.Renderer;

import mint.render.LuxeMintRender;
import luxe.Text;
import luxe.Color;

class Label extends mint.render.Base {

    var label : mint.Label;
    var text : Text;

    public function new( _render:Renderer, _control:mint.Label ) {

        super(_render, _control);
        label = _control;

        trace('label create / ${control.name}');
        text = new luxe.Text({
            bounds: Convert.rect(control.real_bounds),
            color: new Color(),
            text: label.text,
            align: Convert.text_align(label.label_options.align),
            align_vertical: Convert.text_align(label.label_options.align),
            point_size: label.label_options.point_size,
            depth: control.depth,
            visible: control.visible,
        });

        text.clip_rect = Convert.rect(control.clip_rect);

        connect();
        label.ontext.listen(ontext);
        control.mouseenter.listen(function(e,c){
            text.color = new Color().rgb(0xf6007b);
        });
        control.mouseleave.listen(function(e,c){
            text.color = new Color().rgb(0xffffff);
        });
    }

    function ontext(_text:String) {
        text.text = _text;
    }

    override function ondestroy() {
        disconnect();
        label.ontext.remove(ontext);

        text.destroy();
        text = null;

        destroy();
    }

    override function onclip( _rect:Rect ) {
        trace('label / clip / $_rect');
        if(_rect == null) text.clip_rect = null;
        else text.clip_rect = Convert.rect(_rect);
    } //onclip

    override function ontranslate( _x:Float=0.0, _y:Float=0.0, _offset:Bool=false ) {
        trace('label / translate / $_x / $_y / $_offset');
        text.pos.add_xyz(_x, _y);
    } //ontranslate

    override function onvisible( _visible:Bool ) {
        trace('label / visible / $_visible');
        text.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        trace('label / depth / $_depth');
        text.depth = _depth;
    } //ondepth

} //Label
