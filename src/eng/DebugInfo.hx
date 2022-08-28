package eng;

import hxd.Timer;
import echo.util.Debug.HeapsDebug;

class DebugInfo extends Process {
    var debugText:h2d.Text;
    var sceneText:h2d.Text;

    public var physDebug:HeapsDebug;
    public var physDebugLayer:h2d.Object;
    public var canvas:h2d.Graphics;

    public var fpsHistory:Array<Float>;
    public var usageHistory:Array<Float>;

    public function new(p:Process) {
        super(p);

        createRoot();

        fpsHistory = [];
        usageHistory = [];
        debugText = new h2d.Text(Assets.fontTiny);
        sceneText = new h2d.Text(Assets.fontTiny);
        canvas = new h2d.Graphics(root);
    }

    override function init() {
        parent.root.add(root, Const.DEBUG_DATA);

        debugText.name = 'DEBUG_TEXT';
        debugText.text = "60 FPS";
        debugText.textAlign = Left;
        debugText.x = 10;
        debugText.y = 230;
        root.add(debugText, Const.DEBUG_DATA);

        sceneText.name = 'SCENE_TEXT';
        sceneText.text = "";
        sceneText.textAlign = Left;
        sceneText.x = 1600;
        sceneText.y = 5;
        root.add(sceneText, Const.DEBUG_DATA);

        physDebugLayer = new h2d.Object();
        physDebugLayer.name = 'phys_debug';
        world.scene.add(physDebugLayer, Const.DEBUG_DATA);
        physDebug = new HeapsDebug(physDebugLayer);
        physDebug.draw_quadtree = true;
        //physDebug.draw_world_bounds = true;
    }

    override function reset() {}

    override function update() {
        fpsHistory.unshift(1 / Timer.elapsedTime);
        usageHistory.unshift(Timer.elapsedTime / (1 / 60));

        if(fpsHistory.length > 300) {
            fpsHistory.pop();
        }

        if(usageHistory.length > 300) {
            usageHistory.pop();
        }
    }

    override function fixedUpdate() {
        root.visible = Process.PROFILING;
        physDebugLayer.visible = Process.PROFILING;

        if(Process.PROFILING) {
            physDebug.draw(world.physWorld);

            canvas.clear();
            drawFpsChart(10, 10, fpsHistory);
            drawUsageChart(10, 120, usageHistory);

            var avgET = 0.0;
            for(t in usageHistory) avgET += t;
            avgET /= usageHistory.length;

            var avgFPS = 0.0;
            for(t in fpsHistory) avgFPS += t;
            avgFPS /= fpsHistory.length;

            var readout = '';

            readout += 'Average FPS: ' + avgFPS + '\n';
            readout += 'Average usage: ' + avgET + '\n';

            readout += '-- ENGINE --\n';

            readout += engine.drawCalls + ' draw calls \n';

            var stats = engine.mem.stats();

            readout += Math.floor(stats.totalMemory / 1000000) + 'MB total memory used \n';
            readout += Math.floor(stats.textureMemory / 1000000) + 'MB texture memory used \n';
            readout += stats.textureCount + ' texture count \n';
            readout += stats.bufferCount + ' buffer count \n\n';

            readout += '-- ENTITIES --\n';

            readout += Entity.ALL.length + ' entities \n';
            readout += Entity.AllActive().length + ' active \n';
            if(world.currentLevel != null) {
                readout += world.currentLevel.roomCollision.length + ' level \n';
            }
            readout += 'Player Pos: ' + Math.floor(world.player.cx) + ', ' + Math.floor(world.player.cy) + '\n';

            var typeKey:Map<String, Int> = [];

            for(e in Entity.AllActive()) {
                if(e.type == null) {
                    e.type = Type.getClass(e) + "";
                }

                var key = e.type;
                if(typeKey[key] == null) {
                    typeKey[key] = 1;
                }else {
                    typeKey[key] += 1;
                }
            }

            for(type in typeKey.keys()) {
                readout += '- ' + type + ': ' + typeKey[type] + '\n';
            }

            readout += '\n';

            readout += '-- PHYSICS --\n';
            readout += world.physWorld.dynamics().length + ' dynamic bodies\n';
            readout += world.physWorld.statics().length + ' static bodies\n\n';

            readout += '-- PROFILING --\n';

            for(p in Process.getSortedProfilerTimes().slice(0, 4)) {
                var perFrame:Float = (p.value / et);
                perFrame = Math.floor(perFrame * 1000);

                if(perFrame > 0.1) {
                    readout += p.key + ': ' + perFrame + 'ms \n';
                }
            }

            readout += '\n';
            debugText.text = readout;
        }
    }

    function drawFpsChart(x:Float, y:Float, data:Array<Float>) {
        canvas.lineStyle(2, 0xFFFFFF);
        canvas.moveTo(x, y);
        canvas.lineTo(x, y + 100);
        canvas.lineTo(x + 600, y + 100);

        canvas.lineStyle(1, 0xFF0000);
        canvas.moveTo(x, y + 50);
        canvas.lineTo(x + 600, y + 50);

        canvas.lineStyle(1, 0x00FF00);
        canvas.moveTo(x, y);
        canvas.lineTo(x + 600, y);

        var marker = x + 1;
        canvas.lineStyle(1, 0x0000FF, 0.7);

        for(d in data) {
            if(d < 40) {
                canvas.lineStyle(1, 0xFF0000, 0.7);
            }else {
                canvas.lineStyle(1, 0x0000FF, 0.7);
            }

            var itemHeight = Util.clamp(d * (50 / 60), 0, 100);

            canvas.moveTo(marker, y + 99);
            canvas.lineTo(marker, y + 99 - itemHeight);
            marker += 2;
        }
    }

    function drawUsageChart(x:Float, y:Float, data:Array<Float>) {
        canvas.lineStyle(2, 0xFFFFFF);
        canvas.moveTo(x, y);
        canvas.lineTo(x, y + 100);
        canvas.lineTo(x + 600, y + 100);

        canvas.lineStyle(1, 0xFF0000);
        canvas.moveTo(x, y + 50);
        canvas.lineTo(x + 600, y + 50);

        canvas.lineStyle(1, 0x00FF00);
        canvas.moveTo(x, y);
        canvas.lineTo(x + 600, y);

        var marker = x + 1;
        canvas.lineStyle(1, 0x0000FF, 0.7);

        for(d in data) {
            if(d > 0.5) {
                canvas.lineStyle(1, 0xFF0000, 0.7);
            }else {
                canvas.lineStyle(1, 0x0000FF, 0.7);
            }

            var itemHeight = Util.clamp(d * 50, 0, 100);

            canvas.moveTo(marker, y + 99);
            canvas.lineTo(marker, y + 99 - itemHeight);
            marker += 2;
        }
    }

    public function compileScene() {
        sceneText.text = getSceneText(App.inst.s2d, 0);
    }

    function getSceneText(obj:h2d.Object, level:Int) {
        var txt = '';

        if(obj.visible) {
            for(i in 0...obj.numChildren) {
                var childObj = obj.getChildAt(i);

                for(j in 0...level) {
                    txt += ' -';
                }

                txt += ' ' + childObj.name + ': ' + Type.getClass(childObj) + '\n';

                txt += getSceneText(childObj, level + 1);
            }
        }

        return txt;
    }
}
