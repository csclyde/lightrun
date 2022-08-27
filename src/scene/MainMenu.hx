package scene;

import ui.comp.LabelButton;
import sys.FileSystem;

class MainMenu extends Scene {
    public var uiRoot:h2d.Flow;
    public var menuItems:Array<ui.comp.Component>;
    public var logo:h2d.Bitmap;

    var continueGameItem:LabelButton;
    var newGameItem:LabelButton;

    public function new(p:Process) {
        super(p);

        createRoot();

        menuItems = [];

        uiRoot = new h2d.Flow(root);
        uiRoot.horizontalAlign = uiRoot.verticalAlign = Middle;
        uiRoot.layout = Vertical;

        continueGameItem = new ui.comp.LabelButton(uiRoot, 'Continue Journey');
        menuItems.push(continueGameItem);
        continueGameItem.onClick = function() {
            game.saver.loadGame('slot1');
            game.switchScene(game.worldScene, () -> ScriptRunner.run('Dungeon/LoadNextLevel'), 1);
        }

        newGameItem = new ui.comp.LabelButton(uiRoot, 'Begin Journey');
        menuItems.push(newGameItem);
        newGameItem.onClick = function() {
            game.saver.loadGame('slot1');
            game.switchScene(game.worldScene, () -> ScriptRunner.run('Courtroom/Judgement'), 1);
        }

        var optionsItem = new ui.comp.LabelButton(uiRoot, 'Options');
        menuItems.push(optionsItem);
        optionsItem.onClick = function() {
            game.optionsScene.returnScene = this;
            game.switchScene(game.optionsScene);
        }

        var quitItem = new ui.comp.LabelButton(uiRoot, 'Quit Game');
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

    override public function switchTo() {
        if(FileSystem.exists('slot1.sav')) {
            newGameItem.visible = false;
            continueGameItem.visible = true;
        }else {
            newGameItem.visible = true;
            continueGameItem.visible = false;
        }
    }

    override public function switchFrom() {
        for(item in menuItems) {
            item.reset();
        }
    }
}
