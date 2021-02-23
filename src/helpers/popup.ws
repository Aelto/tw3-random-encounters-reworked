
function RER_openPopup(title: string, message: string) {
  var popup_data: BookPopupFeedback;
  var id: SItemUniqueId;

  popup_data = new BookPopupFeedback in thePlayer;
  popup_data.SetMessageTitle( "Surrounding ecosystem" );
  popup_data.SetMessageText( message );
  popup_data.curInventory = thePlayer.GetInventory();
  popup_data.PauseGame = true;
  popup_data.bookItemId = id;
        
    theGame.RequestMenu('PopupMenu', popup_data);
}