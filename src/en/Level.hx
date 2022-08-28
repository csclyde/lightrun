package en;

import echo.data.Options.RayOptions;
import en.EnvShape.ShapeInfo;
import hxd.fmt.fbx.BaseLibrary.TmpObject;
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
    public var roomEnvObjs:Array<EnvObj>;
    public var graphics:h2d.Graphics;

    var shapeColor:Int;
    var envById:Map<Int, EnvObj>;

    var triggers:Array<Trigger>;

    public function new(w:Int, h:Int, ?tw:Int = 16, ?th:Int = 16) {
        super(world, 0, 0);

        roomCollision = [];
        roomEnvObjs = [];
        envById = [];

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

    public function linecast(start:Vector2, end:Vector2, ?exclude:Body) {
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
        // draw room boundaries, then fill with shapes
        // addHexagon(-210, 140);
        // addHexagon(-210, -140);
        // addHexagon(0, -280);
        // addHexagon(210, -140);
        // addHexagon(210, 140);
        // addHexagon(0, 280);

        var shapeCount = 50;
        for(i in 0...shapeCount) {
            // var envShape = Math.random() < 0.5 ? EnvShape.Square(Util.randRange(10, 100), Util.randRange(10, 100)) : EnvShape.Circle(Util.randRange(10, 50));
            // var env = new EnvObj(Util.randRange(-500, 500), Util.randRange(-500, 500), envShape);
            // roomCollision.push(env.body);
            makeRandomEnvObj();
        }
    }

    function makeRandomEnvObj() {
        var shapeInfo:ShapeInfo;
        var roll = Math.random();
        if(roll < 0.33)
            shapeInfo = ShapeInfo.NGon(4, Util.randRange(10, 50), Util.randRange(0, 360));
        else if(roll < 0.66)
            shapeInfo = ShapeInfo.Circle(Util.randRange(10, 50));
        else shapeInfo = ShapeInfo.NGon(Util.randRange(3, 12), Util.randRange(10, 50), Util.randRange(0, 360));

        var envObj = new EnvObj(Util.randRange(-500, 500), Util.randRange(-500, 500), shapeInfo);
        registerEnvObj(envObj);
    }

    function addHexagon(x, y, rr = 140) {
        var roomBody = world.physWorld.make({
            x: x,
            y: y,
            mass: STATIC,
            shape: {
                type: POLYGON,
                vertices: [
                    new Vector2(-rr, 0),
                    new Vector2(-rr / 2, -rr),
                    new Vector2(rr / 2, -rr),
                    new Vector2(rr, 0),
                    new Vector2(rr / 2, rr),
                    new Vector2(-rr / 2, rr),
                ]
            }
        });
        var shapeCount = 200;
        for(i in 0...shapeCount) {
            var shapeInfo = Math.random() < 0.5 ? ShapeInfo.Square(Util.randRange(10, 100), Util.randRange(10, 100),
                Util.randRange(0, 360)) : ShapeInfo.Circle(Util.randRange(10, 50));
            var envObj = new EnvObj(Util.randRange(-500, 500), Util.randRange(-500, 500), shapeInfo);
            registerEnvObj(envObj);
        }
    }

    public function hitEnvBody(body:Body, hit:Vector2, normal:Vector2, playerDir:Vector2) {
        var env = envById[body.id];
        if(env == null)
            return;
        world.getBrighter(env.gotHit());
        world.psystem.makeLightColl(hit, new Vector2(playerDir.x, playerDir.y));
        world.killBunnies(hit.x, hit.y, 100);
    }

    function registerEnvObj(obj:EnvObj) {
        envById[obj.body.id] = obj;
        roomCollision.push(obj.body);
        roomEnvObjs.push(obj);
    }

    function unRegisterEnvObj(obj:EnvObj) {
        envById[obj.body.id] = null;
        roomCollision.remove(obj.body);
        roomEnvObjs.remove(obj);
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
        for(obj in roomEnvObjs) obj.draw();
    }

    /*
        public function draw_obj(obj: EnvObj) {
            switch(obj.shapeInfo) {
                case ShapeInfo.Square(w,h,r):
                    draw_polygon(obj.sides, obj.getVerts(), 0xFFFFFF, shapeColor);
                case Circle(r):
                    draw_circle(obj.cx, obj.cy, r, 0xFFFFFF, shapeColor);
                case NGon(sides, r, rotation):
                    draw_polygon(sides, obj.getVerts(), 0xFFFFFF, shapeColor);
            }
        }
     */
    public function draw_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:Int, alpha:Float = 1.) {
        graphics.lineStyle(1, color, alpha);
        graphics.moveTo(from_x, from_y);
        graphics.lineTo(to_x, to_y);
    }

    public function draw_rect(min_x:Float, min_y:Float, width:Float, height:Float, color:Int, ?stroke:Int, alpha:Float = 1.) {
        stroke != null ? graphics.lineStyle(1, stroke, 1) : graphics.lineStyle();
        graphics.drawRect(min_x, min_y, width, height);
    }
    /*
        public function draw_circle(x:Float, y:Float, radius:Float, color:Int, fillColor: Int, ?stroke:Int,  alpha:Float = 1.) {
            graphics.lineStyle(1, stroke, 1);
            graphics.beginFill(fillColor);
            graphics.drawCircle(x, y, radius);
            graphics.endFill();
        }

        public function draw_polygon(count:Int, vertices:Array<Vector2>, color:Int, fillColor: Int, ?stroke:Int, alpha:Float = 1) {
            if(count < 2)
                return;
            stroke != null ? graphics.lineStyle(1, stroke, 1) : graphics.lineStyle();
            graphics.moveTo(vertices[count - 1].x, vertices[count - 1].y);
            for(i in 0...count) graphics.lineTo(vertices[i].x, vertices[i].y);
            graphics.beginFill(fillColor);
            for(i in 0...count) graphics.addVertex(vertices[i].x, vertices[i].y);
            graphics.endFill();
        }
     */
}
