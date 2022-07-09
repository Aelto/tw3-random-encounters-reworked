
function displayRandomEncounterEnabledNotification() {
  theGame
  .GetGuiManager()
  .ShowNotification(
    GetLocStringByKey("option_rer_enabled")
  );
}

function displayRandomEncounterDisabledNotification() {
  theGame
  .GetGuiManager()
  .ShowNotification(
    GetLocStringByKey("option_rer_disabled")
  );
}

function NDEBUG(message: string, optional duration: float) {
  theGame
  .GetGuiManager()
  .ShowNotification(message, duration);
}

function NHUD(message: string) {
  thePlayer.DisplayHudMessage(message);
}

function NLOG(message: string) {
  LogChannel('RER', message);
}

function NTUTO(title: string, body: string) {
  var tut: W3TutorialPopupData;

  tut = new W3TutorialPopupData in thePlayer;

  tut.managerRef = theGame.GetTutorialSystem();
  tut.messageTitle = title;
  tut.messageText = body;

  // You can even add images if you want, i didn't test it however
  // tut.imagePath = tutorialEntry.GetImagePath();

  tut.enableGlossoryLink = false;
  tut.autosize = true;
  tut.blockInput = true;
  tut.pauseGame = true;
  tut.fullscreen = true;
  tut.canBeShownInMenus = true;

  tut.duration = -1; // input
  tut.posX = 0;
  tut.posY = 0;
  tut.enableAcceptButton = true;
  tut.blockInput = true;
  tut.fullscreen = true;

  theGame.GetTutorialSystem().ShowTutorialHint(tut);
}
