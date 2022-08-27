package scene;

class Pause extends Scene {
    public var uiRoot:h2d.Flow;
    public var menuItems:Array<ui.comp.Component>;

    public function new(p:Process) {
        super(p);
        createRoot();

        uiRoot = new h2d.Flow(root);
        uiRoot.horizontalAlign = uiRoot.verticalAlign = Middle;
        uiRoot.enableInteractive = true;
        uiRoot.layout = Vertical;

        menuItems = [];

        var resumeItem = new ui.comp.LabelButton(uiRoot, 'Resume Game');
        menuItems.push(resumeItem);
        resumeItem.onClick = function() {
            game.switchScene(game.worldScene);
        }

        var optionsItem = new ui.comp.LabelButton(uiRoot, 'Options');
        menuItems.push(optionsItem);
        optionsItem.onClick = function() {
            game.optionsScene.returnScene = this;
            game.switchScene(game.optionsScene);
        }

        var returnItem = new ui.comp.LabelButton(uiRoot, 'Return to Menu');
        menuItems.push(returnItem);
        returnItem.onClick = function() {
            world.reset();
            game.switchScene(game.menuScene);
        }

        var quitItem = new ui.comp.LabelButton(uiRoot, 'Quit Game');
        menuItems.push(quitItem);
        quitItem.onClick = function() {
            Events.send('exit_game');
        }
    }

    override function resize() {
        uiRoot.setScale(Const.SCALE);
        uiRoot.minWidth = Math.ceil(w() / Const.SCALE);
        uiRoot.minHeight = Math.ceil(h() / Const.SCALE);
    }

    override function onEscape() {
        game.switchScene(game.worldScene);
    }

    override public function switchFrom() {
        for(item in menuItems) {
            item.reset();
        }
    }
}
