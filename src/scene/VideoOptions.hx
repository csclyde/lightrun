package scene;

import ui.comp.Label;
import hxd.Window.DisplayMode;

class VideoOptions extends Scene {
    public var uiRoot:h2d.Flow;
    public var menuItems:Array<ui.comp.Component>;

    public function new(p:Process) {
        super(p);
        createRoot();

        uiRoot = new h2d.Flow(root);
        uiRoot.horizontalAlign = uiRoot.verticalAlign = Middle;
        uiRoot.layout = Vertical;
    }

    override function init() {
        var container = new h2d.Flow(uiRoot);
        container.layout = Horizontal;

        var labelCol = new h2d.Flow(container);
        labelCol.layout = Vertical;
        labelCol.horizontalAlign = Right;
        labelCol.fillWidth = true;

        var optionCol = new h2d.Flow(container);
        optionCol.layout = Vertical;
        optionCol.horizontalAlign = Left;
        optionCol.fillWidth = true;

        menuItems = [];

        var displayLabel = new ui.comp.Label(labelCol, 'Display Mode: ', Assets.magicBookFont);
        var displayItem = new ui.comp.OptionPicker(optionCol, () -> {
            return game.saver.settings.video.displayMode;
        }, (option:Dynamic) -> {
            game.saver.settings.video.displayMode = option;
            game.saver.applySettings();
        },
            ['Borderless' => Borderless, 'Fullscreen' => Fullscreen, 'Windowed' => Windowed]);

        var vsyncLabel = new ui.comp.Label(labelCol, 'VSync: ', Assets.magicBookFont);
        var vsyncItem = new ui.comp.OptionPicker(optionCol, () -> {
            return game.saver.settings.video.vsync;
        }, (option:Dynamic) -> {
            game.saver.settings.video.vsync = option;
            game.saver.applySettings();
        }, ['On' => true, 'Off' => false,]);

        var screenshakeLabel = new ui.comp.Label(labelCol, 'Screen Shake: ', Assets.magicBookFont);
        var screenshakeItem = new ui.comp.OptionSlider(optionCol, () -> {
            return game.saver.settings.video.screenshake;
        }, (option:Dynamic) -> {
            game.saver.settings.video.screenshake = option;
            game.saver.applySettings();
        }, 1.0);

        var returnItem = new ui.comp.LabelButton(uiRoot, 'Return');
        menuItems.push(returnItem);
        returnItem.onClick = function() {
            game.switchScene(game.optionsScene);
        }
    }

    override function resize() {
        uiRoot.setScale(Const.SCALE);
        uiRoot.minWidth = gw();
        uiRoot.minHeight = gh();
    }

    override function onEscape() {
        game.switchScene(game.optionsScene);
    }

    override public function switchFrom() {
        for(item in menuItems) {
            item.reset();
        }
    }
}
