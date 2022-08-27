package eng;

typedef Anim = {
    name:String,
    frames:Array<h2d.Tile>,
    speed:Int,
    loop:Bool,
    next:String,
}

class AnimSprite extends h2d.Anim {
    var anims:Map<String, Anim>;

    public var currentAnim:Anim;

    public function new() {
        super();

        anims = [];
        onAnimEnd = playNext;

        currentAnim = {
            name: null,
            frames: [],
            speed: 0,
            loop: false,
            next: null,
        };
    }

    public function add(name:String, animList:Assets.AnimList, ?speed:Int = 15, ?loop:Bool = true, ?next:String = null) {
        anims[name] = {
            name: name,
            frames: animList[name],
            speed: speed,
            loop: loop,
            next: next,
        };

        return anims[name];
    }

    public function addFrames(name:String, frames:Array<h2d.Tile>, ?speed:Int = 15, ?loop:Bool = true, ?next:String = null) {
        anims[name] = {
            name: name,
            frames: frames,
            speed: speed,
            loop: loop,
            next: next,
        };
    }

    public function playAnim(name:String, ?restart:Bool = true) {
        if(anims[name] == null) {
            trace('Animation with name ' + name + ' not found');
            return;
        }

        var pauseHoldover = pause;

        if(restart || currentAnim.name != name) {
            play(anims[name].frames, 0);
            speed = anims[name].speed;
            loop = anims[name].loop;
            currentAnim = anims[name];
            pause = pauseHoldover;
        }
    }

    public function playNext() {
        if(currentAnim != null && !currentAnim.loop && currentAnim.next != null) {
            playAnim(currentAnim.next);
        }
    }

    public function getCurrentFrameName() {
        return currentAnim.name + '_' + Math.floor(curFrame);
    }

    public function getCurrentFrame() {
        return currentAnim.frames[Math.floor(curFrame - 1)];
    }

    public function getAnim(name:String) {
        if(anims[name] != null) {
            return new h2d.Anim(anims[name].frames, anims[name].speed);
        }

        return null;
    }

    public function setSpeed(name:String, speed:Int) {
        if(anims[name] != null) {
            anims[name].speed = speed;
        }
    }

    public function hide() {
        visible = false;
        pause = true;
    }

    public function show() {
        visible = true;
        pause = false;
    }

    public function update(procSpeed:Float) {
        speed = currentAnim.speed * procSpeed;
    }
}
