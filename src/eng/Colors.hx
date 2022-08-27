package eng;

class Colors {
    static public var common = 0xCCCCCC;
    static public var uncommon = 0x007FCC;
    static public var rare = 0xE6E600;
    static public var legendary = 0xCC4C00;

    static public function fire(s:h2d.Drawable) {
        s.color.r = 0.8;
        s.color.g = 0.5;
        s.color.b = 0.0;
        s.adjustColor({
            contrast: 0.8,
            saturation: 1.0,
        });
    }

    static public function hellfire(s:h2d.Drawable) {
        s.color.r = 0.8;
        s.color.g = 0.1;
        s.color.b = 0.0;
        s.adjustColor({
            contrast: 0.8,
            saturation: 1.0,
        });
    }

    static public function colorAttack(s:h2d.Drawable) {
        if(App.inst.game.world.player.flags['ice_strike']) {
            Colors.ice(s);
        }else if(App.inst.game.world.player.flags['fire_strike']) {
            Colors.fire(s);
        }else if(App.inst.game.world.player.flags['lightning_strike']) {
            Colors.elec(s);
        }
    }

    static public function ice(s:h2d.Drawable) {
        s.color.r = 0.0;
        s.color.g = 0.5;
        s.color.b = 1.0;
        s.adjustColor({
            contrast: 0.8,
            saturation: 1.0,
        });
    }

    static public function elec(s:h2d.Drawable) {
        s.color.r = 0.0;
        s.color.g = 1.0;
        s.color.b = 1.0;
        s.adjustColor({
            contrast: 0.8,
            saturation: 1.0,
        });
    }

    static public function energy(s:h2d.Drawable) {
        s.color.r = 0.8;
        s.color.g = 0.0;
        s.color.b = 0.8;
        s.adjustColor({
            contrast: 0.8,
            saturation: 0.2,
        });
    }

    static public function chaos(s:h2d.Drawable) {
        s.color.r = 0.0;
        s.color.g = 0.8;
        s.color.b = 0.5;
        s.adjustColor({
            contrast: 0.8,
            saturation: 0.2,
        });
    }

    static public function bone(s:h2d.Drawable) {
        s.color.r = 0.8;
        s.color.g = 0.8;
        s.color.b = 0.6;
        s.adjustColor({
            contrast: 0.0,
            saturation: 0.0,
        });
    }

    static public function dark_bone(s:h2d.Drawable) {
        s.color.r = 0.5;
        s.color.g = 0.5;
        s.color.b = 0.4;
        s.adjustColor({
            contrast: 0.0,
            saturation: 0.0,
        });
    }

    static public function shadow(s:h2d.Drawable) {
        s.color.r = 0.4;
        s.color.g = 0.4;
        s.color.b = 0.4;
        s.adjustColor({
            contrast: 0.8,
            saturation: 1.0,
        });
    }

    static public function portal(s:h2d.Drawable) {
        s.color.r = 0.1;
        s.color.g = 0.3;
        s.color.b = 0.7;
        s.adjustColor({});
    }

    static public function wood(s:h2d.Drawable) {
        s.color.r = 0.4;
        s.color.g = 0.3;
        s.color.b = 0.3;
        s.adjustColor({
            contrast: 0.2,
            saturation: 0.3,
        });
    }
}
