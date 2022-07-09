
function RER_tutorialTryShowNoticeboard(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialNoticeboardEvent')) {
    return false;
  }

  RER_toggleHUD();
  NTUTO(
    GetLocStringByKey("rer_tutorial_noticeboard_event_title"),
    GetLocStringByKey("rer_tutorial_noticeboard_event_body")
  );
  RER_toggleHUD();

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialNoticeboardEvent', 0);

  theGame.SaveUserSettings();

  return true;
}