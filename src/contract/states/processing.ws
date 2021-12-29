
state Processing in RER_ContractManager {
  var is_spawned: bool;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_ContractManager - Processing");

    this.Processing_main();
  }

  entry function Processing_main() {
    this.waitForPlayerToReachDestination();
    this.waitForPlayerToFinishContract();
    parent.completeCurrentContract();
    parent.GotoState('Waiting');
  }

  latent function waitForPlayerToReachDestination() {
    var ongoing_contract: RER_ContractRepresentation;
    var has_added_pins: bool;
    var map_pin: SU_MapPin;


    while (true) {
      if (!parent.master.storages.contract.has_ongoing_contract) {
        parent.GotoState('Waiting');
        
        return;
      }

      ongoing_contract = parent.master.storages.contract.ongoing_contract;

      // this part is pretty much useless since the storage is unique per region
      // meaning you get only the contract for the current region.
      if (!SUH_isPlayerInRegion(ongoing_contract.region_name)) {
        parent.GotoState('Waiting');
      }

      if (!has_added_pins) {
        SU_removeCustomPinByTag("RER_contract_target");

        map_pin = new SU_MapPin in thePlayer;
        map_pin.tag = "RER_contract_target";
        map_pin.position = ongoing_contract.destination_point;
        map_pin.description = GetLocStringByKey("rer_mappin_regular_description");
        map_pin.label = GetLocStringByKey("rer_mappin_regular_title");
        map_pin.type = "MonsterQuest";
        map_pin.radius = ongoing_contract.destination_radius;
        map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
        map_pin.appears_on_minimap = theGame.GetInGameConfigWrapper()
          .GetVarValue('RERoptionalFeatures', 'RERminimapMarkerBounties');

        thePlayer.addCustomPin(map_pin);

        SU_updateMinimapPins();

        has_added_pins = true;
        theSound.SoundEvent("gui_hubmap_mark_pin");
      }

      if (VecDistanceSquared2D(ongoing_contract.destination_point, thePlayer.GetWorldPosition()) <= ongoing_contract.destination_radius * ongoing_contract.destination_radius) {
        break;
      }

      Sleep(10);
    }

    theGame.SaveGame( SGT_QuickSave, -1 );
    theSound.SoundEvent("gui_ingame_new_journal");
  }

  latent function waitForPlayerToFinishContract() {
    var ongoing_contract: RER_ContractRepresentation;
    if (!parent.master.storages.contract.has_ongoing_contract) {
      return;
    }

    ongoing_contract = parent.master.storages.contract.ongoing_contract;


    if (ongoing_contract.event_type == ContractEventType_NEST) {
      this.createNestEncounterAndWaitForEnd(ongoing_contract);
    }
    else if (ongoing_contract.event_type == ContractEventType_HORDE) {
      this.sendHordeRequestAndWaitForEnd(ongoing_contract);
    }
    else if (ongoing_contract.event_type == ContractEventType_BOSS) {
      this.createHuntingGroundAndWaitForEnd(ongoing_contract);
    }
  }

  latent function createHuntingGroundAndWaitForEnd(ongoing_contract: RER_ContractRepresentation) {
    var bestiary_entry: RER_BestiaryEntry;
    var rer_entity_template: CEntityTemplate;
    var entities: array<CEntity>;
    var rng: RandomNumberGenerator;
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var position: Vector;
    
    bestiary_entry = parent.master.bestiary.getEntry(parent.master, ongoing_contract.creature_type);
    rng = (new RandomNumberGenerator in this).setSeed(ongoing_contract.rng_seed)
      .useSeed(true);

    rng.next();
    position = ongoing_contract.destination_point
      + VecRingRandStatic((int)rng.previous_number, ongoing_contract.destination_radius, 5);

    entities = bestiary_entry.spawn(
      parent.master,
      position,
      RoundF(rng.nextRange(20, 0) / bestiary_entry.ecosystem_delay_multiplier),
      , // density
      EncounterType_CONTRACT,
      RER_BESF_NO_BESTIARY_FEATURE,
      'RandomEncountersReworked_ContractCreature'
    );

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, position, thePlayer.GetWorldRotation());
    rer_entity.manual_destruction = true;
    rer_entity.startEncounter(parent.master, entities, bestiary_entry);

		thePlayer.DisplayHudMessage(
      StrReplace(
        GetLocStringByKeyExt("rer_kill_target"),
        "{{type}}",
        getCreatureNameFromCreatureType(parent.master.bestiary, ongoing_contract.creature_type)
      )
    );

    while (rer_entity.GetCurrentStateName() != 'Ending') {
      Sleep(1);
    }

    rer_entity.clean();
  }

  latent function createNestEncounterAndWaitForEnd(ongoing_contract: RER_ContractRepresentation) {
    var current_template: CEntityTemplate;
    var nests: array<RER_MonsterNest>;
    var are_all_nests_destroyed: bool;
    var rng: RandomNumberGenerator;
    var nest: RER_MonsterNest;
    var position: Vector;
    var path: string;
    var i: int;

    rng = (new RandomNumberGenerator in this).setSeed(ongoing_contract.rng_seed)
      .useSeed(true);

    path = "dlc\modtemplates\randomencounterreworkeddlc\data\rer_monster_nest.w2ent";

    rng.next();

    if (ongoing_contract.difficulty == ContractDifficulty_EASY) {
      i = 1;
    }
    else {
      i = RoundF(rng.nextRange(3, 1));
    }

    while (i > 0) {
      i -= 1;

      position = ongoing_contract.destination_point
        + VecRingRandStatic((int)rng.previous_number, ongoing_contract.destination_radius, 5);

      FixZAxis(position);

      // it doesn't matter if it fails to find a ground position
      getGroundPosition(position, 2, 5);

      current_template = (CEntityTemplate)LoadResourceAsync(path, true);
      nest = (RER_MonsterNest)theGame.CreateEntity(
        current_template,
        position,
        thePlayer.GetWorldRotation(),,,,
        PM_DontPersist
      );

      nest.bestiary_entry = parent.master.bestiary.entries[ongoing_contract.creature_type];
      nest.forced_bestiary_entry = true;
      nest.startEncounter(parent.master);

      nests.PushBack(nest);
    }

    if (nests.Size() <= 1) {
      thePlayer.DisplayHudMessage(
        StrReplace(
          GetLocStringByKeyExt("rer_find_nest"),
          "{{type}}",
          getCreatureNameFromCreatureType(parent.master.bestiary, ongoing_contract.creature_type)
        )
      );
    }
    else {
      thePlayer.DisplayHudMessage(
        StrReplace(
          GetLocStringByKeyExt("rer_find_nests"),
          "{{type}}",
          getCreatureNameFromCreatureType(parent.master.bestiary, ongoing_contract.creature_type)
        )
      );
    }

    do {
      are_all_nests_destroyed = true;

      for (i = 0; i < nests.Size(); i += 1) {
        are_all_nests_destroyed = are_all_nests_destroyed && nests[i].HasTag('WasDestroyed');
      }

      Sleep(1);
    }
  }

  latent function sendHordeRequestAndWaitForEnd(ongoing_contract: RER_ContractRepresentation) {
    var request: RER_HordeRequest;
    var bestiary_entry: RER_BestiaryEntry;
    var rng: RandomNumberGenerator;
    var enemy_count: int;

    bestiary_entry = parent.master.bestiary.getEntry(parent.master, ongoing_contract.creature_type);
    rng = (new RandomNumberGenerator in this).setSeed(ongoing_contract.rng_seed)
      .useSeed(true);

    enemy_count = RoundF(rng.nextRange(20, 0) / bestiary_entry.ecosystem_delay_multiplier)
      * (1 + (int)ongoing_contract.difficulty == ContractDifficulty_HARD);

    if (enemy_count < 3) {
      // the amount of enemies would be too low for it to be a good horde, in
      // that case we spawn a bossfight instead
      this.createHuntingGroundAndWaitForEnd(ongoing_contract);

      return;
    }

    request = new RER_HordeRequest in parent;
    request.init();
    request.setCreatureCounter(
      ongoing_contract.creature_type,
      enemy_count
    );

    parent.master.horde_manager.sendRequest(request);

    // the statemachine may not enter the processing state right away,
    // in this case we wait for it to leave the waiting state.
    while (parent.master.horde_manager.GetCurrentStateName() == 'Waiting') {
      Sleep(1);
    }

    thePlayer.DisplayHudMessage(
      StrReplace(
        GetLocStringByKeyExt("rer_survive_horde"),
        "{{type}}",
        getCreatureNameFromCreatureType(parent.master.bestiary, ongoing_contract.creature_type)
      )
    );

    while (parent.master.horde_manager.GetCurrentStateName() == 'Processing') {
      Sleep(1);
    }
  }
}