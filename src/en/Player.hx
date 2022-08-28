package en;

class Player extends Entity {
    public var graphics:h2d.Graphics;

    var lightCharge:Float;

    public function new(sx, sy) {
        super(world, sx, sy);

        body = new Body({
            x: sx,
            y: sy,
            material: {
                elasticity: 0.5
            },
            mass: 1.0,
            // drag_length: 20,
            shapes: [
                {
                    type: CIRCLE,
                    radius: 10,
                }
            ]
        });

        graphics = new h2d.Graphics(world.scene);
        lightCharge = 0.0;
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
            lightCharge += et;
        }else if(lightCharge > 0) {
            timeout.set('lightmode', Math.min(lightCharge, 3.0));
            lightCharge = 0;
        }

        if(timeout.has('lightmode')) {
            body.shape.solid = false;
            body.mass = 0;

            // COREY
        }else {
            body.shape.solid = true;
            body.mass = 1.0;
        }
    }
}
