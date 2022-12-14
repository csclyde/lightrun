package eng.hxbt.composites;

import eng.hxbt.Behavior.Status;

/**
 * A special branch that starts or resume all children every time it runs.
 * Will success if _all_ the children succeed.
 * Will fail if any one of the children fail.
 * @author Kenton Hamaluik
 */
class Parallel<T> extends Composite<T> {
    public function new() {
        super();
    }

    override function init(context:T) {}

    override function terminate(context:T, status:Status) {
        for(_child in m_children) {
            _child.status = Status.INVALID;
        }
    }

    override function update(context:T, dt:Float):Status {
        var allSucceeded:Bool = true;
        for(child in m_children) {
            child.tick(context, dt);

            // if any of the children fail,
            // fail the whole branch
            if(child.status == Status.FAILURE) {
                return Status.FAILURE;
            }
            // if all children didn't succeed, we're not done yet
            else if(child.status != Status.SUCCESS) {
                allSucceeded = false;
            }
        }

        if(allSucceeded) {
            return Status.SUCCESS;
        }

        return Status.RUNNING;
    }
}
