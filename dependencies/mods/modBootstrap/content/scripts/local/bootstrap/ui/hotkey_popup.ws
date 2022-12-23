// ----------------------------------------------------------------------------
//
// KNOWN BUGS:
//  - many hotkeys -> popup window frame/size freaks out
//
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
struct SModUiHotkeyHelp {
    var action: CName;
    var help: String;
    var keys: array<EInputKey>;
}
function HotkeyHelp_from(action: CName, optional helpKey: String, optional key1: EInputKey, optional key2: EInputKey) : SModUiHotkeyHelp {
    var hotkey: SModUiHotkeyHelp;
    var null: EInputKey;

    hotkey.action = action;
    if (helpKey != "") {
        hotkey.help = GetLocStringByKeyExt(helpKey);
    } else {
        hotkey.help = GetLocStringByKeyExt(action);
    }
    if (key1 != null) {
        hotkey.keys.PushBack(key1);
    }
    if (key2 != null) {
        hotkey.keys.PushBack(key2);
    }

    return hotkey;
}

class CModUiHotkeyHelp extends W3MessagePopupData {
    // ------------------------------------------------------------------------
    private function getIconForKey(inputKey: EInputKey) : String {
        var key: String;
        // FIX F-Keys
        switch (inputKey) {
            case IK_F1: key = "F1"; break;
            case IK_F2: key = "F2"; break;
            case IK_F3: key = "F3"; break;
            case IK_F4: key = "F4"; break;
            case IK_F5: key = "F5"; break;
            case IK_F6: key = "F6"; break;
            case IK_F7: key = "F7"; break;
            case IK_F8: key = "F8"; break;
            case IK_F9: key = "F9"; break;
            case IK_F10: key = "F10"; break;
            case IK_F11: key = "F11"; break;
            case IK_F12: key = "F12"; break;

            case IK_MouseX: key = "Mouse X"; break;
            case IK_MouseY: key = "Mouse Y"; break;
            case IK_LeftMouse: key = "Mouse LB"; break;
            case IK_RightMouse: key = "Mouse RB"; break;

            default:
                return GetIconForKey(inputKey, true);
        }
        return " [<font color=\"#CD7D03\">" + key + "</font>] ";
    }
    // ------------------------------------------------------------------------
    public function open(titleKey: String, introText: String, hotkeyHelp: array<SModUiHotkeyHelp>)
    {
        var msg: String;
        var i, k: int;
        var hotkey: SModUiHotkeyHelp;
        var keys: array<EInputKey>;

        msg = "<p align=\"left\">" + introText + "</p><p align=\"left\">";

        for (i = 0; i < hotkeyHelp.Size(); i += 1) {
            hotkey = hotkeyHelp[i];

            keys.Clear();
            if (hotkey.keys.Size() > 0) {
                keys = hotkey.keys;
            } else {
                theInput.GetCurrentKeysForActionStr(NameToString(hotkey.action), keys);
            }

            // if no key is returned this action is not used in *any* context
            if (keys.Size() > 0) {
                for (k = 0; k < keys.Size(); k += 1) {
                    msg += this.getIconForKey(keys[k]);
                }
                msg += ": " + hotkey.help + "<br>";
            }
        }
        msg += "</p>";

        theGame.GetGuiManager().ShowUserDialogAdv(0, titleKey, msg, false, UDB_Ok);
    }
    // ------------------------------------------------------------------------
}
// ----------------------------------------------------------------------------
