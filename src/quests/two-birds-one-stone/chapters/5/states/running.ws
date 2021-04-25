state Running in RER_Q1_chapter5 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Running_main();
  }


  entry function Running_main() {
    var entity: CEntity;

    entity = theGame.GetEntityByTag('RER_Q1_chapter4_troll');

    this.waitForPlayerToReachPoint(
      ((RER_quest1)parent.quest_entry).constants.chapter_4_trail_position_end,
      10
    );

    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_offsod_or_throw_in_soup in thePlayer, false)
    .play((CNewNPC)entity);

    this.waitForPlayerToReachPoint(
      ((RER_quest1)parent.quest_entry).constants.chapter_4_trail_position_end,
      4
    );

    this.playDialogChoice();
  }

  latent function playDialogChoice() {
    var choices: array<SSceneChoice>;
    var response: SSceneChoice;
    var actions_picked: int;

    choices.PushBack(SSceneChoice(
      "I want to talk",
      true,
      false,
      false,
      DialogAction_MONSTERCONTRACT,
      'WantToTalk'
    ));

    choices.PushBack(SSceneChoice(
      "Can't let you get away with this",
      false,
      false,
      false,
      DialogAction_GETBACK,
      'CloseDialogFight'
    ));

    response = SU_setDialogChoicesAndWaitForResponse(choices);
    SU_closeDialogChoiceInterface();

    if (response.playGoChunk == 'WantToTalk') {
      (new RER_RandomDialogBuilder in thePlayer).start()
      .dialog(new REROL_wait_i_wanna_talk in thePlayer, true)
      .play();

      choices.Clear();
    }

    if (response.playGoChunk == 'CloseDialogFight') {
      return;
    }
  }
}