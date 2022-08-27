package eng;

class Scene extends Process {
    public var entities:Array<Entity>;

    function new(parent:Process) {
        super(parent);
        entities = [];
    }

    public function activeEntities() {
        return entities.filter(e -> return e != null && e.destroyed == false);
    }

    public function destroyedEntities() {
        return entities.filter(e -> return e.destroyed == true);
    }

    public function switchTo() {}

    public function switchFrom() {}

    public function onEscape() {}

    override function preUpdate() {
        super.preUpdate();
        for(e in activeEntities()) {
            e.timeout.update(dt);
            e.tw.update(hxd.Timer.tmod * speed);
            e.internalUpdate();
            e.preUpdate();
        }
    }

    override function fixedUpdate() {
        super.fixedUpdate();
        for(e in activeEntities()) e.fixedUpdate();
    }

    override function update() {
        super.update();

        for(e in activeEntities()) {
            e.update();
        }
    }

    override function postUpdate() {
        super.postUpdate();
        for(e in activeEntities()) e.postUpdate();
        for(e in destroyedEntities()) {
            e.dispose();
            entities.remove(e);
            e = null;
        }
    }
}
