package en;

import echo.data.Types.ShapeType;

enum EnvShape {
    Circle(r:Float);
    Square(w:Float, h:Float);
}

class EnvObj extends Entity {
    public var shapeColor:Int;
    public var maxEmission: Float = 5;
    public var curLightLevel: Float = 1;

    public function new(sx:Float, sy:Float, shape:EnvShape, color:Int = 0xFFFFFFFF) {
        super(world, sx, sy);
        shapeColor = Util.randRange(0x00FF00, 0x0000FF);

        var physShape:echo.data.Options.ShapeOptions = switch(shape) {
            case Square(w, h): {
                    type: ShapeType.RECT,
                    width: w,
                    height: h,
                };
            case Circle(r): {type: ShapeType.CIRCLE, radius: r / 2}
        }
        body = new Body({
            x: sx,
            y: sy,
            shapes: [physShape],
            mass: STATIC,
            rotation: Util.randRange(0, 360),
        });
        world.physWorld.add(body);

        // var graphic = new h2d.Graphics(world.scene);
        // graphic.lineStyle(1, 0x0000FF);
        // switch(shape) {
        //     case Square(w, h):
        //         graphic.drawRect(sx - w / 2, sy - h / 2, w, h);
        //     case Circle(r):
        //         graphic.drawCircle(sx, sy, r / 2, 0);
        // }
    }
    public function GotHit():Float{
        return 1;
    }
}
