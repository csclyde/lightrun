package en;

import echo.data.Types.ShapeType;

enum EnvShape {
    Circle(r:Float);
    Square(w:Float, h:Float);
}

class EnvObj extends Entity {
    public function new(sx:Float, sy:Float, shape:EnvShape, color:Int = 0xFFFFFFFF) {
        super(world, sx, sy);
        var physShape:echo.data.Options.ShapeOptions = switch(shape) {
            case Square(w, h): {
                    type: ShapeType.RECT,
                    width: w,
                    height: h,
                    solid: true
                };
            case Circle(r): {type: ShapeType.CIRCLE, radius: r, solid: true / 2}
        }
        body = new Body({
            x: sx,
            y: sy,
            shapes: [physShape],
            kinematic: true
        });
        world.physWorld.add(body);

        var graphic = new h2d.Graphics(world.scene);
        graphic.beginFill(0xC9823F);
        switch(shape) {
            case Square(w, h):
                graphic.drawRect(sx - w / 2, sy - h / 2, w, h);
            case Circle(r):
                graphic.drawCircle(sx, sy, r / 2, 0);
        }
        graphic.endFill();
    }
}
