// ----------------------------------------------------------------------------
// "UIView" -> "Controller" callback "interfaces"
abstract class IModUiViewCallback extends CObject {}

abstract class IModUiMenuCallback extends IModUiViewCallback {
    public function OnOpened() {}
    public function OnClosed() {}
}
// ----------------------------------------------------------------------------
