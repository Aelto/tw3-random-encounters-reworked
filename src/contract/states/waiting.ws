
state Waiting in RER_ContractManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_ContractManager - state WAITING");

    this.Waiting_main();
  }

  entry function Waiting_main() {
    if (parent.master.storages.contract.has_ongoing_contract) {
      parent.GotoState('Processing');
    }
    else {
      SU_removeCustomPinByTag("RER_contract_target");
      SU_updateMinimapPins();
    }
  }
}