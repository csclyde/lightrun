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
            labelTxt.dropShadow.dx = 0.5;
            labelTxt.dropShadow.dy = 0.5;
        }
    }

    override function out(_) {
        super.out(_);
        labelTxt.dropShadow.dx = 0;
        labelTxt.dropShadow.dy = 0;
    }

    override function push(_) {
        super.push(_);

        labelTxt.color.r = 1.0;
        labelTxt.color.g = 0.0;
        labelTxt.color.b = 0.0;
        labelTxt.dropShadow.dx = 0;
        labelTxt.dropShadow.dy = 0;
    }

    override function release(_) {
        super.release(_);

        labelTxt.color.g = 1.0;
        labelTxt.color.b = 1.0;

        if(hover) {
            labelTxt.dropShadow.dx = 0.5;
            labelTxt.dropShadow.dy = 0.5;
        }
    }
}
