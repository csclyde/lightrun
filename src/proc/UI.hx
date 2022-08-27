package proc;

import ui.*;

class UI extends Process {
    public var uiRoot:h2d.Flow;
    public var hud:h2d.Flow;

    public function new(p:Process) {
        super(p);
        uiRoot = new h2d.Flow();
    }

    override function init() {
        uiRoot.setPosition(0, 0);
        uiRoot.horizontalAlign = uiRoot.verticalAlign = Middle;
        uiRoot.enableInteractive = true;
        uiRoot.layout = Stack;
        world.hud.add(uiRoot, Const.UI_OVERLAY_LAYER);

        Events.subscribe('refresh_hud', refreshHud);
        Events.subscribe('show_hud', showHud);
        Events.subscribe('hide_hud', hideHud);
    }

    override function reset() {}

    public override function resize() {
        uiRoot.minWidth = gw();
        uiRoot.minHeight = gh();
    }

    public function hideHud(p) {}

    public function showHud(p) {}

    public function refreshHud(params:Dynamic) {}
}
