package ui;

import ui.comp.*;

class FeedbackButton extends Component {
    var textBox:TextBox;
    var errorText:h2d.Text;

    public function new(?parent, title:String, imageName:String) {
        super(parent);

        horizontalAlign = Middle;
        layout = Vertical;
        enableInteractive = true;

        var image = new h2d.Bitmap(hxd.Res.sprites.Art.get(imageName), this);
        image.alpha = 0.5;

        var label = new h2d.Text(Assets.fontSmall, this);
        label.text = title;

        onHover = function() {
            image.alpha = 1.0;
        }

        onOut = function() {
            image.alpha = 0.5;
        }
    }
}
