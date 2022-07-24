
function RER_tutorialTryShowClue(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialClueExamined')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_clue_title"),
    GetLocStringByKey("rer_tutorial_clue_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialClueExamined', 0);

  theGame.SaveUserSettings();

  return true;
}