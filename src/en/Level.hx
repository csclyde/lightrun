package en;

import en.EnvShape.EnvObj;
import h2d.TileGroup;

class Level extends Entity {
    public var mapWidth:Int;
    public var mapHeight:Int;
    public var tileWidth:Int;
    public var tileHeight:Int;
    public var offsetX:Float;
    public var offsetY:Float;
    public var difficulty:Float;

    public var roomCollision:Array<Body>;
    public var graphics:h2d.Graphics;

    var shapeColor:Int;

    var triggers:Array<Trigger>;

    public function new(w:Int, h:Int, ?tw:Int = 16, ?th:Int = 16) {
        super(world, 0, 0);

        roomCollision = [];

        shapeColor = 0x0000FF;

        mapWidth = w;
        mapHeight = h;
        tileWidth = tw;
        tileHeight = th;
        offsetX = -(mapWidth / 2) * tileWidth;
        offsetY = -(mapHeight / 2) * tileHeight;

        triggers = [];
        graphics = new h2d.Graphics(world.scene);
        build();
    }

    override function reset() {
        clearCollision();

        for(t in triggers) {
            t.destroy();
            t = null;
        }
        triggers = [];
    }

    public override function destroy() {
        super.destroy();

        reset();
    }

    public function clearCollision() {
        for(b in roomCollision) {
            b.dispose();
            b = null;
        }

        roomCollision = [];
    }

    public function getRoomBody(a:Body, b:Body) {
        if(roomCollision.contains(a)) {
            return a;
        }else if(roomCollision.contains(b)) {
            return b;
        }else {
            return null;
        }
    }

    public function linecast(start:Vector2, end:Vector2, ?exclude: Body) {
        var line = echo.Line.get_from_vectors(start, end);
        return line.linecast(roomCollision.filter(r -> r != exclude));
    }

    public function linecastLength(start:Vector2, end:Vector2) {
        var line = echo.Line.get_from_vectors(start, end);
        var result = line.linecast(roomCollision);

        if(result == null) {
            return line.length;
        }else {
            return result.closest.distance;
        }
    }

    public function linecastTest(start:Vector2, end:Vector2) {
        var line = echo.Line.get_from_vectors(start, end);
        var result = line.linecast(roomCollision);

        return (result == null);
    }

    public function build() {
        createTiles();
        createCollision();
        createTriggers();
        spawnEnemies();
    }

    function createCollision() {
        var GRID_X = 20;
        var GRID_Y = 20;
        var SIZE = 10;
        var THRESHOLD = 0.1;

        // draw room boundaries, then fill with shapes
        world.physWorld.make({
            shape: {
                type: POLYGON
            }
        });
        var shapeCount = 200;
        for(i in 0...shapeCount) {
            var envShape = Math.random() < 0.5 ? EnvShape.Square(Util.randRange(10, 100), Util.randRange(10, 100)) : EnvShape.Circle(Util.randRange(10, 50));
            var env = new EnvObj(Util.randRange(-500, 500), Util.randRange(-500, 500), envShape);
            roomCollision.push(env.body);
            // env.body.dirty = true;
        }

        // for(y in 0...GRID_Y) {
        //     for(x in 0...GRID_X) {
        //         if(Math.random() <= THRESHOLD) {
        //             var envShape = Math.random() < 0.5 ? EnvShape.Square(SIZE, SIZE) : EnvShape.Circle(SIZE);
        //             var env = new EnvObj(x * SIZE, y * SIZE, envShape);
        //             roomCollision.push(env.body);
        //         }
        //     }
        // }
    }

    override function update() {
        draw();
    }

    function createTriggers() {}

    function createTiles() {}

    function spawnEnemies() {}

    public function startLevel() {}

    public function handlePlayerDeath() {}

    public function draw() {
        graphics.clear();

        for(b in roomCollision) {
            for(s in b.shapes) {
                draw_shape(s);
            }
        }
    }

    public function draw_shape(shape:echo.Shape) {
        var shape_pos = shape.get_position();
        switch(shape.type) {
            case RECT:
                var r:echo.shape.Rect = cast shape;
                if(r.transformed_rect != null && r.rotation != 0) {
                    draw_polygon(r.transformed_rect.count, r.transformed_rect.vertices, 0xFFFFFF, shapeColor);
                }else draw_rect(shape_pos.x - r.width * 0.5, shape_pos.y - r.height * 0.5, r.width, r.height, 0xFFFFFF, 0x0000FF, 0);
            case CIRCLE:
                var c:echo.shape.Circle = cast shape;

                draw_circle(shape_pos.x, shape_pos.y, c.radius, 0xFFFFFF, shapeColor);

            case POLYGON:
                var p:echo.shape.Polygon = cast shape;

                draw_polygon(p.count, p.vertices, 0xFFFFFF, shapeColor);
        }
    }

    public function draw_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:Int, alpha:Float = 1.) {
        graphics.lineStyle(1, color, alpha);
        graphics.moveTo(from_x, from_y);
        graphics.lineTo(to_x, to_y);
    }

    public function draw_rect(min_x:Float, min_y:Float, width:Float, height:Float, color:Int, ?stroke:Int, alpha:Float = 1.) {
        stroke != null ? graphics.lineStyle(1, stroke, 1) : graphics.lineStyle();
        graphics.drawRect(min_x, min_y, width, height);
    }

    public function draw_circle(x:Float, y:Float, radius:Float, color:Int, ?stroke:Int, alpha:Float = 1.) {
        graphics.lineStyle(1, stroke, 1);
        graphics.drawCircle(x, y, radius);
    }

    public function draw_polygon(count:Int, vertices:Array<Vector2>, color:Int, ?stroke:Int, alpha:Float = 1) {
        if(count < 2)
            return;
        stroke != null ? graphics.lineStyle(1, stroke, 1) : graphics.lineStyle();
        graphics.moveTo(vertices[count - 1].x, vertices[count - 1].y);
        for(i in 0...count) graphics.lineTo(vertices[i].x, vertices[i].y);
    }
}
