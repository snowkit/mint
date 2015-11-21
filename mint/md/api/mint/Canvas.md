
[![Logo](../../images/logo.png)](../../api/index.html)

<hr/>
<a href="#" id="search_bar" onclick="return;"><div> search API <em>(or start typing anywhere)</em> </div></a>
<hr/>

<script src="../../js/omnibar.js"> </script>
<link rel="stylesheet" type="text/css" href="../../css/omnibar.css" media="all">

<div id="omnibar"> <a href="#" onclick="return" id="omnibar_close"></a> <input id="omnibar_text" type="text" placeholder="search types..."></input></div>
<script  id="typelist" data-relpath="../../" data-types="mint.Button,mint.ButtonOptions,mint.Canvas,mint.CanvasOptions,mint.Checkbox,mint.CheckboxOptions,mint.ChildBounds,mint.Control,mint.ControlOptions,mint.Dropdown,mint.DropdownOptions,mint.Image,mint.ImageOptions,mint.KeySignal,mint.Label,mint.LabelOptions,mint.List,mint.ListOptions,mint.MouseSignal,mint.Panel,mint.PanelOptions,mint.Progress,mint.ProgressOptions,mint.Scroll,mint.ScrollOptions,mint.Slider,mint.SliderOptions,mint.TextEdit,mint.TextEditOptions,mint.TextSignal,mint.Window,mint.WindowOptions,mint.core.DebugError,mint.core.Macros,mint.core.Signal,mint.core.unifill.CodePoint,mint.core.unifill.CodePointIter,mint.core.unifill.Exception,mint.core.unifill.InternalEncoding,mint.core.unifill.InternalEncodingBackwardIter,mint.core.unifill.InternalEncodingIter,mint.core.unifill.Unicode,mint.core.unifill.Unifill,mint.core.unifill.Utf16,mint.core.unifill.Utf32,mint.core.unifill.Utf8,mint.core.unifill._CodePoint.CodePoint_Impl_,mint.core.unifill._InternalEncoding.UtfX,mint.core.unifill._Utf16.StringU16,mint.core.unifill._Utf16.StringU16Buffer,mint.core.unifill._Utf16.StringU16Buffer_Impl_,mint.core.unifill._Utf16.StringU16_Impl_,mint.core.unifill._Utf16.Utf16Impl,mint.core.unifill._Utf16.Utf16_Impl_,mint.core.unifill._Utf32.Utf32_Impl_,mint.core.unifill._Utf8.StringU8,mint.core.unifill._Utf8.StringU8_Impl_,mint.core.unifill._Utf8.Utf8Impl,mint.core.unifill._Utf8.Utf8_Impl_,mint.focus.Focus,mint.layout.margins.AnchorType,mint.layout.margins.Layouts,mint.layout.margins.MarginTarget,mint.layout.margins.MarginType,mint.layout.margins.Margins,mint.layout.margins.SizeTarget,mint.layout.margins._Margins.Anchor,mint.layout.margins._Margins.AnchorType_Impl_,mint.layout.margins._Margins.Margin,mint.layout.margins._Margins.MarginTarget_Impl_,mint.layout.margins._Margins.MarginType_Impl_,mint.layout.margins._Margins.SizeTarget_Impl_,mint.layout.margins._Margins.Sizer,mint.render.Render,mint.render.Renderer,mint.render.Rendering,mint.render.luxe.Button,mint.render.luxe.Canvas,mint.render.luxe.Checkbox,mint.render.luxe.Convert,mint.render.luxe.Dropdown,mint.render.luxe.Image,mint.render.luxe.Label,mint.render.luxe.List,mint.render.luxe.LuxeMintRender,mint.render.luxe.Panel,mint.render.luxe.Progress,mint.render.luxe.Scroll,mint.render.luxe.Slider,mint.render.luxe.TextEdit,mint.render.luxe.Window,mint.render.luxe._Button.LuxeMintButtonOptions,mint.render.luxe._Canvas.LuxeMintCanvasOptions,mint.render.luxe._Checkbox.LuxeMintCheckboxOptions,mint.render.luxe._Dropdown.LuxeMintDropdownOptions,mint.render.luxe._Image.LuxeMintImageOptions,mint.render.luxe._Label.LuxeMintLabelOptions,mint.render.luxe._List.LuxeMintListOptions,mint.render.luxe._Panel.LuxeMintPanelOptions,mint.render.luxe._Progress.LuxeMintProgressOptions,mint.render.luxe._Scroll.LuxeMintScrollOptions,mint.render.luxe._Slider.LuxeMintSliderOptions,mint.render.luxe._TextEdit.LuxeMintTextEditOptions,mint.render.luxe._Window.LuxeMintWindowOptions,mint.types.Helper,mint.types.InteractState,mint.types.KeyCode,mint.types.KeyEvent,mint.types.ModState,mint.types.MouseButton,mint.types.MouseEvent,mint.types.TextAlign,mint.types.TextEvent,mint.types.TextEventType,mint.types._Types.InteractState_Impl_,mint.types._Types.KeyCode_Impl_,mint.types._Types.MouseButton_Impl_,mint.types._Types.TextAlign_Impl_"></script>


<h1>Canvas</h1>
<small>`mint.Canvas`</small>

A canvas is a root object in mint.
    It requires a rendering instance, and handles all incoming events,
    propagating them to the children.
    Additional Signals: none

<hr/>

`class`extends <code><span>mint.Control</span></code><br/><span class="meta">
meta: @:directlyUsed, @:allow(mint.render.Renderer)</span>

<hr/>


&nbsp;
&nbsp;




<h3>Members</h3> <hr/><span class="member apipage">
                <a name="focus_invalid"><a class="lift" href="#focus_invalid">focus\_invalid</a></a><div class="clear"></div>
                <code class="signature apipage">focus\_invalid : [Bool](http://api.haxe.org/Bool.html)</code><br/></span>
            <span class="small_desc_flat">Whether or not the current focus needs refreshing.</span><br/><span class="member apipage">
                <a name="oncapturedchange"><a class="lift" href="#oncapturedchange">oncapturedchange</a></a><div class="clear"></div>
                <code class="signature apipage">oncapturedchange : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat">An event for when the captured state changes</span><br/><span class="member apipage">
                <a name="onfocusedchange"><a class="lift" href="#onfocusedchange">onfocusedchange</a></a><div class="clear"></div>
                <code class="signature apipage">onfocusedchange : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat">An event for when the focused state changes</span><br/><span class="member apipage">
                <a name="onmarkedchange"><a class="lift" href="#onmarkedchange">onmarkedchange</a></a><div class="clear"></div>
                <code class="signature apipage">onmarkedchange : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat">An event for when the marked state changes</span><br/>

<h3>Properties</h3> <hr/><span class="member apipage">
                <a name="captured"><a class="lift" href="#captured">captured</a></a><div class="clear"></div>
                <code class="signature apipage">captured : [mint.Control](../../api/mint/Control.html)</code><br/></span>
            <span class="small_desc_flat">The current modal control, null if none</span><span class="member apipage">
                <a name="focused"><a class="lift" href="#focused">focused</a></a><div class="clear"></div>
                <code class="signature apipage">focused : [mint.Control](../../api/mint/Control.html)</code><br/></span>
            <span class="small_desc_flat">The current focused control, null if none</span><span class="member apipage">
                <a name="marked"><a class="lift" href="#marked">marked</a></a><div class="clear"></div>
                <code class="signature apipage">marked : [mint.Control](../../api/mint/Control.html)</code><br/></span>
            <span class="small_desc_flat">The current marked control, null if none</span>

<h3>Methods</h3> <hr/><span class="method apipage">
            <a name="bring_to_front"><a class="lift" href="#bring_to_front">bring\_to\_front</a></a><div class="clear"></div>
            <code class="signature apipage">bring\_to\_front(control:[mint.Control](../../api/mint/Control.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


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
            <code class="signature apipage">new(\_options:[mint.CanvasOptions](../../api/mint/CanvasOptions.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="textinput"><a class="lift" href="#textinput">textinput</a></a><div class="clear"></div>
            <code class="signature apipage">textinput(e:[mint.types.TextEvent](../../api/mint/types/TextEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="topmost_at_point"><a class="lift" href="#topmost_at_point">topmost\_at\_point</a></a><div class="clear"></div>
            <code class="signature apipage">topmost\_at\_point(\_x:[Float](http://api.haxe.org/Float.html)<span></span>, \_y:[Float](http://api.haxe.org/Float.html)<span></span>) : [mint.Control](../../api/mint/Control.html)</code><br/><span class="small_desc_flat">Get the top most control under the given point, or null if there is none (or is the canvas itself)</span>


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