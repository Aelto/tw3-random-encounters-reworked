
function RER_tutorialTryShowClue(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialClueExamined')) {
    return false;
  }

  RER_openPopup(
    "RER Tutorial - Clue examined",
    "You just " + RER_yellowFont("examined") + " a track from the mod Random Encounters Reworked. " +
    "When you examine a track Geralt will tell what monster it is from, and if you " +
    "the trail you will eventually the creature who left them. " +
    "<br /> " +
    "Almost all creatures from the mod leave tracks on the ground. But be aware that " +
    "because RER uses voicelines from the game the creature you'll see may not " +
    "always correspond exactly to what Geralt said. But you can be sure the family " +
    "will always be the right one. For example Geralt never says NoonWraith and so " +
    "it will say NightWraith instead, but it's still a wraith so it's ok." +
    "<br /> " +
    "<br /> " +
    "Have fun!"
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialClueExamined', 0);

  theGame.SaveUserSettings();

  return true;
}