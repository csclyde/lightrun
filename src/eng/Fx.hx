package eng;

import h2d.filter.Blur;
import h2d.Bitmap;

class Fx extends Process {
    public var effects:Array<h2d.Object>;
    public var tweens:Array<Tween>;

    public var blurFilter:Blur;

    public function new(p:Process) {
        super(p);

        effects = [];
        tweens = [];
        blurFilter = new Blur(0.5, 1.2, 2.0, 0);
    }

    override function init() {}

    override function reset() {
        for(e in effects) {
            e.remove();
        }

        for(t in tweens) {
            t.endWithoutCallbacks();
        }

        effects = [];
        tweens = [];
    }

    override function update() {
        for(e in effects) {
            if(e.parent == null) {
                effects.remove(e);
            }
        }

        for(t in tweens) {
            if(t.done) {
                tweens.remove(t);
            }
        }

        Emitter.updateAll(dt);
    }

    override function resize() {}

    public function squash(sprite:h2d.Object, toX:Float, toY:Float, t:Float) {
        tweens.push(tw.createMs(sprite.scaleX, toX, TEaseIn, t / 2).chainMs(1, TElasticEnd, t / 2));
        tweens.push(tw.createMs(sprite.scaleY, toY, TEaseIn, t / 2).chainMs(1, TElasticEnd, t / 2));
    }

    public function stretch(sprite:h2d.Object, toX:Float, toY:Float, t:Float) {
        tweens.push(tw.createMs(sprite.scaleX, toX, TEaseOut, t / 2).chainMs(1, TEaseIn, t / 2));
        tweens.push(tw.createMs(sprite.scaleY, toY, TEaseOut, t / 2).chainMs(1, TEaseIn, t / 2));
    }

    public function warble(sprite:h2d.Object, amt:Float, speed:Float) {
        sprite.scaleX = Math.cos(et * speed) * amt + (amt + 1);
        sprite.scaleY = Math.sin(et * speed) * amt + (amt + 1);
    }

    public function growshrink(sprite:h2d.Object, amt:Float, speed:Float, ?base:Float = 1.0, ?offset:Float = 0.0) {
        sprite.scaleX = Math.sin(offset + et * speed) * amt + (amt + base);
        sprite.scaleY = Math.sin(offset + et * speed) * amt + (amt + base);
    }

    public function stutter(t:Float) {
        tw.createS(world.speed, 0.0, TEaseIn, t * 0.2);
        timeout.add('stutter', () -> {
            tw.createS(world.speed, 1.0, TEaseOut, t * 0.8);
        }, t * 0.21);
    }
}
