package eng;

typedef Callback = (Dynamic) -> Void;

class Events {
    public static var events:Map<String, Array<Callback>> = [];

    public static function subscribe(eventName:String, newCallback:Callback) {
        var callbacks = events[eventName];

        if(callbacks == null) {
            events[eventName] = [];
            callbacks = events[eventName];
        }

        callbacks.push(newCallback);
    }

    public static function send(eventName:String, ?params:Dynamic = null) {
        var callbacks = events[eventName];

        if(callbacks == null) {
            // trace('Event (' + eventName + ') called with no listeners');
            return;
        }

        for(c in callbacks) {
            c(params);
        }
    }
}
