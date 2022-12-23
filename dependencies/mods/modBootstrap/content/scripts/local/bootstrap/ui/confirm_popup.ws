// ----------------------------------------------------------------------------
//
// KNOWN BUGS:
//
// ----------------------------------------------------------------------------
// "UIView" -> "Controller" callback "interface"
abstract class IModUiConfirmPopupCallback extends IModUiViewCallback {
    public function OnConfirmed(actionId: String) {}
}
// ----------------------------------------------------------------------------
class CModUiActionConfirmation extends ConfirmationPopupData {
    private var callerRef: IModUiConfirmPopupCallback;
    private var actionId: String;

    public function open(
        caller: IModUiConfirmPopupCallback, title: String, msg: String, action: String)
    {
        this.callerRef = caller;
        this.actionId = action;
        this.SetMessageTitle(title);
        this.SetMessageText(msg);
        this.BlurBackground = true;

        theGame.RequestMenu('PopupMenu', this);
    }

    protected function OnUserAccept() : void {
        super.OnUserAccept();
        callerRef.OnConfirmed(actionId);
    }
}
// ----------------------------------------------------------------------------
