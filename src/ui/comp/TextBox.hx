package ui.comp;

class TextBox extends Component {
    var input:h2d.TextInput;

    public var placeholder:String;
    public var virgin:Bool;
    public var max:Int;

    public var text(get, set):String;

    function get_text() return input.text;

    function set_text(s) {
        input.text = s;
        return s;
    }

    public function new(?parent, p:String) {
        super(parent);

        virgin = true;
        placeholder = p;
        max = 0;

        backgroundTile = hxd.Res.sprites.Art.get('select4');
        borderWidth = 8;
        borderHeight = 8;
        padding = 8;
        minHeight = 150;
        verticalAlign = Top;
        enableInteractive = true;
        maxWidth = 200;
        minWidth = 200;

        input = new h2d.TextInput(Assets.fontSmall, this);
        input.text = placeholder;
        // input.multiline = true;
        input.cursorTile.dy = 5;
        input.maxWidth = 400;

        interactive.onClick = function(_) {
            if(virgin == true) {
                input.text = '';
                virgin = false;
            }

            input.cursorIndex = input.text.length;
            input.focus();
        }

        input.onClick = function(_) {
            if(virgin == true) {
                input.text = '';
                virgin = false;
            }
        }

        input.onChange = function() {
            // var preCursorText = input.text.substr(0, input.cursorIndex);
            // var preCursorWidth = input.calcTextWidth(preCursorText);

            // var cursorXOffset = (preCursorWidth % input.maxWidth);
            // var cursorYOffset = (Math.floor(input.textHeight / 18) - 1) * (input.textHeight / 3);

            // input.cursorTile.dx = cursorXOffset;
            // input.cursorTile.dy = cursorYOffset;

            if(max > 0) {
                text = text.substr(0, max);
            }

            onChange(text);
        }
    }

    override function reset() {
        virgin = true;
        text = placeholder;
    }

    public dynamic function onChange(text:String) {}
}
