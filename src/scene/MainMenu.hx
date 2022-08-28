package scene;

import eng.tool.VectorText;
import ui.comp.LabelButton;
import sys.FileSystem;

class MainMenu extends Scene {
    public var uiRoot:h2d.Flow;
    public var menuItems:Array<ui.comp.Component>;

    var continueGameItem:LabelButton;
    var newGameItem:LabelButton;

    var logo:VectorText;

    public function new(p:Process) {
        super(p);

        createRoot();

        menuItems = [];

        uiRoot = new h2d.Flow(root);
        uiRoot.horizontalAlign = uiRoot.verticalAlign = Middle;
        uiRoot.layout = Vertical;

        logo = new VectorText(uiRoot, 16);
        logo.setStyle(24, 1, 0xFF00FF);
        logo.drawText(0, 0, "LIGHTRUN");

        newGameItem = new ui.comp.LabelButton(uiRoot, 'PLAY GAME');
        menuItems.push(newGameItem);
        newGameItem.onClick = function() {
            game.saver.loadGame('slot1');
            game.switchScene(game.worldScene, () -> {}, 1);
        }

        // var optionsItem = new ui.comp.LabelButton(uiRoot, 'Options');
        // menuItems.push(optionsItem);
        // optionsItem.onClick = function() {
        //     game.optionsScene.returnScene = this;
        //     game.switchScene(game.optionsScene);
        // }

        var quitItem = new ui.comp.LabelButton(uiRoot, 'QUIT GAME');
        menuItems.push(quitItem);
        quitItem.onClick = function() {
            onEscape();
        }
    }

    override function resize() {
        uiRoot.setScale(Const.SCALE);
        uiRoot.minWidth = gw();
        uiRoot.minHeight = gh();
    }

    override function onEscape() {
        Events.send('exit_game');
    }

    override public function switchTo() {}

    override public function switchFrom() {
        for(item in menuItems) {
            item.reset();
        }
    }
}
