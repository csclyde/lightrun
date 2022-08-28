package en;

class Player extends Entity {
    public var graphics:h2d.Graphics;

    public function new(sx, sy) {
        super(world, sx, sy);

        body = new Body({
            x: sx,
            y: sy,
            // mass: 1.0,
            // drag_length: 20,
            max_velocity_length: 50,
            shapes: [
                {
                    type: CIRCLE,
                    radius: 10,
                }
            ]
        });

        graphics = new h2d.Graphics(world.scene);

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

        if(input.isControlActive('left')) {
            body.acceleration.x -= 500;
        }

        if(input.isControlActive('right')) {
            body.acceleration.x += 500;
        }

        if(!input.isControlActive('left') && !input.isControlActive('right')) {
            body.acceleration.x = 0;
        }

        if(input.isControlActive('up')) {
            body.acceleration.y -= 500;
        }

        if(input.isControlActive('down')) {
            body.acceleration.y += 500;
        }

        if(!input.isControlActive('up') && !input.isControlActive('down')) {
            body.acceleration.y = 0;
        }

        graphics.clear();
        graphics.lineStyle(2, 0xFF0000);
        graphics.drawCircle(0, 0, 10);
        graphics.moveTo(0, 0);
        graphics.lineTo(body.velocity.x, body.velocity.y);
        graphics.x = body.x;
        graphics.y = body.y;
    }
}
