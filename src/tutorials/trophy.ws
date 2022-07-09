
function RER_tutorialTryShowTrophy(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialTrophy')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_rewards_title"),
    GetLocStringByKey("rer_tutorial_rewards_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialTrophy', 0);

  theGame.SaveUserSettings();

  return true;
}