package ui.comp;

class Button extends Component {
    var labelTxt:h2d.Text;

    public var label(get, set):String;

    function get_label() return labelTxt.text;

    function set_label(s) {
        labelTxt.text = s;
        return s;
    }

    var upTile:h2d.Tile;
    var hoverTile:h2d.Tile;
    var downTile:h2d.Tile;

    public function new(?parent) {
        super(parent);

        upTile = hxd.Res.sprites.UI.get('button1_up', Left, Top);
        hoverTile = hxd.Res.sprites.UI.get('button1_hover', Left, Top);
        downTile = hxd.Res.sprites.UI.get('button1_down', Left, Top);

        backgroundTile = upTile;
        borderWidth = 3;
        borderHeight = 3;
        padding = 4;

        labelTxt = new h2d.Text(Assets.lanternFont, this);
    }

    override function over(_) {
        super.over(_);

        backgroundTile = hoverTile;
    }

    override function out(_) {
        super.out(_);

        if(!active) {
            backgroundTile = upTile;
        }
    }

    override function push(_) {
        super.push(_);
        backgroundTile = downTile;
    }

    override function release(_) {
        super.release(_);

        if(hover) {
            backgroundTile = hoverTile;
        }else {
            backgroundTile = upTile;
        }
    }
}
