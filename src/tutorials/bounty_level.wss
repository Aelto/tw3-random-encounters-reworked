
function RER_tutorialTryShowBountyLevel(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialBountyLevel')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_bounty_level_title"),
    GetLocStringByKey("rer_tutorial_bounty_level_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialBountyLevel', 0);

  theGame.SaveUserSettings();

  return true;
}