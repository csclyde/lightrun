package eng.tiled;

import h2d.TileGroup;

@:allow(tiled.com.TiledObject)
@:allow(tiled.com.TiledLayer)
class TiledMap {
    public var width:Int;
    public var height:Int;
    public var tileWidth:Int;
    public var tileHeight:Int;

    public var tilesets:Array<TiledTileset> = [];
    public var layers:Array<TiledLayer> = [];
    public var objects:Map<String, Array<TiledObject>> = new Map();

    var props:Map<String, String> = new Map();

    public var bgColor:Null<UInt>;

    private function htmlHexToInt(s:String):Null<UInt> {
        if(s.indexOf("#") == 0)
            return Std.parseInt("0x" + s.substring(1));

        return null;
    }

    public function new(tmxRes:hxd.res.Resource) {
        var folder = tmxRes.entry.directory;
        var xml = new haxe.xml.Access(Xml.parse(tmxRes.entry.getText()));
        xml = xml.node.map;

        width = Std.parseInt(xml.att.width);
        height = Std.parseInt(xml.att.height);
        tileWidth = Std.parseInt(xml.att.tilewidth);
        tileHeight = Std.parseInt(xml.att.tileheight);
        bgColor = xml.has.backgroundcolor ? htmlHexToInt(xml.att.backgroundcolor) : null;

        // Parse tilesets
        for(t in xml.nodes.tileset) {
            var set = readTileset(folder, t.att.source, Std.parseInt(t.att.firstgid));
            tilesets.push(set);
        }

        // Parse layers
        for(l in xml.nodes.layer) {
            var layer = new TiledLayer(this, Std.string(l.att.name), Std.parseInt(l.att.id), Std.parseInt(l.att.width), Std.parseInt(l.att.height));
            layers.push(layer);

            // Properties
            if(l.hasNode.properties)
                for(p in l.node.properties.nodes.property) layer.setProp(p.att.name, p.att.value);

            // Tile IDs
            var data = l.node.data;
            switch(data.att.encoding) {
                case "csv":
                    layer.setIds(data.innerHTML.split(",").map(function(id:String):UInt {
                        var f = Std.parseFloat(id);
                        if(f > 2147483648.) // dirty fix for Float>UInt casting issue when "bit #32" is set
                            return (cast(f - 2147483648.) : UInt) | (1 << 31);
                        else return (cast f : UInt);
                    }));

                case _:
                    throw "Unsupported layer encoding " + data.att.encoding + " in " + tmxRes.entry.path;
            }
        }

        // Parse objects
        for(ol in xml.nodes.objectgroup) {
            objects.set(ol.att.name, []);
            for(o in ol.nodes.object) {
                var e = new TiledObject(this, Std.parseInt(o.att.x), Std.parseInt(o.att.y));
                if(o.has.width)
                    e.width = Std.parseInt(o.att.width);
                if(o.has.height)
                    e.height = Std.parseInt(o.att.height);
                if(o.has.name)
                    e.name = o.att.name;
                if(o.has.type)
                    e.type = o.att.type;
                if(o.has.gid) {
                    e.tileId = Std.parseInt(o.att.gid);
                    e.y -= e.height; // fix stupid bottom-left based coordinate
                }else if(o.hasNode.ellipse) {
                    e.ellipse = true;
                    if(e.width == 0) {
                        // Fix 0-sized ellipses
                        e.x -= tileWidth >> 1;
                        e.y -= tileHeight >> 1;
                        e.width = tileWidth;
                        e.height = tileHeight;
                    }
                }

                // Properties
                if(o.hasNode.properties)
                    for(p in o.node.properties.nodes.property) e.setProp(p.att.name, p.att.value);
                objects.get(ol.att.name).push(e);
            }
        }

        // Parse map properties
        if(xml.hasNode.properties) {
            for(p in xml.node.properties.nodes.property) setProp(p.att.name, p.att.value);
        }
    }

    public function getLayer(name:String):Null<TiledLayer> {
        for(l in layers) if(l.name == name)
            return l;

        return null;
    }

    public function getObject(layer:String, name:String):Null<TiledObject> {
        if(!objects.exists(layer))
            return null;

        for(o in objects.get(layer)) if(o.name == name)
            return o;

        return null;
    }

    public function getObjects(layer:String, ?type:String):Array<TiledObject> {
        if(!objects.exists(layer))
            return [];

        return type == null ? objects.get(layer) : objects.get(layer).filter(function(o) return o.type == type);
    }

    public function getPointObjects(layer:String, ?type:String):Array<TiledObject> {
        if(!objects.exists(layer))
            return [];

        return objects.get(layer).filter(function(o) return o.isPoint() && (type == null || o.type == type));
    }

    public function getRectObjects(layer:String, ?type:String):Array<TiledObject> {
        if(!objects.exists(layer))
            return [];

        return objects.get(layer).filter(function(o) return o.isRect() && (type == null || o.type == type));
    }

    public function renderLayerBitmap(l:TiledLayer, ?group):h2d.TileGroup {
        var cx = 0;
        var cy = 0;

        if(group == null) {
            group = new h2d.TileGroup();
            group.name = 'Tiled.' + l.name;
        }

        for(id in l.getIds()) {
            if(id != 0) {
                group.add(cx * tileWidth, cy * tileHeight, getTile(id));
            }

            cx++;
            if(cx >= width) {
                cx = 0;
                cy++;
            }
        }
        return group;
    }

    public function getTiles(l:TiledLayer):Array<{t:h2d.Tile, x:Int, y:Int}> {
        var out = [];
        var cx = 0;
        var cy = 0;
        for(id in l.getIds()) {
            if(id != 0)
                out.push({
                    t: getTile(id),
                    x: cx * tileWidth,
                    y: cy * tileHeight,
                });

            cx++;
            if(cx >= width) {
                cx = 0;
                cy++;
            }
        }
        return out;
    }

    public function getTileSet(tileId:Int):Null<TiledTileset> {
        for(set in tilesets) if(tileId >= set.baseId && tileId <= set.lastId)
            return set;
        return null;
    }

    inline function getTile(tileId:Int):Null<h2d.Tile> {
        var s = getTileSet(tileId);
        return s != null ? s.getTile(tileId) : null;
    }

    function readTileset(folder:String, fileName:String, baseIdx:Int):TiledTileset {
        var folderUnstack = folder.split("/");
        var fileUnstack = fileName.split("/");
        while(fileUnstack[0] == "..") {
            fileUnstack.shift();
            folderUnstack.pop();
        }

        folder = folderUnstack.length > 0 ? folderUnstack.join("/") + "/" : "";
        fileName = fileUnstack.join("/");

        var file = try hxd.Res.load(folder + fileName) catch (e : Dynamic) throw "File not found " + fileName;

        var xml = new haxe.xml.Access(Xml.parse(file.entry.getText())).node.tileset;
        var tile = hxd.Res.load(file.entry.directory + "/" + xml.node.image.att.source).toTile();

        var e = new TiledTileset(xml.att.name, tile, Std.parseInt(xml.att.tilewidth), Std.parseInt(xml.att.tileheight), baseIdx);
        return e;
    }

    public function setProp(name, v) {
        props.set(name, v);
    }

    public inline function hasProp(name) {
        return props.exists(name);
    }

    public function getPropStr(name):Null<String> {
        return props.get(name);
    }

    public function getPropInt(name):Int {
        var v = getPropStr(name);
        return v == null ? 0 : Std.parseInt(v);
    }

    public function getPropFloat(name):Float {
        var v = getPropStr(name);
        return v == null ? 0 : Std.parseFloat(v);
    }

    public function getPropBool(name):Bool {
        var v = getPropStr(name);
        return v == "true";
    }
}
