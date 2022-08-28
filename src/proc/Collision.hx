package proc;

import echo.Physics;
import echo.data.Data.CollisionData;

class Collision extends Process {
    public function new(p:Process) {
        super(p);
    }

    override function init() {}

    override function reset() {}

    public function onEnter(a:Body, b:Body, c:Array<CollisionData>) {
        trace('fuck');
        var playerInvolved = world.player.isPlayerBody(a, b);

        var levelBody = world.currentLevel == null ? null : world.currentLevel.getRoomBody(a, b);

        var trigger = Trigger.getTriggerFromBody(a, b);

        // player vs trigger
        if(playerInvolved == true && trigger != null) {
            trigger.enter();
        }
    }

    public function onStay(a:Body, b:Body, c:Array<CollisionData>) {
        var trigger = Trigger.getTriggerFromBody(a, b);
    }

    public function onExit(a:Body, b:Body) {}
}
