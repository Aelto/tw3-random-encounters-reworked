
function RER_tutorialTryShowBounty(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialBountyHunting')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_bounty_title"),
    GetLocStringByKey("rer_tutorial_bounty_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialBountyHunting', 0);

  theGame.SaveUserSettings();

  return true;
}