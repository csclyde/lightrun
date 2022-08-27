package eng;

typedef Control = {
    ?desc:String,
    ?input:Int,
    ?defaultInput:Int,
    ?group:String,
    ?order:Int,
    ?pressed:Bool,
    ?preventRebind:Bool,
    ?action:(ctx:Game) -> Void,
    ?release:(ctx:Game) -> Void,
};

var ControlScheme:Map<String, Control> = [
    'exit' => {
        desc: 'Exit a menu or the game.',
        defaultInput: Key.ESCAPE,
        group: 'system',
        order: 0,
        action: (ctx:Game) -> {
            if(ctx.feedbackOpen()) {
                Events.send('toggle_feedback');
            }else {
                Events.send('escape_scene');
            }
        }
    },
    'inventory' => {
        desc: 'Open the inventory',
        defaultInput: Key.TAB,
        group: 'gameplay',
        order: 1,
        action: (ctx:Game) -> {
            if(!ctx.feedbackOpen()) {
                Events.send('toggle_inventory');
            }
        }
    },
    'weapon1' => {
        desc: 'Primary weapon',
        defaultInput: Key.MOUSE_LEFT,
        group: 'gameplay',
        order: 2,
        action: (ctx:Game) -> {
            Events.send('activate_weapon1', {x: ctx.input.mouseWorldX, y: ctx.input.mouseWorldY});
        },
        release: (ctx:Game) -> {
            Events.send('release_weapon1', {x: ctx.input.mouseWorldX, y: ctx.input.mouseWorldY});
        }
    },
    'weapon2' => {
        desc: 'Offhand weapon',
        defaultInput: Key.MOUSE_RIGHT,
        group: 'gameplay',
        order: 3,
        action: (ctx:Game) -> {
            Events.send('activate_weapon2', {x: ctx.input.mouseWorldX, y: ctx.input.mouseWorldY});
        },
        release: (ctx:Game) -> {
            Events.send('release_weapon2', {x: ctx.input.mouseWorldX, y: ctx.input.mouseWorldY});
        }
    },
    'up' => {
        desc: 'Move up',
        defaultInput: Key.W,
        group: 'gameplay',
        order: 4,
    },
    'down' => {
        desc: 'Move down',
        defaultInput: Key.S,
        group: 'gameplay',
        order: 5,
    },
    'left' => {
        desc: 'Move left',
        defaultInput: Key.A,
        group: 'gameplay',
        order: 6,
    },
    'right' => {
        desc: 'Move right',
        defaultInput: Key.D,
        group: 'gameplay',
        order: 7,
    },
    'potion_1' => {
        desc: 'Potion One',
        defaultInput: Key.NUMBER_1,
        group: 'gameplay',
        order: 8,
        action: (ctx:Game) -> {
            Events.send('use_potion', {slot: 0});
        }
    },
    'potion_2' => {
        desc: 'Potion Two',
        defaultInput: Key.NUMBER_2,
        group: 'gameplay',
        order: 9,
        action: (ctx:Game) -> {
            Events.send('use_potion', {slot: 1});
        }
    },
    'potion_3' => {
        desc: 'Potion Three',
        defaultInput: Key.NUMBER_3,
        group: 'gameplay',
        order: 10,
        action: (ctx:Game) -> {
            Events.send('use_potion', {slot: 2});
        }
    },
    'potion_4' => {
        desc: 'Potion Four',
        defaultInput: Key.NUMBER_4,
        group: 'gameplay',
        order: 11,
        action: (ctx:Game) -> {
            Events.send('use_potion', {slot: 3});
        }
    },
    'feedback' => {
        desc: 'Open the feedback menu',
        defaultInput: Key.F9,
        group: 'system',
        order: 12,
        action: (ctx:Game) -> {
            Events.send('toggle_feedback');
        }
    },
    'record' => {
        desc: 'Record images for a GIF',
        defaultInput: 44,
        group: 'system',
        preventRebind: true,
        action: (ctx:Game) -> {
            Screenshot.record();
        }
    },
    'debug_kill' => {
        desc: 'Kill the player',
        defaultInput: Key.F10,
        group: 'system',
        preventRebind: true,
        action: (ctx:Game) -> {
            Events.send('kill_player');
        }
    },
    'debug_profile' => {
        desc: 'Toggle profiling',
        defaultInput: Key.F8,
        group: 'system',
        preventRebind: true,
        action: (ctx:Game) -> {
            Process.PROFILING = !Process.PROFILING;
        }
    },
    'debug_compile' => {
        desc: 'Compile the draw scene',
        defaultInput: Key.F7,
        group: 'system',
        preventRebind: true,
        action: (ctx:Game) -> {
            ctx.debugInfo.compileScene();
        }
    },
];
