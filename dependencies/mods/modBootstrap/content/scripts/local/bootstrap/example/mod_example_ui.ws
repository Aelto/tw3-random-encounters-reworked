
function modCreate_UiExampleMod() : CMod {
    // do nothing besides creating and returning of mod class!
    return new CModUiExampleMod in thePlayer;
}

// ----------------------------------------------------------------------------
class CModUiExampleList extends CModUiFilteredList {

    public function initList() {
        items.Clear();
        items.PushBack(SModUiCategorizedListItem("someId1", "caption 1", "catA", "sub-cat1", "subsub-cat1"));
        items.PushBack(SModUiCategorizedListItem("someId2", "caption 2", "catA", "sub-cat1", ""));
        items.PushBack(SModUiCategorizedListItem("someId3", "caption 3", "catA", "sub-cat2", ""));
        items.PushBack(SModUiCategorizedListItem("someId4", "caption 4", "catB", "sub-catX", "subsub-catY"));
        items.PushBack(SModUiCategorizedListItem("someId5", "caption 5", "catB", "sub-catX", "subsub-catY"));
        items.PushBack(SModUiCategorizedListItem("someId6", "caption 6", "catB", "sub-catX", "subsub-catZ"));
        items.PushBack(SModUiCategorizedListItem("someId7", "caption 7", "catB", "", ""));
        items.PushBack(SModUiCategorizedListItem("someId8", "caption 8", "catC", "", ""));
        items.PushBack(SModUiCategorizedListItem("someId9", "caption 9", "catC", "", ""));
        items.PushBack(SModUiCategorizedListItem("someId10", "caption 10", "", "", ""));
    }

}
// ----------------------------------------------------------------------------
// callback for generic ui list which will call example mod back
class CModUiExampleListCallback extends IModUiEditableListCallback {
    public var callback: CModUiExampleMod;

    public function OnOpened() { callback.OnUpdateView(); }

    public function OnInputEnd(inputString: String) { callback.OnInputEnd(inputString); }

    public function OnInputCancel() { callback.OnInputCancel(); }

    public function OnClosed() { delete listMenuRef; }

    public function OnSelected(optionName: String) { callback.OnSelected(optionName); }
}
// ----------------------------------------------------------------------------
statemachine class CModUiExampleMod extends CMod {
    default modName = 'UiExampleMod';
    default modAuthor = "unknown";
    default modUrl = "http://www.nexusmods.com/witcher3/mods/????/";
    default modVersion = '0.1';

    default logLevel = MLOG_DEBUG;

    protected var view: CModUiExampleListCallback;

    protected var listProvider: CModUiExampleList;

    // ------------------------------------------------------------------------
    public function init() {
        super.init();

        // DO STUFF

        // prepare view callback wiring and set labels
        view = new CModUiExampleListCallback in this;
        view.callback = this;
        view.title = "My Listview Title";   // title currently unused (missing swf element for now)
        view.statsLabel = "Example Items";  // used for showing number of seen elements

        // load example data into list provider
        listProvider = new CModUiExampleList in this;
        listProvider.initList();

        // simple dummy hotkey binding for menu (reusing vanilla actions just for this example)
        // bind some other keys to test properly...
        // for a sane usage a new inputcontext should be started when menu is
        // opened and restored after it is closed
        // selection works either with mouse or space/enter
        theInput.RegisterListener(this, 'OnOpenMenu', 'SteelSword');
        theInput.RegisterListener(this, 'OnFilter', 'SilverSword');
        theInput.RegisterListener(this, 'OnResetFilter', 'SelectAard');
        theInput.RegisterListener(this, 'OnCategoryUp', 'SelectYrden');
    }
    // ------------------------------------------------------------------------
    // called by user action to open menu
    event OnOpenMenu(action: SInputAction) {
        // open only on action start
        if (IsPressed(action)) {
            theGame.RequestMenu('ListView', view);
        }
    }

    // called by user action to start filter input
    event OnFilter(action: SInputAction) {
        if (!view.listMenuRef.isEditActive() && IsPressed(action)) {

            view.listMenuRef.startInputMode(
                //GetLocStringByKeyExt("MyModFilter"),
                "Filter List",
                listProvider.getWildcardFilter());
        }
    }

    // called by user action to reset currently set filter
    event OnResetFilter() {
        listProvider.resetWildcardFilter();
        view.listMenuRef.resetEditField();

        updateView();
    }

    // called by user action to go one opened category up
    event OnCategoryUp(action: SInputAction) {
        if (IsPressed(action)) {
            listProvider.clearLowestSelectedCategory();
            updateView();
        }
    }
    // ------------------------------------------------------------------------
    // -- called by listview
    // called if user exits edit mode in list
    event OnInputCancel() {
        theGame.GetGuiManager().ShowNotification("edit canceled");

        view.listMenuRef.resetEditField();
        updateView();
    }

    // called when user ends edit (return pressed)
    event OnInputEnd(inputString: String) {
        if (inputString == "") {
            OnResetFilter();
        } else {
            // Note: filter field is not removed to indicate the current filter
            listProvider.setWildcardFilter(inputString);
            updateView();
        }
    }

    // called when list item was selected
    event OnSelected(listItemId: String) {
        // listprovider opens a category if a category was selected otherwise
        // returns true (meaning a "real" item was selected)
        if (listProvider.setSelection(listItemId, true)) {
            theGame.GetGuiManager().ShowNotification("selected ID " + listItemId);
        }
        updateView();
    }

    // called when list menu opens first time
    event OnUpdateView() {
        var wildcard: String;
        // Note: if search filter is active show the wildcard to indicate the
        // current filter
        wildcard = listProvider.getWildcardFilter();
        if (wildcard != "") {
            view.listMenuRef.setInputFieldData(
                //GetLocStringByKeyExt("MyModFilter"),
                "Filter List",
                wildcard);
        }
        updateView();
    }
    // ------------------------------------------------------------------------
    protected function updateView() {
        // set updated list data and render in listview
        view.listMenuRef.setListData(
            listProvider.getFilteredList(),
            listProvider.getMatchingItemCount(),
            // number of items without filtering
            listProvider.getTotalCount());

        view.listMenuRef.updateView();
    }
}
// ----------------------------------------------------------------------------
