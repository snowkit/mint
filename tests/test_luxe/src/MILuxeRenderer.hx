package ;

import luxe.Rectangle;
import minterface.MIRenderer;
import minterface.MIRenderer.MILabelRenderer;
import minterface.MIRenderer.MICanvasRenderer;

import minterface.MILabel;
import minterface.MICanvas;

import luxe.Text;
import luxe.Color;
import luxe.Vector;

import phoenix.geometry.QuadGeometry;


class MILuxeRenderer extends MIRenderer {

	public function new() {
		
		super();

		canvas = new MICanvasLuxeRenderer();
		label = new MILabelLuxeRenderer();

	} //new

} //MIRenderer

class MICanvasLuxeRenderer extends MICanvasRenderer {
	
	public override function init( _canvas:MICanvas, _options:Dynamic ) {

		var back = new QuadGeometry({			
			x: _canvas.real_bounds.x,
            y: _canvas.real_bounds.y,
            width: _canvas.real_bounds.w,
            height: _canvas.real_bounds.h,
            color : new Color().rgb(0x212121),
            depth : _canvas.depth
		});

		Luxe.addGeometry( back );

			//store inside the element	
		_canvas.render_items.set('back', back);

	} //init

} //MICanvasLuxeRenderer

class MILabelLuxeRenderer extends MILabelRenderer {


	public override function init( _label:MILabel, _options:Dynamic ) {
		
		var text = new Text( _options );

        _label.render_items.set('text', text);

        	//default clipping to the canvas the control belongs to
        set_clip( _label, _label.canvas.real_bounds );

	} //init

	public override function translate( _label:MILabel, _x:Float, _y:Float ) {

		var text:Text = cast _label.render_items.get('text');

		text.pos = new Vector( text.pos.x + _x, text.pos.y + _y );
		
	} //translate

	public override function set_clip( _label:MILabel, ?clip_rect : Rectangle = null ) {

		var text:Text = cast _label.render_items.get('text');

		if(clip_rect == null) {
			text.geometry.clip = false;
		} else {
			text.geometry.clip = true;
        	text.geometry.clip_rect = clip_rect.clone();
		}

	} //set clip

} //MILabelLuxeRenderer
