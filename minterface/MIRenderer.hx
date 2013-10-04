package minterface;

import minterface.MITypes;

class MIRenderer {
	
	public var canvas 	: MICanvasRenderer;
	public var label 	: MILabelRenderer;
	public var button 	: MIButtonRenderer;
	public var list 	: MIListRenderer;
	public var scroll 	: MIScrollAreaRenderer;
	public var image 	: MIImageRenderer;
	public var window   : MIWindowRenderer;
	public var dropdown : MIDropdownRenderer;
	public var panel 	: MIPanelRenderer;
	public var checkbox : MICheckboxRenderer;

	public function new() {
		//this should stay blank to not needlessly create instances
	} //new

} //MIRenderer

class MICanvasRenderer {
	public function new(){}
	public function init( _control:MICanvas, _options:Dynamic ) { } //init
	public function destroy( _control:MICanvas ) {}
	public function translate( _control:MICanvas, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MICanvas, _clip_rect:MIRectangle ) { } //set_clip
	public function set_visible( _control:MICanvas, ?_visible:Bool=true ) { } //set_visible
	public function set_depth( _control:MICanvas, ?_depth:Float=0.0 ) { } //set_depth
} //MICanvasRenderer

class MILabelRenderer {
	public function new(){}
	public function init( _control:MILabel, _options:Dynamic ) { } //init
	public function destroy( _control:MILabel ) {}
	public function translate( _control:MILabel, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MILabel, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function set_visible( _control:MILabel, ?_visible:Bool=true ) { } //set_visible
	public function set_depth( _control:MILabel, ?_depth:Float=0.0 ) { } //set_depth
	public function set_text( _control:MILabel, ?_text:String='label' ) { } //set_text
} //MILabelRenderer


class MIButtonRenderer {
	public function new(){}
	public function init( _control:MIButton, _options:Dynamic ) { } //init
	public function destroy( _control:MIButton ) {}
	public function translate( _control:MIButton, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIButton, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function set_visible( _control:MIButton, ?_visible:Bool=true ) { } //set_visible
	public function set_depth( _control:MIButton, ?_depth:Float=0.0 ) { } //set_depth
} //MIButtonRenderer

class MIListRenderer {
	public function new(){}
	public function init( _control:MIList, _options:Dynamic ) { } //init
	public function destroy( _control:MIList ) {}
	public function translate( _control:MIList, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIList, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function select_item( _control:MIList, _selected:MIControl ) { } //select_item
	public function scroll( _control:MIList, _x:Float, _y:Float ) { } //scroll
	public function set_visible( _control:MIList, ?_visible:Bool=true ) { } //set_visible	
	public function set_depth( _control:MIList, ?_depth:Float=0.0 ) { } //set_depth
} //MIList

class MIImageRenderer {
	public function new(){}
	public function init( _control:MIImage, _options:Dynamic ) { } //init
	public function destroy( _control:MIImage ) {}
	public function translate( _control:MIImage, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIImage, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function set_visible( _control:MIImage, ?_visible:Bool=true ) { } //set_visible	
	public function set_depth( _control:MIImage, ?_depth:Float=0.0 ) { } //set_depth
} //MIImageRenderer

class MIWindowRenderer {
	public function new(){}
	public function init( _control:MIWindow, _options:Dynamic ) { } //init
	public function destroy( _control:MIWindow ) {}	
	public function translate( _control:MIWindow, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIWindow, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function set_visible( _control:MIWindow, ?_visible:Bool=true ) { } //set_visible	
	public function set_depth( _control:MIWindow, ?_depth:Float=0.0 ) { } //set_depth
} //MIWindowRenderer

class MIScrollAreaRenderer {
	public function new(){}
	public function init( _control:MIScrollArea, _options:Dynamic ) { } //init
	public function destroy( _control:MIScrollArea ) {}	
	public function translate( _control:MIScrollArea, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIScrollArea, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function refresh_scroll( _control:MIScrollArea, shx:Float, shy:Float, svx:Float, svy:Float, hv:Bool, vv:Bool ) { } //refresh_scroll
	public function set_visible( _control:MIScrollArea, ?_visible:Bool=true ) { } //set_visible
	public function set_depth( _control:MIScrollArea, ?_depth:Float=0.0 ) { } //set_depth
} //MIScrollAreaRenderer

class MIDropdownRenderer {
	public function new(){}
	public function init( _control:MIDropdown, _options:Dynamic ) { } //init
	public function destroy( _control:MIDropdown ) {}	
	public function translate( _control:MIDropdown, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIDropdown, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function set_visible( _control:MIDropdown, ?_visible:Bool=true ) { } //set_visible
	public function set_depth( _control:MIDropdown, ?_depth:Float=0.0 ) { } //set_depth
} //MIDropdownRenderer

class MIPanelRenderer {
	public function new(){}
	public function init( _control:MIPanel, _options:Dynamic ) { } //init
	public function destroy( _control:MIPanel ) {}
	public function translate( _control:MIPanel, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MIPanel, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function set_visible( _control:MIPanel, ?_visible:Bool=true ) { } //set_visible
	public function set_depth( _control:MIPanel, ?_depth:Float=0.0 ) { } //set_depth
} //MIPanelRenderer

class MICheckboxRenderer {
	public function new(){}
	public function init( _control:MICheckbox, _options:Dynamic ) { } //init
	public function destroy( _control:MICheckbox ) {}
	public function translate( _control:MICheckbox, _x:Float, _y:Float ) { } //translate
	public function set_clip( _control:MICheckbox, ?_clip_rect:MIRectangle=null ) { } //set_clip
	public function set_visible( _control:MICheckbox, ?_visible:Bool=true ) { } //set_visible
	public function set_depth( _control:MICheckbox, ?_depth:Float=0.0 ) { } //set_depth
} //MICheckboxRenderer
