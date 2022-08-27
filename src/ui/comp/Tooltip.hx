package ui.comp;

import h3d.Vector;

class Tooltip extends h2d.Flow {
    var tipText:h2d.Text;

    public function new(?parent) {
        super(parent);

        backgroundTile = hxd.Res.sprites.UI.get('scroll_open', Middle, Middle);
        borderWidth = 13;
        borderHeight = 13;
        minWidth = 40;
        minHeight = 20;
        padding = 5;
        layout = Vertical;
        verticalAlign = Top;
        horizontalAlign = Left;
        verticalSpacing = 10;
        // debug = true;

        tipText = new h2d.Text(Assets.magicBookFont, this);
        tipText.color = new Vector(0);
    }

    public function showText(text:String, newX:Float, newY:Float) {
        tipText.text = formatText(text);

        reflow();

        x = newX - calculatedWidth - 10;
        y = newY - calculatedHeight / 2;

        visible = true;
    }

    public function formatText(str:String) {
        var words = str.split(' ');
        var formattedText = "";
        var lineLen = 0;
        for(d in words) {
            if(lineLen + d.length > 30) {
                formattedText += '\n';
                lineLen = 0;
            }

            formattedText += d + ' ';
            lineLen += d.length + 1;
        }

        return replaceVariables(formattedText);
    }

    public function replaceVariables(str:String) {
        return str;
    }

    public function hide() {
        visible = false;
    }
}
