
[![Logo](../../images/logo.png)](../../api/index.html)

<hr/>
<a href="#" id="search_bar" onclick="return;"><div> search API <em>(or start typing anywhere)</em> </div></a>
<hr/>

<script src="../../js/omnibar.js"> </script>
<link rel="stylesheet" type="text/css" href="../../css/omnibar.css" media="all">

<div id="omnibar"> <a href="#" onclick="return" id="omnibar_close"></a> <input id="omnibar_text" type="text" placeholder="search types..."></input></div>
<script  id="typelist" data-relpath="../../" data-types="mint.Button,mint.ButtonOptions,mint.Canvas,mint.CanvasOptions,mint.Checkbox,mint.CheckboxOptions,mint.ChildBounds,mint.Control,mint.ControlOptions,mint.Dropdown,mint.DropdownOptions,mint.Image,mint.ImageOptions,mint.KeySignal,mint.Label,mint.LabelOptions,mint.List,mint.ListOptions,mint.MouseSignal,mint.Panel,mint.PanelOptions,mint.Progress,mint.ProgressOptions,mint.Scroll,mint.ScrollOptions,mint.Slider,mint.SliderOptions,mint.TextEdit,mint.TextEditOptions,mint.TextSignal,mint.Window,mint.WindowOptions,mint.core.Macros,mint.core.Signal,mint.core.unifill.CodePoint,mint.core.unifill.CodePointIter,mint.core.unifill.Exception,mint.core.unifill.InternalEncoding,mint.core.unifill.InternalEncodingBackwardIter,mint.core.unifill.InternalEncodingIter,mint.core.unifill.Unicode,mint.core.unifill.Unifill,mint.core.unifill.Utf,mint.core.unifill.Utf16,mint.core.unifill.Utf32,mint.core.unifill.Utf8,mint.core.unifill.UtfIter,mint.core.unifill.UtfTools,mint.core.unifill._CodePoint.CodePoint_Impl_,mint.core.unifill._InternalEncoding.UtfX,mint.core.unifill._Utf16.StringU16,mint.core.unifill._Utf16.StringU16Buffer,mint.core.unifill._Utf16.StringU16Buffer_Impl_,mint.core.unifill._Utf16.StringU16_Impl_,mint.core.unifill._Utf16.Utf16Impl,mint.core.unifill._Utf8.StringU8,mint.core.unifill._Utf8.StringU8_Impl_,mint.core.unifill._Utf8.Utf8Impl,mint.layout.margins.AnchorType,mint.layout.margins.Layouts,mint.layout.margins.MarginTarget,mint.layout.margins.MarginType,mint.layout.margins.Margins,mint.layout.margins.SizeTarget,mint.layout.margins._Margins.Anchor,mint.layout.margins._Margins.AnchorType_Impl_,mint.layout.margins._Margins.Margin,mint.layout.margins._Margins.MarginTarget_Impl_,mint.layout.margins._Margins.MarginType_Impl_,mint.layout.margins._Margins.SizeTarget_Impl_,mint.layout.margins._Margins.Sizer,mint.render.Render,mint.render.Renderer,mint.render.Rendering,mint.render.luxe.Button,mint.render.luxe.Canvas,mint.render.luxe.Checkbox,mint.render.luxe.Convert,mint.render.luxe.Dropdown,mint.render.luxe.Image,mint.render.luxe.Label,mint.render.luxe.List,mint.render.luxe.LuxeMintRender,mint.render.luxe.Panel,mint.render.luxe.Progress,mint.render.luxe.Scroll,mint.render.luxe.Slider,mint.render.luxe.TextEdit,mint.render.luxe.Window,mint.render.luxe._Button.LuxeMintButtonOptions,mint.render.luxe._Canvas.LuxeMintCanvasOptions,mint.render.luxe._Checkbox.LuxeMintCheckboxOptions,mint.render.luxe._Dropdown.LuxeMintDropdownOptions,mint.render.luxe._Image.LuxeMintImageOptions,mint.render.luxe._Label.LuxeMintLabelOptions,mint.render.luxe._List.LuxeMintListOptions,mint.render.luxe._Panel.LuxeMintPanelOptions,mint.render.luxe._Progress.LuxeMintProgressOptions,mint.render.luxe._Scroll.LuxeMintScrollOptions,mint.render.luxe._Slider.LuxeMintSliderOptions,mint.render.luxe._TextEdit.LuxeMintTextEditOptions,mint.render.luxe._Window.LuxeMintWindowOptions,mint.types.Helper,mint.types.InteractState,mint.types.KeyCode,mint.types.KeyEvent,mint.types.ModState,mint.types.MouseButton,mint.types.MouseEvent,mint.types.TextAlign,mint.types.TextEvent,mint.types.TextEventType,mint.types._Types.InteractState_Impl_,mint.types._Types.KeyCode_Impl_,mint.types._Types.MouseButton_Impl_,mint.types._Types.TextAlign_Impl_"></script>


<h1>Control</h1>
<small>`mint.Control`</small>

An empty control.
    Base class for all controls
    handles propogation of events,
    mouse handling, layout and so on

<hr/>

`class`<br/><span class="meta">
meta: @:directlyUsed, @:allow(mint.render.Renderer)</span>

<hr/>


&nbsp;
&nbsp;




<h3>Members</h3> <hr/><span class="member apipage">
                <a name="canvas"><a class="lift" href="#canvas">canvas</a></a><div class="clear"></div>
                <code class="signature apipage">canvas : [mint.Canvas](../../api/mint/Canvas.html)</code><br/></span>
            <span class="small_desc_flat">Root canvas that this element belongs to</span><br/><span class="member apipage">
                <a name="children"><a class="lift" href="#children">children</a></a><div class="clear"></div>
                <code class="signature apipage">children : [Array](http://api.haxe.org/Array.html)&lt;[mint.Control](../../api/mint/Control.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="closest_to_canvas"><a class="lift" href="#closest_to_canvas">closest\_to\_canvas</a></a><div class="clear"></div>
                <code class="signature apipage">closest\_to\_canvas : [mint.Control](../../api/mint/Control.html)</code><br/></span>
            <span class="small_desc_flat">the top most control below the canvas that holds us</span><br/><span class="member apipage">
                <a name="isfocused"><a class="lift" href="#isfocused">isfocused</a></a><div class="clear"></div>
                <code class="signature apipage">isfocused : [Bool](http://api.haxe.org/Bool.html)</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="ishovered"><a class="lift" href="#ishovered">ishovered</a></a><div class="clear"></div>
                <code class="signature apipage">ishovered : [Bool](http://api.haxe.org/Bool.html)</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="key_input"><a class="lift" href="#key_input">key\_input</a></a><div class="clear"></div>
                <code class="signature apipage">key\_input : [Bool](http://api.haxe.org/Bool.html)</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="mouse_input"><a class="lift" href="#mouse_input">mouse\_input</a></a><div class="clear"></div>
                <code class="signature apipage">mouse\_input : [Bool](http://api.haxe.org/Bool.html)</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="name"><a class="lift" href="#name">name</a></a><div class="clear"></div>
                <code class="signature apipage">name : [String](http://api.haxe.org/String.html)</code><br/></span>
            <span class="small_desc_flat">The name of this control. default: 'control'</span><br/><span class="member apipage">
                <a name="onbounds"><a class="lift" href="#onbounds">onbounds</a></a><div class="clear"></div>
                <code class="signature apipage">onbounds : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onchildadd"><a class="lift" href="#onchildadd">onchildadd</a></a><div class="clear"></div>
                <code class="signature apipage">onchildadd : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onchildremove"><a class="lift" href="#onchildremove">onchildremove</a></a><div class="clear"></div>
                <code class="signature apipage">onchildremove : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onclip"><a class="lift" href="#onclip">onclip</a></a><div class="clear"></div>
                <code class="signature apipage">onclip : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="oncreate"><a class="lift" href="#oncreate">oncreate</a></a><div class="clear"></div>
                <code class="signature apipage">oncreate : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="ondepth"><a class="lift" href="#ondepth">ondepth</a></a><div class="clear"></div>
                <code class="signature apipage">ondepth : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="ondestroy"><a class="lift" href="#ondestroy">ondestroy</a></a><div class="clear"></div>
                <code class="signature apipage">ondestroy : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onkeydown"><a class="lift" href="#onkeydown">onkeydown</a></a><div class="clear"></div>
                <code class="signature apipage">onkeydown : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.KeySignal](../../api/mint/KeySignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onkeyup"><a class="lift" href="#onkeyup">onkeyup</a></a><div class="clear"></div>
                <code class="signature apipage">onkeyup : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.KeySignal](../../api/mint/KeySignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onmousedown"><a class="lift" href="#onmousedown">onmousedown</a></a><div class="clear"></div>
                <code class="signature apipage">onmousedown : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.MouseSignal](../../api/mint/MouseSignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onmouseenter"><a class="lift" href="#onmouseenter">onmouseenter</a></a><div class="clear"></div>
                <code class="signature apipage">onmouseenter : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.MouseSignal](../../api/mint/MouseSignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onmouseleave"><a class="lift" href="#onmouseleave">onmouseleave</a></a><div class="clear"></div>
                <code class="signature apipage">onmouseleave : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.MouseSignal](../../api/mint/MouseSignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onmousemove"><a class="lift" href="#onmousemove">onmousemove</a></a><div class="clear"></div>
                <code class="signature apipage">onmousemove : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.MouseSignal](../../api/mint/MouseSignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onmouseup"><a class="lift" href="#onmouseup">onmouseup</a></a><div class="clear"></div>
                <code class="signature apipage">onmouseup : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.MouseSignal](../../api/mint/MouseSignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onmousewheel"><a class="lift" href="#onmousewheel">onmousewheel</a></a><div class="clear"></div>
                <code class="signature apipage">onmousewheel : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.MouseSignal](../../api/mint/MouseSignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onrender"><a class="lift" href="#onrender">onrender</a></a><div class="clear"></div>
                <code class="signature apipage">onrender : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="ontextinput"><a class="lift" href="#ontextinput">ontextinput</a></a><div class="clear"></div>
                <code class="signature apipage">ontextinput : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[mint.TextSignal](../../api/mint/TextSignal.html)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onvisible"><a class="lift" href="#onvisible">onvisible</a></a><div class="clear"></div>
                <code class="signature apipage">onvisible : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="renderable"><a class="lift" href="#renderable">renderable</a></a><div class="clear"></div>
                <code class="signature apipage">renderable : [Bool](http://api.haxe.org/Bool.html)</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="renderer"><a class="lift" href="#renderer">renderer</a></a><div class="clear"></div>
                <code class="signature apipage">renderer : [mint.render.Renderer](../../api/mint/render/Renderer.html)</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="rendering"><a class="lift" href="#rendering">rendering</a></a><div class="clear"></div>
                <code class="signature apipage">rendering : [mint.render.Rendering](../../api/mint/render/Rendering.html)</code><br/></span>
            <span class="small_desc_flat">The rendering service that this instance uses, defaults to the canvas render service</span><br/>

<h3>Properties</h3> <hr/><span class="member apipage">
                <a name="bottom"><a class="lift" href="#bottom">bottom</a></a><div class="clear"></div>
                <code class="signature apipage">bottom : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The bottom edge of the control bounds</span><span class="member apipage">
                <a name="children_bounds"><a class="lift" href="#children_bounds">children\_bounds</a></a><div class="clear"></div>
                <code class="signature apipage">children\_bounds : [mint.ChildBounds](../../api/mint/ChildBounds.html)</code><br/></span>
            <span class="small_desc_flat"></span><span class="member apipage">
                <a name="clip_with"><a class="lift" href="#clip_with">clip\_with</a></a><div class="clear"></div>
                <code class="signature apipage">clip\_with : [mint.Control](../../api/mint/Control.html)</code><br/></span>
            <span class="small_desc_flat"></span><span class="member apipage">
                <a name="depth"><a class="lift" href="#depth">depth</a></a><div class="clear"></div>
                <code class="signature apipage">depth : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat"></span><span class="member apipage">
                <a name="h"><a class="lift" href="#h">h</a></a><div class="clear"></div>
                <code class="signature apipage">h : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The height of the control bounds</span><span class="member apipage">
                <a name="h_max"><a class="lift" href="#h_max">h\_max</a></a><div class="clear"></div>
                <code class="signature apipage">h\_max : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The maximum height</span><span class="member apipage">
                <a name="h_min"><a class="lift" href="#h_min">h\_min</a></a><div class="clear"></div>
                <code class="signature apipage">h\_min : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The minimum height</span><span class="member apipage">
                <a name="nodes"><a class="lift" href="#nodes">nodes</a></a><div class="clear"></div>
                <code class="signature apipage">nodes : [Int](http://api.haxe.org/Int.html)</code><br/></span>
            <span class="small_desc_flat"></span><span class="member apipage">
                <a name="parent"><a class="lift" href="#parent">parent</a></a><div class="clear"></div>
                <code class="signature apipage">parent : [mint.Control](../../api/mint/Control.html)</code><br/></span>
            <span class="small_desc_flat"></span><span class="member apipage">
                <a name="right"><a class="lift" href="#right">right</a></a><div class="clear"></div>
                <code class="signature apipage">right : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The right edge of the control bounds</span><span class="member apipage">
                <a name="visible"><a class="lift" href="#visible">visible</a></a><div class="clear"></div>
                <code class="signature apipage">visible : [Bool](http://api.haxe.org/Bool.html)</code><br/></span>
            <span class="small_desc_flat"></span><span class="member apipage">
                <a name="w"><a class="lift" href="#w">w</a></a><div class="clear"></div>
                <code class="signature apipage">w : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The width of the control bounds</span><span class="member apipage">
                <a name="w_max"><a class="lift" href="#w_max">w\_max</a></a><div class="clear"></div>
                <code class="signature apipage">w\_max : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The maximum width</span><span class="member apipage">
                <a name="w_min"><a class="lift" href="#w_min">w\_min</a></a><div class="clear"></div>
                <code class="signature apipage">w\_min : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The minimum width</span><span class="member apipage">
                <a name="x"><a class="lift" href="#x">x</a></a><div class="clear"></div>
                <code class="signature apipage">x : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The x position of the control bounds, world coordinate</span><span class="member apipage">
                <a name="x_local"><a class="lift" href="#x_local">x\_local</a></a><div class="clear"></div>
                <code class="signature apipage">x\_local : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The x position of the control bounds, relative to its container</span><span class="member apipage">
                <a name="y"><a class="lift" href="#y">y</a></a><div class="clear"></div>
                <code class="signature apipage">y : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The y position of the control bounds, world coordinate</span><span class="member apipage">
                <a name="y_local"><a class="lift" href="#y_local">y\_local</a></a><div class="clear"></div>
                <code class="signature apipage">y\_local : [Float](http://api.haxe.org/Float.html)</code><br/></span>
            <span class="small_desc_flat">The y position of the control bounds, relative to its container</span>

<h3>Methods</h3> <hr/><span class="method apipage">
            <a name="add"><a class="lift" href="#add">add</a></a><div class="clear"></div>
            <code class="signature apipage">add(child:[mint.Control](../../api/mint/Control.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="contains"><a class="lift" href="#contains">contains</a></a><div class="clear"></div>
            <code class="signature apipage">contains(\_x:[Float](http://api.haxe.org/Float.html)<span></span>, \_y:[Float](http://api.haxe.org/Float.html)<span></span>) : [Bool](http://api.haxe.org/Bool.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="destroy"><a class="lift" href="#destroy">destroy</a></a><div class="clear"></div>
            <code class="signature apipage">destroy() : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="destroy_children"><a class="lift" href="#destroy_children">destroy\_children</a></a><div class="clear"></div>
            <code class="signature apipage">destroy\_children() : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="keydown"><a class="lift" href="#keydown">keydown</a></a><div class="clear"></div>
            <code class="signature apipage">keydown(e:[mint.types.KeyEvent](../../api/mint/types/KeyEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="keyup"><a class="lift" href="#keyup">keyup</a></a><div class="clear"></div>
            <code class="signature apipage">keyup(e:[mint.types.KeyEvent](../../api/mint/types/KeyEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="mousedown"><a class="lift" href="#mousedown">mousedown</a></a><div class="clear"></div>
            <code class="signature apipage">mousedown(e:[mint.types.MouseEvent](../../api/mint/types/MouseEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="mouseenter"><a class="lift" href="#mouseenter">mouseenter</a></a><div class="clear"></div>
            <code class="signature apipage">mouseenter(e:[mint.types.MouseEvent](../../api/mint/types/MouseEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="mouseleave"><a class="lift" href="#mouseleave">mouseleave</a></a><div class="clear"></div>
            <code class="signature apipage">mouseleave(e:[mint.types.MouseEvent](../../api/mint/types/MouseEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="mousemove"><a class="lift" href="#mousemove">mousemove</a></a><div class="clear"></div>
            <code class="signature apipage">mousemove(e:[mint.types.MouseEvent](../../api/mint/types/MouseEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="mouseup"><a class="lift" href="#mouseup">mouseup</a></a><div class="clear"></div>
            <code class="signature apipage">mouseup(e:[mint.types.MouseEvent](../../api/mint/types/MouseEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="mousewheel"><a class="lift" href="#mousewheel">mousewheel</a></a><div class="clear"></div>
            <code class="signature apipage">mousewheel(e:[mint.types.MouseEvent](../../api/mint/types/MouseEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="new"><a class="lift" href="#new">new</a></a><div class="clear"></div>
            <code class="signature apipage">new(\_options:[mint.ControlOptions](../../api/mint/ControlOptions.html)<span></span>, \_emit\_oncreate:[Bool](http://api.haxe.org/Bool.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat">Create a Control with the given options.
            The emit_oncreate flag will fire the oncreate signal at the end of this function default:false</span>


</span>
<span class="method apipage">
            <a name="remove"><a class="lift" href="#remove">remove</a></a><div class="clear"></div>
            <code class="signature apipage">remove(child:[mint.Control](../../api/mint/Control.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="render"><a class="lift" href="#render">render</a></a><div class="clear"></div>
            <code class="signature apipage">render() : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="set_pos"><a class="lift" href="#set_pos">set\_pos</a></a><div class="clear"></div>
            <code class="signature apipage">set\_pos(\_x:[Float](http://api.haxe.org/Float.html)<span></span>, \_y:[Float](http://api.haxe.org/Float.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="set_size"><a class="lift" href="#set_size">set\_size</a></a><div class="clear"></div>
            <code class="signature apipage">set\_size(\_w:[Float](http://api.haxe.org/Float.html)<span></span>, \_h:[Float](http://api.haxe.org/Float.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="textinput"><a class="lift" href="#textinput">textinput</a></a><div class="clear"></div>
            <code class="signature apipage">textinput(e:[mint.types.TextEvent](../../api/mint/types/TextEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="topmost_child_at_point"><a class="lift" href="#topmost_child_at_point">topmost\_child\_at\_point</a></a><div class="clear"></div>
            <code class="signature apipage">topmost\_child\_at\_point(\_x:[Float](http://api.haxe.org/Float.html)<span></span>, \_y:[Float](http://api.haxe.org/Float.html)<span></span>) : [mint.Control](../../api/mint/Control.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="update"><a class="lift" href="#update">update</a></a><div class="clear"></div>
            <code class="signature apipage">update(dt:[Float](http://api.haxe.org/Float.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>



<hr/>

&nbsp;
&nbsp;
&nbsp;
&nbsp;