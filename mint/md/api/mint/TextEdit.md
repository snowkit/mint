
[![Logo](../../images/logo.png)](../../api/index.html)

<hr/>
<a href="#" id="search_bar" onclick="return;"><div> search API <em>(or start typing anywhere)</em> </div></a>
<hr/>

<script src="../../js/omnibar.js"> </script>
<link rel="stylesheet" type="text/css" href="../../css/omnibar.css" media="all">

<div id="omnibar"> <a href="#" onclick="return" id="omnibar_close"></a> <input id="omnibar_text" type="text" placeholder="search types..."></input></div>
<script  id="typelist" data-relpath="../../" data-types="mint.Button,mint.ButtonOptions,mint.Canvas,mint.CanvasOptions,mint.Checkbox,mint.CheckboxOptions,mint.ChildBounds,mint.Control,mint.ControlOptions,mint.Dropdown,mint.DropdownOptions,mint.Image,mint.ImageOptions,mint.KeySignal,mint.Label,mint.LabelOptions,mint.List,mint.ListOptions,mint.MouseSignal,mint.Panel,mint.PanelOptions,mint.Progress,mint.ProgressOptions,mint.Scroll,mint.ScrollOptions,mint.Slider,mint.SliderOptions,mint.TextEdit,mint.TextEditOptions,mint.TextSignal,mint.Window,mint.WindowOptions,mint.core.DebugError,mint.core.Macros,mint.core.Signal,mint.core.unifill.CodePoint,mint.core.unifill.CodePointIter,mint.core.unifill.Exception,mint.core.unifill.InternalEncoding,mint.core.unifill.InternalEncodingBackwardIter,mint.core.unifill.InternalEncodingIter,mint.core.unifill.Unicode,mint.core.unifill.Unifill,mint.core.unifill.Utf16,mint.core.unifill.Utf32,mint.core.unifill.Utf8,mint.core.unifill._CodePoint.CodePoint_Impl_,mint.core.unifill._InternalEncoding.UtfX,mint.core.unifill._Utf16.StringU16,mint.core.unifill._Utf16.StringU16Buffer,mint.core.unifill._Utf16.StringU16Buffer_Impl_,mint.core.unifill._Utf16.StringU16_Impl_,mint.core.unifill._Utf16.Utf16Impl,mint.core.unifill._Utf16.Utf16_Impl_,mint.core.unifill._Utf32.Utf32_Impl_,mint.core.unifill._Utf8.StringU8,mint.core.unifill._Utf8.StringU8_Impl_,mint.core.unifill._Utf8.Utf8Impl,mint.core.unifill._Utf8.Utf8_Impl_,mint.focus.Focus,mint.layout.margins.AnchorType,mint.layout.margins.Layouts,mint.layout.margins.MarginTarget,mint.layout.margins.MarginType,mint.layout.margins.Margins,mint.layout.margins.SizeTarget,mint.layout.margins._Margins.Anchor,mint.layout.margins._Margins.AnchorType_Impl_,mint.layout.margins._Margins.Margin,mint.layout.margins._Margins.MarginTarget_Impl_,mint.layout.margins._Margins.MarginType_Impl_,mint.layout.margins._Margins.SizeTarget_Impl_,mint.layout.margins._Margins.Sizer,mint.render.Render,mint.render.Renderer,mint.render.Rendering,mint.render.luxe.Button,mint.render.luxe.Canvas,mint.render.luxe.Checkbox,mint.render.luxe.Convert,mint.render.luxe.Dropdown,mint.render.luxe.Image,mint.render.luxe.Label,mint.render.luxe.List,mint.render.luxe.LuxeMintRender,mint.render.luxe.Panel,mint.render.luxe.Progress,mint.render.luxe.Scroll,mint.render.luxe.Slider,mint.render.luxe.TextEdit,mint.render.luxe.Window,mint.render.luxe._Button.LuxeMintButtonOptions,mint.render.luxe._Canvas.LuxeMintCanvasOptions,mint.render.luxe._Checkbox.LuxeMintCheckboxOptions,mint.render.luxe._Dropdown.LuxeMintDropdownOptions,mint.render.luxe._Image.LuxeMintImageOptions,mint.render.luxe._Label.LuxeMintLabelOptions,mint.render.luxe._List.LuxeMintListOptions,mint.render.luxe._Panel.LuxeMintPanelOptions,mint.render.luxe._Progress.LuxeMintProgressOptions,mint.render.luxe._Scroll.LuxeMintScrollOptions,mint.render.luxe._Slider.LuxeMintSliderOptions,mint.render.luxe._TextEdit.LuxeMintTextEditOptions,mint.render.luxe._Window.LuxeMintWindowOptions,mint.types.Helper,mint.types.InteractState,mint.types.KeyCode,mint.types.KeyEvent,mint.types.ModState,mint.types.MouseButton,mint.types.MouseEvent,mint.types.TextAlign,mint.types.TextEvent,mint.types.TextEventType,mint.types._Types.InteractState_Impl_,mint.types._Types.KeyCode_Impl_,mint.types._Types.MouseButton_Impl_,mint.types._Types.TextAlign_Impl_"></script>


<h1>TextEdit</h1>
<small>`mint.TextEdit`</small>

A simple text edit control
    Additional Signals: none

<hr/>

`class`extends <code><span>mint.Control</span></code><br/><span class="meta">
meta: @:directlyUsed, @:allow(mint.render.Renderer)</span>

<hr/>


&nbsp;
&nbsp;




<h3>Members</h3> <hr/><span class="member apipage">
                <a name="index"><a class="lift" href="#index">index</a></a><div class="clear"></div>
                <code class="signature apipage">index : [Int](http://api.haxe.org/Int.html)</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="label"><a class="lift" href="#label">label</a></a><div class="clear"></div>
                <code class="signature apipage">label : [mint.Label](../../api/mint/Label.html)</code><br/></span>
            <span class="small_desc_flat"></span><br/><span class="member apipage">
                <a name="onchange"><a class="lift" href="#onchange">onchange</a></a><div class="clear"></div>
                <code class="signature apipage">onchange : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat">Emitted whenever the text or display text is changed. 
            `text:String, display_text:String, from_typing:Bool`</span><br/><span class="member apipage">
                <a name="onchangeindex"><a class="lift" href="#onchangeindex">onchangeindex</a></a><div class="clear"></div>
                <code class="signature apipage">onchangeindex : [mint.core.Signal](../../api/mint/core/Signal.html)&lt;[](#)&gt;</code><br/></span>
            <span class="small_desc_flat">Emitted whenever the index is changed.</span><br/>

<h3>Properties</h3> <hr/><span class="member apipage">
                <a name="display_char"><a class="lift" href="#display_char">display\_char</a></a><div class="clear"></div>
                <code class="signature apipage">display\_char : [String](http://api.haxe.org/String.html)</code><br/></span>
            <span class="small_desc_flat"></span><span class="member apipage">
                <a name="display_text"><a class="lift" href="#display_text">display\_text</a></a><div class="clear"></div>
                <code class="signature apipage">display\_text : [String](http://api.haxe.org/String.html)</code><br/></span>
            <span class="small_desc_flat"></span><span class="member apipage">
                <a name="text"><a class="lift" href="#text">text</a></a><div class="clear"></div>
                <code class="signature apipage">text : [String](http://api.haxe.org/String.html)</code><br/></span>
            <span class="small_desc_flat"></span>

<h3>Methods</h3> <hr/><span class="method apipage">
            <a name="filter"><a class="lift" href="#filter">filter</a></a><div class="clear"></div>
            <code class="signature apipage">filter(:[String](http://api.haxe.org/String.html)<span></span>, :[String](http://api.haxe.org/String.html)<span></span>, :[String](http://api.haxe.org/String.html)<span></span>) : [Bool](http://api.haxe.org/Bool.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="keydown"><a class="lift" href="#keydown">keydown</a></a><div class="clear"></div>
            <code class="signature apipage">keydown(event:[mint.types.KeyEvent](../../api/mint/types/KeyEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="mousedown"><a class="lift" href="#mousedown">mousedown</a></a><div class="clear"></div>
            <code class="signature apipage">mousedown(event:[mint.types.MouseEvent](../../api/mint/types/MouseEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="new"><a class="lift" href="#new">new</a></a><div class="clear"></div>
            <code class="signature apipage">new(\_options:[mint.TextEditOptions](../../api/mint/TextEditOptions.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="textinput"><a class="lift" href="#textinput">textinput</a></a><div class="clear"></div>
            <code class="signature apipage">textinput(event:[mint.types.TextEvent](../../api/mint/types/TextEvent.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>
<span class="method apipage">
            <a name="unfocus"><a class="lift" href="#unfocus">unfocus</a></a><div class="clear"></div>
            <code class="signature apipage">unfocus() : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat"></span>


</span>



<hr/>

&nbsp;
&nbsp;
&nbsp;
&nbsp;