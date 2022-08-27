package eng;

class Util {
    public static function gauss(x:Float, height:Float, pos:Float, width:Float) {
        return height * Math.exp(-1 * (Math.pow(x - pos, 2) / (2 * Math.pow(width, 2))));
    }

    public inline static function clamp(value:Float, min:Float, max:Float):Float {
        if(value < min)
            return min;
        else if(value > max)
            return max;
        else return value;
    }

    public static function calcScale(width:Float, height:Float):Int {
        var vw:Float = hxd.Window.getInstance().width * 1.1;
        var vh:Float = hxd.Window.getInstance().height * 1.1;

        var sx = Math.floor(vw / width);
        var sy = Math.floor(vh / height);

        return Math.floor(Math.max(1, Math.min(sx, sy)));
    }

    inline public static function frand(?rnd:Void->Float):Float {
        return if(rnd == null) Math.random();else rnd();
    }

    inline public static function frandRange(min:Float, max:Float, ?rnd:Void->Float):Float {
        return min + (max - min) * frand(rnd);
    }

    inline public static function randRange(min:Int, max:Int, ?rnd:Void->Float):Int {
        var l = min - .4999;
        var h = max + .4999;
        return Util.round(l + (h - l) * frand(rnd));
    }

    inline public static function round(x:Float):Int {
        return Std.int(x > 0 ? x + .5 : x < 0 ? x - .5 : 0);
    }

    public static inline function distSqr(ax:Float, ay:Float, bx:Float, by:Float):Float {
        return (ax - bx) * (ax - bx) + (ay - by) * (ay - by);
    }

    public static inline function idistSqr(ax:Int, ay:Int, bx:Int, by:Int):Int {
        return (ax - bx) * (ax - bx) + (ay - by) * (ay - by);
    }

    public static inline function dist(ax:Float, ay:Float, bx:Float, by:Float):Float {
        return Math.sqrt(Math.abs(distSqr(ax, ay, bx, by)));
    }

    public static function formatText(str:String, len:Int) {
        var words = str.split(' ');
        var formattedText = "";
        var lineLen = 0;
        for(d in words) {
            if(lineLen + d.length > len) {
                formattedText += '\n';
                lineLen = 0;
            }

            formattedText += d + ' ';
            lineLen += d.length + 1;
        }

        return formattedText;
    }
}
