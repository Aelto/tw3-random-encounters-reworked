
function RER_tutorialTryShowEcosystem(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialEcosystem')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_ecosystem_title"),
    GetLocStringByKey("rer_tutorial_ecosystem_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialEcosystem', 0);

  theGame.SaveUserSettings();

  return true;
}