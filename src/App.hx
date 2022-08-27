import hxd.Window;

class App extends hxd.App {
    public static var inst:App;

    public var game:Game;
    public var console:Console;

    static function main() {
        hxd.Res.initEmbed();
        new App();
    }

    override function init() {
        // prevent the main loop from getting whacked out
        @:privateAccess haxe.MainLoop.add(() -> {});

        Window.getInstance().displayMode = Borderless;

        inst = this;
        Data.load(hxd.Res.data.entry.getText()); // read castleDB json

        // Engine settings
        engine.backgroundColor = 0xFFFFFF;
        s2d.camera.clipViewport = true;

        // Assets & data init
        Assets.init(); // init assets

        // Start with 1 frame delay, to avoid 1st frame freezing from the game perspective
        hxd.Timer.wantedFPS = Const.FPS;
        hxd.Timer.maxDeltaTime = 0.04;
        hxd.Timer.smoothFactor = 0.5;
        hxd.Timer.skip();

        Process.PROFILING = false;

        game = new Game(s2d);
        game.initAll();
        game.resetAll();

        console = new Console(game);
    }

    override function onResize() {
        super.onResize();
        game.resizeAll();
    }

    override function update(dt:Float) {
        game.updateAll(dt);
    }
}
