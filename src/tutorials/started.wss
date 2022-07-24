
function RER_tutorialTryShowStarted(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialStarted')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_started_title"),
    GetLocStringByKey("rer_tutorial_started_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialStarted', 0);

  theGame.SaveUserSettings();

  return true;
}