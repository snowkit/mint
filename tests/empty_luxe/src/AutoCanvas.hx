import mint.render.luxe.Convert;

/** This canvas will automatically listen to relevant luxe events, when you call auto_listen()
    which is convenient for quickly testing things and throwing ideas around. To stop listening call auto_unlisten(). */
class AutoCanvas extends mint.Canvas {

    public function auto_listen() {

        Luxe.on(Luxe.Ev.render,     conv_render);
        Luxe.on(Luxe.Ev.update,     conv_update);
        Luxe.on(Luxe.Ev.mousewheel, conv_mousewheel);
        Luxe.on(Luxe.Ev.mousedown,  conv_mousedown);
        Luxe.on(Luxe.Ev.mouseup,    conv_mouseup);
        Luxe.on(Luxe.Ev.mousemove,  conv_mousemove);
        Luxe.on(Luxe.Ev.keyup,      conv_keyup);
        Luxe.on(Luxe.Ev.keydown,    conv_keydown);
        Luxe.on(Luxe.Ev.textinput,  conv_textinput);
            //make sure we clean up
        ondestroy.listen(auto_unlisten);

    } //listen

    public function auto_unlisten() {

        Luxe.off(Luxe.Ev.render,     conv_render);
        Luxe.off(Luxe.Ev.update,     conv_update);
        Luxe.off(Luxe.Ev.mousewheel, conv_mousewheel);
        Luxe.off(Luxe.Ev.mousedown,  conv_mousedown);
        Luxe.off(Luxe.Ev.mouseup,    conv_mouseup);
        Luxe.off(Luxe.Ev.mousemove,  conv_mousemove);
        Luxe.off(Luxe.Ev.keyup,      conv_keyup);
        Luxe.off(Luxe.Ev.keydown,    conv_keydown);
        Luxe.off(Luxe.Ev.textinput,  conv_textinput);
            //no longer try to clean up
        ondestroy.remove(auto_unlisten);

    } //

    function conv_update(dt:Float)  update(dt);
    function conv_render(_)         render();
    function conv_mousewheel(e)     mousewheel(Convert.mouse_event(e));
    function conv_mousedown(e)      mousedown(Convert.mouse_event(e));
    function conv_mouseup(e)        mouseup(Convert.mouse_event(e));
    function conv_mousemove(e)      mousemove(Convert.mouse_event(e));
    function conv_keyup(e)          keyup(Convert.key_event(e));
    function conv_keydown(e)        keydown(Convert.key_event(e));
    function conv_textinput(e)      textinput(Convert.text_event(e));

} //AutoCanvas
