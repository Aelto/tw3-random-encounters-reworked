
function RER_tutorialTryShowNoticeboard(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialNoticeboardEvent')) {
    return false;
  }

  RER_openPopup(
    GetLocStringByKey("rer_tutorial_noticeboard_event_title"),
    GetLocStringByKey("rer_tutorial_noticeboard_event_body")
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialNoticeboardEvent', 0);

  theGame.SaveUserSettings();

  return true;
}