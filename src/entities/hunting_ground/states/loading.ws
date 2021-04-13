
state Loading in RandomEncountersReworkedHuntingGroundEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntingGroundEntity - State Loading");
    this.Loading_main();
  }

  entry function Loading_main() {
    var template: CEntityTemplate;
    var can_place_bounty_marker: bool;
    var predicate: SU_CustomPinRemoverPredicatePositionNearby;
    var map_pin: SU_MapPin;

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

    can_place_bounty_marker = theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERmarkersBountyHunting');
    if (parent.is_bounty && can_place_bounty_marker) {
      // // to remove any duplicate marker in the area.
      // predicate = new SU_CustomPinRemoverPredicatePositionNearby in parent;
      // predicate.position = parent.GetWorldPosition();
      // predicate.radius = 100;
      // SU_removeCustomPinByPredicate(predicate);

      map_pin = new SU_MapPin in thePlayer;
        map_pin.tag = "RER_bounty_target";
        map_pin.position = predicate.position;
        map_pin.description = StrReplace(
          GetLocStringByKey("rer_mappin_bounty_target_description"),
          "{{creature_type}}",
          getCreatureNameFromCreatureType(
            parent.master.bestiary,
            parent.bestiary_entry.type
          )
        );
        map_pin.label = GetLocStringByKey("rer_mappin_bounty_target_title");
        map_pin.type = "MonsterQuest";
        map_pin.radius = 100;
        map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
    }

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