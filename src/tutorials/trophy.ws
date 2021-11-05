
function RER_tutorialTryShowTrophy(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialTrophy')) {
    return false;
  }

  if (!RER_openPopup(
    GetLocStringByKey("rer_tutorial_rewards_title"),
    GetLocStringByKey("rer_tutorial_rewards_body")
  )) {
    return false;
  }

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialTrophy', 0);

  theGame.SaveUserSettings();

  return true;
}