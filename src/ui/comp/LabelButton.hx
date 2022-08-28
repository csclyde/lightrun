package ui.comp;

class LabelButton extends Label {
    public function new(?parent, l:String, ?f:h2d.Font) {
        super(parent, l, (f != null ? f : Assets.alagardFont));

        labelTxt.dropShadow = {
            dx: 0,
            dy: 0,
            color: 0xFF0000,
            alpha: 1.0
        };
    }

    override function over(_) {
        super.over(_);

        if(active == false) {
            vectorTxt.clear();
            vectorTxt.setStyle(16, 1, 0xFF0000);
            vectorTxt.drawText(0, 0, text);
        }
    }

    override function out(_) {
        super.out(_);
        vectorTxt.clear();
        vectorTxt.setStyle(16, 1, 0x0000FF);
        vectorTxt.drawText(0, 0, text);
    }

    override function push(_) {
        super.push(_);

        vectorTxt.clear();
        vectorTxt.setStyle(16, 1, 0xFF00FF);
        vectorTxt.drawText(0, 0, text);
    }

    override function release(_) {
        super.release(_);

        if(hover) {
            vectorTxt.clear();
            vectorTxt.setStyle(16, 1, 0xFF0000);
            vectorTxt.drawText(0, 0, text);
        }else {
            vectorTxt.clear();
            vectorTxt.setStyle(16, 1, 0x0000FF);
            vectorTxt.drawText(0, 0, text);
        }
    }
}
