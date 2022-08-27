package scene;

class AudioOptions extends Scene {
    public var uiRoot:h2d.Flow;
    public var menuItems:Array<ui.comp.Component>;

    public function new(p:Process) {
        super(p);
        createRoot();

        uiRoot = new h2d.Flow(root);
        uiRoot.horizontalAlign = uiRoot.verticalAlign = Middle;
        uiRoot.layout = Vertical;

        menuItems = [];
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

        var masterVolumeLabel = new ui.comp.Label(labelCol, 'Master Volume: ', Assets.magicBookFont);
        var masterVolumeItem = new ui.comp.OptionSlider(optionCol, () -> {
            return game.saver.settings.audio.masterVolume;
        }, (val:Dynamic) -> {
            game.saver.settings.audio.masterVolume = Math.floor(val * 10) / 10;
            game.saver.applySettings();
        }, 2.0);

        var musicVolumeLabel = new ui.comp.Label(labelCol, 'Music Volume: ', Assets.magicBookFont);
        var musicVolumeItem = new ui.comp.OptionSlider(optionCol, () -> {
            return game.saver.settings.audio.musicVolume;
        }, (val:Dynamic) -> {
            game.saver.settings.audio.musicVolume = Math.floor(val * 10) / 10;
            game.saver.applySettings();
        }, 2.0);

        var sfxVolumeLabel = new ui.comp.Label(labelCol, 'Effects Volume: ', Assets.magicBookFont);
        var sfxVolumeItem = new ui.comp.OptionSlider(optionCol, () -> {
            return game.saver.settings.audio.sfxVolume;
        }, (val:Dynamic) -> {
            game.saver.settings.audio.sfxVolume = Math.floor(val * 10) / 10;
            game.saver.applySettings();
        }, 2.0);

        var returnItem = new ui.comp.LabelButton(uiRoot, 'Return');
        menuItems.push(returnItem);
        returnItem.onClick = function() {
            onEscape();
        }
    }

    override function reset() {}

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
