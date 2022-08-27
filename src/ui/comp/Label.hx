package ui.comp;

class Label extends Component {
    var labelTxt:h2d.Text;

    public var label(get, set):String;

    function get_label() return labelTxt.text;

    function set_label(s) {
        labelTxt.text = s;
        return s;
    }

    public function new(?parent:h2d.Flow, l:String, f:h2d.Font) {
        super(parent);

        parentFlow = parent;

        borderWidth = 3;
        borderHeight = 3;
        padding = 4;
        horizontalAlign = Middle;

        labelTxt = new h2d.Text(f, this);
        labelTxt.text = l;
        labelTxt.setScale(2);

        // labelTxt.dropShadow = {
        // 	dx: 0,
        // 	dy: 0,
        // 	color: 0xFF0000,
        // 	alpha: 1.0
        // };
    }

    override function reset() {
        labelTxt.dropShadow.dx = 0;
        labelTxt.dropShadow.dy = 0;
        setColor(1.0, 1.0, 1.0);
    }

    public function setColor(r, g, b) {
        labelTxt.color.r = r;
        labelTxt.color.g = g;
        labelTxt.color.b = b;
    }

    public function setDropshadow(color:Int) {
        labelTxt.dropShadow = {
            dx: 0.5,
            dy: 0.5,
            color: color,
            alpha: 1.0
        };
    }

    public function setTextScale(s:Float) {
        labelTxt.setScale(s);
    }

    public function setTextAlign(s:h2d.Text.Align) {
        labelTxt.textAlign = Center;
    }

    public dynamic function onChange(option:String) {}
}
