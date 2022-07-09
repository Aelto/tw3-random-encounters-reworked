
function RER_tutorialTryShowContract(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialMonsterContract')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_contract_title"),
    GetLocStringByKey("rer_tutorial_contract_body")
  );
  RER_toggleHUD();


  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialMonsterContract', 0);

  theGame.SaveUserSettings();

  return true;
}