package ui;

import h2d.Flow;
import ui.comp.*;

class FeedbackPanel extends h2d.Flow {
    var textBox:TextBox;
    var errorText:h2d.Text;

    public function new(?parent) {
        super(parent);

        // background filling the screen, greying things out
        visible = false;
        fillWidth = true;
        fillHeight = true;
        enableInteractive = true;
        backgroundTile = h2d.Tile.fromColor(0x000000);
        background.alpha = 0.9;
        borderWidth = 15;
        borderHeight = 15;
        padding = 100;
        layout = Vertical;
        verticalAlign = Top;
        horizontalAlign = Middle;

        interactive.onClick = (_) -> Events.send('toggle_feedback');

        // the feedback dialog box itself
        var panel = new h2d.Flow(this);
        panel.backgroundTile = hxd.Res.sprites.Art.get('select4');
        panel.borderWidth = 8;
        panel.borderHeight = 8;
        panel.layout = Vertical;
        panel.horizontalAlign = Middle;
        panel.enableInteractive = true;
        panel.padding = 20;
        panel.verticalSpacing = 20;

        // dialog title
        var label = new h2d.Text(Assets.fontMedium, panel);
        label.text = 'Submit Feedback';

        // text input
        textBox = new TextBox(panel, "Enter feedback here.");
        textBox.maxWidth = 400;
        textBox.minWidth = 400;
        textBox.max = 500;

        var instructionText = new h2d.Text(Assets.fontSmall, panel);
        instructionText.text = 'To submit, choose one:';

        var submits = new h2d.Flow(panel);
        submits.horizontalSpacing = 30;

        var noPain = new FeedbackButton(submits, 'No Pain', 'satisfaction0000');
        noPain.onClick = () -> submitFeedback(4);

        var mildPain = new FeedbackButton(submits, 'Mild Pain', 'satisfaction0001');
        mildPain.onClick = () -> submitFeedback(3);

        var badPain = new FeedbackButton(submits, 'Bad Pain', 'satisfaction0002');
        badPain.onClick = () -> submitFeedback(2);

        var horriblePain = new FeedbackButton(submits, 'Unspeakable Pain', 'satisfaction0003');
        horriblePain.onClick = () -> submitFeedback(1);

        errorText = new h2d.Text(Assets.fontSmall, panel);
        errorText.color.g = 0;
        errorText.color.b = 0;
        errorText.text = '';
        errorText.visible = false;
    }

    public function reset() {
        errorText.visible = false;
        errorText.text = '';
        textBox.reset();
    }

    public function resize() {}

    public function submitFeedback(s:Int) {
        if(textBox.text == '' || textBox.text == textBox.placeholder) {
            errorText.text = 'Please... enter a message before submitting.';
            errorText.visible = true;
            return;
        }else {
            errorText.text = '';
            errorText.visible = false;
        }

        Analytics.sendFeedback(s, textBox.text);
        Events.send('toggle_feedback');
    }

    public function toggle() {
        this.visible = !this.visible;

        if(this.visible) {
            refresh();
        }else {
            reset();
        }
    }

    public function refresh() {}
}
