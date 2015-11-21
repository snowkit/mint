
[![Logo](../../../../images/logo.png)](../../../../api/index.html)

<hr/>
<a href="#" id="search_bar" onclick="return;"><div> search API <em>(or start typing anywhere)</em> </div></a>
<hr/>

<script src="../../../../js/omnibar.js"> </script>
<link rel="stylesheet" type="text/css" href="../../../../css/omnibar.css" media="all">

<div id="omnibar"> <a href="#" onclick="return" id="omnibar_close"></a> <input id="omnibar_text" type="text" placeholder="search types..."></input></div>
<script  id="typelist" data-relpath="../../../../" data-types="mint.Button,mint.ButtonOptions,mint.Canvas,mint.CanvasOptions,mint.Checkbox,mint.CheckboxOptions,mint.ChildBounds,mint.Control,mint.ControlOptions,mint.Dropdown,mint.DropdownOptions,mint.Image,mint.ImageOptions,mint.KeySignal,mint.Label,mint.LabelOptions,mint.List,mint.ListOptions,mint.MouseSignal,mint.Panel,mint.PanelOptions,mint.Progress,mint.ProgressOptions,mint.Scroll,mint.ScrollOptions,mint.Slider,mint.SliderOptions,mint.TextEdit,mint.TextEditOptions,mint.TextSignal,mint.Window,mint.WindowOptions,mint.core.DebugError,mint.core.Macros,mint.core.Signal,mint.core.unifill.CodePoint,mint.core.unifill.CodePointIter,mint.core.unifill.Exception,mint.core.unifill.InternalEncoding,mint.core.unifill.InternalEncodingBackwardIter,mint.core.unifill.InternalEncodingIter,mint.core.unifill.Unicode,mint.core.unifill.Unifill,mint.core.unifill.Utf16,mint.core.unifill.Utf32,mint.core.unifill.Utf8,mint.core.unifill._CodePoint.CodePoint_Impl_,mint.core.unifill._InternalEncoding.UtfX,mint.core.unifill._Utf16.StringU16,mint.core.unifill._Utf16.StringU16Buffer,mint.core.unifill._Utf16.StringU16Buffer_Impl_,mint.core.unifill._Utf16.StringU16_Impl_,mint.core.unifill._Utf16.Utf16Impl,mint.core.unifill._Utf16.Utf16_Impl_,mint.core.unifill._Utf32.Utf32_Impl_,mint.core.unifill._Utf8.StringU8,mint.core.unifill._Utf8.StringU8_Impl_,mint.core.unifill._Utf8.Utf8Impl,mint.core.unifill._Utf8.Utf8_Impl_,mint.focus.Focus,mint.layout.margins.AnchorType,mint.layout.margins.Layouts,mint.layout.margins.MarginTarget,mint.layout.margins.MarginType,mint.layout.margins.Margins,mint.layout.margins.SizeTarget,mint.layout.margins._Margins.Anchor,mint.layout.margins._Margins.AnchorType_Impl_,mint.layout.margins._Margins.Margin,mint.layout.margins._Margins.MarginTarget_Impl_,mint.layout.margins._Margins.MarginType_Impl_,mint.layout.margins._Margins.SizeTarget_Impl_,mint.layout.margins._Margins.Sizer,mint.render.Render,mint.render.Renderer,mint.render.Rendering,mint.render.luxe.Button,mint.render.luxe.Canvas,mint.render.luxe.Checkbox,mint.render.luxe.Convert,mint.render.luxe.Dropdown,mint.render.luxe.Image,mint.render.luxe.Label,mint.render.luxe.List,mint.render.luxe.LuxeMintRender,mint.render.luxe.Panel,mint.render.luxe.Progress,mint.render.luxe.Scroll,mint.render.luxe.Slider,mint.render.luxe.TextEdit,mint.render.luxe.Window,mint.render.luxe._Button.LuxeMintButtonOptions,mint.render.luxe._Canvas.LuxeMintCanvasOptions,mint.render.luxe._Checkbox.LuxeMintCheckboxOptions,mint.render.luxe._Dropdown.LuxeMintDropdownOptions,mint.render.luxe._Image.LuxeMintImageOptions,mint.render.luxe._Label.LuxeMintLabelOptions,mint.render.luxe._List.LuxeMintListOptions,mint.render.luxe._Panel.LuxeMintPanelOptions,mint.render.luxe._Progress.LuxeMintProgressOptions,mint.render.luxe._Scroll.LuxeMintScrollOptions,mint.render.luxe._Slider.LuxeMintSliderOptions,mint.render.luxe._TextEdit.LuxeMintTextEditOptions,mint.render.luxe._Window.LuxeMintWindowOptions,mint.types.Helper,mint.types.InteractState,mint.types.KeyCode,mint.types.KeyEvent,mint.types.ModState,mint.types.MouseButton,mint.types.MouseEvent,mint.types.TextAlign,mint.types.TextEvent,mint.types.TextEventType,mint.types._Types.InteractState_Impl_,mint.types._Types.KeyCode_Impl_,mint.types._Types.MouseButton_Impl_,mint.types._Types.TextAlign_Impl_"></script>


<h1>InternalEncoding</h1>
<small>`mint.core.unifill.InternalEncoding`</small>

InternalEncoding provides primitive API to deal with strings across
   all platforms. You should consider adopting Unifill before this.

<hr/>

`class`
<hr/>


&nbsp;
&nbsp;






<h3>Methods</h3> <hr/><span class="method apipage">
            <a name="backwardOffsetByCodePoints"><a class="lift" href="#backwardOffsetByCodePoints">backwardOffsetByCodePoints</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">backwardOffsetByCodePoints(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>, codePointOffset:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the index within String `s` that is offset from
       position `index` by `codePointOffset` code points counting
       backward.</span>


</span>
<span class="method apipage">
            <a name="charAt"><a class="lift" href="#charAt">charAt</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">charAt(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>) : [String](http://api.haxe.org/String.html)</code><br/><span class="small_desc_flat">Returns the character as a String at position `index` of
       String `s`.</span>


</span>
<span class="method apipage">
            <a name="codePointAt"><a class="lift" href="#codePointAt">codePointAt</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">codePointAt(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the Unicode code point at position `index` of
       String `s`.</span>


</span>
<span class="method apipage">
            <a name="codePointCount"><a class="lift" href="#codePointCount">codePointCount</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">codePointCount(s:[String](http://api.haxe.org/String.html)<span></span>, beginIndex:[Int](http://api.haxe.org/Int.html)<span></span>, endIndex:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the number of Unicode code points from `beginIndex`
       to `endIndex` in String `s`.</span>


</span>
<span class="method apipage">
            <a name="codePointWidthAt"><a class="lift" href="#codePointWidthAt">codePointWidthAt</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">codePointWidthAt(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the number of units of the code point at position
       `index` of String `s`.</span>


</span>
<span class="method apipage">
            <a name="codePointWidthBefore"><a class="lift" href="#codePointWidthBefore">codePointWidthBefore</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">codePointWidthBefore(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the number of units of the code point before
       position `index` of String `s`.</span>


</span>
<span class="method apipage">
            <a name="codeUnitAt"><a class="lift" href="#codeUnitAt">codeUnitAt</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">codeUnitAt(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the UTF-8/16/32 code unit at position `index` of
       String `s`.</span>


</span>
<span class="method apipage">
            <a name="fromCodePoint"><a class="lift" href="#fromCodePoint">fromCodePoint</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">fromCodePoint(codePoint:[Int](http://api.haxe.org/Int.html)<span></span>) : [String](http://api.haxe.org/String.html)</code><br/><span class="small_desc_flat">Converts the code point `code` to a character as String.</span>


</span>
<span class="method apipage">
            <a name="fromCodePoints"><a class="lift" href="#fromCodePoints">fromCodePoints</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">fromCodePoints(codePoints:[Iterable](#)&lt;[Int](http://api.haxe.org/Int.html)&gt;<span></span>) : [String](http://api.haxe.org/String.html)</code><br/><span class="small_desc_flat">Converts `codePoints` to a String.</span>


</span>
<span class="method apipage">
            <a name="isValidString"><a class="lift" href="#isValidString">isValidString</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">isValidString(s:[String](http://api.haxe.org/String.html)<span></span>) : [Bool](http://api.haxe.org/Bool.html)</code><br/><span class="small_desc_flat">Returns if String `s` is valid.</span>


</span>
<span class="method apipage">
            <a name="offsetByCodePoints"><a class="lift" href="#offsetByCodePoints">offsetByCodePoints</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">offsetByCodePoints(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>, codePointOffset:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the index within String `s` that is offset from
       position `index` by `codePointOffset` code points.</span>


</span>
<span class="method apipage">
            <a name="validate"><a class="lift" href="#validate">validate</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">validate(s:[String](http://api.haxe.org/String.html)<span></span>) : [Void](http://api.haxe.org/Void.html)</code><br/><span class="small_desc_flat">Validates String `s`.

       If the code unit sequence of `s` is invalid,
       `Exception.InvalidCodeUnitSequence` is throwed.</span>


</span>



<hr/>

&nbsp;
&nbsp;
&nbsp;
&nbsp;