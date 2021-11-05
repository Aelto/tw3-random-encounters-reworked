
function RER_tutorialTryShowBounty(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialBountyHunting')) {
    return false;
  }

  if (!RER_openPopup(
    GetLocStringByKey("rer_tutorial_bounty_title"),
    GetLocStringByKey("rer_tutorial_bounty_body")
  )) {
    return;
  }

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialBountyHunting', 0);

  theGame.SaveUserSettings();

  return true;
}