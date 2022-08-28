package en;

import hxd.fmt.grd.Data.ColorStop;
import echo.data.Options.LinecastOptions;

class Player extends Entity {
    public var graphics:h2d.Graphics;

    var lightCharge:Float;
    var lightGraphics:h2d.Graphics;
    var lazerSpeed = 700;
    var chargeSpeed = .4;
    var isLight = false;
    var lastCollided:Body = null;
    var lazerPoints:Array<PointInTime> = [];
    var lazerTTL = 0.3;
    var lazerDir:Vector2;

    var darkness:Float;

    public function new(sx, sy) {
        super(world, sx, sy);

        body = new Body({
            x: sx,
            y: sy,
            material: {
                elasticity: 0.5
            },
            mass: 1.0,
            // drag_length: 1,
            shapes: [
                {
                    type: CIRCLE,
                    radius: 10,
                    solid: true,
                }
            ]
        });

        graphics = new h2d.Graphics(world.scene);
        lightGraphics = new h2d.Graphics(world.scene);
        lightCharge = 0.0;
        world.physWorld.add(body);
        enterLameMode();

        darkness = 0.0;
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

    public function isPlayerBody(a:Body, b:Body) {
        return body != null && (body == b || body == a);
    }

    override public function die() {
        body.mass = 0;

        dead = true;

        Events.send('player_died');
    }

    public override function preUpdate() {}

    public override function update() {
        cx = body.x;
        cy = body.y;
        lightGraphics.clear();

        if(isLight)
            lightControl();
        else lameControl();

        while(lazerPoints.length > 0 && (et - lazerPoints[0].time) > lazerTTL) {
            lazerPoints.shift();
        }
        if(lazerPoints.length > 1)
            drawLightbeam(lazerPoints.map(lp -> lp.point));
    }

    function enterLameMode() {
        isLight = false;
        body.active = true;
        body.mass = 1.0;
        lightGraphics.clear();
    }

    function lameControl() {
        var accelX = 0.0;
        var accelY = 0.0;
        var accel = 100;

        // apply the controls to players acceleration
        if(input.isControlActive('up')) {
            accelY -= accel;
        }
        if(input.isControlActive('down')) {
            accelY += accel;
        }
        if(input.isControlActive('left')) {
            accelX -= accel;
        }
        if(input.isControlActive('right')) {
            accelX += accel;
        }

        body.acceleration.set(accelX, accelY);
        body.max_velocity_length = 100;

        graphics.clear();
        graphics.lineStyle(1, 0xFF0000);
        graphics.drawCircle(0, 0, 10);
        graphics.moveTo(0, 0);
        graphics.x = body.x;
        graphics.y = body.y;

        if(input.isControlActive('primary')) {
            lightCharge += dt * chargeSpeed;
            lightGraphics.clear();
            var playerPos = new Vector2(cx, cy);
            var dir = (new Vector2(input.mouseWorldX, input.mouseWorldY) - playerPos).normal;
            lastCollided = null;
            var points = calculateLightbeam(playerPos, dir, lightCharge * lazerSpeed, 0, [playerPos], true);
            drawLightPreview(points);
        }else if(lightCharge > 0) {
            timeout.set('lightmode', Math.min(lightCharge, 3.0));
            lightCharge = 0;
            enterLightMode();
        }
    }

    function enterLightMode() {
        isLight = true;
        body.active = false;
        body.mass = 0;
        graphics.clear();
        lastCollided = null;
        lazerPoints = [{point: new Vector2(cx, cy), time: et}];
        var playerPos = new Vector2(cx, cy);
        lazerDir = (new Vector2(input.mouseWorldX, input.mouseWorldY) - playerPos).normal;
    }

    function lightControl() {
        if(timeout.getS("lightmode") == 0)
            enterLameMode();
        var playerPos = new Vector2(cx, cy);
        var points = calculateLightbeam(playerPos, lazerDir, dt * lazerSpeed, 0, [playerPos], true);
        var lastPoint = points[points.length - 1];
        lazerPoints.push({point: lastPoint, time: et});
        body.x = lastPoint.x;
        body.y = lastPoint.y;
    }

    function drawLightPreview(points:Array<Vector2>) {
        lightGraphics.lineStyle(1, 0xF0F010);
        lightGraphics.moveTo(points[0].x, points[0].y);
        for(i in 1...points.length) {
            lightGraphics.lineTo(points[i].x, points[i].y);
        }
    }

    function drawLightbeam(points:Array<Vector2>) {
        lightGraphics.lineStyle(3, 0xF0F010);
        lightGraphics.moveTo(points[0].x, points[0].y);
        for(i in 1...points.length) {
            lightGraphics.lineTo(points[i].x, points[i].y);
        }
    }
<<<<<<< HEAD
    function calculateLightbeam(origin:Vector2, direction:Vector2, len:Float, depth: Int, points: Array<Vector2>, isReal: Bool, debug = false) {
=======

    function calculateLightbeam(origin:Vector2, direction:Vector2, len:Float, depth:Int, points:Array<Vector2>, debug = false) {
>>>>>>> e06918abf59474873953f0f2dc1aa1f01c1163c3
        if(depth == 30)
            return points;
        var to = origin + (direction * len);
        var lCast = world.currentLevel.linecast(origin, to, lastCollided);
        if(lCast == null) {
            lastCollided = null;
            lightGraphics.lineStyle(1, 0xf0f010);
            lightGraphics.moveTo(origin.x, origin.y);
            lightGraphics.lineTo(to.x, to.y);
            if(isReal)
                world.currentLevel.hitEnvBody(lCast.body);
            points.push(to);
            return points;
        }else {
            var hit = lCast.closest.hit;
            var norm = lCast.closest.normal;
            var lazerDist = (hit - origin).length;
            var remaining = len - lazerDist;
            lastCollided = lCast.body;

            var dot = 2.0 * (direction.x * norm.x + direction.y * norm.y);
            var x = direction.x - dot * norm.x;
            var y = direction.y - dot * norm.y;

            points.push(hit);
<<<<<<< HEAD
            lazerDir = new Vector2(x,y).normal;
            calculateLightbeam(hit, lazerDir, remaining, depth + 1, points, isReal);
=======
            lazerDir = new Vector2(x, y).normal;
            calculateLightbeam(hit, lazerDir, remaining, depth + 1, points);
>>>>>>> e06918abf59474873953f0f2dc1aa1f01c1163c3
            return points;
        }
    }
}

typedef PointInTime = {
    point:Vector2,
    time:Float
}
