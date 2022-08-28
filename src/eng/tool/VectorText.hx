package eng.tool;

class VectorText {
    var tx:Int;
    var ty:Int;
    var ch:Int;
    var chh:Int;
    var cw:Int;
    var cwh:Int;
    var sw:Int;

    var g:h2d.Graphics;

    public function new(parent:h2d.Object, ?size:Int = 16) {
        tx = 0;
        ty = 0;

        g = new h2d.Graphics(parent);
        setStyle(size, 1, 0xFF0000);
    }

    public function clear() {
        g.clear();
    }

    public function setStyle(size = 16, thickness:Int = 1, color:Int = 0xFF0000) {
        ch = size * 2;
        chh = size;
        cw = size;
        cwh = Math.floor(size / 2);
        sw = size + 3;
        g.lineStyle(thickness, color);
    }

    public function drawText(x:Int, y:Int, text:String) {
        tx = x;
        ty = y;

        for(i in 0...text.length) {
            var l = text.toUpperCase().charAt(i);

            if(l == ' ') {
                // tx += sw;
            }else if(l == '0') {
                g.moveTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx, ty + ch);
            }else if(l == '1') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cwh, ty);
                g.lineTo(tx + cwh, ty + ch);
                g.moveTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == '2') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx, ty + chh);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == '3') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx, ty + ch);
                g.moveTo(tx + cw, ty + chh);
                g.lineTo(tx, ty + chh);
            }else if(l == '4') {
                g.moveTo(tx, ty);
                g.lineTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
                g.moveTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == '5') {
                g.moveTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.lineTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx, ty + ch);
            }else if(l == '6') {
                g.moveTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx, ty + chh);
            }else if(l == '7') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx, ty + ch);
            }else if(l == '8') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx, ty);
                g.moveTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
            }else if(l == '9') {
                g.moveTo(tx + cw, ty + ch);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.lineTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
            }else if(l == 'A') {
                g.moveTo(tx, ty + ch);
                g.lineTo(tx, ty + chh);
                g.lineTo(tx + cwh, ty);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx + cw, ty + ch);
                g.moveTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
            }else if(l == 'B') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx, ty);
                g.moveTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
            }else if(l == 'C') {
                g.moveTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == 'D') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cwh, ty);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx + cwh, ty + ch);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx, ty);
            }else if(l == 'E') {
                g.moveTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
                g.moveTo(tx, ty + chh);
                g.lineTo(tx + cwh, ty + chh);
            }else if(l == 'F') {
                g.moveTo(tx, ty + ch);
                g.lineTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.moveTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
            }else if(l == 'G') {
                g.moveTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx + cwh, ty + chh);
            }else if(l == 'H') {
                g.moveTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.moveTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
                g.moveTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == 'I') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.moveTo(tx + cwh, ty);
                g.lineTo(tx + cwh, ty + ch);
                g.moveTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == 'J') {
                g.moveTo(tx + cwh, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx, ty + chh);
            }else if(l == 'K') {
                g.moveTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.moveTo(tx, ty + chh);
                g.lineTo(tx + cw, ty);
                g.moveTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == 'L') {
                g.moveTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == 'M') {
                g.moveTo(tx, ty + ch);
                g.lineTo(tx, ty);
                g.lineTo(tx + cwh, ty + chh);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == 'N') {
                g.moveTo(tx, ty + ch);
                g.lineTo(tx, ty);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx + cw, ty);
            }else if(l == 'O') {
                g.drawEllipse(tx + cwh, ty + chh, cwh, chh);
            }else if(l == 'P') {
                g.moveTo(tx, ty + ch);
                g.lineTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx, ty + chh);
            }else if(l == 'Q') {
                g.moveTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.moveTo(tx + cwh, ty + chh);
                g.lineTo(tx + cw + cwh, ty + ch + chh);
            }else if(l == 'R') {
                g.moveTo(tx, ty + ch);
                g.lineTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + ch);
            }else if(l == 'S') {
                g.moveTo(tx + cw, ty);
                g.lineTo(tx, ty);
                g.lineTo(tx, ty + chh);
                g.lineTo(tx + cw, ty + chh);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx, ty + ch);
            }else if(l == 'T') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.moveTo(tx + cwh, ty);
                g.lineTo(tx + cwh, ty + ch);
            }else if(l == 'U') {
                g.moveTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx + cw, ty);
            }else if(l == 'V') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cwh, ty + ch);
                g.lineTo(tx + cw, ty);
            }else if(l == 'W') {
                g.moveTo(tx, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cwh, ty + chh);
                g.lineTo(tx + cw, ty + ch);
                g.lineTo(tx + cw, ty);
            }else if(l == 'X') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty + ch);
                g.moveTo(tx + cw, ty);
                g.lineTo(tx, ty + ch);
            }else if(l == 'Y') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cwh, ty + chh);
                g.lineTo(tx + cw, ty);
                g.moveTo(tx + cwh, ty + chh);
                g.lineTo(tx + cwh, ty + ch);
            }else if(l == 'Z') {
                g.moveTo(tx, ty);
                g.lineTo(tx + cw, ty);
                g.lineTo(tx, ty + ch);
                g.lineTo(tx + cw, ty + ch);
            }
            tx += sw;
        }
    }
}
