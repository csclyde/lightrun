package eng;

import hxd.Math;
import haxe.Timer;
import h2d.SpriteBatch;
import h2d.SpriteBatch.BatchElement;

class Particle extends BatchElement {
    public var vel:Vector2;
    public var drag:Float;
    public var lifespan:Float;
    public var totalLife:Float;
    public var rotVel:Float;

    public function new(t:h2d.Tile) {
        super(t);
    }
}

class Emitter extends SpriteBatch {
    static var all:Array<Emitter> = [];

    var pool:Array<Particle>;
    var active:Array<Particle>;

    var elapsedTime:Float;
    var rate:Float;
    var running:Bool;

    var xBound:Float;
    var yBound:Float;
    var w:Float;
    var h:Float;

    var minLife:Float;
    var maxLife:Float;
    var minVel:Float;
    var maxVel:Float;
    var minDrag:Float;
    var maxDrag:Float;
    var minAngle:Float;
    var maxAngle:Float;
    var startFade:Float;
    var endFade:Float;
    var minScale:Float;
    var maxScale:Float;
    var minRotation:Float;
    var maxRotation:Float;
    var minRotationVel:Float;
    var maxRotationVel:Float;

    public function new(t:Array<h2d.Tile>, c:Int) {
        super(null);
        all.push(this);

        pool = [];
        active = [];

        elapsedTime = 0.0;
        rate = 0.0;
        running = false;

        for(i in 0...c) {
            var part = new Particle(t[Util.randRange(0, t.length - 1)]);
            pool.push(part);
        }

        xBound = yBound = w = h = 0;
        minLife = 0;
        maxLife = 1;
        minVel = maxVel = 0;
        minDrag = maxDrag = 0;
        minAngle = 0;
        maxAngle = 2 * Math.PI;
        startFade = endFade = 1;
        minScale = maxScale = 1;
        minRotation = maxRotation = 0;
    }

    public static function updateAll(dt:Float) {
        for(e in all) {
            e.update(dt);
        }
    }

    public function destroy() {
        running = false;
        all = null;
        pool = null;
        active = null;
        remove();
        all.remove(this);
    }

    public function update(dt:Float) {
        for(p in active) {
            p.lifespan -= dt;
            if(p.lifespan <= 0) {
                active.remove(p);
                pool.push(p);
                p.remove();
                continue;
            }

            p.x += p.vel.x * dt;
            p.y += p.vel.y * dt;
            p.vel.length -= (p.drag * dt);

            if(startFade != endFade) {
                p.alpha = Math.lerp(endFade, startFade, p.lifespan / p.totalLife);
            }

            if(hasRotationScale) {
                p.rotation += p.rotVel * dt;
            }
        }

        // if the emitter is running, emit the correct number of particles / time
        if(running) {
            elapsedTime += dt;
            var partCount = rate > 0 ? Math.floor(elapsedTime / rate) : 0;

            for(i in 0...partCount) {
                elapsedTime -= rate;
                emitParticle();
            }
        }
    }

    public function setPos(sx:Float, sy:Float, ?sw:Float = 0, ?sh:Float = 0) {
        xBound = sx;
        yBound = sy;
        w = sw;
        h = sh;
    }

    public function setLifespan(min:Float, max:Float) {
        minLife = min;
        maxLife = max;
    }

    public function setVelocity(min:Float, max:Float) {
        minVel = min;
        maxVel = max;
    }

    public function setDrag(min:Float, max:Float) {
        minDrag = min;
        maxDrag = max;
    }

    public function setAngle(min:Float, max:Float) {
        minAngle = min;
        maxAngle = max;
    }

    public function setFade(start:Float, end:Float) {
        startFade = start;
        endFade = end;
    }

    public function setScales(min:Float, max:Float) {
        hasRotationScale = true;
        minScale = min;
        maxScale = max;
    }

    public function setRotation(min:Float, max:Float) {
        hasRotationScale = true;
        minRotation = min;
        maxRotation = max;
    }

    public function setRotationVel(min:Float, max:Float) {
        hasRotationScale = true;
        minRotationVel = min;
        maxRotationVel = max;
    }

    public function burst(amount:Int) {
        if(amount > pool.length)
            amount = pool.length;

        for(i in 0...amount) {
            emitParticle();
        }
    }

    public function trickle(r:Float) {
        rate = r;
        elapsedTime = 0.0;
        running = true;
    }

    public function stop() {
        running = false;
    }

    function emitParticle() {
        if(pool.length == 0)
            return;

        var p = pool.shift();
        active.push(p);

        p.x = Util.frandRange(xBound - (w / 2), xBound + (w / 2));
        p.y = Util.frandRange(yBound - (h / 2), yBound + (h / 2));
        p.lifespan = Util.frandRange(minLife, maxLife);
        p.totalLife = p.lifespan;
        p.vel = Vector2.from_radians(Util.frandRange(minAngle, maxAngle), Util.frandRange(minVel, maxVel));
        p.drag = Util.frandRange(minDrag, maxDrag);
        p.alpha = startFade;

        if(hasRotationScale) {
            p.scale = Util.frandRange(minScale, maxScale);
            p.rotation = Util.frandRange(minRotation, maxRotation);
            p.rotVel = Util.frandRange(minRotationVel, maxRotationVel);
        }

        add(p);
    }
}
