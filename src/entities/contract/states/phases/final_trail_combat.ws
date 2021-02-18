
// A trail is created is created from the previous checkpoint to a random position
// where creatures will be waiting
state FinalTrailCombat in RandomEncountersReworkedContractEntity extends TrailCombat {
  event OnEnterState(previous_state_name: name) {
    LogChannel('modRandomEncounters', "Contract - State FinalTrailCombat");

    this.FinalTrailCombat_main();
  }

  entry function FinalTrailCombat_main() {
    this.TrailCombat_start();
  }

  latent function spawnRandomMonster() {
    var bestiary_entry: RER_BestiaryEntry;

    bestiary_entry = parent.bestiary_entry;

    parent.entities = bestiary_entry.spawn(
      parent.master,
      this.destination,
      ,,
      parent.entity_settings.allow_trophies,
      EncounterType_CONTRACT
    );
  }
}
