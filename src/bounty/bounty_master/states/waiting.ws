state Waiting in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - Waiting");

    this.Waiting_main();
  }

  entry function Waiting_main() {
    var already_has_listener: bool;

    already_has_listener = SU_NpcInteraction_hasEventListenerWithTag(
      (CNewNPC)parent.bounty_master_entity,
      "RER_StartBountyMasterConversationOnInteraction"
    );

    if (!already_has_listener) {
      ((CNewNPC)parent.bounty_master_entity)
        .addInteractionEventListener(new RER_StartBountyMasterConversationOnInteraction in parent.bounty_master_entity);
    }
  }
}

class RER_StartBountyMasterConversationOnInteraction extends SU_InteractionEventListener {

  default tag = "RER_StartBountyMasterConversationOnInteraction";

  public function run(actionName : string, activator : CEntity, receptor: CNewNPC): bool {
    var rer: CRandomEncounters;

    if (!getRandomEncounters(rer)) {
      NDEBUG("An error occured, could not find the RER entity in the world");
    }

    if (rer.bounty_manager.bounty_master_manager.GetCurrentStateName() == 'Waiting') {
      rer.bounty_manager.bounty_master_manager.GotoState('DialogChoice');
    }

    /**
     * We still want the dialogue to play after the interaction, so we'll return
     * true no matter what.
     */
    return true;
  }

}