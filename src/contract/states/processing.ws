
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
  }

  latent function waitForPlayerToReachDestination() {
    var ongoing_contract: RER_ContractRepresentation;
    var has_added_pins: bool;
    var map_pin: SU_MapPin;


    while (true) {
      NLOG("parent.master.storages.contract.has_ongoing_contract = " + parent.master.storages.contract.has_ongoing_contract);

      if (!parent.master.storages.contract.has_ongoing_contract) {
        Sleep(20);

        continue;
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
        map_pin.description = StrReplace(
          GetLocStringByKey("rer_mappin_bounty_target_description"),
          "{{creature_type}}",
          getCreatureNameFromCreatureType(
            parent.master.bestiary,
            ongoing_contract.creature_type
          )
        );
        map_pin.label = GetLocStringByKey("rer_mappin_bounty_target_title");
        map_pin.type = "MonsterQuest";
        map_pin.radius = ongoing_contract.destination_radius;
        map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
        map_pin.appears_on_minimap = theGame.GetInGameConfigWrapper()
          .GetVarValue('RERoptionalFeatures', 'RERminimapMarkerBounties');

        thePlayer.addCustomPin(map_pin);

        SU_updateMinimapPins();

        has_added_pins = true;
      }

      if (VecDistanceSquared2D(ongoing_contract.destination_point, thePlayer.GetWorldPosition()) > ongoing_contract.destination_radius * ongoing_contract.destination_radius) {
        Sleep(10);

        continue;
      }

	    theGame.SaveGame( SGT_QuickSave, -1 );

      Sleep(10);
    }
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
    
    bestiary_entry = parent.master.bestiary.getEntry(ongoing_contract.creature_type);
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
      'RandomEncountersReworked_ContractCreature
    );

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, position, thePlayer.GetWorldRotation());    rer_entity.startEncounter(this.master, entities, bestiary_entry);
    rer_entity.manual_destruction = true;
    rer_entity.startEncounter(this.master, entities, bestiary_entry);

    while (rer_entity.GetCurrentStateName() != 'Ending') {
      Sleep(1);
    }

    rer_entity.clean();
  }

  latent function createNestEncounterAndWaitForEnd(ongoing_contract: RER_ContractRepresentation) {
    var current_template: CEntityTemplate;
    var rng: RandomNumberGenerator;
    var nest: RER_MonsterNest;
    var position: Vector;
    var path: string;

    rng = (new RandomNumberGenerator in this).setSeed(ongoing_contract.rng_seed)
      .useSeed(true);

    path = "dlc\modtemplates\randomencounterreworkeddlc\data\rer_monster_nest.w2ent";

    rng.next();
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

    while (!nest.HasTag('WasDestroyed')) {
      Sleep(1);
    }
  }

  latent function sendHordeRequestAndWaitForEnd(ongoing_contract: RER_ContractRepresentation) {
    var request: RER_HordeRequestBeforeBounty;
    var bestiary_entry: RER_BestiaryEntry;
    var rng: RandomNumberGenerator;

    bestiary_entry = parent.master.bestiary.getEntry(parent.master, ongoing_contract.creature_type);
    rng = (new RandomNumberGenerator in this).setSeed(ongoing_contract.rng_seed)
      .useSeed(true);


    request = new RER_HordeRequestBeforeBounty in parent;
    request.init();
    request.setCreatureCounter(ongoing_contract.creature_type, RoundF(rng.nextRange(20, 0) / bestiary_entry.ecosystem_delay_multiplier));

    parent.master.horde_manager.sendRequest(request);

    if (parent.master.horde_manager.GetCurrentStateName() == 'Waiting') {
      while (parent.master.horde_manager.GetCurrentStateName() == 'Waiting') {
        Sleep(1);
      }
    }

    while (parent.master.horde_manager.GetCurrentStateName() == 'Processing') {
      Sleep(1);
    }
  }
}