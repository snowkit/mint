
[![Logo](../../../../images/logo.png)](../../../../api/index.html)

<hr/>
<a href="#" id="search_bar" onclick="return;"><div> search API <em>(or start typing anywhere)</em> </div></a>
<hr/>

<script src="../../../../js/omnibar.js"> </script>
<link rel="stylesheet" type="text/css" href="../../../../css/omnibar.css" media="all">

<div id="omnibar"> <a href="#" onclick="return" id="omnibar_close"></a> <input id="omnibar_text" type="text" placeholder="search types..."></input></div>
<script  id="typelist" data-relpath="../../../../" data-types="mint.Button,mint.ButtonOptions,mint.Canvas,mint.CanvasOptions,mint.Checkbox,mint.CheckboxOptions,mint.ChildBounds,mint.Control,mint.ControlOptions,mint.Dropdown,mint.DropdownOptions,mint.Image,mint.ImageOptions,mint.KeySignal,mint.Label,mint.LabelOptions,mint.List,mint.ListOptions,mint.MouseSignal,mint.Panel,mint.PanelOptions,mint.Progress,mint.ProgressOptions,mint.Scroll,mint.ScrollOptions,mint.Slider,mint.SliderOptions,mint.TextEdit,mint.TextEditOptions,mint.TextSignal,mint.Window,mint.WindowOptions,mint.core.DebugError,mint.core.Macros,mint.core.Signal,mint.core.unifill.CodePoint,mint.core.unifill.CodePointIter,mint.core.unifill.Exception,mint.core.unifill.InternalEncoding,mint.core.unifill.InternalEncodingBackwardIter,mint.core.unifill.InternalEncodingIter,mint.core.unifill.Unicode,mint.core.unifill.Unifill,mint.core.unifill.Utf16,mint.core.unifill.Utf32,mint.core.unifill.Utf8,mint.core.unifill._CodePoint.CodePoint_Impl_,mint.core.unifill._InternalEncoding.UtfX,mint.core.unifill._Utf16.StringU16,mint.core.unifill._Utf16.StringU16Buffer,mint.core.unifill._Utf16.StringU16Buffer_Impl_,mint.core.unifill._Utf16.StringU16_Impl_,mint.core.unifill._Utf16.Utf16Impl,mint.core.unifill._Utf16.Utf16_Impl_,mint.core.unifill._Utf32.Utf32_Impl_,mint.core.unifill._Utf8.StringU8,mint.core.unifill._Utf8.StringU8_Impl_,mint.core.unifill._Utf8.Utf8Impl,mint.core.unifill._Utf8.Utf8_Impl_,mint.focus.Focus,mint.layout.margins.AnchorType,mint.layout.margins.Layouts,mint.layout.margins.MarginTarget,mint.layout.margins.MarginType,mint.layout.margins.Margins,mint.layout.margins.SizeTarget,mint.layout.margins._Margins.Anchor,mint.layout.margins._Margins.AnchorType_Impl_,mint.layout.margins._Margins.Margin,mint.layout.margins._Margins.MarginTarget_Impl_,mint.layout.margins._Margins.MarginType_Impl_,mint.layout.margins._Margins.SizeTarget_Impl_,mint.layout.margins._Margins.Sizer,mint.render.Render,mint.render.Renderer,mint.render.Rendering,mint.render.luxe.Button,mint.render.luxe.Canvas,mint.render.luxe.Checkbox,mint.render.luxe.Convert,mint.render.luxe.Dropdown,mint.render.luxe.Image,mint.render.luxe.Label,mint.render.luxe.List,mint.render.luxe.LuxeMintRender,mint.render.luxe.Panel,mint.render.luxe.Progress,mint.render.luxe.Scroll,mint.render.luxe.Slider,mint.render.luxe.TextEdit,mint.render.luxe.Window,mint.render.luxe._Button.LuxeMintButtonOptions,mint.render.luxe._Canvas.LuxeMintCanvasOptions,mint.render.luxe._Checkbox.LuxeMintCheckboxOptions,mint.render.luxe._Dropdown.LuxeMintDropdownOptions,mint.render.luxe._Image.LuxeMintImageOptions,mint.render.luxe._Label.LuxeMintLabelOptions,mint.render.luxe._List.LuxeMintListOptions,mint.render.luxe._Panel.LuxeMintPanelOptions,mint.render.luxe._Progress.LuxeMintProgressOptions,mint.render.luxe._Scroll.LuxeMintScrollOptions,mint.render.luxe._Slider.LuxeMintSliderOptions,mint.render.luxe._TextEdit.LuxeMintTextEditOptions,mint.render.luxe._Window.LuxeMintWindowOptions,mint.types.Helper,mint.types.InteractState,mint.types.KeyCode,mint.types.KeyEvent,mint.types.ModState,mint.types.MouseButton,mint.types.MouseEvent,mint.types.TextAlign,mint.types.TextEvent,mint.types.TextEventType,mint.types._Types.InteractState_Impl_,mint.types._Types.KeyCode_Impl_,mint.types._Types.MouseButton_Impl_,mint.types._Types.TextAlign_Impl_"></script>


<h1>Unifill</h1>
<small>`mint.core.unifill.Unifill`</small>

Unifill provides Unicode-code-point-wise methods on Strings. It is
   ideally used with 'using Unifill' and then acts as an extension to
   the String class.

<hr/>

`class`
<hr/>


&nbsp;
&nbsp;






<h3>Methods</h3> <hr/><span class="method apipage">
            <a name="uCharAt"><a class="lift" href="#uCharAt">uCharAt</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uCharAt(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>) : [String](http://api.haxe.org/String.html)</code><br/><span class="small_desc_flat">Returns the character at position `index` by code points of String `s`.</span>


</span>
<span class="method apipage">
            <a name="uCharCodeAt"><a class="lift" href="#uCharCodeAt">uCharCodeAt</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uCharCodeAt(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the code point as Int at position `index` by code points of String `s`.</span>


</span>
<span class="method apipage">
            <a name="uCodePointAt"><a class="lift" href="#uCodePointAt">uCodePointAt</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uCodePointAt(s:[String](http://api.haxe.org/String.html)<span></span>, index:[Int](http://api.haxe.org/Int.html)<span></span>) : [mint.core.unifill.CodePoint](../../../../api/mint/core/unifill/CodePoint.html)</code><br/><span class="small_desc_flat">Returns the code point at position `index` by code points of String `s`.</span>


</span>
<span class="method apipage">
            <a name="uCompare"><a class="lift" href="#uCompare">uCompare</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uCompare(a:[String](http://api.haxe.org/String.html)<span></span>, b:[String](http://api.haxe.org/String.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Compares String `a` and `b`.</span>


</span>
<span class="method apipage">
            <a name="uIndexOf"><a class="lift" href="#uIndexOf">uIndexOf</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uIndexOf(s:[String](http://api.haxe.org/String.html)<span></span>, value:[String](http://api.haxe.org/String.html)<span></span>, startIndex:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the position of the leftmost occurence of the str within String `s`.

       `startIndex` is counted by code points.</span>


</span>
<span class="method apipage">
            <a name="uIterator"><a class="lift" href="#uIterator">uIterator</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uIterator(s:[String](http://api.haxe.org/String.html)<span></span>) : [mint.core.unifill.CodePointIter](../../../../api/mint/core/unifill/CodePointIter.html)</code><br/><span class="small_desc_flat">Returns an iterator of the code points of String `s`.</span>


</span>
<span class="method apipage">
            <a name="uLastIndexOf"><a class="lift" href="#uLastIndexOf">uLastIndexOf</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uLastIndexOf(s:[String](http://api.haxe.org/String.html)<span></span>, value:[String](http://api.haxe.org/String.html)<span></span>, startIndex:[Int](http://api.haxe.org/Int.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the position of the rightmost occurence of the str within String `s`.

       `startIndex` is counted by code points.</span>


</span>
<span class="method apipage">
            <a name="uLength"><a class="lift" href="#uLength">uLength</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uLength(s:[String](http://api.haxe.org/String.html)<span></span>) : [Int](http://api.haxe.org/Int.html)</code><br/><span class="small_desc_flat">Returns the number of Unicode code points of String `s`.</span>


</span>
<span class="method apipage">
            <a name="uSplit"><a class="lift" href="#uSplit">uSplit</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uSplit(s:[String](http://api.haxe.org/String.html)<span></span>, delimiter:[String](http://api.haxe.org/String.html)<span></span>) : [Array](http://api.haxe.org/Array.html)&lt;[String](http://api.haxe.org/String.html)&gt;</code><br/><span class="small_desc_flat">Splits String `s` at each occurence of `delimiter`.</span>


</span>
<span class="method apipage">
            <a name="uSubstr"><a class="lift" href="#uSubstr">uSubstr</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uSubstr(s:[String](http://api.haxe.org/String.html)<span></span>, startIndex:[Int](http://api.haxe.org/Int.html)<span></span>, length:[Int](http://api.haxe.org/Int.html)<span></span>) : [String](http://api.haxe.org/String.html)</code><br/><span class="small_desc_flat">Returns `length` characters of String `s`, starting at position `startIndex`.

       `startIndex` and `length` are counted by code points.</span>


</span>
<span class="method apipage">
            <a name="uSubstring"><a class="lift" href="#uSubstring">uSubstring</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uSubstring(s:[String](http://api.haxe.org/String.html)<span></span>, startIndex:[Int](http://api.haxe.org/Int.html)<span></span>, endIndex:[Int](http://api.haxe.org/Int.html)<span></span>) : [String](http://api.haxe.org/String.html)</code><br/><span class="small_desc_flat">Returns the part of String `s` from `startIndex` to `endIndex`.

       `startIndex` and `endIndex` are counted by code points.</span>


</span>
<span class="method apipage">
            <a name="uToString"><a class="lift" href="#uToString">uToString</a></a><span class="inline-block static">inline</span><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">uToString(codePoints:[Iterable](#)&lt;[mint.core.unifill.CodePoint](../../../../api/mint/core/unifill/CodePoint.html)&gt;<span></span>) : [String](http://api.haxe.org/String.html)</code><br/><span class="small_desc_flat">Converts `codePoints` to string.</span>


</span>



<hr/>

&nbsp;
&nbsp;
&nbsp;
&nbsp;