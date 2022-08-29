package en;

import h3d.Vector;
import echo.util.ext.IntExt.max;
import echo.World;
import hxd.fmt.grd.Data.ColorStop;
import echo.data.Options.LinecastOptions;

class DustBunny extends Entity {
    public var g:h2d.Graphics;

    public function new(sx, sy) {
        super(world, sx, sy);

        body = new Body({
            x: sx,
            y: sy,
            material: {
                elasticity: 0.5
            },
            mass: .0001,
            // drag_length: 1,
            max_velocity_length: 200,
            shapes: [
                {
                    type: CIRCLE,
                    radius: 3,
                    solid: true,
                }
            ]
        });

        g = new h2d.Graphics(world.scene);
        g.lineStyle(1, 0x7C3D8A);
        g.drawCircle(0, 0, 3, 10);
        world.physWorld.add(body);
    }

    override function reset() {
        setPosition(0, 0);

        dead = false;

        Events.send('refresh_hud');
    }

    public function setPosition(x:Float, y:Float) {
        // cx = spr.x = x;
        // cy = spr.y = y;

        // if(body != null) {
        //     body.x = x;
        //     body.y = y;
        //     body.velocity.set(0, 0);
        //     body.rotation = 0;
        //     body.mass = 1.0;
        // }
    }

    public function play(name:String, restart:Bool = true) {
        // spr.playAnim(name, restart);
    }

    public function isBunnyBody(a:Body, b:Body) {
        return body != null && (body == b || body == a);
    }

    override public function die() {
        if(dead)
            return;

        body.mass = 0;
        body.active = false;
        dead = true;
        body.dispose();

        g.remove();

        Events.send('bunny_died');

        new DeadBunny(world, new Vector2(body.x, body.y), 3, 0x7C3D8A);
    }

    public override function preUpdate() {}

    public override function update() {
        cx = body.x;
        cy = body.y;
        g.x = body.x;
        g.y = body.y;

        var playerVec = world.player.body.get_position() - body.get_position();

        if(playerVec.length > 500) {
            body.set_position(world.player.body.x + Util.randRange(-200, 200), world.player.body.y + Util.randRange(-200, 200));
        }

        if(playerVec.length < 200) {
            if(playerVec.length < 30 && world.player.isLight == false) {
                world.player.lightness -= 1.0 * dt;
            }

            playerVec = playerVec.normal * 200;
            body.acceleration = playerVec;
        }else {
            body.acceleration.set(0, 0);
        }

        if(dead) {}
    }
}

class DeadBunny extends Entity{
    var graphics:h2d.Graphics;
    var time: Float = 0;
    var maxMoteLife =  10;
    var heartGrow: Float = 0.5;
    var isGrowingHeart = true; 
    var edgeExplodeStart = 0.3;
    var didExplodeEdge = false;
    var edgeColor: Int;
    var numBunnies = 12;
    var maxMoteSpeed = 5;
    var motes: Array<BunnyMote> = [];
    var implodes: Array<MoteImplode> = [];
    public function new(s: Scene, pos: Vector2, radius: Float, _edgeColor: Int){
        super(s, pos.x, pos.y);
        edgeColor = _edgeColor;
        graphics = new h2d.Graphics(world.scene);
        graphics.x = pos.x;
        graphics.y = pos.y;
        for(i in 0...10){
            var vel = new Vector2(Util.frandRange(-5,5), Util.frandRange(-5,5));
            implodes.push(new MoteImplode( vel,0xffff00, heartGrow, -vel));
        }
    }
    public override function update(){
        var delta = App.inst.game.worldScene.dt;
        time += delta;
        graphics.clear();
        if(isGrowingHeart){
            if(time >= heartGrow)
                isGrowingHeart = false;
            drawHeart();
            drawImplode(delta);
        }
        if(!didExplodeEdge){
            drawMotes(delta);
        }else{
            drawEdge();
            if(time >= edgeExplodeStart){
                didExplodeEdge = true;
                motes = [for(i in 0...numBunnies) new BunnyMote(
                    new Vector2(0,0),
                    new Vector2(Util.frandRange(-maxMoteSpeed, maxMoteSpeed), Util.frandRange(-maxMoteSpeed, maxMoteSpeed)),
                    Util.frandRange(5, maxMoteLife)
                )];
            }
        }
        if(time > 20)
            destroy();
    }
    function drawImplode(delta: Float){
        var white = new Vector(1,1,1);
        for(p in implodes){
            p.life -= delta;
            var lifeRatio = 1 - (p.life / p.maxLife);
            p.head = PSystem.easeInLerp(p.startPos, p.endPos, lifeRatio);
            p.tail = PSystem.easeOutLerp(p.startPos, p.endPos, lifeRatio);
            p.curColor.lerp(white, p.baseColor, lifeRatio);
            graphics.lineStyle(1, p.curColor.toColor(), 1);
            graphics.moveTo(p.head.x, p.head.y);
            graphics.lineTo(p.tail.x, p.tail.y);
        }
    }
    function drawEdge(){
        graphics.lineStyle(1, edgeColor, 1 - (time / edgeExplodeStart));
        graphics.drawCircle(0,0, 3);
    }
    function drawHeart(){
        graphics.beginFill(0x880000);
        graphics.drawCircle(0,0, (time / heartGrow) * 3);
        graphics.endFill();
    }
    function drawMotes(delta: Float){
        for(mote in motes){
            mote.life -= delta;
            mote.position += mote.velocity * delta;
            graphics.drawCircle(mote.position.x, mote.position.y, 1.5);
        }
    }
}
class BunnyMote{
    public var position: Vector2;
    public var velocity: Vector2;
    public var maxLife: Float;
    public var life: Float;
    public function new (_pos: Vector2, _vel: Vector2, _life: Float){
        position = _pos; 
        velocity = _vel; 
        maxLife = _life;
        life = _life;
    }
}
class MoteImplode{
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