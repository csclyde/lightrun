package en;

import hxd.Math;
import h3d.Vector;

class PSystem extends Process{
    var fxs: Array<LightCollisionFX> = [];
    public function new(parent: Process){
        super(parent);
    }
    override function update(){
        for(fx in fxs)
            fx.update(dt);
        fxs = fxs.filter((fx) -> !fx.isComplete);
    }
    public function makeLightColl(pos: Vector2, norm: Vector2){
        var fx = new LightCollisionFX(pos, norm);
        fxs.push(fx);
    }
	public static function easeInLerp(v1: Vector, v2: Vector, k: Float){
        var result = new Vector();
		result.x = Math.lerp(v1.x, v2.x, k*k);
		result.y = Math.lerp(v1.y, v2.y, k*k);
		result.z = Math.lerp(v1.z, v2.z, k*k);
		result.w = Math.lerp(v1.w, v2.w, k*k);
        return result;
	}
	public static function easeOutLerp(v1: Vector, v2: Vector, k: Float){
        var result = new Vector();
		var flip = 1-k;
		result.x = Math.lerp(v1.x, v2.x, 1-flip*flip);
		result.y = Math.lerp(v1.y, v2.y, 1-flip*flip);
		result.z = Math.lerp(v1.z, v2.z, 1-flip*flip);
		result.w = Math.lerp(v1.w, v2.w, 1-flip*flip);
        return result;
	}

}
class LightCollisionFX{
    var graphics:h2d.Graphics;
    var maxLife:Float = .5;
    var minLife:Float = 0.1;
    var maxParticles = 20;
    var minSpeed = 70;
    var maxSpeed = 120;
    var maxAngle = 50;
    var colors = [0xFF0202, 0x0213FF,0xB3FF00,0x03FF39];
    var curFrame: Float = 0;
    var beams: Array<LightParticle>;
    var white = new Vector(1,1,1);
    public var isComplete = false;
    public function new(position: Vector2, normal: Vector2){
        beams = [for(i in 0...maxParticles) new LightParticle(
            position,
            colors[Util.randRange(0, colors.length)],
            Util.frandRange(minLife, maxLife),
            makeAngle(normal) * Util.frandRange(minSpeed, maxSpeed)
        )];
        graphics = new h2d.Graphics(App.inst.game.world.scene);
    }
    function makeAngle(norm: Vector2){
        var rotRad = 60 * (Math.PI / 180);
        var angle = Util.frandRange(rotRad * -1, rotRad);
        return new Vector2(
            norm.x * Math.cos(angle) - norm.y * Math.sin(angle),
            norm.x * Math.sin(angle) - norm.y * Math.cos(angle)
        );
    }
    public function update(delta: Float){
        var allDead = true;
        //trace(beams.map((a)-> a.position));
        graphics.clear();
        for(p in beams){
            if(p.isDead)
                continue;
            allDead = false;
            p.life -= delta;
            if(p.life <= 0) {
                p.isDead = true;
                p.life = 0;
                continue;
            }
            var lifeRatio = 1 - (p.life / p.maxLife);
            p.head = PSystem.easeInLerp(p.startPos, p.endPos, lifeRatio);
            p.tail = PSystem.easeOutLerp(p.startPos, p.endPos, lifeRatio);
            //trace('${p.head} | ${p.tail}');
            p.curColor.lerp(white, p.baseColor, lifeRatio);
            graphics.lineStyle(1, p.curColor.toColor(), 1);
            graphics.moveTo(p.head.x, p.head.y);
            graphics.lineTo(p.tail.x, p.tail.y);
        }
        if(allDead)
            isComplete = true;
    }
}
class LightParticle{
    public var baseColor: Vector; 
    public var curColor: Vector;
    public var life: Float;
    public var maxLife: Float;
    public var isDead = false;
    public var startPos: Vector;
    public var endPos: Vector;
    public var head: Vector; 
    public var tail: Vector;

    public function new(_pos: Vector2, _col: Int, _life: Float, _velocity: Vector2){
        baseColor = Vector.fromColor(_col); 
        life = _life;
        maxLife = _life;
        curColor = new Vector(1,1,1);
        startPos = new Vector(_pos.x, _pos.y);
        var endTemp = _velocity * _life + _pos;
        endPos = new Vector(endTemp.x, endTemp.y);
        head = new Vector(_pos.x, _pos.y);
        tail = new Vector(_pos.x, _pos.y);
    }
}