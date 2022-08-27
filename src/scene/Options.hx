package scene;

class Options extends Scene {
    public var uiRoot:h2d.Flow;
    public var menuItems:Array<ui.comp.Component>;
    public var returnScene:Scene;

    public function new(p:Process) {
        super(p);
        createRoot();

        uiRoot = new h2d.Flow(root);
        uiRoot.horizontalAlign = uiRoot.verticalAlign = Middle;
        uiRoot.enableInteractive = true;
        uiRoot.layout = Vertical;

        menuItems = [];

        var videoItem = new ui.comp.LabelButton(uiRoot, 'Video Options');
        menuItems.push(videoItem);
        videoItem.onClick = function() {
            game.switchScene(game.videoOptionsScene);
        }

        var audioItem = new ui.comp.LabelButton(uiRoot, 'Audio Options');
        menuItems.push(audioItem);
        audioItem.onClick = function() {
            game.switchScene(game.audioOptionsScene);
        }

        var controlItem = new ui.comp.LabelButton(uiRoot, 'Control Options');
        menuItems.push(controlItem);
        controlItem.onClick = function() {
            game.switchScene(game.controlOptionsScene);
        }

        var returnItem = new ui.comp.LabelButton(uiRoot, 'Return');
        menuItems.push(returnItem);
        returnItem.onClick = function() {
            onEscape();
        }
    }

    override function resize() {
        uiRoot.setScale(Const.SCALE);
        uiRoot.minWidth = gw();
        uiRoot.minHeight = gh();
    }

    override function onEscape() {
        if(returnScene != null) {
            game.switchScene(returnScene);
        }else {
            game.switchScene(game.menuScene);
        }
    }

    override public function switchFrom() {
        for(item in menuItems) {
            item.reset();
        }
    }
}
