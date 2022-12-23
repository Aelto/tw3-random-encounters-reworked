// -----------------------------------------------------------------------------
//
// KNOWN BUGS:
//
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
struct SModUiCategorizedListItem {
    // order important for construct calls! do not change!
    var id: String;
    var caption: String;
    var cat1: String;
    var cat2: String;
    var cat3: String;
    // flag for ignoring by currently set filter
    var isWildcardMiss: bool;
}
struct SModUiFilteredListCatItem {
    var id: String;
    var item: SModUiListItem;
    var count: int;
    var total: int;
    var isOpen: bool;
    var entryPos: int;
}
// ----------------------------------------------------------------------------
abstract class CModUiFilteredList {
    protected var items: array<SModUiCategorizedListItem>;
    protected var selectedCat1: String;
    protected var selectedCat2: String;
    protected var selectedCat3: String;

    protected var wildcardFilter: String;
    // number of items available in filtered list
    protected var itemsMatching: int;

    protected var filteredList: array<SModUiListItem>;
    protected var selectedId: String;
    // ------------------------------------------------------------------------
    public function setSelection(id: String, optional openCategories: bool)
        : bool
    {
        var prefix: String;
        var catId: String;
        var i: int;

        if (StrBeginsWith(id, "CAT")) {
            prefix = StrLeft(id, 4);
            catId = StrMid(id, 4);

            switch (prefix) {
                case "CAT1":
                    selectedCat1 = catId;
                    selectedCat2 = "";
                    selectedCat3 = "";
                    break;

                case "CAT2":
                    selectedCat2 = catId;
                    selectedCat3 = "";
                    break;

                case "CAT3":
                    selectedCat3 = catId;
                    break;
            }

            return false;
        } else {
            // normal selection
            selectedId = id;
            if (openCategories) {
                // not pretty but no other option get categories..
                for (i = 0; i < items.Size(); i += 1) {
                    if (items[i].id == selectedId) {
                        selectedCat1 = items[i].cat1;
                        selectedCat2 = items[i].cat2;
                        selectedCat3 = items[i].cat3;
                    }
                }

            }
            return true;
        }
    }
    // ------------------------------------------------------------------------
    public function getWildcardFilter() : String  {
        return wildcardFilter;
    }
    // ------------------------------------------------------------------------
    public function setWildcardFilter(filter: String, optional ignoreCategories: bool)
    {
        var isMatch: bool;
        var firstMatchFound: bool;
        var i: int;

        wildcardFilter = filter;

        for (i = 0; i < items.Size(); i += 1) {
            if (!ignoreCategories) {
                isMatch = StrFindFirst(items[i].cat1, wildcardFilter) >= 0;
                isMatch = isMatch || StrFindFirst(items[i].cat2, wildcardFilter) >= 0;
                isMatch = isMatch || StrFindFirst(items[i].cat3, wildcardFilter) >= 0;
            }
            isMatch = isMatch || StrFindFirst(items[i].caption, wildcardFilter) >= 0;
            items[i].isWildcardMiss = !isMatch;

            // set selected categories from first match to open the categories
            if (!firstMatchFound && isMatch) {
                firstMatchFound = true;
                selectedCat1 = items[i].cat1;
                selectedCat2 = items[i].cat2;
                selectedCat3 = items[i].cat3;
            }
        }
    }
    // ------------------------------------------------------------------------
    public function resetWildcardFilter() {
        var i: int;

        for (i = 0; i < items.Size(); i += 1) {
            items[i].isWildcardMiss = false;
        }
        wildcardFilter = "";
    }
    // ------------------------------------------------------------------------
    public function clearLowestSelectedCategory() {
        if (selectedCat3 != "") {
            selectedCat3 = "";
        } else if (selectedCat2 != "") {
            selectedCat2 = "";
        } else if (selectedCat1 != "") {
            selectedCat1 = "";
        }
    }
    // ------------------------------------------------------------------------
    private function updateCatStats(
        out itemList: array<SModUiListItem>,
        out catData: SModUiFilteredListCatItem,
        optional isVisible: bool)
    {
        // check if category has an id or
        if (isVisible && catData.id != "") {
            if (catData.count != catData.total) {
                catData.item.suffix = " (" + IntToString(catData.count) + "/" + IntToString(catData.total) + ")";
            } else {
                catData.item.suffix = " (" + IntToString(catData.total) + ")";
            }
            if (catData.count > 0) {
                // overwrite categoryEntry with updated data
                itemList[catData.entryPos] = catData.item;
            } else {
                // filter is active -> remove empty categories
                // Note: stats are updated in the same run of the list
                // => deleting entryPos is ok (no change in total order)
                itemList.Erase(catData.entryPos);
            }
        }
    }
    // ------------------------------------------------------------------------
    private function addCategoryEntry(
        catPos: int,
        catId: String,
        selectedCatId: String,
        out itemList: array<SModUiListItem>,
        out indent: String,
        isVisible: bool) : SModUiFilteredListCatItem
    {
        var catData: SModUiFilteredListCatItem;

        if (isVisible) {
            catData.id = catId;
            catData.item = SModUiListItem("CAT" + IntToString(catPos) + catId, catId);

            if (catId == selectedCatId) {
                catData.item.prefix = indent + "-";
                catData.isOpen = true;
            } else {
                catData.item.prefix = indent + "+";
            }

            // empty categories == not categorized
            if (catId != "") {
                itemList.PushBack(catData.item);
                indent += "  ";
                // store position so stats can be updated
                catData.entryPos = itemList.Size() - 1;
            }
        }
        return catData;
    }
    // ------------------------------------------------------------------------
    public function getFilteredList() : array<SModUiListItem> {
        var item: SModUiCategorizedListItem;
        var itemList: array<SModUiListItem>;
        var i: int;
        var indent: String;

        // managing info about currently set categories
        var cat1: SModUiFilteredListCatItem;
        var cat2: SModUiFilteredListCatItem;
        var cat3: SModUiFilteredListCatItem;

        var isOpened: bool;
        var lastCategories: String;
        var itemCategories: String;
        var selectedCategories: String;

        itemsMatching = 0;

        // setup default none but open if there are no categories at all
        lastCategories = "||";
        isOpened = true;
        selectedCategories = selectedCat1 + "|" + selectedCat2 + "|" + selectedCat3;

        // will be increased by "  " in every category
        indent = "";
        for (i = 0; i < items.Size(); i += 1) {
            item = items[i];

            itemCategories = item.cat1 + "|" + item.cat2 + "|" + item.cat3;

            if (itemCategories != lastCategories) {
                // at least one category changed
                lastCategories = itemCategories;
                isOpened = itemCategories == selectedCategories;

                if (item.cat1 != cat1.id) {
                    // update stats in cat name
                    updateCatStats(itemList, cat1, true);
                    updateCatStats(itemList, cat2, cat1.isOpen);
                    updateCatStats(itemList, cat3, cat1.isOpen && cat2.isOpen);

                    // reset cat stats counter and add category to list
                    indent = "";
                    cat1 = addCategoryEntry(1, item.cat1, selectedCat1, itemList, indent, true);
                    cat2 = addCategoryEntry(2, item.cat2, selectedCat2, itemList, indent, cat1.isOpen);
                    cat3 = addCategoryEntry(3, item.cat3, selectedCat3, itemList, indent, cat1.isOpen && cat2.isOpen);

                } else if (item.cat2 != cat2.id) {
                    // update stats in cat name
                    updateCatStats(itemList, cat2, cat1.isOpen);
                    updateCatStats(itemList, cat3, cat1.isOpen && cat2.isOpen);

                    // reset cat stats counter and add category to list
                    indent = "  ";
                    cat2 = addCategoryEntry(2, item.cat2, selectedCat2, itemList, indent, cat1.isOpen);
                    cat3 = addCategoryEntry(3, item.cat3, selectedCat3, itemList, indent, cat1.isOpen && cat2.isOpen);
                } else if (item.cat3 != cat3.id) {
                    // update stats in cat name
                    updateCatStats(itemList, cat3, cat1.isOpen && cat2.isOpen);

                    // reset cat stats counter and add category to list
                    indent = "    ";
                    cat3 = addCategoryEntry(3, item.cat3, selectedCat3, itemList, indent, cat1.isOpen && cat2.isOpen);
                }
            }

            // add item if all of item categories are opened
            if (!item.isWildcardMiss) {
                if (isOpened) {
                    itemList.PushBack(SModUiListItem(
                        item.id, item.caption, item.id == selectedId, indent));
                }
                // count stats event if it is not visible for category stats
                cat1.count += 1;
                cat2.count += 1;
                cat3.count += 1;
                itemsMatching += 1;
            }
            cat1.total += 1;
            cat2.total += 1;
            cat3.total += 1;
        }
        // update stats of last category set
        updateCatStats(itemList, cat1, true);
        updateCatStats(itemList, cat2, cat1.isOpen);
        updateCatStats(itemList, cat3, cat1.isOpen && cat2.isOpen);

        return itemList;
    }
     // ------------------------------------------------------------------------
    public function getMatchingItemCount() : int {
        return itemsMatching;
    }
    // ------------------------------------------------------------------------
    public function getTotalCount() : int {
        return items.Size();
    }
    // ------------------------------------------------------------------------
    public function getPreviousId() : String {
        var prevMatchSlot: int;
        var i,j: int;

        prevMatchSlot = -1;

        for (i = 0; i < items.Size(); i += 1) {

            if (items[i].id == selectedId) {
                // if there is already a prev filter match return it
                if (prevMatchSlot >= 0) {
                    return items[prevMatchSlot].id;
                }
                // otherwise it's a wraparound: run from end of list to current
                // position and return first match
                for (j = items.Size() -1; j > i; j -= 1) {
                    if (!items[j].isWildcardMiss) {
                        return items[j].id;
                    }
                }
                // nothing found => return already selected
                return items[i].id;

            } else if (!items[i].isWildcardMiss) {
                prevMatchSlot = i;
            }
        }
        return "";
    }
    // ------------------------------------------------------------------------
    public function getNextId() : String {
        var nextMatchSlot: int;
        var i,j: int;

        nextMatchSlot = -1;

        // search backwards to save "next" match
        for (i = items.Size() -1; i >= 0; i -= 1) {

            if (items[i].id == selectedId) {

                if (nextMatchSlot >= 0) {
                    return items[nextMatchSlot].id;
                }
                // otherwise it's a wraparound: start from start to current
                // position and return first match
                for (j = 0; j < i; j += 1) {
                    if (!items[j].isWildcardMiss) {
                        return items[j].id;
                    }
                }
                // nothing found => return already selected
                return items[i].id;

            } else if (!items[i].isWildcardMiss) {
                nextMatchSlot = i;
            }
        }
        return "";
    }
    // ------------------------------------------------------------------------
}
// -----------------------------------------------------------------------------
