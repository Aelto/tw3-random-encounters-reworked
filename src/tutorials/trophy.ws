
function RER_tutorialTryShowTrophy(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialTrophy')) {
    return false;
  }

  RER_openPopup(
    "RER Tutorial - Rewards",
    "You just found a " + RER_yellowFont("Trophy") + " from the mod " +
    "Random Encounters Reworked. These trophies were created only to reward Geralt " +
    "for the creatures he hunts and do not have any purpose but to be sold. " +
    "<br />" +
    "Creatures from the mod also drop a few crowns for the same purpose. If you " +
    "do not like the rewards or would like to change how many you find you can do " +
    "so in the " + RER_yellowFont("Rewards System") + " menu specifically made for it."
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialTrophy', 0);

  theGame.SaveUserSettings();

  return true;
}