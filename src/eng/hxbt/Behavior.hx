package eng.hxbt;

/*
 * Behavior states.
 */
enum Status {
    INVALID;
    SUCCESS;
    FAILURE;
    RUNNING;
}

/**
 * Base class for all actions, conditons and composites.
 * A composite is a branch in the behavior tree.
 * @author Kristian Brodal
 */
@:keepSub
class Behavior<T> {
    public var status(default, default):Status = Status.INVALID;

    public function new() {}

    public function update(context:T, dt:Float):Status {
        return Status.INVALID;
    }

    public function init(context:T):Void {}

    public function terminate(context:T, status:Status):Void {}

    public function tick(context:Dynamic, dt:Float):Status {
        if(status == Status.INVALID) {
            init(context);
        }

        status = update(context, dt);

        if(status != Status.RUNNING) {
            terminate(context, status);
        }

        return status;
    }
}
