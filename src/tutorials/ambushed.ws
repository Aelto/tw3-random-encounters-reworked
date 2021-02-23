
function RER_tutorialTryShowAmbushed(): bool {
  if (theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialAmbushed')) {
    return false;
  }

  RER_openPopup(
    "RER Tutorial - Ambushed",
    "You are being " + RER_yellowFont("Ambushed") + " by monsters or bandits from " +
    "the mod Random Encounters Reworked. Fight in an attempt to survive the ambush " +
    "you will be rewarded by trophies and crowns. " +
    "<br />" +
    "<br />" +
    "If you don't like being ambushed, you can change the amount of ambushes " +
    "created by the mod and also control exactly what kind of creature you will " +
    "see from them in the " + RER_yellowFont("Encounter System") + "menu and the " +
    "sub-menus for ambushes. " +
    "<br />" +
    "<br />" +
    "Good luck!"
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialAmbushed', 0);

  theGame.SaveUserSettings();

  return true;
}