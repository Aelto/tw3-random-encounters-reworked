
function RER_tutorialTryShowStarted(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialStarted')) {
    return false;
  }

  RER_openPopup(
    GetLocStringByKey("rer_tutorial_started_title"),
    GetLocStringByKey("rer_tutorial_started_body")
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialStarted', 0);

  theGame.SaveUserSettings();

  return true;
}