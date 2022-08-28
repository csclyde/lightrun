package eng;

class Camera extends Process {
    public var focus = {x: 0.0, y: 0.0};

    var target:Null<Entity>;

    public var pxWidth:Int;
    public var pxHeight:Int;
    public var rootScene:h2d.Object;

    var dx:Float;
    var dy:Float;
    var lerpForce:Float;
    var maxStep:Float;

    public var left(get, never):Int;

    inline function get_left() return Math.floor(focus.x - pxWidth * 0.5);

    public var right(get, never):Int;

    inline function get_right() return left + pxWidth - 1;

    public var top(get, never):Int;

    inline function get_top() return Math.floor(focus.y - pxHeight * 0.5);

    public var bottom(get, never):Int;

    inline function get_bottom() return top + pxHeight - 1;

    public function new(p:Process) {
        super(p);
        dx = dy = 0;
        lerpForce = 7;
        maxStep = 5;

        Events.subscribe('camera_shake', (params) -> {
            shakeS(params.t, params.pow);
        });
        Events.subscribe('camera_track_ref', (p) -> trackEntityByRef(p.ref));
        Events.subscribe('camera_set_lerp', (p) -> lerpForce = p.force);
        Events.subscribe('camera_reset_lerp', (p) -> lerpForce = 7);
    }

    override function init() {
        rootScene = world.scene;
    }

    override function resize() {
        pxWidth = gw();
        pxHeight = gh();
    }

    override function reset() {
        recenter();
        lerpForce = 7;
    }

    public function trackEntity(e:Entity, immediate:Bool = true) {
        if(e == null)
            return;

        target = e;
        if(immediate)
            recenter();
    }

    public function trackEntityByRef(ref:String) {
        var ent:Entity;
        if(ref == 'player')
            ent = world.player;
        else ent = Entity.getByRef(ref);

        trackEntity(ent, false);
    }

    public inline function stopTracking() {
        target = null;
    }

    public inline function entityOnScreen(en:Entity, pad:Int) {
        return coordsOnScreen(en.cx, en.cy, pad);
    }

    public inline function coordsOnScreen(x:Float, y:Float, pad:Int) {
        if(x < left - pad || x > right + pad) {
            return false;
        }

        if(y < top - pad || y > bottom + pad) {
            return false;
        }

        return true;
    }

    public function recenter() {
        if(target != null) {
            focus.x = target.getCameraAnchorX();
            focus.y = target.getCameraAnchorY();
        }
    }

    var shakePower = 1.0;

    public function shakeS(t:Float, ?pow = 1.0) {
        timeout.set("shaking", t);
        shakePower = pow * game.saver.settings.video.screenshake;
    }

    function apply() {
        rootScene.x = -focus.x + pxWidth * 0.5;
        rootScene.y = -focus.y + pxHeight * 0.5;

        // Shakes
        if(timeout.has("shaking")) {
            rootScene.x += Math.cos(hxd.Timer.frameCount * 1.1) * 2.5 * shakePower * timeout.getRatio("shaking");
            rootScene.y += Math.sin(0.3 + hxd.Timer.frameCount * 1.7) * 2.5 * shakePower * timeout.getRatio("shaking");
        }

        // Scaling
        rootScene.x *= Const.SCALE;
        rootScene.y *= Const.SCALE;

        // Rounding
        rootScene.x = Math.floor(rootScene.x);
        rootScene.y = Math.floor(rootScene.y);
    }

    override function postUpdate() {
        apply();
    }

    override function update() {
        // Follow target entity
        if(target != null) {
            var delta = new Vector2((target.getCameraAnchorX() - focus.x) * dt * lerpForce, (target.getCameraAnchorY() - focus.y) * dt * lerpForce);
            Util.clamp(delta.length, -maxStep, maxStep);

            focus.x += delta.x;
            focus.y += delta.y;
        }
    }
}
