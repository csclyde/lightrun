package en;

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
            mass: .5,
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

        g.remove();

        Events.send('bunny_died');

        var shape:echo.shape.Circle = cast body.shape;

        var count = Math.floor(shape.radius / 1.5);

        // COREY MAKE AN EFFECT HERE
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
            playerVec = playerVec.normal * 200;
            body.acceleration = playerVec;
        }else {
            body.acceleration.set(0, 0);
        }

        if(dead) {}
    }
}
