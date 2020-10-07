
state CombatAmbush in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State CombatAmbush");

    this.CombatAmbush_Main();
  }

  entry function CombatAmbush_Main() {

  }

  latent function createAmbush() {

  }

  latent function CluesInvestigate_goToNextState() {
    
  }
}
