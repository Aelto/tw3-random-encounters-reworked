
state Combat in RandomEncountersReworkedContractEntity {
  var has_been_ambushed: bool;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Combat");

    this.Combat_Main();
  }

  entry function Combat_Main() {
    this.waitUntilPlayerFinishesCombat();
    this.Combat_goToNextState();
  }

  latent function waitUntilPlayerFinishesCombat() {
    // 1. we wait until the player is out of combat
    while (!parent.areAllEntitiesDead() || thePlayer.IsInCombat()) {
      Sleep(1);
    }

    // 2. there is a small chance a second encounter with the
    //    same bestiary entry will start as an ambush.
    if (!this.has_been_ambushed && RandRange(100) < 15) {
      REROL_monsters_everywhere_feel_them_coming();
      
      createRandomCreatureAmbush(parent.master, parent.chosen_bestiary_entry.type);
      this.has_been_ambushed = true;

      Sleep(10);

      this.waitUntilPlayerFinishesCombat();
    }
  }

  latent function Combat_goToNextState() {
    parent.GotoState('CombatLoop');
  }
}
