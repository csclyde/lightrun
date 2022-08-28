package proc;

import hxd.Math;

enum Movement {
    None;
    Flicker;
    Jitter;
}

typedef Light = {
    x:Float,
    y:Float,
    color:Int,
    scale:Float,
    intensity:Float,
    dead:Bool,
    killed:Float,
    visible:Bool,
    etOffset:Float,
    movement:Movement,
}

class Lighting extends Process {
    public var lightmapTex:h3d.mat.Texture;
    public var lightmap:h2d.Bitmap;
    public var light:h2d.Bitmap;

    public var lights:Array<Light>;

    public var globalIllum = 1.0;

    public function new(p:Process) {
        super(p);

        lights = [];

        var lightTile = hxd.Res.world.light.toTile();
        lightTile.setCenterRatio();

        light = new h2d.Bitmap(lightTile);
        lightmapTex = new h3d.mat.Texture(gw(), gh(), [Target]);
        lightmap = new h2d.Bitmap(h2d.Tile.fromTexture(lightmapTex));
    }

    override function init() {
        light.blendMode = Add;
        lightmap.blendMode = Multiply;
        lightmap.width = gw();
        lightmap.height = gh();
        // world.hud.add(lightmap, Const.LIGHTING);
    }

    override function reset() {
        // lights = [];
        globalIllum = 1.0;
    }

    override function resize() {
        lightmap.width = gw();
        lightmap.height = gh();
    }

    public function addLight(x:Float, y:Float, color:Int, ?scale:Float = 1.0, ?intensity:Float = 1.0) {
        var newLight = {
            x: x,
            y: y,
            color: color,
            scale: scale,
            intensity: intensity,
            dead: false,
            killed: 0.0,
            visible: true,
            movement: None,
            etOffset: Util.frandRange(0, 100),
        };

        lights.push(newLight);
        return newLight;
    }

    public function removeLight(light:Light) {
        if(light == null)
            return;

        light.dead = true;
        light.killed = et;
    }

    public override function update() {
        return;

        lightmap.tile.getTexture().clear(0x000001);

        lights = lights.filter(l -> !l.dead || l.killed + 1 > et);

        for(l in lights) {
            if(!l.visible)
                continue;

            var intensity = l.intensity;

            if(l.dead) {
                intensity = Math.lerp(l.intensity, 0, et - l.killed);
            }

            light.x = l.x + (world.camera.rootScene.x / Const.SCALE);
            light.y = l.y + (world.camera.rootScene.y / Const.SCALE);
            light.scaleX = l.scale;
            light.scaleY = l.scale;
            var color = h3d.Vector.fromColor(l.color, intensity);
            light.color.r = color.r;
            light.color.g = color.g;
            light.color.b = color.b;

            if(l.movement == Flicker) {
                fx.growshrink(light, 0.07, 10, l.scale, l.etOffset);
            }else if(l.movement == Jitter) {
                var scale = Util.frandRange(-0.2, 0.2);
                light.scaleX += scale;
                light.scaleY += scale;
            }

            light.drawTo(lightmap.tile.getTexture());
        }

        // lightmap.adjustColor({
        //     lightness: world.lightness / 10
        // });
    }
}
