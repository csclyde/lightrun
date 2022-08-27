package eng.tiled;

class TiledTileset {
    public var name:String;
    public var tile:h2d.Tile;
    public var baseId:Int = 0;
    public var lastId(get, never):Int;

    inline function get_lastId() return baseId + cwid * chei - 1;

    public var tileWidth:Int;
    public var tileHeight:Int;

    public var cwid(get, never):Int;

    inline function get_cwid() return Std.int(tile.width / tileWidth);

    public var chei(get, never):Int;

    inline function get_chei() return Std.int(tile.height / tileHeight);

    public function new(n:Null<String>, t:h2d.Tile, tw, th, base) {
        tile = t;
        name = n == null ? "Unnamed" : n;
        baseId = base;
        tileWidth = tw;
        tileHeight = th;
    }

    public function getTile(id:Int):h2d.Tile {
        id -= baseId;
        var cy = Std.int(id / cwid);
        var cx = Std.int(id - cy * cwid);
        return tile.sub(cx * tileWidth, cy * tileHeight, tileWidth, tileHeight);
    }
}
