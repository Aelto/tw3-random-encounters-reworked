
state Loading in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Loading");
    this.Loading_main();
  }

  entry function Loading_main() {
    var template: CEntityTemplate;

    template = (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true);

    parent.bait_entity = theGame.CreateEntity(
      template,
      parent.GetWorldPosition(),
      parent.GetWorldRotation()
    );

    ((CNewNPC)parent.bait_entity).SetGameplayVisibility(false);
    ((CNewNPC)parent.bait_entity).SetVisibility(false);
    ((CActor)parent.bait_entity).EnableCharacterCollisions(false);
    ((CActor)parent.bait_entity).EnableDynamicCollisions(false);
    ((CActor)parent.bait_entity).EnableStaticCollisions(false);
    ((CActor)parent.bait_entity).SetImmortalityMode(AIM_Immortal, AIC_Default);
    ((CActor)parent.bait_entity).AddBuffImmunity_AllNegative('RandomEncountersReworked', false);

    parent.GotoState('Wandering');
  }

  
}

// class SU_CustomPinRemoverPredicatePositionNearby extends SU_PredicateInterfaceRemovePin {
//   var position: Vector;
//   var radius: float;

//   function predicate(pin: SU_MapPin): bool {
//     return VecDistanceSquared(pin.position, position) < radius * radius;
//   }
// }