package eng;

class Console extends Process {
    public var h2dConsole:h2d.Console;

    #if debug
    var flags:Map<String, Bool>;
    #end

    public function new(parent:Process) {
        super(parent);

        createRoot();
        game.root.add(root, Const.DEBUG_DATA);

        h2dConsole = new h2d.Console(Assets.fontTiny, root);

        h2dConsole.setScale(2); // TODO smarter scaling for 4k screens
        h2dConsole.shortKeyChar = "`".code;

        // Settings
        h2d.Console.HIDE_LOG_TIMEOUT = 30;
        haxe.Log.trace = function(m, ?pos) {
            if(pos != null && pos.customParams == null)
                pos.customParams = ["debug"];

            h2dConsole.log(pos.fileName + "(" + pos.lineNumber + ") : " + Std.string(m));
        }

        // Debug flags
        #if debug
        flags = new Map();
        this.addCommand("set", [{n: "k", t: AString}], function(k:String) {
            setFlag(k, true);
            log("+ " + k.toLowerCase(), 0x80FF00);
        });
        this.addCommand("unset", [{n: "k", t: AString, opt: true}], function(?k:String) {
            if(k == null) {
                log("Reset all.", 0xFF0000);
                for(k in flags.keys()) setFlag(k, false);
            }else {
                log("- " + k, 0xFF8000);
                setFlag(k, false);
            }
        });
        this.addCommand("list", [], function() {
            for(k in flags.keys()) log(k, 0x80ff00);
        });
        this.addAlias("+", "set");
        this.addAlias("-", "unset");
        #end
    }

    // function handleCommand(command:String) {
    // 	var flagReg = ~/[\/ \t]*\+[ \t]*([\w]+)/g; // cleanup missing spaces
    // 	h2dConsole.handleCommand( flagReg.replace(command, "/+ $1") );
    // }

    public function error(msg:Dynamic) {
        h2dConsole.log("[ERROR] " + Std.string(msg), 0xff0000);
        h2d.Console.HIDE_LOG_TIMEOUT = 999999;
    }

    #if debug
    public function setFlag(k:String, v) {
        k = k.toLowerCase();
        var hadBefore = hasFlag(k);

        if(v)
            flags.set(k, v);
        else flags.remove(k);

        if(v && !hadBefore || !v && hadBefore)
            onFlagChange(k, v);
        return v;
    }

    public function hasFlag(k:String) return flags.get(k.toLowerCase()) == true;
    #else
    public function hasFlag(k:String) return false;
    #end

    public function onFlagChange(k:String, v:Bool) {}
}
