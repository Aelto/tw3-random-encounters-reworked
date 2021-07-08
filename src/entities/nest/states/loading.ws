
state Loading in RER_MonsterNest {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_MonsterNest - State Loading");

    this.Loading_main();
  }

  entry function Loading_main() {
    parent.bestiary_entry = parent.master.bestiary.getRandomEntryFromBestiary(
      parent.master,
      EncounterType_HUNTINGGROUND,
      false,
      CreatureARACHAS, // left offset
      CreatureDRACOLIZARD // right offset
    );
  }
}
