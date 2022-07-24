
function RER_tutorialTryShowAmbushed(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialAmbushed')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_ambush_title"),
    GetLocStringByKey("rer_tutorial_ambush_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialAmbushed', 0);

  theGame.SaveUserSettings();

  return true;
}