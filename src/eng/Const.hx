package eng;

class Const {
    // Various constants
    public static inline var FPS = 60;
    public static inline var FIXED_UPDATE_FPS = 30;

    /** Unique value generator **/
    public static var NEXT_UNIQ(get, never):Int;

    static inline function get_NEXT_UNIQ() return _uniq++;

    static var _uniq = 0;

    public static var GAME_W = 480;
    public static var GAME_H = 270;

    /** Viewport scaling **/
    public static var SCALE(get, never):Float;

    public static var scaleMod:Float = 1.0;

    static inline function get_SCALE() {
        return eng.Util.calcScale(GAME_W, GAME_H) * scaleMod;
    }

    /** Game layers indexes **/
    static var _inc = 0;

    public static var BACKGROUND_OBJECTS = _inc++;

    public static var MIDGROUND_SHADOWS = _inc++;
    public static var MIDGROUND_DEBRIS = _inc++;
    public static var MIDGROUND_OBJECTS = _inc++;
    public static var MIDGROUND_PORTAL = _inc++;
    public static var MIDGROUND_TOP = _inc++;
    public static var MIDGROUND_EFFECTS = _inc++;

    public static var FOREGROUND_OBJECTS = _inc++;
    public static var FOREGROUND_EFFECTS = _inc++;
    public static var LIGHTING = _inc++;
    public static var UI_LAYER = _inc++;
    public static var UI_OVERLAY_LAYER = _inc++;
    public static var SCREEN_LAYER = _inc++;
    public static var DEBUG_DATA = _inc++;

    public static var INVENTORY_SIZE = 8;

    public static var DEBUGGING = true;
}
