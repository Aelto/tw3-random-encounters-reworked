
function RER_tutorialTryShowNoticeboard(): bool {
  if (theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialMonsterContract')) {
    return false;
  }

  RER_openPopup(
    "RER Tutorial - Noticeboard event",
    "A " + RER_yellowFont("Noticeboard Event") + "from the mod Random Encounters Reworked " +
    "has just started. When you'll close the window, a camera scene will play and Geralt will " +
    "say a few lines. After that the mod will wait for you to leave the settlement or the city " +
    "you're in, and once you far enough a " + RER_yellowFont("Monster Contract") + " will start " +
    "based on the path you walked."
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialMonsterContract', 0);

  theGame.SaveUserSettings();

  return true;
}