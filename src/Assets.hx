typedef AnimList = Map<String, Array<h2d.Tile>>;

class Assets {
    public static var fontTiny:h2d.Font;
    public static var fontTinyRed:h2d.Font;
    public static var fontTinyGreen:h2d.Font;
    public static var fontSmall:h2d.Font;
    public static var fontMedium:h2d.Font;
    public static var fontLarge:h2d.Font;
    public static var bubbleFont:h2d.Font;
    public static var lanternFont:h2d.Font;
    public static var magicBookFont:h2d.Font;
    public static var alagardFont:h2d.Font;

    static var initDone = false;

    public static function init() {
        if(initDone)
            return;
        initDone = true;

        fontTiny = hxd.Res.fonts.barlow_condensed_medium_regular_9.toFont();
        fontTinyRed = hxd.Res.fonts.barlow_condensed_medium_regular_9_red.toFont();
        fontTinyGreen = hxd.Res.fonts.barlow_condensed_medium_regular_9_green.toFont();
        fontSmall = hxd.Res.fonts.barlow_condensed_medium_regular_11.toFont();
        fontMedium = hxd.Res.fonts.barlow_condensed_medium_regular_17.toFont();
        fontLarge = hxd.Res.fonts.barlow_condensed_medium_regular_32.toFont();
        bubbleFont = hxd.Res.fonts.bubble.toFont();
        lanternFont = hxd.Res.fonts.lantern.toFont();
        magicBookFont = hxd.Res.fonts.magicBook.toFont();
        alagardFont = hxd.Res.fonts.alagard.toFont();
    }

    public static function getAllAnimNames(atlas:hxd.res.Atlas) {
        var iter = atlas.getContents().keys();
        var anims = [];
        for(i in iter) {
            anims.push(i);
        }

        return anims;
    }
}
