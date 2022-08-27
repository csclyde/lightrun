package eng;

import eng.ControlScheme;
import hxd.Key;

class Input extends Process {
    public var mouseX:Float;
    public var mouseY:Float;
    public var mouseWorldX:Float;
    public var mouseWorldY:Float;

    public var inputAllowed:Bool;
    public var awaitingRebind:Bool;
    public var cancelNextClick:Bool;

    public function new(p:Process) {
        super(p);
        inputAllowed = false;
        awaitingRebind = false;
        cancelNextClick = false;
    }

    override function init() {
        hxd.Window.getInstance().addEventTarget(onEvent);

        Events.subscribe('allow_input', (p) -> {
            inputAllowed = true;
        });
        Events.subscribe('disallow_input', (p) -> {
            inputAllowed = false;
        });
        Events.subscribe('await_rebind', (p) -> awaitingRebind = true);
        Events.subscribe('finish_rebind', (p) -> awaitingRebind = false);
    }

    public function onEvent(e:hxd.Event) {
        if(awaitingRebind) {
            if(e.kind == hxd.Event.EventKind.EKeyDown) {
                Events.send('rebind', {key: e.keyCode});
            }else if(e.kind == hxd.Event.EventKind.EPush) {
                Events.send('rebind', {key: e.button});
            }
        }
    }

    public function applySettings(s) {
        var bindings:Map<String, Int> = s.bindings;
        for(k => v in bindings) {
            if(ControlScheme[k] != null) {
                ControlScheme[k].input = v;
            }
        }
    }

    public function getSettings() {
        var settings = {
            bindings: ['unused' => 0]
        };

        for(k => v in ControlScheme) {
            if(v.input != null) {
                settings.bindings.set(k, v.input);
            }
        }

        return settings;
    }

    public function isControlActive(name:String) {
        return ControlScheme[name] != null ? ControlScheme[name].pressed : false;
    }

    public function getControlKeyName(name:String) {
        var control = ControlScheme[name];
        if(control != null) {
            return Key.getKeyName(ControlScheme[name].input != null ? ControlScheme[name].input : ControlScheme[name].defaultInput);
        }else {
            return null;
        }
    }

    function controlUsesMouse(c:Control) {
        var button = c.input != null ? c.input : c.defaultInput;
        return [Key.MOUSE_LEFT, Key.MOUSE_RIGHT].contains(button);
    }

    override function preUpdate() {
        super.preUpdate();

        mouseX = App.inst.s2d.mouseX / Const.SCALE;
        mouseY = App.inst.s2d.mouseY / Const.SCALE;

        if(world != null && world.camera != null) {
            mouseWorldX = mouseX + world.camera.left;
            mouseWorldY = mouseY + world.camera.top;
        }
    }

    override function update() {
        // when awaiting a rebind, do not activate any controls
        if(awaitingRebind)
            return;

        // special case for skipping text
        if(Key.isPressed(ControlScheme['weapon1'].defaultInput)) {
            Events.send('skip_speech');
        }

        for(c in ControlScheme) {
            // if its a gameplay control and controls are inactive, release the control
            if((!inputAllowed || game.currentScene != game.worldScene) && c.group == 'gameplay') {
                if(c.pressed) {
                    if(c.release != null)
                        c.release(game);
                    c.pressed = false;
                }

                continue;
            }

            // if we are preventing the next mouse click, and its from the mouse, skip
            if(controlUsesMouse(c) && cancelNextClick) {
                cancelNextClick = false;
                continue;
            }

            var key = c.input != null ? c.input : c.defaultInput;

            if(Key.isPressed(key) && c.action != null) {
                c.action(game);
            }

            // if the button is not down but the action still registers as pressed,
            // execute the release action
            if(!Key.isDown(key) && c.pressed == true && c.release != null) {
                c.release(game);
            }

            c.pressed = Key.isDown(key);
        }
    }
}
