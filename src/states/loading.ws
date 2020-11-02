
state Loading in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state LOADING");
    this.startLoading();
  }

  entry function startLoading() {
    this.createEncountersUsingFacts();

    parent.GotoState('Waiting');
  }

  // Some encounters are stored using facts so that when the player dies,
  // the encounter can be recreated when the game reloads.
  private latent function createEncountersUsingFacts() {
    var contract_position: Vector;
    var contract_creature_type: CreatureType;

    while (RERFACT_hasNoticeboardEvent()) {
      if (!RERFACT_getLatestNoticeboardEvent(contract_position, contract_creature_type)) {
        break;
      }

      createRandomCreatureContract(parent, contract_position, contract_creature_type);
    }
  }
}
