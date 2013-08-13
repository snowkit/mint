package minterface;

import luxe.Rectangle;

class MIRenderer {
	
	public var canvas 	: MICanvasRenderer;
	public var label 	: MILabelRenderer;
	public var button 	: MIButtonRenderer;
	public var scroll 	: MIScrollAreaRenderer;
	public var image 	: MIImageRenderer;
	public var window   : MIWindowRenderer;

	public function new() {
		//this should stay blank to not needlessly create instances
	} //new

} //MIRenderer

class MICanvasRenderer {
	public function new(){}
	public function init( _control:MICanvas, _options:Dynamic ) { } //init
	public function translate( _control:MICanvas, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MICanvas, _clip_rect:Rectangle ) { } //set_clip
} //MICanvasRenderer

class MILabelRenderer {
	public function new(){}
	public function init( _control:MILabel, _options:Dynamic ) { } //init
	public function translate( _control:MILabel, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MILabel, ?_clip_rect:Rectangle=null ) { } //set_clip
} //MILabelRenderer

class MIButtonRenderer {
	public function new(){}
	public function init( _control:MIButton, _options:Dynamic ) { } //init
	public function translate( _control:MIButton, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIButton, ?_clip_rect:Rectangle=null ) { } //set_clip
} //MIButtonRenderer

class MIImageRenderer {
	public function new(){}
	public function init( _control:MIImage, _options:Dynamic ) { } //init
	public function translate( _control:MIImage, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIImage, ?_clip_rect:Rectangle=null ) { } //set_clip
} //MIImageRenderer

class MIWindowRenderer {
	public function new(){}
	public function init( _control:MIWindow, _options:Dynamic ) { } //init
	public function translate( _control:MIWindow, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIWindow, ?_clip_rect:Rectangle=null ) { } //set_clip
} //MIWindowRenderer

class MIScrollAreaRenderer {
	public function new(){}
	public function init( _control:MIScrollArea, _options:Dynamic ) { } //init
	public function translate( _control:MIScrollArea, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIScrollArea, ?_clip_rect:Rectangle=null ) { } //set_clip
	public function refresh_scroll( _control:MIScrollArea, shx:Float, shy:Float, svx:Float, svy:Float, hv:Bool, vv:Bool ) { } //refresh_scroll
} //MIScrollAreaRenderer

