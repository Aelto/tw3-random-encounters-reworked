
state Loading in RER_MonsterNest {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_MonsterNest - State Loading");

    this.Loading_main();
  }

  entry function Loading_main() {
    parent.bestiary_entry = parent.getRandomNestCreatureType(parent.master);

    if (parent.bestiary_entry.type == CreatureARACHAS ) {
      parent.monsters_spawned_limit /= 3;
    }
    if (parent.bestiary_entry.type == CreatureWRAITH) {
      parent.monsters_spawned_limit /= 2;
    }

    this.placeMarker();

    parent.GotoState('Spawning');
  }

  function placeMarker() {
    var can_show_markers: bool;
    var map_pin: SU_MapPin;
    var position: Vector;

    can_show_markers = theGame.GetInGameConfigWrapper()
      .GetVarValue('RERoptionalFeatures', 'RERmarkersContractFirstPhase');

    if (can_show_markers) {
      position = parent.GetWorldPosition()
          + VecRingRand(0, 50);

      map_pin = new SU_MapPin in thePlayer;
      map_pin.tag = "RER_nest_contract_target";
      map_pin.position = position;
      map_pin.description = GetLocStringByKey("rer_mappin_regular_description");
      map_pin.label = GetLocStringByKey("rer_mappin_regular_title");
      map_pin.type = "TreasureQuest";
      map_pin.radius = 100;
      map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

      thePlayer.addCustomPin(map_pin);

      parent.pin_position = position;

      SU_updateMinimapPins();
    }
  }
}
