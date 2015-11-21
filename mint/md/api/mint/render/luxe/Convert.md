
[![Logo](../../../../images/logo.png)](../../../../api/index.html)

<hr/>
<a href="#" id="search_bar" onclick="return;"><div> search API <em>(or start typing anywhere)</em> </div></a>
<hr/>

<script src="../../../../js/omnibar.js"> </script>
<link rel="stylesheet" type="text/css" href="../../../../css/omnibar.css" media="all">

<div id="omnibar"> <a href="#" onclick="return" id="omnibar_close"></a> <input id="omnibar_text" type="text" placeholder="search types..."></input></div>
<script  id="typelist" data-relpath="../../../../" data-types="mint.Button,mint.ButtonOptions,mint.Canvas,mint.CanvasOptions,mint.Checkbox,mint.CheckboxOptions,mint.ChildBounds,mint.Control,mint.ControlOptions,mint.Dropdown,mint.DropdownOptions,mint.Image,mint.ImageOptions,mint.KeySignal,mint.Label,mint.LabelOptions,mint.List,mint.ListOptions,mint.MouseSignal,mint.Panel,mint.PanelOptions,mint.Progress,mint.ProgressOptions,mint.Scroll,mint.ScrollOptions,mint.Slider,mint.SliderOptions,mint.TextEdit,mint.TextEditOptions,mint.TextSignal,mint.Window,mint.WindowOptions,mint.core.DebugError,mint.core.Macros,mint.core.Signal,mint.core.unifill.CodePoint,mint.core.unifill.CodePointIter,mint.core.unifill.Exception,mint.core.unifill.InternalEncoding,mint.core.unifill.InternalEncodingBackwardIter,mint.core.unifill.InternalEncodingIter,mint.core.unifill.Unicode,mint.core.unifill.Unifill,mint.core.unifill.Utf16,mint.core.unifill.Utf32,mint.core.unifill.Utf8,mint.core.unifill._CodePoint.CodePoint_Impl_,mint.core.unifill._InternalEncoding.UtfX,mint.core.unifill._Utf16.StringU16,mint.core.unifill._Utf16.StringU16Buffer,mint.core.unifill._Utf16.StringU16Buffer_Impl_,mint.core.unifill._Utf16.StringU16_Impl_,mint.core.unifill._Utf16.Utf16Impl,mint.core.unifill._Utf16.Utf16_Impl_,mint.core.unifill._Utf32.Utf32_Impl_,mint.core.unifill._Utf8.StringU8,mint.core.unifill._Utf8.StringU8_Impl_,mint.core.unifill._Utf8.Utf8Impl,mint.core.unifill._Utf8.Utf8_Impl_,mint.focus.Focus,mint.layout.margins.AnchorType,mint.layout.margins.Layouts,mint.layout.margins.MarginTarget,mint.layout.margins.MarginType,mint.layout.margins.Margins,mint.layout.margins.SizeTarget,mint.layout.margins._Margins.Anchor,mint.layout.margins._Margins.AnchorType_Impl_,mint.layout.margins._Margins.Margin,mint.layout.margins._Margins.MarginTarget_Impl_,mint.layout.margins._Margins.MarginType_Impl_,mint.layout.margins._Margins.SizeTarget_Impl_,mint.layout.margins._Margins.Sizer,mint.render.Render,mint.render.Renderer,mint.render.Rendering,mint.render.luxe.Button,mint.render.luxe.Canvas,mint.render.luxe.Checkbox,mint.render.luxe.Convert,mint.render.luxe.Dropdown,mint.render.luxe.Image,mint.render.luxe.Label,mint.render.luxe.List,mint.render.luxe.LuxeMintRender,mint.render.luxe.Panel,mint.render.luxe.Progress,mint.render.luxe.Scroll,mint.render.luxe.Slider,mint.render.luxe.TextEdit,mint.render.luxe.Window,mint.render.luxe._Button.LuxeMintButtonOptions,mint.render.luxe._Canvas.LuxeMintCanvasOptions,mint.render.luxe._Checkbox.LuxeMintCheckboxOptions,mint.render.luxe._Dropdown.LuxeMintDropdownOptions,mint.render.luxe._Image.LuxeMintImageOptions,mint.render.luxe._Label.LuxeMintLabelOptions,mint.render.luxe._List.LuxeMintListOptions,mint.render.luxe._Panel.LuxeMintPanelOptions,mint.render.luxe._Progress.LuxeMintProgressOptions,mint.render.luxe._Scroll.LuxeMintScrollOptions,mint.render.luxe._Slider.LuxeMintSliderOptions,mint.render.luxe._TextEdit.LuxeMintTextEditOptions,mint.render.luxe._Window.LuxeMintWindowOptions,mint.types.Helper,mint.types.InteractState,mint.types.KeyCode,mint.types.KeyEvent,mint.types.ModState,mint.types.MouseButton,mint.types.MouseEvent,mint.types.TextAlign,mint.types.TextEvent,mint.types.TextEventType,mint.types._Types.InteractState_Impl_,mint.types._Types.KeyCode_Impl_,mint.types._Types.MouseButton_Impl_,mint.types._Types.TextAlign_Impl_"></script>


<h1>Convert</h1>
<small>`mint.render.luxe.Convert`</small>



<hr/>

`class`<br/><span class="meta">
meta: @:directlyUsed</span>

<hr/>


&nbsp;
&nbsp;






<h3>Methods</h3> <hr/><span class="method apipage">
            <a name="bounds"><a class="lift" href="#bounds">bounds</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">bounds(\_control:[mint.Control](../../../../api/mint/Control.html)<span></span>) : [luxe.Rectangle](#)</code><br/><span class="small_desc_flat">from mint.Control bounds to luxe.Rectangle</span>


</span>
<span class="method apipage">
            <a name="interact_state"><a class="lift" href="#interact_state">interact\_state</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">interact\_state(\_state:[luxe.InteractState](#)<span></span>) : [mint.types.InteractState](../../../../api/mint/types/InteractState.html)</code><br/><span class="small_desc_flat">from luxe.Input.InteractState to mint.InteractState</span>


</span>
<span class="method apipage">
            <a name="key_code"><a class="lift" href="#key_code">key\_code</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">key\_code(\_keycode:[Int](http://api.haxe.org/Int.html)<span></span>) : [mint.types.KeyCode](../../../../api/mint/types/KeyCode.html)</code><br/><span class="small_desc_flat">from luxe.Input.Key to mint.KeyCode</span>


</span>
<span class="method apipage">
            <a name="key_event"><a class="lift" href="#key_event">key\_event</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">key\_event(\_event:[luxe.KeyEvent](#)<span></span>) : [mint.types.KeyEvent](../../../../api/mint/types/KeyEvent.html)</code><br/><span class="small_desc_flat">from luxe.Input.KeyEvent to mint.KeyEvent</span>


</span>
<span class="method apipage">
            <a name="mod_state"><a class="lift" href="#mod_state">mod\_state</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">mod\_state(\_mod:[luxe.ModState](#)<span></span>) : [mint.types.ModState](../../../../api/mint/types/ModState.html)</code><br/><span class="small_desc_flat">from luxe.Input.ModState to mint.ModState</span>


</span>
<span class="method apipage">
            <a name="mouse_button"><a class="lift" href="#mouse_button">mouse\_button</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">mouse\_button(\_button:[luxe.MouseButton](#)<span></span>) : [mint.types.MouseButton](../../../../api/mint/types/MouseButton.html)</code><br/><span class="small_desc_flat">from luxe.Input.MouseButton to mint.MouseButton</span>


</span>
<span class="method apipage">
            <a name="mouse_event"><a class="lift" href="#mouse_event">mouse\_event</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">mouse\_event(\_event:[luxe.MouseEvent](#)<span></span>, view:[phoenix.Camera](#)<span></span>) : [mint.types.MouseEvent](../../../../api/mint/types/MouseEvent.html)</code><br/><span class="small_desc_flat">from luxe.Input.MouseEvent to mint.MouseEvent</span>


</span>
<span class="method apipage">
            <a name="text_align"><a class="lift" href="#text_align">text\_align</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">text\_align(\_align:[mint.types.TextAlign](../../../../api/mint/types/TextAlign.html)<span></span>) : [luxe.TextAlign](#)</code><br/><span class="small_desc_flat">from mint.TextAlign to luxe.Text.TextAlign</span>


</span>
<span class="method apipage">
            <a name="text_event"><a class="lift" href="#text_event">text\_event</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">text\_event(\_event:[luxe.TextEvent](#)<span></span>) : [mint.types.TextEvent](../../../../api/mint/types/TextEvent.html)</code><br/><span class="small_desc_flat">from luxe.Input.TextEvent to mint.TextEvent</span>


</span>
<span class="method apipage">
            <a name="text_event_type"><a class="lift" href="#text_event_type">text\_event\_type</a></a><span class="inline-block static">static</span><div class="clear"></div>
            <code class="signature apipage">text\_event\_type(\_type:[luxe.TextEventType](#)<span></span>) : [mint.types.TextEventType](../../../../api/mint/types/TextEventType.html)</code><br/><span class="small_desc_flat"></span>


</span>



<hr/>

&nbsp;
&nbsp;
&nbsp;
&nbsp;