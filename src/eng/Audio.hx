package eng;

import hxd.snd.ChannelGroup;

class Audio extends Process {
    public var snd:hxd.snd.Manager;

    var sounds:Map<Data.SoundsKind, hxd.res.Sound>;
    var groups:Map<String, ChannelGroup>;
    var music:hxd.snd.Channel;

    public function new(p:Process) {
        super(p);

        snd = hxd.snd.Manager.get(); // force sound manager init on startup instead of first sound play
        sounds = [];
        groups = [];

        for(s in Data.sounds.all) {
            var sound = hxd.Res.load(s.file).toSound();
            sounds[s.id] = sound;
        }
    }

    override function init() {
        Events.subscribe('play_sound', (params:Dynamic) -> playSound(params.id));
    }

    override function reset() {}

    public function applySettings(s) {
        snd.masterVolume = Math.pow(s.masterVolume, 4);

        for(g in groups) {
            g.volume = Math.pow(s.sfxVolume, 4);
        }

        if(groups['music'] != null) {
            groups['music'].volume = Math.pow(s.musicVolume, 4);
        }
    }

    override public function onDispose() {
        super.onDispose();

        snd.dispose();
    }

    override function update() {
        super.update();
    }

    public function muteGroup(group:String) {
        if(groups[group] != null) {
            groups[group].fadeTo(0, 0.2);
        }
    }

    public function unmuteGroup(group:String) {
        if(groups[group] != null) {
            groups[group].fadeTo(1.0, 0.2);
        }
    }

    public function playSound(id:Data.SoundsKind) {
        var data = Data.sounds.get(id);

        if(groups[data.group] == null) {
            groups[data.group] = new hxd.snd.ChannelGroup(data.group);
        }

        return sounds[id].play(data.loop, data.volume, groups[data.group]);
    }

    public function stopSound(sound:hxd.res.Sound) {
        sound.stop();
    }

    public function playMusic(id:Data.SoundsKind) {
        var data = Data.sounds.get(id);

        if(groups['music'] == null) {
            groups['music'] = new hxd.snd.ChannelGroup(data.group);
        }

        if(music != null) {
            music.stop();
            music = null;
        }

        music = sounds[id].play(data.loop, data.volume, groups[data.group]);
        return music;
    }

    public function stopMusic() {
        if(music != null) {
            music.stop();
            music = null;
        }
    }
}
