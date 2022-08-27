package eng;

class Process {
    static var UNIQ_ID = 0;

    public var game(get, never):Game;

    inline function get_game() return App.inst.game;

    public var input(get, never):Input;

    inline function get_input() return game.inputProc;

    public var audio(get, never):Audio;

    inline function get_audio() return game.audioProc;

    public var world(get, never):World;

    inline function get_world() return game.worldScene;

    public var fx(get, never):Fx;

    inline function get_fx() return world.fxProc;

    public var uid:Int; // Process unique ID
    public var name:Null<String>; // Process display name

    var parent(default, null):Process;
    var children:Array<Process>;

    public var speed:Float;
    public var storedSpeed:Float;
    public var dt:Float;
    public var et:Float;

    var _manuallyPaused:Bool; // TRUE if this process was directly manually paused

    public var destroyed(default,
        null):Bool; // TRUE if process was marked for removal during garbage collection phase. Most stuff should stop from happening if this flag is set!

    public var tw:Tweenie; // Tweenie tweens values
    public var timeout:Timeout;

    var _fixedUpdateAccu = 0.;

    public var root:Null<h2d.Layers>; // Graphic context, can be null
    public var engine(get, never):h3d.Engine;

    inline function get_engine() return h3d.Engine.getCurrent();

    public function new(parent:Process) {
        uid = UNIQ_ID++;
        children = [];
        _manuallyPaused = false;
        destroyed = false;

        speed = 1.0;
        storedSpeed = 0.0;
        et = 0.0;

        tw = new Tweenie(Const.FPS);
        timeout = new Timeout();

        if(parent != null) {
            parent.addChild(this);
        }
    }

    public function createRoot(?ctx:h2d.Object) {
        if(root != null)
            throw this + ": root already created!";

        root = new h2d.Layers(ctx);
        root.name = getDisplayName();
    }

    public static var PROFILING = false; // Set to TRUE to enabled Process timing profiling (warning: this will reduce performances)
    public static var PROFILER_TIMES:Map<String, Float> = new Map(); // List of current profiling times

    var tmpProfilerTimes = new Map();

    inline function markProfilingStart(id:String) {
        if(PROFILING) {
            id = getDisplayName() + "." + id;
            tmpProfilerTimes.set(id, haxe.Timer.stamp() * 1000);
        }
    }

    inline function markProfilingEnd(id:String) {
        if(PROFILING) {
            id = getDisplayName() + "." + id;
            if(tmpProfilerTimes.exists(id)) {
                var t = (haxe.Timer.stamp() * 1000) - tmpProfilerTimes.get(id);
                tmpProfilerTimes.remove(id);

                // PROFILER_TIMES.set(id, t);

                if(!PROFILER_TIMES.exists(id))
                    PROFILER_TIMES.set(id, t);
                else PROFILER_TIMES.set(id, PROFILER_TIMES.get(id) + t);
            }
        }
    }

    /** Return the current profiling times, sorted from highest to lowest **/
    public static function getSortedProfilerTimes() {
        var all = [];
        for(i in PROFILER_TIMES.keyValueIterator()) all.push(i);
        all.sort((a, b) -> -Reflect.compare(a.value, b.value));
        return all;
    }

    public inline function getDisplayName() {
        if(name == null) {
            name = Type.getClassName(Type.getClass(this));
        }

        return name;
    }

    public inline function w() return hxd.Window.getInstance().width;

    public inline function h() return hxd.Window.getInstance().height;

    public inline function gw() return Math.ceil(w() / Const.SCALE);

    public inline function gh() return Math.ceil(h() / Const.SCALE);

    public inline function isPaused() {
        if(_manuallyPaused)
            return true;
        else return parent != null ? parent.isPaused() : false;
    }

    public function pause()_manuallyPaused = true;

    public function resume()_manuallyPaused = false;

    public function freeze() {
        storedSpeed = speed;
        speed = 0.0;
    }

    public function unfreeze() {
        speed = storedSpeed;
    }

    public final inline function togglePause():Bool {
        if(_manuallyPaused)
            resume();
        else pause();
        return _manuallyPaused;
    }

    public function destroy()destroyed = true;

    public function addChild(p:Process) {
        if(p.parent != null)
            p.parent.children.remove(p);
        p.parent = this;
        children.push(p);
    }

    inline function canRun() return !isPaused() && !destroyed;

    function _doPreUpdate(deltaTime:Float) {
        if(!canRun())
            return;

        dt = deltaTime * speed;
        et += dt;

        tw.update(hxd.Timer.tmod * speed);
        timeout.update(dt);

        markProfilingStart("pre");
        preUpdate();
        markProfilingEnd("pre");

        for(c in children) c._doPreUpdate(dt);
    }

    function _doMainUpdate() {
        markProfilingStart("always");
        alwaysUpdate();
        markProfilingEnd("always");

        if(canRun()) {
            markProfilingStart("update");
            update();
            markProfilingEnd("update");
        }

        for(c in children) c._doMainUpdate();
    }

    function _doFixedUpdate() {
        if(!canRun())
            return;

        markProfilingStart("fixed");
        _fixedUpdateAccu += hxd.Timer.tmod;
        while(_fixedUpdateAccu >= Const.FPS / Const.FIXED_UPDATE_FPS) {
            _fixedUpdateAccu -= Const.FPS / Const.FIXED_UPDATE_FPS;
            fixedUpdate();
        }
        markProfilingEnd("fixed");

        for(c in children) c._doFixedUpdate();
    }

    function _doPostUpdate() {
        if(!canRun())
            return;

        markProfilingStart("post");
        postUpdate();
        markProfilingEnd("post");

        for(c in children) c._doPostUpdate();
    }

    function _garbageCollector(plist:Array<Process>) {
        var i = 0;
        while(i < plist.length) {
            var p = plist[i];
            if(p.destroyed)
                _disposeProcess(p);
            else {
                _garbageCollector(p.children);
                i++;
            }
        }
    }

    function _disposeProcess(p:Process) {
        // Children
        for(p in p.children) p.destroy();
        _garbageCollector(p.children);

        // Tools
        p.tw.destroy();

        // Unregister from lists
        if(p.parent != null) {
            p.parent.children.remove(p);
        }

        // Graphic context
        if(p.root != null) {
            p.root.remove();
        }

        // Callbacks
        p.onDispose();

        // Clean up
        p.parent = null;
        p.children = null;
        p.tw = null;
        p.root = null;
    }

    function init() {}

    function reset() {}

    function resize() {}

    function preUpdate() {}

    function update() {}

    function alwaysUpdate() {}

    function fixedUpdate() {}

    function postUpdate() {}

    function onDispose() {}

    public final function initAll() {
        init();
        for(c in children) c.initAll();
    }

    public final function resetAll() {
        reset();
        for(c in children) c.resetAll();
    }

    public final function resizeAll() {
        resize();
        for(c in children) c.resizeAll();
    }

    public final function updateAll(dt:Float) {
        _doPreUpdate(dt);
        _doMainUpdate();
        _doFixedUpdate();
        _doPostUpdate();
    }
}
