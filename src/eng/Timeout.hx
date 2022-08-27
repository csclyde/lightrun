package eng;

class Task { // Classes are faster
    public var t:Float;
    public var total:Float;
    public var id:String;
    public var cb:Void->Void;

    public inline function new(id, t, ?cb) { // Inline new classes are faster faster
        this.t = t;
        this.total = t;
        this.cb = cb;
        this.id = id;
    }
}

class Timeout {
    var delays:Array<Task> = [];

    public function new() {}

    public inline function isDestroyed() return delays == null;

    public function destroy()delays = null;

    public function cancelEverything() {
        delays = [];
    }

    public function has(id:String) {
        for(e in delays) if(e.id == id)
            return true;
        return false;
    }

    public function getS(id:String) {
        for(e in delays) if(e.id == id)
            return e.t;

        return 0.0;
    }

    public function getRatio(id:String) {
        for(e in delays) if(e.id == id)
            return e.t / e.total;

        return 0.0;
    }

    public function cancel(id:String) {
        var i = 0;
        while(i < delays.length)
            if(delays[i].id == id)
                delays.splice(i, 1);
            else i++;
    }

    public function unset(id:String) {
        cancel(id);
    }

    public function runImmediately(id:String) {
        var i = 0;
        while(i < delays.length) {
            if(delays[i].id == id) {
                var cb = delays[i].cb;
                delays.splice(i, 1);
                if(cb != null)
                    cb();
                break;
            }else {
                i++;
            }
        }
    }

    inline function cmp(a:Task, b:Task) {
        return if(a.t < b.t) -1else if(a.t > b.t) 1;else 0;
    }

    public function addMs(?id:String, cb:Void->Void, ms:Float) {
        add(id, cb, ms / 1000);
    }

    public function add(?id:String, cb:Void->Void, sec:Float) {
        var t = new Task(id, sec, cb);
        delays.push(t);
        haxe.ds.ArraySort.sort(delays, cmp);
        return t;
    }

    public function set(id:String, sec:Float, ?cb:Void->Void) {
        for(e in delays) {
            if(e.id == id) {
                e.t = sec;
                e.total = sec;
                e.cb = cb;
                haxe.ds.ArraySort.sort(delays, cmp);
                return;
            }
        }

        add(id, cb, sec);
    }

    public inline function hasAny() return !isDestroyed() && delays.length > 0;

    public function update(dt:Float) {
        var i = 0;
        while(i < delays.length) {
            delays[i].t -= dt;
            if(delays[i].t <= 0) {
                if(delays == null || delays[i] == null) // can happen if cb() called a cancel or dispose method
                    break;

                if(delays[i].cb != null)
                    delays[i].cb();
                delays[i].cb = null;
                delays.shift();
            }else i++;
        }
    }
}
