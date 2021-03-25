
function RER_tutorialTryShowNoticeboard(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialMonsterContract')) {
    return false;
  }

  RER_openPopup(
    GetLocStringByKey("rer_tutorial_noticeboard_event_title"),
    GetLocStringByKey("rer_tutorial_noticeboard_event_body")
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialMonsterContract', 0);

  theGame.SaveUserSettings();

  return true;
}