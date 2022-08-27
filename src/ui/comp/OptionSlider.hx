package ui.comp;

class OptionSlider extends Component {
    var valueText:Label;
    var reduce:LabelButton;
    var increase:LabelButton;

    var max:Float;

    var get:() -> Dynamic;

    public function new(?parent, getter:() -> Dynamic, setter:(option:Dynamic) -> Void, m:Float) {
        super(parent);

        layout = Horizontal;
        get = getter;
        onChange = setter;
        max = m;

        reduce = new LabelButton(this, '<', Assets.magicBookFont);
        reduce.onClick = function() {
            var decVal = ((get() * 10) - 1) / 10;
            var newVal = Math.max(0, decVal);

            onChange(newVal);
            valueText.label = getValueText();
        }

        valueText = new Label(this, getValueText(), Assets.magicBookFont);
        valueText.minWidth = 100;

        increase = new LabelButton(this, '>', Assets.magicBookFont);
        increase.onClick = function() {
            var incVal = ((get() * 10) + 1) / 10;
            var newVal = Math.min(max, incVal);

            onChange(newVal);
            valueText.label = getValueText();
        }
    }

    function getValueText() {
        return Math.floor(get() * 100) + '%';
    }

    public dynamic function onChange(option:Dynamic) {}
}
