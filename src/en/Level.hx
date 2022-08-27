package en;

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

    var triggers:Array<Trigger>;

    public function new(w:Int, h:Int, ?tw:Int = 16, ?th:Int = 16) {
        super(world, 0, 0);

        roomCollision = [];

        mapWidth = w;
        mapHeight = h;
        tileWidth = tw;
        tileHeight = th;
        offsetX = -(mapWidth / 2) * tileWidth;
        offsetY = -(mapHeight / 2) * tileHeight;

        triggers = [];
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
        createDoodads();
        createCollision();
        createTriggers();
        spawnEnemies();
    }

    // meant to be overridden by subclasses
    function createCollision() {}

    function createTriggers() {}

    function createTiles() {}

    function createDoodads() {}

    function spawnEnemies() {}

    public function startLevel() {}

    public function handlePlayerDeath() {}
}
