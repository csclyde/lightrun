package scene;

import ui.comp.LabelButton;
import eng.ControlScheme;

class ControlOptions extends Scene {
    public var uiRoot:h2d.Flow;
    public var container:h2d.Flow;
    public var labelCol:h2d.Flow;
    public var optionCol:h2d.Flow;
    public var menuItems:Array<ui.comp.Component>;

    public var returnItem:LabelButton;

    public function new(p:Process) {
        super(p);
        createRoot();

        uiRoot = new h2d.Flow(root);
        uiRoot.horizontalAlign = uiRoot.verticalAlign = Middle;
        uiRoot.layout = Vertical;
        uiRoot.fillWidth = true;

        container = new h2d.Flow(uiRoot);
        container.layout = Horizontal;

        labelCol = new h2d.Flow(container);
        labelCol.layout = Vertical;
        labelCol.horizontalAlign = Right;
        labelCol.fillWidth = true;

        optionCol = new h2d.Flow(container);
        optionCol.layout = Vertical;
        optionCol.horizontalAlign = Left;
        optionCol.fillWidth = true;

        menuItems = [];

        var schemeArray = [];
        for(k => v in ControlScheme) {
            schemeArray.push(v);
        }
        schemeArray.sort((a, b) -> a.order - b.order);

        for(control in schemeArray) {
            if(!control.preventRebind) {
                var inputDesc = new ui.comp.Label(labelCol, control.desc + ':   ', Assets.magicBookFont);
                inputDesc.setScale(0.5);
                menuItems.push(inputDesc);

                var bindItem = new ui.KeyBind(optionCol, control);
                bindItem.setScale(0.5);
                menuItems.push(bindItem);
            }
        }

        returnItem = new ui.comp.LabelButton(uiRoot, 'Return');
        menuItems.push(returnItem);
        returnItem.onClick = function() {
            onEscape();
        }
    }

    override function reset() {}

    override function resize() {
        uiRoot.maxWidth = gw();
        uiRoot.minHeight = h();
        container.setScale(Const.SCALE);
        returnItem.setScale(Const.SCALE);
    }

    override function onEscape() {
        game.switchScene(game.optionsScene);
    }

    override public function switchTo() {
        for(i in menuItems) {
            i.refresh();
        }
    }

    override public function switchFrom() {}
}
