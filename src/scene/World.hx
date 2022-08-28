package scene;

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

    public var currentLevel:Level;
    public var player:en.Player;
    public var collision:Collision;
    public var fxProc:Fx;

    public var worldGraphics:h2d.Graphics;
    public var lightGraphics:h2d.Graphics;

    public function new(p:Process) {
        super(p);

        createRoot();

        flags = [];

        camera = new Camera(this);

        scene = new h2d.Layers();
        scene.name = 'scene';
        hud = new h2d.Layers();
        hud.name = 'hud';

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
        worldGraphics.lineStyle(3, 0x00FF00);
        worldGraphics.drawRect(-50, -50, 100, 100);

        lightGraphics = new h2d.Graphics(scene);
        lightGraphics.lineStyle(3, 0xEED707);
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
        var LAZER_LEN = 200;
        var playerPos = new Vector2(player.cx, player.cy);
        var dir = (new Vector2(input.mouseWorldX, input.mouseWorldY) - playerPos).normal;
        lightGraphics.clear();
        drawLightbeam(playerPos, dir, LAZER_LEN, 0, true);
    }

    override function fixedUpdate() {
        super.fixedUpdate();
    }

    function drawLightbeam(origin:Vector2, direction:Vector2, len:Float, depth: Int, debug = false) {
        if(depth == 10)
            return;
        if(input.isControlActive('primary')) {
            var to = origin + (direction * len);
            var lCast = currentLevel.linecast(origin, to);
            if(lCast == null) {
                lightGraphics.lineStyle(1, 0xf0f010);
                lightGraphics.moveTo(origin.x, origin.y);
                lightGraphics.lineTo(to.x, to.y);
            }else {
                var hit = lCast.closest.hit;
                var norm = lCast.closest.normal;
                var lazerDist =(hit-origin).length;
                var remaining = len - lazerDist;

                var dot = 2.0*(direction.x*norm.x + direction.y*norm.y);
                var x = direction.x - dot*norm.x;
                var y = direction.y - dot*norm.y;
                
                //lightGraphics.lineStyle(3, 0xFF1E1E);
                //lightGraphics.moveTo(hit.x, hit.y);
                //lightGraphics.lineTo(refTarget.x, refTarget.y);
                lightGraphics.lineStyle(1, 0xF0F010);
                lightGraphics.moveTo(origin.x, origin.y);
                lightGraphics.lineTo(hit.x, hit.y);
                drawLightbeam(hit, new Vector2(x,y).normal, remaining, depth + 1);
            }
            // trace(start);
            // trace(dest);
        }
    }
}
