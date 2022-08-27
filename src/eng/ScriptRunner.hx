package eng;

typedef Command = {
    ?n:String,
    ?p:Dynamic,
    ?f:(ctx:Game) -> Void,
    ?to:eng.Timeout.Task,
};

typedef Script = Array<Command>;

class ScriptRunner {
    public static var timeout:Timeout = new Timeout();
    public static var commandQueue:Array<Command> = [];
    public static var currentCommand:Command = null;
    public static var scripts:Map<String, Script> = [];

    public static var textCommand:Command = null;

    public static function run(s:String) {
        if(scripts[s] == null) {
            trace('Script not found ($s)');
            return;
        }

        // push all the new commands to the front of the queue
        commandQueue = scripts[s].concat(commandQueue);
        // cancel our delay for the next command
        timeout.cancel('next_command');
        // immediately run the first command in the new sequence
        executeNextCommand();
    }

    public static function addScript(name:String, script:Script) {
        scripts[name] = script;
    }

    static public function skipSpeech() {
        if(currentCommand != null && currentCommand.n == 'show_speech') {
            timeout.runImmediately('hide_text');
            timeout.runImmediately('next_command');
        }
    }

    static function executeNextCommand() {
        var delay = 0.0;
        currentCommand = commandQueue.shift();

        // if the queue is empty, we are done for now
        if(currentCommand == null) {
            return;
        }
        // wait command adds a delay to calling the next command
        else if(currentCommand.n == 'wait') {
            delay = currentCommand.p.t;
        }else if(currentCommand.n == 'trace') {
            trace(currentCommand.p.t);
        }
        // run another command asynchronously
        else if(currentCommand.n == 'run') {
            commandQueue = scripts[currentCommand.p.script].concat(commandQueue);
        }
        // run a speech event
        else if(currentCommand.n == 'show_speech') {
            Events.send(currentCommand.n, currentCommand.p);

            delay = 10.0;
            timeout.cancel('hide_text');
            timeout.add('hide_text', () -> {
                Events.send('hide_speech');
            }, delay);
        }
        // run an arbitrary function
        else if(currentCommand.f != null) {
            currentCommand.f(App.inst.game);
        }
        // non-special commands are sent as events
        else {
            Events.send(currentCommand.n, currentCommand.p);
        }

        // call the next command in the queue
        timeout.add('next_command', () -> {
            executeNextCommand();
        }, delay);
    }
}
