package scene;

import eng.tool.VectorText;
import h3d.shader.pbr.Light.LightEvaluation;
import h2d.SpriteBatch;
import echo.World;
import proc.*;
import en.*;

class World extends Scene {
    public var flags:Map<String, Bool>;

    public var physWorld:echo.World;
    public var scene:h2d.Layers;
    public var hud:h2d.Layers;

    public var camera:Camera;
    public var ui:UI;
    public var lighting:Lighting;
    public var psystem:PSystem;

    public var currentLevel:Level;
    public var player:en.Player;
    public var collision:Collision;
    public var fxProc:Fx;

    public var vt:VectorText;

    public var worldGraphics:h2d.Graphics;
    public var hudGraphics:h2d.Graphics;

    var shouldDraw = false;

    var bunnies:Array<DustBunny>;

    public var darkness:Float;

    public var spawnRate:Float;
    public var spawnTimer:Float;

    public function new(p:Process) {
        super(p);

        createRoot();

        flags = [];

        camera = new Camera(this);

        scene = new h2d.Layers();
        scene.name = 'scene';
        hud = new h2d.Layers();
        hud.name = 'hud';
        psystem = new PSystem(this);

        bunnies = [];

        root.add(scene, Const.MIDGROUND_OBJECTS);
        root.add(hud, Const.FOREGROUND_OBJECTS);

        physWorld = new echo.World({
            x: -2000,
            y: -2000,
            width: 4000,
            height: 4000,
            iterations: 5,
        });

        Trigger.setPhys(physWorld);

        lighting = new Lighting(this);
        ui = new UI(this);
        collision = new Collision(this);
        fxProc = new Fx(this);

        worldGraphics = new h2d.Graphics(scene);
        vt = new VectorText(hud, 8);

        spawnRate = 0.5;
        spawnTimer = 0.0;
    }

    public function getBrighter(amount:Float) {}

    public function killBunnies(x:Float, y:Float, r:Float) {
        for(b in bunnies) {
            var dist = b.body.get_position() - player.body.get_position();
            if(dist.length < r) {
                b.die();
                bunnies.remove(b);
            }
        }
    }

    override function init() {
        player = new en.Player(0, 0);
        currentLevel = new Level(0, 0);

        Events.subscribe('player_died', (params) -> currentLevel.handlePlayerDeath());

        camera.trackEntity(player);

        physWorld.listen({
            enter: collision.onEnter,
            exit: collision.onExit,
            stay: collision.onStay,
        });

        // for(i in 0...50) {
        //     var db = new DustBunny(Util.randRange(-100, 100), Util.randRange(-100, 100));
        //     bunnies.push(db);
        // }
    }

    override function reset() {
        player.reset();
        Trigger.reset();

        root.filter = null;

        // if(currentLevel != null) {
        //    currentLevel.destroy();
        //    currentLevel = null;
        // }

        speed = 1.0;
    }

    override function resize() {
        scene.setScale(Const.SCALE);
        hud.setScale(Const.SCALE);
    }

    override function onEscape() {
        game.switchScene(game.pauseScene);
    }

    override public function pause() {
        super.pause();
        audio.muteGroup('world');
    }

    override public function resume() {
        super.resume();
        Events.send('world_unpaused');
        audio.unmuteGroup('world');
    }

    public override function switchTo() {
        speed = 1.0;
    }

    public function setFlag(name:String, val:Bool = true) {
        flags[name] = val;
    }

    public function hasFlag(name:String) {
        return flags[name];
    }

    override function preUpdate() {
        super.preUpdate();

        markProfilingStart('Physics');
        physWorld.step(dt);
        markProfilingEnd('Physics');
    }

    override function update() {
        super.update();

        vt.clear();

        vt.setStyle(8, 1, 0xFF0000);
        vt.drawText(Math.floor(gw() / 2) - 70, 10, "DARKNESS: " + Math.floor(darkness * 10));

        spawnTimer += dt;

        if(spawnTimer > spawnRate) {
            spawnTimer -= spawnRate;
            var db = new DustBunny(player.cx + Util.randRange(-200, 200), player.cy + Util.randRange(-200, 200));
            bunnies.push(db);
        }
    }

    override function fixedUpdate() {
        super.fixedUpdate();
    }
}
