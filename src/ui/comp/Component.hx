package ui.comp;

import h2d.Flow.FlowAlign;

class Component extends h2d.Flow {
    var hover:Bool;
    var active:Bool;
    var parentFlow:h2d.Flow;

    public function new(parent:h2d.Flow) {
        super(parent);
        parentFlow = parent;

        enableInteractive = true;

        hover = false;
        active = false;

        interactive.onOver = over;
        interactive.onOut = out;
        interactive.onPush = push;
        interactive.onRelease = release;
    }

    public function setAlign(v:FlowAlign, h:FlowAlign) {
        var props = parentFlow.getProperties(this);
        if(props != null) {
            props.verticalAlign = v;
            props.horizontalAlign = h;
        }
    }

    public function setPadding(l:Int = 0, r:Int = 0, t:Int = 0, b:Int = 0) {
        var props = parentFlow.getProperties(this);

        if(props != null) {
            props.paddingBottom = b;
            props.paddingTop = t;
            props.paddingRight = r;
            props.paddingLeft = l;
        }
    }

    function over(_) {
        hover = true;
        onHover();
    }

    function out(_) {
        hover = false;
        onOut();
    }

    function push(_) {
        active = true;
        onPush();
    }

    function release(_) {
        active = false;
        onRelease();

        if(hover) {
            onClick();
        }
    }

    public function reset() {}

    public function refresh() {}

    public dynamic function onClick() {}

    public dynamic function onHover() {}

    public dynamic function onOut() {}

    public dynamic function onPush() {}

    public dynamic function onRelease() {}
}
