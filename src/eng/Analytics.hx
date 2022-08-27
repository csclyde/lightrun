package eng;

import haxe.Json;
import haxe.crypto.Md5;
import sys.FileSystem;
import sys.io.File;

class Analytics {
    public function new() {}

    public static function sendFeedback(rating:Int, message:String) {
        var feedback = {
            PID: getSysUUID(),
            Env: 'dev',
            Project: 'necrovale',
            Platform: Sys.systemName(),

            Rating: rating,
            Message: message,
            Category: 'general',
            FPS: Math.floor(hxd.Timer.fps()),
        }

        try {
            var request = new haxe.Http('https://api.clyde.games/feedback');
            request.setPostData(Json.stringify(feedback));
            request.request(true);

            trace('Feedback successfully submitted');
            // trace(request.responseData);
            // for(k => v in request.responseHeaders) {
            //     trace(k + ' => ' + v);
            // }
        } catch (e) {
            trace(e.message);
        }
    }

    public static function event(type:String) {
        var event = {
            PID: getSysUUID(),
            Env: 'dev',
            Project: 'necrovale',
            Platform: Sys.systemName(),

            Type: type,
        }

        try {
            var request = new haxe.Http('https://api.clyde.games/event');
            request.setPostData(Json.stringify(event));
            request.request(true);

            trace(request.responseData);
            for(k => v in request.responseHeaders) {
                trace(k + ' => ' + v);
            }
        } catch (e) {
            trace(e.message);
        }
    }

    public static function getSysUUID() {
        if(FileSystem.exists('uuid')) {
            return File.getContent('necrovale.uuid');
        }else {
            var envs = Sys.environment();
            var os = Sys.systemName();
            var username = '';

            if(envs["USER"] != null) {
                username = envs["USER"];
            }else if(envs["USERNAME"] != null) {
                username = envs["USERNAME"];
            }

            var rand = Math.round(Math.random() * 1000000);

            var uuid = Md5.encode(os + '.' + username + '.' + rand);
            File.saveContent('necrovale.uuid', uuid);
            return uuid;
        }
    }
}
