package en;

import hxsl.RuntimeShader;
import format.swf.Data.Font2GlyphData;
import openal.EFX.Filter;
import h2d.filter.Glow;
import h2d.filter.Bloom;
import format.abc.Data.MethodTypeExtra;
import h3d.Vector;
import echo.shape.Polygon;
import echo.data.Types.ShapeType;

enum ShapeInfo {
    Circle(r:Float);
    Square(w:Float, h:Float, rotation:Float);
    NGon(sides:Int, r:Float, rotation:Float);
}

class EnvObj extends Entity {
    public var shapeColor:Int;
    public var maxBrightness: Float = 2;
    public var extraBrightness: Float = 0;
    public var baseBrightness: Float = 0;
    public var shapeInfo: ShapeInfo;
    public var rotation: Float;
    public var sides: Int;
    public var radius: Float;
    var isActive = false;
    var decay: Float = 0.75;
    var nextBright: Float = 1;
    var fadeRate: Float = 2;
    var fillColor: Vector;
    var graphics:h2d.Graphics;
    var fxFilter: h2d.filter.Filter;

    public function new(sx:Float, sy:Float, shape:ShapeInfo, color:Int = 0xFFFFFFFF) {
        super(world, sx, sy);
        shapeColor = Util.randRange(0x00FF00, 0x0000FF);
        fillColor = Vector.fromColor(shapeColor);
        fillColor.w = 0;
        graphics = new h2d.Graphics(world.scene);

        shapeInfo = shape;
        var physShape:echo.data.Options.ShapeOptions = switch(shape) {
            case Square(w, h, rot):
                radius = w / 2;
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

    public override function update() {
        if(extraBrightness > 0) {
            extraBrightness = Math.max(0, extraBrightness - dt * fadeRate);
            fillColor.w = (baseBrightness + extraBrightness) / (maxBrightness * 2);
            draw();
        }
    }

    function getPos() {
        return new Vector2(body.x, body.y);
    }

    function getVerts() {
        var p:Polygon = cast body.shape;
        return p.vertices;
    }

    public function draw() {
        graphics.clear();
        switch(shapeInfo) {
            case ShapeInfo.Square(w, h, r):
                draw_polygon(sides, getVerts());
            case Circle(r):
                draw_circle(cx, cy, r);
            case NGon(sides, r, rotation):
                draw_polygon(sides, getVerts());
        }
    }
    function increase_canvas_size(){
        var lowerLeft = new Vector2(body.x - radius * 2, body.y - radius * 2);
        var upperLeft = new Vector2(body.x - radius * 2, body.y + radius * 2);
        var lowerRight = new Vector2(body.x + radius * 2, body.y - radius * 2);
        var upperRight = new Vector2(body.x + radius * 2, body.y + radius * 2);
        
        graphics.lineStyle(1, 0x111111, 1);
        graphics.beginFill(0xff0000, 0);
        graphics.moveTo(lowerLeft.x, lowerLeft.y);
        graphics.lineTo(upperLeft.x, upperLeft.y);
        graphics.lineTo(upperRight.x, upperRight.y);
        graphics.lineTo(lowerRight.x, lowerRight.y);
        graphics.lineTo(lowerLeft.x, lowerLeft.y);
        graphics.endFill();
    }

    function draw_circle(x:Float, y:Float, radius:Float) {
        //increase_canvas_size();
        graphics.lineStyle(1, shapeColor, 1);
        graphics.beginFill(fillColor.toColor(), fillColor.w);
        graphics.drawCircle(x, y, radius);
        graphics.endFill();
    }

    function draw_polygon(count:Int, vertices:Array<Vector2>) {
        if(count < 2)
            return;
        
        //increase_canvas_size();
        graphics.lineStyle(1, shapeColor, 1);
        graphics.moveTo(vertices[count - 1].x, vertices[count - 1].y);
        for(i in 0...count) graphics.lineTo(vertices[i].x, vertices[i].y);
        graphics.beginFill(fillColor.toColor());
        for(i in 0...count) graphics.addVertex(vertices[i].x, vertices[i].y, fillColor.r, fillColor.g, fillColor.b, fillColor.a);
        graphics.endFill();
    }

    public function gotHit():Float {
        var value = nextBright;
        baseBrightness += nextBright;
        extraBrightness += value * 3;
        nextBright *= decay; 
        if(!isActive){
            isActive = true;
            var col = Vector.fromColor(shapeColor);
            col.add(new Vector(1,1,1)).scale(0.5);
            //var lightGlow = new shader.LightGlow(); 
            //lightGlow.glowColor = new Vector(1,0,0);
            //lightGlow.globalPos = new Vector(body.x, body.y);
            //graphics.addShader(lightGlow);
        }
        return value;
    }
}
