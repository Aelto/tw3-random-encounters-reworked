
function RER_tutorialTryShowStarted(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialStarted')) {
    return false;
  }

  if (!RER_openPopup(
    GetLocStringByKey("rer_tutorial_started_title"),
    GetLocStringByKey("rer_tutorial_started_body")
  )) {
    return;
  }

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialStarted', 0);

  theGame.SaveUserSettings();

  return true;
}