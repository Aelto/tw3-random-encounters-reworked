
function RER_tutorialTryShowAmbushed(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialAmbushed')) {
    return false;
  }

  if (!RER_openPopup(
    GetLocStringByKey("rer_tutorial_ambush_title"),
    GetLocStringByKey("rer_tutorial_ambush_body")
  )) {
    return false;
  }

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialAmbushed', 0);

  theGame.SaveUserSettings();

  return true;
}