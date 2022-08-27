package en;

class Player extends Entity {
    public function new(sx, sy) {
        super(world, sx, sy);

        body = new Body({
            x: sx,
            y: sy,
            mass: 1.0,
            kinematic: false,
            drag_length: 0.5,
            max_velocity_length: 3,
            shapes: [
                {
                    type: CIRCLE,
                    radius: 10,
                }
            ]
        });

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

        if(body != null) {
            body.x = x;
            body.y = y;
            body.velocity.set(0, 0);
            body.rotation = 0;
            body.mass = 1.0;
        }
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
    }
}
