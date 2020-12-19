
// The Ambush state is quite simple, it's a stationnary phase where Monsters appear
// around Geralt and ambush him. Then it goes directly in the Combat phase.
state Ambush in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Ambush");

    this.Ambush_main();
  }

  entry function Ambush_main() {
    this.spawnRandomMonster();

    parent.GotoState('Combat');
  }

  latent function spawnRandomMonster() {
    var bestiary_entry: RER_BestiaryEntry;

    bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary(parent.master, EncounterType_CONTRACT);

    parent.entities = bestiary_entry.spawn(parent.master, parent.previous_phase_checkpoint);
  }
}
