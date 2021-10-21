
state HordeContract in RER_contractManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_contractManager - state HordeContract");

    this.HordeContract_main();
  }

  private var menu_distance_value: float;

  entry function HordeContract_main() {
    this.startNoticeboardCutscene();
    this.sendHordeRequest();
  }

  latent function sendHordeRequest() {
    var bestiary_entry: RER_BestiaryEntry;
    var request: RER_HordeRequest;

    request = new RER_HordeRequest in parent.master;
    request.init();

    bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary(
        parent.master,
        EncounterType_CONTRACT,
        RER_BREF_IGNORE_SETTLEMENT,
        (new RER_SpawnRollerFilter in this)
          .init()
          .setOffsets(CreatureHUMAN, CreatureDRACOLIZARD)
      );

    request.setCreatureCounter(bestiary_entry.type, bestiary_entry.getSpawnCount(parent.master) * 4);

    parent.master.horde_manager
      .sendRequest(request);

    Sleep(10);
    if (parent.master.rExtra.isPlayerInSettlement(50) && RandRange(10) < 5) {
      (new RER_RandomDialogBuilder in thePlayer)
        .start()
        .either(new REROL_not_a_single_monster in thePlayer, true, 0.5)
        .play();
    }

    parent.GotoState('Waiting');
  }

  private latent function startNoticeboardCutscene() {
    RER_tutorialTryShowNoticeboard();

    if (RandRange(10) < 2) {
      REROL_unusual_contract();
    }

    Sleep(0.4);
    REROL_mhm();
    Sleep(0.1);

    if (RandRange(10) < 5) {
      REROL_ill_tend_to_the_monster();
    }
    else {
      REROL_where_will_i_find_this_monster();
    }
  }
}