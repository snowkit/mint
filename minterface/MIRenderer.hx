package minterface;

import luxe.Rectangle;

class MIRenderer {
	
	public var canvas 	: MICanvasRenderer;
	public var label 	: MILabelRenderer;

	public function new() {
		//this should stay blank to not needlessly create instances
	} //new

} //MIRenderer

class MICanvasRenderer {
	public function new(){}
	public function init( _canvas:MICanvas, _options:Dynamic ) { } //init
	public function translate( _canvas:MICanvas, _x:Float, _y:Float ) { } //translate
	public function set_clip( _canvas:MICanvas, _clip_rect:Rectangle ) { } //set_clip
} //MICanvasRenderer

class MILabelRenderer {
	public function new(){}
	public function init( _label:MILabel, _options:Dynamic ) { } //init
	public function translate( _label:MILabel, _x:Float, _y:Float ) { } //translate
	public function set_clip( _label:MILabel, ?_clip_rect:Rectangle=null ) { } //set_clip
} //MILabelRenderer

