
function RER_tutorialTryShowAmbushed(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialAmbushed')) {
    return false;
  }

  RER_openPopup(
    GetLocStringByKey("rer_tutorial_ambush_title"),
    GetLocStringByKey("rer_tutorial_ambush_body")
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialAmbushed', 0);

  theGame.SaveUserSettings();

  return true;
}