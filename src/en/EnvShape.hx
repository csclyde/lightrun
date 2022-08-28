package en;

import echo.shape.Rect;
import echo.shape.Polygon;
import echo.data.Types.ShapeType;

enum ShapeInfo {
    Circle(r:Float);
    Square(w:Float, h:Float, rotation: Float);
    NGon(sides: Int, r: Float, rotation: Float);
}

class EnvObj extends Entity {
    public var shapeColor:Int;
    public var maxEmission: Float = 5;
    public var extraBrightness: Float = 0;
    public var baseBrightness: Float = 0;
    public var shapeInfo: ShapeInfo;
    public var rotation: Float;
    public var sides: Int;
    public var radius: Float;
    var decay: Float = 0.75;
    var nextBright: Float = 1;

    public function new(sx:Float, sy:Float, shape:ShapeInfo, color:Int = 0xFFFFFFFF) {
        super(world, sx, sy);
        shapeColor = Util.randRange(0x00FF00, 0x0000FF);

        shapeInfo = shape;
        var physShape:echo.data.Options.ShapeOptions = switch(shape) {
            case Square(w, h, rot): 
                radius = w/2;
                sides = 4;
                rotation = rot;
                {
                    type: ShapeType.RECT,
                    width: w,
                    height: h,
                    rotation: rotation
                };
            case Circle(r): 
                sides = 0;
                radius = r;
                {type: ShapeType.CIRCLE, radius: r}
            case NGon(s, r, rot):
                sides = s;
                radius = r;
                rotation = rot;
                {
                    type: ShapeType.POLYGON,
                    sides: s,
                    radius: r,
                    rotation: rotation
                }
        }
        body = new Body({
            x: sx,
            y: sy,
            shapes: [physShape],
            mass: STATIC,
        });
        world.physWorld.add(body);
    }
    public function GetPos(){
        return new Vector2(body.x, body.y);
    }
    public function GetVerts(){
        var p:Polygon = cast body.shape;
        return p.vertices;
    }
    public function GotHit():Float{
        return 1;
    }
}
