package minterface;

import luxe.Rectangle;

class MIRenderer {
	
	public var canvas 	: MICanvasRenderer;
	public var label 	: MILabelRenderer;
	public var button 	: MIButtonRenderer;
	public var list 	: MIListRenderer;
	public var scroll 	: MIScrollAreaRenderer;
	public var image 	: MIImageRenderer;
	public var window   : MIWindowRenderer;
	public var dropdown : MIDropdownRenderer;

	public function new() {
		//this should stay blank to not needlessly create instances
	} //new

} //MIRenderer

class MICanvasRenderer {
	public function new(){}
	public function init( _control:MICanvas, _options:Dynamic ) { } //init
	public function translate( _control:MICanvas, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MICanvas, _clip_rect:Rectangle ) { } //set_clip
	public function set_visible( _control:MICanvas, ?_visible:Bool=true ) { } //set_visible
} //MICanvasRenderer

class MILabelRenderer {
	public function new(){}
	public function init( _control:MILabel, _options:Dynamic ) { } //init
	public function translate( _control:MILabel, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MILabel, ?_clip_rect:Rectangle=null ) { } //set_clip
	public function set_visible( _control:MILabel, ?_visible:Bool=true ) { } //set_visible
} //MILabelRenderer

class MIButtonRenderer {
	public function new(){}
	public function init( _control:MIButton, _options:Dynamic ) { } //init
	public function translate( _control:MIButton, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIButton, ?_clip_rect:Rectangle=null ) { } //set_clip
	public function set_visible( _control:MIButton, ?_visible:Bool=true ) { } //set_visible
} //MIButtonRenderer

class MIListRenderer {
	public function new(){}
	public function init( _control:MIList, _options:Dynamic ) { } //init
	public function translate( _control:MIList, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIList, ?_clip_rect:Rectangle=null ) { } //set_clip
	public function select_item( _control:MIList, _selected:MIControl ) { } //select_item
	public function scroll( _control:MIList, _x:Float, _y:Float ) { } //scroll
	public function set_visible( _control:MIList, ?_visible:Bool=true ) { } //set_visible	
} //MIList

class MIImageRenderer {
	public function new(){}
	public function init( _control:MIImage, _options:Dynamic ) { } //init
	public function translate( _control:MIImage, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIImage, ?_clip_rect:Rectangle=null ) { } //set_clip
	public function set_visible( _control:MIImage, ?_visible:Bool=true ) { } //set_visible	
} //MIImageRenderer

class MIWindowRenderer {
	public function new(){}
	public function init( _control:MIWindow, _options:Dynamic ) { } //init
	public function translate( _control:MIWindow, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIWindow, ?_clip_rect:Rectangle=null ) { } //set_clip
	public function set_visible( _control:MIWindow, ?_visible:Bool=true ) { } //set_visible	
} //MIWindowRenderer

class MIScrollAreaRenderer {
	public function new(){}
	public function init( _control:MIScrollArea, _options:Dynamic ) { } //init
	public function translate( _control:MIScrollArea, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIScrollArea, ?_clip_rect:Rectangle=null ) { } //set_clip
	public function refresh_scroll( _control:MIScrollArea, shx:Float, shy:Float, svx:Float, svy:Float, hv:Bool, vv:Bool ) { } //refresh_scroll
	public function set_visible( _control:MIScrollArea, ?_visible:Bool=true ) { } //set_visible
} //MIScrollAreaRenderer

class MIDropdownRenderer {
	public function new(){}
	public function init( _control:MIDropdown, _options:Dynamic ) { } //init
	public function translate( _control:MIDropdown, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIDropdown, ?_clip_rect:Rectangle=null ) { } //set_clip
	public function set_visible( _control:MIDropdown, ?_visible:Bool=true ) { } //set_visible
} //MIDropdownRenderer
