
<a href="{{{rel_path}}}index.html" id="logo"><img src="{{{rel_path}}}images/logo.png" /></a>

<div class="topmenu">
[api]({{{rel_path}}}api/index.html) . ~~guide~~ ![github]({{{rel_path}}}/images/github.png)  [source](https://github.com/snowkit/mint/) . [issues](https://github.com/snowkit/mint/issues/)
</div>

---

<br/>
<a name="about"></a> 
##mínt

**mint** is **minimal, renderer agnostic ui library** for **Haxe**.

> “`m`inimal `int`erface”


&nbsp;

[ <img src="{{{rel_path}}}images/haxe.png" target="_blank" class="small-image"/> ](http://haxe.org)   

<small class="haxedesc">Haxe is an expressive, beautiful modern programming language <br/>
      that compiles its own code into other languages. <a href="http://haxe.org/" target="_blank"> learn more</a> </small>

<br/>

---

<a name="about"></a>
### About

**Purpose**   
mint is a game and tool focused library.
mint is intentionally minimal and to the point.   

It is designed around the notion that not every game    
looks the same. Not every game uses the same UI skin   
across all UI elements. That games are particularly   
nuanced when it comes to user interfaces and interaction.

**Goals**

- **efficient** - no superfluous code or requirements for controls
- **light weight** - only the essentials, easy to include
- **easy to use** - rapid iteration for prototyping UI and UI based games
- **flexible** - per control renderer instances allow nuanced visual diversion
- **extensible** - Designed for _writing_ UI, quickly and to the point
- **agnostic** - handles logic. abstracts the framework and layout specifics

&nbsp;

This means the core library remains pure, and ideally use case specific   
controls are shared via simple, isolated controls with similar intentions.

More [thoughts](http://snowkit.org/2015/01/25/mint-details-part-1/) here in the mean time.


---

<small style="display:block;margin:auto;">
<a href="{{{rel_path}}}images/controls.png">
<img src="{{{rel_path}}}images/controls.png" width="550px" /></a>
<br/>
rendered in [luxe engine](http://luxeengine.com/)
</small>

---

<a name="setup"></a>
## setup

`haxelib git mint https://github.com/snowkit/mint.git`

<a name="quickstart"></a>
## quick start

- create a canvas
- feed it events!
    - canvas.mousemove({ ... });
    - canvas.keydown({ ... });
    - canvas.update(dt);

---

###Alpha

<small>
Please note   

mint is currently considered alpha, which means there may be bugs, inconsistencies, incomplete implementations, and possible minor API changes.
It is still considered fairly usable and is being used by multiple tools and games, but there are things to tighten up before it can be called beta or final. 

Join us in developing and testing the library and tools, below.

**luxe specifics**   
The `mint.render.luxe` code and `test_luxe` folders are temporarily stored   
in the main repo for iteration and examples of a complete renderer, for the tests.

In the near future this will be moved to it's own repo as it's meant to be.

</small>

### Examples 
In the repo and in the wild

- See the [tests/test_luxe](https://github.com/snowkit/mint/tree/master/tests/test_luxe) folder
- See https://github.com/FuzzyWuzzie/LuxeParticleDesigner/

### Controls

Current default controls include

- Control (empty)
- Canvas
- Button
- Checkbox
- Dropdown
- Image
- Label
- List
- Panel
- Progress
- Scroll area
- Slider
- TextEdit
- Window

---

<a name="example"></a>
### Quick look

```haxe

class Example {
    ...
    function create() {

        var rendering = new YourFrameworkMintRenderer();

        canvas = new mint.Canvas({
            name:'canvas',
            rendering: rendering,
            x: 0, y:0, w: 960, h: 640,
            options: {
                framework_specific_option: new FrameworkType()
            }
        });

        new mint.Label({
            parent: canvas,
            name: 'label',
            x:10, y:10, w:100, h:32,
            text: 'hello mínt',
            align:left,
            text_size: 14,
            onclick: function(_,_) { trace('hello mint!'); }
        });

    }
} 

```

---

<a name="contribute"></a>
## Contribute

Feedback, bugs, PR's and suggestions definitely welcome!

<small>_(They will be weighted against the purpose and goals of the library)_</small>

---


&nbsp;
&nbsp;

<a href="http://snowkit.org" ><img src="{{{rel_path}}}images/snowkit.png" /></a>

&nbsp;
&nbsp;

---

**mint is a [snõwkit](http://snowkit.org/) community library**

[feedback](https://github.com/snowkit/mint/issues)
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
