
function RER_tutorialTryShowBountyMaster(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialBountyMaster')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_bounty_master_title"),
    GetLocStringByKey("rer_tutorial_bounty_master_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialBountyMaster', 0);

  theGame.SaveUserSettings();

  return true;
}