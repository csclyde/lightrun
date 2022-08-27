package ui.comp;

typedef Option = {
    val:Dynamic,
    label:String,
    next:Option,
    prev:Option,
};

class OptionPicker extends Component {
    var optionText:Label;
    var prevOption:LabelButton;
    var nextOption:LabelButton;

    var options:Array<Option>;
    var get:() -> Dynamic;

    public function new(?parent, getter:() -> Dynamic, setter:(option:Dynamic) -> Void, opt:Map<String, Dynamic>) {
        super(parent);

        layout = Horizontal;
        get = getter;
        onChange = setter;

        options = [];

        for(key => value in opt) {
            options.push({
                val: value,
                label: key,
                prev: null,
                next: null,
            });
        }

        var prevOpt = options[options.length - 1];
        for(o in options) {
            o.prev = prevOpt;
            o.prev.next = o;
            prevOpt = o;
        }

        prevOption = new LabelButton(this, '<', Assets.magicBookFont);
        prevOption.onClick = function() {
            var newVal = null;
            for(o in options) {
                if(get() == o.val) {
                    newVal = o.prev.val;
                }
            }

            onChange(newVal);
            optionText.label = getLabel();
        }

        optionText = new Label(this, getLabel(), Assets.magicBookFont);
        optionText.minWidth = 100;

        nextOption = new LabelButton(this, '>', Assets.magicBookFont);
        nextOption.onClick = function() {
            var newVal = null;

            for(o in options) {
                if(get() == o.val) {
                    newVal = o.next.val;
                }
            }

            onChange(newVal);
            optionText.label = getLabel();
        }
    }

    function getLabel() {
        for(o in options) {
            if(get() == o.val) {
                return o.label;
            }
        }

        return 'Missing Value';
    }

    public dynamic function onChange(option:Dynamic) {}
}
