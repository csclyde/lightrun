package ui;

import ui.comp.LabelButton;
import eng.ControlScheme.Control;

class KeyBind extends LabelButton {
    var control:Control;
    var waiting:Bool;

    var resetBind:ui.comp.LabelButton;

    public function new(?parent, c:Control) {
        waiting = false;
        super(parent, '', Assets.magicBookFont);

        control = c;

        resetBind = new LabelButton(this, '   (Reset)', Assets.magicBookFont);
        resetBind.setScale(0.5);
        resetBind.onClick = () -> {
            control.input = null;
            refresh();
            Events.send('save_settings');
        }

        refresh();

        layout = Horizontal;

        Events.subscribe('rebind', rebindKey);
    }

    public override function onClick() {
        waiting = true;
        label = 'Waiting...';
        Events.send('await_rebind');
    }

    override function refresh() {
        var controlName = Key.getKeyName(control.input != null ? control.input : control.defaultInput);
        label = controlName;
        if(control.input != null) {
            resetBind.visible = true;
        }else {
            resetBind.visible = false;
        }
    }

    function rebindKey(p) {
        if(waiting) {
            if(p.key == control.defaultInput) {
                control.input = null;
            }else {
                control.input = p.key;
            }

            refresh();
            Events.send('save_settings');
            Events.send('finish_rebind');
            waiting = false;
        }
    }
}
