package eng;

class Trigger {
    public static var all:Array<Trigger> = [];
    public static var phys:echo.World;

    public var body:Body;

    var name:String;
    var x:Float;
    var y:Float;
    var w:Float;
    var h:Float;
    var once:Bool;

    public function new(sx, sy, sw, sh, o:Bool = false) {
        name = 'new_trigger';
        x = sx;
        y = sy;
        w = sw;
        h = sh;

        once = o;

        body = new Body({
            x: x,
            y: y,
            mass: 0.0,
            shapes: [
                {
                    type: RECT,
                    solid: false,
                    width: w,
                    height: h
                },
            ]
        });

        phys.add(body);
        all.push(this);
    }

    public function destroy() {
        all.remove(this);
        if(body != null) {
            body.dispose();
            body = null;
        }
    }

    public function enter() {
        onEnter();

        if(once) {
            destroy();
        }
    }

    public function stay() {
        onStay();
    }

    public function exit() {
        onExit();
    }

    public dynamic function onEnter() {}

    public dynamic function onStay() {}

    public dynamic function onExit() {}

    public static function setPhys(p:echo.World) {
        phys = p;
    }

    public static function reset() {
        for(t in all) {
            t.body.dispose();
            t.body = null;
            all.remove(t);
            t = null;
        }
    }

    public static function getTriggerFromBody(a:Body, b:Body) {
        for(t in all) {
            if(t.body != null && (t.body == a || t.body == b)) {
                return t;
            }
        }

        return null;
    }
}
