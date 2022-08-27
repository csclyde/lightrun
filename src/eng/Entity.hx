package eng;

enum Dir {
    Left;
    Right;
    Up;
    Down;
}

class Entity {
    public static var ALL:Array<Entity> = [];

    public var scene:Scene;
    public var ref:String;

    public static function AllActive() {
        return ALL.filter(e -> return e.isAlive());
    }

    // Various getters to access all important stuff easily
    public var game(get, never):Game;

    inline function get_game() return App.inst.game;

    public var input(get, never):Input;

    inline function get_input() return game.inputProc;

    public var audio(get, never):Audio;

    inline function get_audio() return game.audioProc;

    public var world(get, never):World;

    inline function get_world() return game.worldScene;

    public var fx(get, never):Fx;

    inline function get_fx() return world.fxProc;

    public var dt(get, never):Float;

    inline function get_dt() return scene.dt;

    public var et(get, never):Float;

    inline function get_et() return scene.et;

    public var sceneSpeed(get, never):Float;

    inline function get_sceneSpeed() return scene.speed;

    public var uid(default, null):Int;

    public var name:String;
    public var type:String; // for debugging
    public var destroyed:Bool;
    public var created:Float;
    public var etOffset:Float;
    public var flags:Map<String, Bool>;
    public var stats:Map<String, Float>;
    public var dead:Bool;
    public var facing:Dir;

    public var timeout:Timeout;
    public var tw:Tweenie;

    public var cx = 0.0;
    public var cy = 0.0;

    public var spr:AnimSprite;
    public var body:Body;
    public var shadow:h2d.SpriteBatch.BatchElement;
    public var shadowOffset:Float;
    public var light:proc.Lighting.Light;
    public var fire:h2d.Anim;
    public var lightning:h2d.Anim;
    public var ice:h2d.Anim;
    public var effectLight:proc.Lighting.Light;

    public function new(s:Scene, x, y) {
        uid = Const.NEXT_UNIQ;
        ALL.push(this);
        scene = s;
        scene.entities.push(this);

        destroyed = false;
        created = et;
        etOffset = Util.frandRange(0, 100);
        flags = [];
        stats = [];
        dead = false;
        facing = Dir.Right;

        cx = x;
        cy = y;

        tw = new Tweenie(Const.FPS);
        timeout = new Timeout();
        timeout.add(() -> init(), 0);
    }

    public function isAlive() {
        return !destroyed;
    }

    public function getCameraAnchorX() {
        return cx;
    }

    public function getCameraAnchorY() {
        return cy;
    }

    public function is<T:Entity>(c:Class<T>) return Std.isOfType(this, c);

    public function as<T:Entity>(c:Class<T>):T return Std.downcast(this, c);

    public function enableSprite(?p:h2d.Layers, ?layer:Int) {
        spr = new AnimSprite();
        spr.x = cx;
        spr.y = cy;

        if(p == null) {
            p = world.scene;
        }

        if(layer == null) {
            layer = Const.MIDGROUND_OBJECTS;
        }

        p.add(spr, layer);
    }

    public function enableLight(color:Int, ?scale:Float = 1.0, ?intensity:Float = 1.0) {
        light = world.lighting.addLight(cx, cy, color, scale, intensity);
    }

    public final function internalUpdate() {
        if(spr != null) {
            if(scene.isPaused()) {
                spr.update(0);
            }else {
                spr.update(sceneSpeed);
            }

            spr.x = cx;
            spr.y = cy;

            if(facing == Left) {
                spr.scaleX = Math.abs(spr.scaleX) * -1;
            }else if(facing == Right) {
                spr.scaleX = Math.abs(spr.scaleX);
            }
        }
    }

    public function destroy() {
        destroyed = true;
    }

    public function dispose() {
        ALL.remove(this);

        timeout.destroy();
        tw.destroy();

        if(spr != null) {
            spr.remove();
            spr = null;
        }

        if(light != null) {
            world.lighting.removeLight(light);
        }

        if(body != null) {
            body.dispose();
            body = null;
        }

        if(shadow != null) {
            shadow.remove();
            shadow = null;
        }

        if(fire != null) {
            fire.remove();
            fire = null;
        }

        if(lightning != null) {
            lightning.remove();
            lightning = null;
        }
    }

    public function init() {}

    public function reset() {}

    public function preUpdate() {}

    public function postUpdate() {}

    public function fixedUpdate() {}

    public function update() {}

    public function die() {}

    public static function getByRef(r:String) {
        for(e in ALL) if(e.ref == r)
            return e;
        return null;
    }
}
