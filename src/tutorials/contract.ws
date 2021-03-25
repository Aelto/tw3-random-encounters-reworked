
function RER_tutorialTryShowContract(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialMonsterContract')) {
    return false;
  }

  RER_openPopup(
    GetLocStringByKey("rer_tutorial_contract_title"),
    GetLocStringByKey("rer_tutorial_contract_body")
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialMonsterContract', 0);

  theGame.SaveUserSettings();

  return true;
}