package proc;

class Game extends Process {
    public var saver:Saver;

    public var bg:h2d.Bitmap;
    public var fade:h2d.Bitmap;
    public var feedback:ui.FeedbackPanel;
    public var feedbackDisplay:ui.comp.Label;

    public var inputProc:Input;
    public var audioProc:Audio;
    public var debugInfo:DebugInfo;
    public var scriptRunner:ScriptRunner;

    public var currentScene:Scene;

    public var menuScene:MainMenu;
    public var optionsScene:Options;
    public var pauseScene:Pause;
    public var videoOptionsScene:VideoOptions;
    public var audioOptionsScene:AudioOptions;
    public var controlOptionsScene:ControlOptions;

    public var worldScene:World;

    public function new(s:h2d.Scene) {
        super(null);

        createRoot(s);

        feedback = new ui.FeedbackPanel();
        feedbackDisplay = new ui.comp.Label(null, '', Assets.fontTiny);
        feedbackDisplay.vectorTxt.clear();
        feedbackDisplay.vectorTxt.setStyle(8, 1, 0x0000FF);
        feedbackDisplay.vectorTxt.drawText(0, 0, 'Alpha Build. Press F9 to give in-game feedback.');
        inputProc = new Input(this);
        audioProc = new Audio(this);
        debugInfo = new DebugInfo(this);

        worldScene = new World(null);
        menuScene = new MainMenu(null);
        optionsScene = new Options(null);
        pauseScene = new Pause(null);
        videoOptionsScene = new VideoOptions(null);
        audioOptionsScene = new AudioOptions(null);
        controlOptionsScene = new ControlOptions(null);

        saver = new Saver(worldScene);
    }

    public override function init() {
        setCursor();

        bg = new h2d.Bitmap(h2d.Tile.fromColor(0x070707));
        bg.width = w();
        bg.height = h();
        root.add(bg);

        fade = new h2d.Bitmap(h2d.Tile.fromColor(0x070707));
        fade.width = w();
        fade.height = h();
        root.add(fade, Const.SCREEN_LAYER);

        feedbackDisplay.setTextScale(1);
        root.add(feedback, Const.UI_LAYER);
        root.add(feedbackDisplay, Const.UI_LAYER);

        saver.loadSettings();

        worldScene.initAll();
        menuScene.initAll();
        optionsScene.initAll();
        pauseScene.initAll();
        videoOptionsScene.initAll();
        audioOptionsScene.initAll();
        controlOptionsScene.initAll();

        // delay a frame so the viewport can be adjusted to the correct size. might not
        // be neccessary after adding a loading scene
        timeout.add(() -> {
            // normal start into main menu
            // switchScene(menuScene, null, 0.5);

            // kick the player right into the first level for testing and such
            saver.loadGame('zzz');
            switchScene(worldScene, () -> {}, -1);

            // testing start
            // switchScene(worldScene, () -> ScriptRunner.run(LoadTest), -1);
        }, 0.1);

        Events.subscribe('escape_scene', (params:Dynamic) -> currentScene.onEscape());
        Events.subscribe('exit_game', (params:Dynamic) -> hxd.System.exit());
        Events.subscribe('toggle_feedback', toggleFeedback);
        Events.subscribe('fade_out', (params:Dynamic) -> fadeOut(params.t));
        Events.subscribe('fade_in', (params:Dynamic) -> fadeIn(params.t));
    }

    override function reset() {
        world.resetAll();
    }

    override function resize() {
        bg.width = w();
        bg.height = h();

        fade.width = w();
        fade.height = h();
        fade.alpha = 0;

        world.resizeAll();
        setCursor();
    }

    public function setCursor() {
        var cursor;

        // var overrideCursor:hxd.Cursor = Custom(new hxd.Cursor.CustomCursor([cursor], 0, 0, 0));

        // hxd.System.setCursor = function(cur:hxd.Cursor) {
        //     hxd.System.setNativeCursor(overrideCursor);
        // }
    }

    public function fadeOut(t:Float, ?then:() -> Void) {
        var tween = tw.createS(fade.alpha, 1.0, TEaseOut, t);

        if(then != null) {
            tween.onEnd = then;
        }

        return tween;
    }

    public function fadeIn(t:Float, ?then:() -> Void) {
        var tween = tw.createS(fade.alpha, 0.0, TEaseIn, t);

        if(then != null) {
            tween.onEnd = then;
        }

        return tween;
    }

    public function toggleFeedback(params:Dynamic) {
        feedback.toggle();

        if(feedback.visible) {
            Events.send('disallow_input');
            world.pause();
        }
    }

    public function feedbackOpen() {
        return feedback.visible;
    }

    public function switchScene(to:Scene, ?onSwitch, ?t:Float = 0.5) {
        if(currentScene == to) {
            return;
        }

        var fadeTime = Math.max(t, 0.0);

        // if we have no scene, immediately switch into the specified one
        if(currentScene == null) {
            currentScene = to;
            fadeTime = 0.0;
        }

        fadeOut(fadeTime, () -> {
            currentScene.root.remove();
            currentScene.switchFrom();

            currentScene = to;
            game.root.add(currentScene.root, 0);
            currentScene.resizeAll();
            currentScene.switchTo();

            // negative fade time means, don't even do it
            if(t >= 0) {
                fadeIn(1.0);
            }

            if(onSwitch != null) {
                onSwitch();
            }
        });
    }

    override function onDispose() {
        fx.destroy();
        for(e in Entity.ALL) {
            e.destroy();
        }
    }

    override function update() {
        ScriptRunner.timeout.update(dt);
        if(currentScene != null) {
            currentScene.updateAll(dt);
        }
    }
}
