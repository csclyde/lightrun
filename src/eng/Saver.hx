package eng;

import hxd.Save;
import sdl.Window.DisplayMode;
import proc.*;

typedef Settings = {
    video:{
        displayMode:DisplayMode, screenshake:Float, vsync:Bool,
    },
    audio:{
        masterVolume:Float, musicVolume:Float, sfxVolume:Float,
    },
    controls:{
        bindings:Map<String, Int>,
    }
};

class Saver {
    public var settings:Settings;
    public var world:World;

    public function new(w:World) {
        world = w;

        Events.subscribe('save_game', saveGame);
        Events.subscribe('save_settings', saveSettings);
    }

    public function loadGame(slot:String) {
        var defaultSave = {};

        var save = load(defaultSave, slot);
        return save;
    }

    public function saveGame(params:Dynamic) {}

    public function applySettings() {
        hxd.Window.getInstance().displayMode = settings.video.displayMode;
        hxd.Window.getInstance().vsync = settings.video.vsync;
        world.audio.applySettings(settings.audio);
        world.input.applySettings(settings.controls);

        world.game.resizeAll();

        saveSettings();
    }

    public function loadSettings() {
        var defaultSettings:Settings = {
            video: {
                displayMode: Borderless,
                screenshake: 1.0,
                vsync: true,
            },
            audio: {
                masterVolume: 1.0,
                musicVolume: 1.0,
                sfxVolume: 1.0,
            },
            controls: {
                bindings: ["unused" => 0],
            }
        };

        settings = load(defaultSettings, 'settings');
        applySettings();
    }

    public function saveSettings(?p) {
        // pull in the control scheme bindings
        settings.controls = world.input.getSettings();
        save(settings, 'settings');
    }

    public function save(data:Dynamic, slot:String) {
        Save.save(data, slot);
    }

    public function load(def:Dynamic, slot:String):Dynamic {
        var data = Save.load(def, slot);
        return data;
    }

    public function hasSave() {
        return sys.FileSystem.exists('slot1.sav');
    }
}
