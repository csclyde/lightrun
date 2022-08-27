package eng.tool;

import h2d.Bitmap;
import format.png.Writer;
import format.png.Tools;
import sys.io.File;
import haxe.io.Path;

class Screenshot {
    static var timeout:Timeout = new Timeout();
    static var bufferEnabled:Bool = false;
    static var imgBuffer:Array<h2d.Bitmap> = [];
    static var bl:Int = 100;
    static var op:String = 'working/gif';
    static var fps:Int = 15;

    public static function capture(path:String) {
        var ss = App.inst.s2d.captureBitmap();
        var bytes = ss.tile.getTexture().capturePixels().bytes;

        doodleBytes(bytes);
        var png = Tools.build32BGRA(App.inst.s2d.width, App.inst.s2d.height, bytes);
        var pngWriter = new Writer(File.write(op + 'Screenshot-${Date.now().toString()}'));
        pngWriter.write(png);
    }

    public static function record() {
        // begin a chain of delays, based on the fps
        trace('Beginning recording...');
        removeDirectory(op);
        createDirectory(op);
        captureScreen();
    }

    static function captureScreen() {
        addScreenshotToBuffer();

        if(imgBuffer.length >= 100) {
            trace('Finished recording. Beginning save process...');
            savePngsFromBuffer();
            trace('Images saved to ' + op);
        }else {
            timeout.add('capture_screen', captureScreen, 1 / fps);
        }
    }

    static function addScreenshotToBuffer() {
        var ss = App.inst.s2d.captureBitmap();

        if(imgBuffer.length > 100) {
            imgBuffer.shift();
        }

        imgBuffer.push(ss);
    }

    static function savePngsFromBuffer() {
        for(i in 0...imgBuffer.length) {
            var bytes = imgBuffer[i].tile.getTexture().capturePixels().bytes;
            doodleBytes(bytes);
            var png = Tools.build32BGRA(App.inst.s2d.width, App.inst.s2d.height, bytes);
            // png = Tools.build32BGRA
            var pngWriter = new Writer(File.write(op + '/screenshot.' + i + '.png'));
            pngWriter.write(png);
        }

        imgBuffer = [];
    }

    static function doodleBytes(b:haxe.io.Bytes) {
        inline function bget(p) {
            return b.get(p);
        }
        inline function bset(p, v) {
            return b.set(p, v);
        }
        var p = 0;
        for(i in 0...b.length >> 2) {
            var b = bget(p);
            var g = bget(p + 1);
            var r = bget(p + 2);
            var a = bget(p + 3);
            bset(p++, r);
            bset(p++, g);
            bset(p++, b);
            bset(p++, a);
        }
    }

    static function createDirectory(path:String) {
        path = Path.normalize(path);

        try {
            sys.FileSystem.createDirectory(path);
        } catch (e : Dynamic) {
            trace("Couldn't create directory " + path + ". Maybe it's in use right now? (" + e + ")");
        }
    }

    static function removeDirectory(path:String) {
        path = Path.normalize(path);

        if(!sys.FileSystem.exists(path)) {
            return;
        }else if(!sys.FileSystem.isDirectory(path)) {
            trace("Tried to delete directory (" + path + ") which isn't a directory.");
            return;
        }

        for(e in sys.FileSystem.readDirectory(path)) {
            if(sys.FileSystem.isDirectory(path + "/" + e))
                removeDirectory(path + "/" + e);
            else sys.FileSystem.deleteFile(path + "/" + e);
        }

        sys.FileSystem.deleteDirectory(path + "/");
    }
}
