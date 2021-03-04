
// Lots of the code from this class was inspired by the Action Log mod from Wolfmark
// on Nexusmods. All credits go to him for finding how to do this stuff
class RER_PopupData extends BookPopupFeedback {

  public /* override */ function GetGFxData(parentFlashValueStorage : CScriptedFlashValueStorage) : CScriptedFlashObject {
		var objResult : CScriptedFlashObject;

		objResult = super.GetGFxData(parentFlashValueStorage);
		objResult.SetMemberFlashString("iconPath", "img://icons/inventory/scrolls/scroll2.dds");

		return objResult;
	}

  public /* override */ function SetupOverlayRef(target : CR4MenuPopup) : void {
		super.SetupOverlayRef(target);
		PopupRef.GetMenuFlash().GetChildFlashSprite("background").SetAlpha(100.0);
	}

}

function RER_openPopup(title: string, message: string) {
  var popup_data: RER_PopupData;
  // var id: SItemUniqueId;

  popup_data = new RER_PopupData in thePlayer;
  popup_data.SetMessageTitle( title );
  popup_data.SetMessageText( message );
  popup_data.PauseGame = true;

  popup_data.ScreenPosX = 1100.0 / 1920.0;
  popup_data.ScreenPosY = 155.0 / 1080.0;

  theGame.RequestMenu('PopupMenu', popup_data);
}