state Running in RER_Q1_chapter3 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Running_main();
  }


  entry function Running_main() {
    var interactive_point: SU_InteractivePoint;
    var position: Vector;
    var template: CEntityTemplate;

    template = (CEntityTemplate)LoadResourceAsync(
      "dlc\dlcsharedutils\data\su_interactive_point.w2ent",
      true
    );

    position = ((RER_quest1)parent.quest_entry)
      .constants
      .chapter1_corpse_position;

    interactive_point = (SU_InteractivePoint)theGame.CreateEntity(
      template,
      position,
      thePlayer.GetWorldRotation()
    );

    this.waitUntilInteraction((CPeristentEntity)interactive_point);
    this.playDialogChoice();
    parent.quest_entry.completeCurrentChapterAndGoToNext();
  }

  latent function playDialogChoice() {
    var choices: array<SSceneChoice>;
    var response: SSceneChoice;
    var actions_picked: int;

    choices.PushBack(SSceneChoice(
      "Examine clothes",
      false,
      false,
      false,
      DialogAction_NONE,
      'ExamineClothes'
    ));

    choices.PushBack(SSceneChoice(
      "Examine legs",
      false,
      false,
      false,
      DialogAction_NONE,
      'ExamineLegs'
    ));

    thePlayer.PlayerStartAction( PEA_InspectLow );
    Sleep(0.25);

    (new RER_RandomDialogBuilder in thePlayer).start()
    .dialog(new REROL_smells_worse_than_it_looks in thePlayer, true)
    .play();


    while (true) {
      this.keepCreaturesOutsidePoint(thePlayer.GetWorldPosition(), 30);
      response = SU_setDialogChoicesAndWaitForResponse(choices);
      SU_closeDialogChoiceInterface();
      this.keepCreaturesOutsidePoint(thePlayer.GetWorldPosition(), 30);


      if (response.playGoChunk == 'ExamineClothes') {
        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_harpies_treated_him_painful_end in thePlayer, true)
        .dialog(new REROL_claw_marks_bite_marks_ripped_to_shreds in thePlayer, true)
        .play();

        actions_picked += 1;
      }

      if (response.playGoChunk == 'ExamineLegs') {
        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_takes_strength_to_do_something_like_this in thePlayer, true)
        .play();

        actions_picked += 1;
      }

      if (response.playGoChunk == 'CloseDialog') {
        thePlayer.PlayerStopAction( PEA_InspectLow );

        (new RER_RandomDialogBuilder in thePlayer).start()
        .dialog(new REROL_a_rock_troll_looks_like in thePlayer, true)
        .then(1)
        .dialog(new REROL_data_should_look_around in thePlayer, true)
        .play();

        return;
      }

      if (actions_picked >= 2) {
        choices.PushBack(SSceneChoice(
          "Leave",
          true,
          false,
          false,
          DialogAction_GETBACK,
          'CloseDialog'
        ));
      }
    }
  }
}