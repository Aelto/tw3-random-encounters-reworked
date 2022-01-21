

statemachine class RER_BountyManager extends CEntity {
  var master: CRandomEncounters;
  var bounty_master_manager: RER_BountyMasterManager;

  // the list of hunting grounds for the current bounty.
  var currently_managed_groups: array<RandomEncountersReworkedHuntingGroundEntity>;

  // uses the group indices for the position indices
  var cached_bounty_group_positions: array<Vector>;

  public function init(master: CRandomEncounters) {
    this.master = master;
    this.bounty_master_manager = new RER_BountyMasterManager in this;
    this.GotoState('Processing');
  }

  public latent function retrieveBountyGroups() {
    var new_managed_group: RandomEncountersReworkedHuntingGroundEntity;
    var bounty: RER_Bounty;
    var map_pin: SU_MapPin;
    var i, k: int;

    // there is no current bounty active in the world.
    if (!this.master.storages.bounty.current_bounty.is_active) {
      return;
    }

    this.cached_bounty_group_positions = this.getAllBountyGroupPositions();

    bounty = this.getCurrentBountyCopy();

    SU_removeCustomPinByTag("RER_bounty_target");

    for (i = 0; i < bounty.random_data.groups.Size(); i += 1) {
      // it was not spawned earlier so we skip it
      if (!bounty.random_data.groups[i].was_picked) {
        continue;
      }

      // it was already killed so we skip it too
      if (bounty.random_data.groups[i].was_killed) {
        continue;
      }

      if (bounty.random_data.groups[i].was_spawned) {
        // now if the group was spawned earlier and was not killed,
        // we create a new hunting group there with the bounty entities around the
        // point.
        new_managed_group = retrieveBountyGroup(bounty.random_data.groups[i], i);

        this.currently_managed_groups.PushBack(new_managed_group);
      }


      if (theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERmarkersBountyHunting')) {

        map_pin = new SU_MapPin in thePlayer;
        map_pin.tag = "RER_bounty_target";
        map_pin.position = this.cached_bounty_group_positions[i];
        map_pin.description = StrReplace(
          GetLocStringByKey("rer_mappin_bounty_target_description"),
          "{{creature_type}}",
          getCreatureNameFromCreatureType(
            this.master.bestiary,
            bounty.random_data.groups[i]
              .type
          )
        );
        map_pin.label = GetLocStringByKey("rer_mappin_bounty_target_title");
        map_pin.type = "MonsterQuest";
        map_pin.radius = 100;
        map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

        thePlayer.addCustomPin(map_pin);
      }
    }
  }



  public function getCurrentBountyCopy(): RER_Bounty {
    return this.master.storages.bounty.current_bounty;
  }

  //#region bounty settings & constants

  // returns the steps at which the seed gains difficulty points
  public function getSeedDifficultyStep(): int {
    return 1000;
  }

  public function getDifficultyForSeed(seed: int): int {
    // when using the 0 seed, which means the bounty is completely random. The
    // difficulty no longer scales on the seed as there is no seed but instead
    // on the player's level.
    if (seed == 0) {
      // there is still a level of randomness here, it uses the settings values
      // to get the difficulty relative to the player's level.
      return getRandomLevelBasedOnSettings(this.master.settings);
    }

    return (int)(seed / this.getSeedDifficultyStep());
  }

  // returns how much the seed cap is increased by bounty level
  public function getSeedBountyLevelStep(): int {
    return 500;
  }

  public function getMaximumSeed(): int {
    return this.master.storages.bounty.bounty_level * this.getSeedBountyLevelStep();
  }

  //#endregion bounty settings & constants


  //#region bounty creation

  // create a new bounty struct with all the data we need to know about the new
  // bounty.
  public latent function getNewBounty(seed: int): RER_Bounty {
    var bounty: RER_Bounty;

    // if (seed <= 0) {
    //   seed = RandRange(this.getMaximumSeed());
    // }

    bounty = RER_Bounty();
    bounty.seed = seed;
    bounty.is_active = true;
    bounty.random_data = this.generateRandomDataForBounty(seed);

    return bounty;
  }

  public latent function generateRandomDataForBounty(seed: int): RER_BountyRandomData {
    var current_group_data: RER_BountyRandomMonsterGroupData;
    var current_bestiary_entry: RER_BestiaryEntry;
    var rng: RandomNumberGenerator;
    var data: RER_BountyRandomData;
    var number_of_groups: int;
    var constants: RER_ConstantCreatureTypes;
    var i: int;

    constants = RER_ConstantCreatureTypes();

    // the seed 0 means the bounty will be completely random and won't use the
    // seed in the RNG
    rng = (new RandomNumberGenerator in this).setSeed(seed)
      .useSeed(seed != 0);

    data = RER_BountyRandomData();
    number_of_groups = this.getNumberOfGroupsForSeed(rng, seed);

    NLOG("number of groups = " + number_of_groups);

    for (i = 0; i < number_of_groups; i += 1) {
      current_group_data = RER_BountyRandomMonsterGroupData();

      if (seed == 0) {
        current_bestiary_entry = this.master.bestiary.getRandomEntryFromBestiary(
          this.master,
          EncounterType_CONTRACT,
          RER_BREF_IGNORE_BIOMES | RER_BREF_IGNORE_SETTLEMENT,
          (new RER_SpawnRollerFilter in this)
            .init()
            .setOffsets(
              constants.large_creature_begin,
              constants.large_creature_max,
              0.1 // creature outside the offset have -90% chance to appear
            )
        );

        current_group_data.type = current_bestiary_entry.type;
      }
      else {
        current_group_data.type = (int)(rng.next() * (int)CreatureMAX);
        
        current_bestiary_entry = this.master.bestiary.entries[current_group_data.type];
      }
      
      current_group_data.count = Max(1,
        rollDifficultyFactorWithRng(
          current_bestiary_entry.template_list.difficulty_factor,
          this.master.settings.selectedDifficulty,
          this.master.settings.enemy_count_multiplier
          * current_bestiary_entry.creature_type_multiplier
          // double the amount of creatures at level 100
          * (1 + this.getDifficultyForSeed(seed) * 0.01),
          rng
        )
      );

      current_group_data.position_x = rng.next();
      current_group_data.position_y = rng.next();
      current_group_data.translation_heading = rng.nextRange(360, 0);

      data.groups.PushBack(current_group_data);
    }

    return data;
  }

  //#endregion bounty creation


  //#region bounty workflow

  // create the new bounty from the bounty struct that contains all the data about
  // the bounty.
  // NOTE: it kills every existing bounty creatures already in the world before
  // creating new ones, in order to cancel the previous bounty if it existed.
  public latent function startBounty(bounty: RER_Bounty) {
    var entities: array<CEntity>;
    var new_managed_group: RandomEncountersReworkedHuntingGroundEntity;
    var i: int;

    theGame.GetEntitiesByTag('RER_BountyEntity', entities);

    SU_removeCustomPinByTag("RER_bounty_target");

    for (i = 0; i < entities.Size(); i += 1) {
      ((CNewNPC)entities[i]).Kill('Bounty');
    }

    NLOG("killed " + entities.Size() + " entities");

    if (entities.Size() > 0) {
      NLOG("waiting 10 seconds");

      // to give time to the HuntingGround to notify the manager
      Sleep(10);
    }

    this.currently_managed_groups.Clear();
    
    this.master.storages.bounty.current_bounty = bounty;

    NLOG("starting bounty with " + bounty.random_data.groups.Size() + " groups");

    SU_removeCustomPinByTag("RER_bounty_target");

    this.master
        .storages
        .bounty
        .save();

    this.cached_bounty_group_positions = this.getAllBountyGroupPositions();

    NLOG("starting bounty with " + this.master.storages.bounty.current_bounty.random_data.groups.Size() + " groups");

    for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.groups.Size() && i < 4; i += 1) {
      this.progressThroughCurrentBounty();
    }

    // for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.groups.Size(); i += 1) {
    //   new_managed_group = this.spawnBountyGroup(
    //     this.master.storages.bounty.current_bounty.random_data.groups[i],
    //     i
    //   );

    //   this.currently_managed_groups.PushBack(new_managed_group);

    //   // don't spawn more than 5 groups at the start.
    //   // The rest of the groups are spawned the player progresses through the bounty.
    //   if (i >= 4) {
    //     break;
    //   }
    // }

    theSound.SoundEvent( 'gui_enchanting_socket_add' );

    Sleep(0.2);

    RER_tutorialTryShowBounty();

    Sleep(0.5);

    RER_openPopup(
      "Bounty information",
      this.getInformationMessageAboutCurrentBounty()
    );

    SU_updateMinimapPins();

    NLOG("bounty started");
  }

  public function getInformationMessageAboutCurrentBounty(): string {
    var group: RER_BountyRandomMonsterGroupData;
    var message: string;
    var i: int;

    for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.groups.Size(); i += 1) {
      group = this.master.storages.bounty.current_bounty.random_data.groups[i];
      message += " - " + group.count + " ";
      message += " " + getCreatureNameFromCreatureType(this.master.bestiary, group.type) + "<br />";
    }

    return StrReplace(
      GetLocStringByKey("rer_bounty_start_popup"),
      "{{creature_listing}}",
      message
    );
  }

  public latent function progressThroughCurrentBounty() {
    var current_seed: int;
    var random_group: RER_BountyRandomMonsterGroupData;
    var random_group_index: int;
    var map_pin: SU_MapPin;
    var position: Vector;

    if (!this.master.storages.bounty.current_bounty.is_active) {
      return;
    }

    // if the player has killed enough groups then we consider the bounty finished
    if (!this.hasAnyGroupToKillYet(this.master.storages.bounty.current_bounty)) {
      NLOG("progress - no more groups to kill in the bounty, bounty is finished");

      // we increase the bounty level for the player
      this.increaseBountyLevel();

      // set the bounty as no longer active
      this.master
        .storages
        .bounty
        .current_bounty
        .is_active = false;

      // save the changes
      this.master
        .storages
        .bounty
        .save();

      NDEBUG(
        StrReplace(
          GetLocStringByKey("rer_bounty_finished_notification"),
          "{{bounty_level}}",
          RER_yellowFont(this.master.storages.bounty.bounty_level)
        )
      );

      return;
    }

    // there is still a group to pick
    if (this.getRandomGroupToPick(this.master.storages.bounty.current_bounty, random_group, random_group_index)) {
      position = this.cached_bounty_group_positions[random_group_index];

      if (theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERmarkersBountyHunting')) {

        map_pin = new SU_MapPin in thePlayer;
        map_pin.tag = "RER_bounty_target";
        map_pin.position = position;
        map_pin.description = StrReplace(
          GetLocStringByKey("rer_mappin_bounty_target_description"),
          "{{creature_type}}",
          getCreatureNameFromCreatureType(
            this.master.bestiary,
            this.master
              .storages
              .bounty
              .current_bounty
              .random_data
              .groups[random_group_index]
              .type
          )
        );
        map_pin.label = GetLocStringByKey("rer_mappin_bounty_target_title");
        map_pin.type = "MonsterQuest";
        map_pin.radius = 100;
        map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
        map_pin.appears_on_minimap = theGame.GetInGameConfigWrapper()
          .GetVarValue('RERoptionalFeatures', 'RERminimapMarkerBounties');

        thePlayer.addCustomPin(map_pin);
      }

      this.master
        .storages
        .bounty
        .current_bounty
        .random_data
        .groups[random_group_index].was_picked = true;

      this.master
        .storages
        .bounty
        .save();
    }
  }

  public function hasAnyGroupToKillYet(bounty: RER_Bounty): bool {
    var i: int;

    for (i = 0; i < bounty.random_data.groups.Size(); i += 1) {
      if (!bounty.random_data.groups[i].was_killed) {
        return true;
      }
    }

    return false;
  }

  public latent function notifyHuntingGroundKilled(group_index: int) {
    this.master
      .storages
      .bounty
      .current_bounty
      .random_data
      .groups[group_index]
      .was_killed = true;

    this.master
        .storages
        .bounty
        .save();


    this.progressThroughCurrentBounty();

    (new RER_RandomDialogBuilder in thePlayer).start()
    .then(2)
    .either(new REROL_alright_whats_next in thePlayer, false, 1)
    .either(new REROL_thats_my_next_destination in thePlayer, false, 1)
    .play();
  }

  // returns false if it could not find any more group to spawn in the supplied bounty.
  public function getRandomGroupToSpawn(bounty: RER_Bounty, out group_data: RER_BountyRandomMonsterGroupData, out group_index: int): bool {
    var i: int;

    for (i = 0; i < bounty.random_data.groups.Size(); i += 1) {
      if (!bounty.random_data.groups[i].was_spawned) {
        group_data = bounty.random_data.groups[i];
        group_index = i;
        
        return true;
      }
    }

    return false;
  }

  // returns false if it could not find any more group to pick in the supplied bounty.
  public function getRandomGroupToPick(bounty: RER_Bounty, out group_data: RER_BountyRandomMonsterGroupData, out group_index: int): bool {
    var i: int;

    for (i = 0; i < bounty.random_data.groups.Size(); i += 1) {
      if (!bounty.random_data.groups[i].was_picked) {
        group_data = bounty.random_data.groups[i];
        group_index = i;
        
        return true;
      }
    }

    return false;
  }

  //#endregion bounty workflow


  //#region bounty spawn & retrieve

  public latent function spawnBountyGroup(group_data: RER_BountyRandomMonsterGroupData, group_index: int): RandomEncountersReworkedHuntingGroundEntity {
    var bestiary_entry: RER_BestiaryEntry;
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var rer_entity_template: CEntityTemplate;
    var entities: array<CEntity>;
    var position: Vector;
    var player_position: Vector;
    var i: int;

    bestiary_entry = this.master.bestiary.entries[group_data.type];
    position = this.cached_bounty_group_positions[group_index];

    // to get it closer to the real ground position. It works because bounty
    // groups are spawned only when the player gets close.
    if (position.Z == 0) {
      player_position = thePlayer.GetWorldPosition();
      position.Z = player_position.Z;
    }

    // we remove the pin because the hunting ground will create one and the
    // getGroundPosition will probably slightly move the point away.
    SU_removeCustomPinByPosition(position);

    if (!getGroundPosition(position, 2, 50) || position.Z <= 0) {
      if (!getRandomPositionBehindCamera(position, 50)) {
        NLOG("spawnBountyGroup, could not find a safe ground position. Defaulting to marker position");
      }
    }

    entities = bestiary_entry.spawn(
      this.master,
      position,
      group_data.count,
      , // density
      EncounterType_CONTRACT,
      RER_BESF_NO_BESTIARY_FEATURE,
      'RandomEncountersReworked_BountyCreature'
    );

    NLOG("bounty group " + group_index + " spawned " + entities.Size() + " entities at " + VecToString(position));

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, position, thePlayer.GetWorldRotation());
    rer_entity.activateBountyMode(this, group_index);
    rer_entity.startEncounter(this.master, entities, bestiary_entry);

    for (i = 0; i < entities.Size(); i += 1) {
      if (!entities[i].HasTag('RER_BountyEntity')) {
        entities[i].AddTag('RER_BountyEntity');
      }
    }

    this.master
      .storages
      .bounty
      .current_bounty
      .random_data
      .groups[group_index]
      .was_spawned = true;

    this.master
        .storages
        .bounty
        .save();

    return rer_entity;
  }

  public latent function retrieveBountyGroup(group_data: RER_BountyRandomMonsterGroupData, group_index: int): RandomEncountersReworkedHuntingGroundEntity {
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var rer_entity_template: CEntityTemplate;
    var entities: array<CGameplayEntity>;
    var filtered_entities: array<CEntity>;
    var position: Vector;
    var original_position: Vector;
    var i: int;

    position = this.cached_bounty_group_positions[group_index];
    original_position = position;
    
    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    FindGameplayEntitiesInRange(
      entities,
      rer_entity,
      100, // radius
      50, // max number of entities
      'RandomEncountersReworked_BountyCreature', // tag
      FLAG_ExcludePlayer,
      thePlayer, // target
      'CEntity'
    );

    for (i = 0; i < entities.Size(); i += 1) {
      if (entities[i].HasTag('RER_controlled')) {
        continue;
      }

      entities[i].AddTag('RER_controlled');
      filtered_entities.PushBack((CEntity)entities[i]);
    }

    // to better place the marker, set the position to the first creature found
    // but we still move the position a bit closer to the marker to avoid
    // the case where the creature, over many reloads, slowly moves away from
    // the marker up to the point where it's not found anymore.
    if (entities.Size() > 0) {
      position = entities[0].GetWorldPosition();
      position = VecInterpolate(
        position,
        original_position,
        0.05
      );

      // then we find a safe spot in the position if possible. We don't really
      // care if it succeeds or not.
      if (!getGroundPosition(position, 5, 10)) {
        NLOG("retrieveBountyGroup, could not find a safe ground position.");
      }
    }

    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(
      rer_entity_template,
      position,
      thePlayer.GetWorldRotation()
    );

    rer_entity.activateBountyMode(this, group_index);
    rer_entity.startEncounter(this.master, filtered_entities, this.master.bestiary.entries[group_data.type]);

    return rer_entity;
  }

  //#endregion bounty spawn & retrieve


  //#region coordinates
  public function getAllBountyGroupPositions(): array<Vector> {
    var groups: array<RER_BountyRandomMonsterGroupData>;
    var positions: array<Vector>;
    var i: int;

    groups = this.master.storages.bounty.current_bounty.random_data.groups;

    for (i = 0; i < groups.Size(); i += 1) {
      positions.PushBack(
        SUH_getSafeCoordinatesFromPoint(
          SUH_moveCoordinatesAwayFromSafeAreas(
            SUH_moveCoordinatesInsideValidAreas(
              SUH_getCoordinatesFromPercentValues(
                groups[i].position_x,
                groups[i].position_y
              )
            )
          )
        )
      );
    }

    return positions;
  }

  //#endregion coordinates

  // return the maximum progress the bounty will have for this seed. Each progress
  // level is a group of creatures.
  public function getNumberOfGroupsForSeed(rng: RandomNumberGenerator, seed: int): int {
    var min: int;
    var max: int;

    min = 3;
    // for every 20 levels bounties have a chance to get 1 more group
    max = 2 + (int)(this.getDifficultyForSeed(seed) * 0.05) + min;

    NLOG("getNumberOfGroupsForSeed(" + seed + ") - " + RandNoiseF(seed, max, min) + " " + max);

    // a difficulty 0 seed has maximum 5 monster groups in it
    // the difficulty seed step divided by 100 means that a difficulty 100 seed
    // will double the amount of creatures.
    return (int)rng.nextRange(max, min);
  }

  public function increaseBountyLevel() {
    this.master
      .storages
      .bounty
      .bounty_level += 1;

    this.master
      .storages
      .bounty
      .save();
  }
}

state Processing in RER_BountyManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyManager - Processing");

    this.Processing_main();
  }

  entry function Processing_main() {

    // we also call it instantly to handle cases where the player teleported near
    // a group that was picked but not spawned yet
    this.spawnNearbyBountyGroups();

    while (true) {
      Sleep(10);

      // no active bounty, do nothing
      if (!parent.master.storages.bounty.current_bounty.is_active) {
        continue;
      }

      this.moveBountyTargets();
      this.spawnNearbyBountyGroups();
    }

  }

  function moveBountyTargets() {
    var groups: array<RER_BountyRandomMonsterGroupData>;
    var gametime_delta_multiplier: float;
    var custom_pins: array<SU_MapPin>;
    var current_translation: Vector;
    var current_group_index: int;
    var new_position: Vector;
    var pin: SU_MapPin;
    var i: int;

    groups = parent.master.storages.bounty.current_bounty.random_data.groups;
    for (i = 0; i < groups.Size(); i += 1) {
      // we only move the targets that were not spawned yet and only the markers
      // that are currently shown on the map.
      if (!this.isGroupActive(groups[i])) {
        continue;
      }

      // randomly change the current translation heading up to a maximum of 5
      // degrees.
      groups[i].translation_heading = AngleNormalize(
        groups[i].translation_heading + RandRangeF(10) - 5
      );

      current_translation = VecConeRand(
        groups[i].translation_heading,
        15, // angle
        0, // min range
        0.0005 // max range
      );

      // y at 1 is the top of the map
      // x at 1 is the right of the map
      // heading at 0 is the 

      // we mutate the original coordinates
      groups[i].position_x += current_translation.X;
      groups[i].position_y += current_translation.Y;

      if (groups[i].position_x <= 0.05) {
        groups[i].position_x = 0.06;

        // 270 degrees is the right
        groups[i].translation_heading = 270;
      }

      if (groups[i].position_x >= 0.95) {
        groups[i].position_x = 0.94;

        // 90 degrees is the left
        groups[i].translation_heading = 90;
      }

      // y below zero is the top of the map
      if (groups[i].position_y <= 0.05) {
        groups[i].position_y = 0.06;

        // 0 degrees is the top of the map
        groups[i].translation_heading = 0;
      }

      if (groups[i].position_y >= 0.95) {
        groups[i].position_y = 0.94;

        // 180 degrees is the bottom of the map
        groups[i].translation_heading = 180;
      }

      new_position = SUH_getSafeCoordinatesFromPoint(
        SUH_moveCoordinatesAwayFromSafeAreas(
          SUH_moveCoordinatesInsideValidAreas(
            SUH_getCoordinatesFromPercentValues(
              groups[i].position_x,
              groups[i].position_y
            )
          )
        )
      );

      parent.master.storages.bounty.current_bounty.random_data.groups[i].position_x = groups[i].position_x;
      parent.master.storages.bounty.current_bounty.random_data.groups[i].position_y = groups[i].position_y;
      parent.master.storages.bounty.current_bounty.random_data.groups[i].translation_heading = groups[i].translation_heading;
      // parent.cached_bounty_group_positions[i] = new_position;
    }

    parent.cached_bounty_group_positions = parent.getAllBountyGroupPositions();
    
    parent.master
        .storages
        .bounty
        .save();

    // updating markers now:
    if (theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERmarkersBountyHunting')) {

      current_group_index = 0;
      custom_pins = thePlayer.customMapPins;
      for (i = 0; i < custom_pins.Size(); i += 1) {
        if (custom_pins[i].tag != "RER_bounty_target") {
          continue;
        }

        // we reuse the new position variable here
        if (this.getActiveBountyGroupPositionByIndex(current_group_index, new_position)) {
          custom_pins[i].position = new_position;

          current_group_index += 1;
        }
        // for some reason there are more pins in the array than we have bounty
        // targets, we remove that extra pin.
        else {
          SU_removeCustomPinByIndex(i);
        }
      }
    }

    SU_updateMinimapPins();
  }

  function isGroupActive(group: RER_BountyRandomMonsterGroupData): bool {
    return group.was_picked
        && !group.was_spawned
        && !group.was_killed;
  }

  // NOTE: this loops through the ACTIVE bounty groups, so an index of 2
  // may not actually be the third in the array. It is the second ACTIVE bounty
  // group.
  //
  function getActiveBountyGroupPositionByIndex(index: int, out group_position: Vector): bool {
    var groups: array<RER_BountyRandomMonsterGroupData>;
    var internal_index: int;
    var i: int;

    groups = parent.master.storages.bounty.current_bounty.random_data.groups;

    for (i = 0; i < groups.Size(); i += 1) {
      if (!this.isGroupActive(groups[i])) {
        continue;
      }

      if (internal_index == index && parent.cached_bounty_group_positions.Size() > i) {
        group_position = parent.cached_bounty_group_positions[i];

        return true;
      }

      internal_index += 1;
    }

    return false;
  }

  latent function spawnNearbyBountyGroups() {
    var i: int;
    var groups: array<RER_BountyRandomMonsterGroupData>;
    var position: Vector;
    var distance_from_player: float;
    var max_distance: float;
    var new_managed_group: RandomEncountersReworkedHuntingGroundEntity;
    var player_position: Vector;

    groups = parent.master.storages.bounty.current_bounty.random_data.groups;
    max_distance = 100 * 100;
    player_position = thePlayer.GetWorldPosition();

    for (i = 0; i < groups.Size(); i += 1) {
      if (!groups[i].was_picked || groups[i].was_spawned) {
        continue;
      }

      // here, we know the group we currently have was picked and was not spawned
      position = parent.cached_bounty_group_positions[i];

      position.Z = player_position.Z;

      distance_from_player = VecDistanceSquared(
        player_position,
        position
      );

      // the player is too far from the group, we'll wait for him to get closer
      // before spawning it
      if (distance_from_player > max_distance) {
        continue;
      }

      new_managed_group = parent.spawnBountyGroup(
        parent.master.storages.bounty.current_bounty.random_data.groups[i],
        i
      );

      parent.currently_managed_groups.PushBack(new_managed_group);
    }
  }
}