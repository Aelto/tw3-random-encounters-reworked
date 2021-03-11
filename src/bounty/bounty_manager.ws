

class RER_BountyManager extends CEntity {
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
    var i, k: int;

    // there is no current bounty active in the world.
    if (!this.master.storages.bounty.current_bounty.is_active) {
      return;
    }

    this.cached_bounty_group_positions = this.getAllBountyGroupPositions();

    bounty = this.getCurrentBountyCopy();

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

      this.master
        .pin_manager
        .addPinHere(this.cached_bounty_group_positions[i], RER_SkullPin);
    }
  }

  public function getAllBountyGroupPositions(): array<Vector> {
    var groups: array<RER_BountyRandomMonsterGroupData>;
    var positions: array<Vector>;
    var i: int;

    groups = this.master.storages.bounty.current_bounty.random_data.groups;

    for (i = 0; i < groups.Size(); i += 1) {
      positions.PushBack(
        this.getSafeCoordinatesFromPoint(
          this.moveCoordinatesAwayFromSafeAreas(
            this.getCoordinatesFromPercentValues(
              groups[i].position_x,
              groups[i].position_y
            )
          )
        )
      );
    }

    return positions;
  }

  public function getCurrentBountyCopy(): RER_Bounty {
    return this.master.storages.bounty.current_bounty;
  }

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
    var i: int;

    // the seed 0 means the bounty will be completely random and won't use the
    // seed in the RNG
    rng = (new RandomNumberGenerator in this).setSeed(seed)
      .useSeed(seed != 0);

    data = RER_BountyRandomData();
    number_of_groups = this.getNumberOfGroupsForSeed(seed);

    NLOG("number of groups = " + number_of_groups);

    for (i = 0; i < number_of_groups; i += 1) {
      current_group_data = RER_BountyRandomMonsterGroupData();

      if (seed == 0) {
        current_bestiary_entry = this.master.bestiary.getRandomEntryFromBestiary(
          this.master,
          EncounterType_HUNTINGGROUND
        );

        current_group_data.type = current_bestiary_entry.type;
      }
      else {
        current_group_data.type = (int)(rng.next() * (int)CreatureMAX);
        
        current_bestiary_entry = this.master.bestiary.entries[current_group_data.type];
      }
      
      current_group_data.count = rollDifficultyFactorWithRng(
        current_bestiary_entry.template_list.difficulty_factor,
        this.master.settings.selectedDifficulty,
        this.master.settings.enemy_count_multiplier
        * current_bestiary_entry.creature_type_multiplier
        // double the amount of creatures at level 100
        * (1 + this.getDifficultyForSeed(seed) * 0.01),
        rng
      );

      current_group_data.position_x = rng.next();
      current_group_data.position_y = rng.next();

      data.groups.PushBack(current_group_data);
    }

    return data;
  }

  // create the new bounty from the bounty struct that contains all the data about
  // the bounty.
  // NOTE: it kills every existing bounty creatures already in the world before
  // creating new ones, in order to cancel the previous bounty if it existed.
  public latent function startBounty(bounty: RER_Bounty) {
    var entities: array<CEntity>;
    var new_managed_group: RandomEncountersReworkedHuntingGroundEntity;
    var i: int;

    theGame.GetEntitiesByTag('RER_BountyEntity', entities);

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

    RER_removeAllPins(this.master.pin_manager);

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

    NLOG("bounty started");
  }

  public function getInformationMessageAboutCurrentBounty(): string {
    var group: RER_BountyRandomMonsterGroupData;
    var message: string;
    var i: int;

    message = "The following creatures were seen and now have bounties on their heads:<br />";

    for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.groups.Size(); i += 1) {
      group = this.master.storages.bounty.current_bounty.random_data.groups[i];
      message += " - " + group.count + " ";
      message += " " + getCreatureNameFromCreatureType(this.master.bestiary, group.type) + "<br />";
    }

    message += "<br />Whoever brings their trophies to the bounty master will get a sizable reward";

    return message;
  }

  public latent function progressThroughCurrentBounty() {
    var current_seed: int;
    var random_group: RER_BountyRandomMonsterGroupData;
    var random_group_index: int;
    // var new_managed_group: RandomEncountersReworkedHuntingGroundEntity;
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
        "Bounty finished, you now have a bounty level of "
        + RER_yellowFont(this.master.storages.bounty.bounty_level)
      );

      return;
    }

    // there is still a group to pick
    if (this.getRandomGroupToPick(this.master.storages.bounty.current_bounty, random_group, random_group_index)) {
      position = this.cached_bounty_group_positions[random_group_index];

      this.master
        .pin_manager
        .addPinHere(position, RER_SkullPin);

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

    entities = bestiary_entry.spawn(
      this.master,
      position,
      group_data.count,
      , // density
      true, // trophies
      EncounterType_HUNTINGGROUND,
      ,
      true // no bestiary
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
    var i: int;

    position = this.cached_bounty_group_positions[group_index];
    
    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );
    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, position, thePlayer.GetWorldRotation());

    FindGameplayEntitiesInRange(
      entities,
      rer_entity,
      50, // radius
      50, // max number of entities
      'RandomEncountersReworked_Entity', // tag
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
    
    rer_entity.activateBountyMode(this, group_index);
    rer_entity.startEncounter(this.master, filtered_entities, this.master.bestiary.entries[group_data.type]);

    return rer_entity;
  }

  public function getCoordinatesFromPercentValues(percent_x: float, percent_y: float): Vector {
    var min: float;
    var max: float;
    var output: Vector;
    var area: EAreaName;
    var area_string: string;

    area = theGame.GetCommonMapManager().GetCurrentArea();
    // TODO: use real values
    // the min & max values are random values at the moment

    switch (area) {
      case AN_Prologue_Village:
      case AN_Prologue_Village_Winter:
      case AN_Spiral:
      case AN_CombatTestLevel:
      case AN_Wyzima:
      case AN_Island_of_Myst:
        // first the X coordinates
        min = -350;
        max = 450;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -200;
        max = 235;

        output.Y = min + (max - min) * percent_y;
        break;

      case AN_Skellige_ArdSkellig:
        // first the X coordinates
        min = -1750;
        max = 1750;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -1750;
        max = 1750;

        output.Y = min + (max - min) * percent_y;
        break;

      case AN_Kaer_Morhen:
        // first the X coordinates
        min = -180;
        max = 50;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -500;
        max = 900;

        output.Y = min + (max - min) * percent_y;
        break;

      case AN_NMLandNovigrad:
      case AN_Velen:
        // first the X coordinates
        min = -350;
        max = 2500;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -1000;
        max = 2500;

        output.Y = min + (max - min) * percent_y;
        break;

      default:
        area_string = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

        if (area_string == "bob") {
          // first the X coordinates
          min = -1500;
          max = 1250;

          output.X = min + (max - min) * percent_x;

          // then the Y coordinates
          min = -2000;
          max = 1000;

          output.Y = min + (max - min) * percent_y;
        }
        else {
          // first the X coordinates
          min = -300;
          max = 300;

          output.X = min + (max - min) * percent_x;

          // then the Y coordinates
          min = -300;
          max = 300;

          output.Y = min + (max - min) * percent_y;
        }

        break;
    }

    return output;
  }

  // because lots of bounties end up in bodies of water, this function returns 
  // the closest piece of land.
  public function getSafeCoordinatesFromPoint(point: Vector): Vector {
    // we will use water depth to detect if the point is on land or in water
    // every other functions failed certainly because the game doesn't load
    // the data about the chunks until the player gets close enough.
    //
    // This function works everywhere, and returns 10 000 when it's on land
    // and a value between 0 and 100 or 200 when in a body of water.
    var water_depth: float;
    var signposts: array<CEntity>;
    var array_of_nodes: array<CNode>;
    var closest_signpost_node: CNode;
    var closest_signpost_position: Vector;
    var i: int;
    var output: Vector;

    water_depth = theGame.GetWorld().GetWaterDepth(point);

    // it's on land, we can return now
    if (water_depth >= 5000) {
      return point;
    }

    // get all the signposts in the map
    theGame.GetEntitiesByTag(
      'W3FastTravelEntity',
      signposts
    );

    for (i = 0; i < signposts.Size(); i += 1) {
      array_of_nodes.PushBack((CNode)signposts[i]);
    }

    // then find the closest one
    closest_signpost_node = FindClosestNode(point, array_of_nodes);
    closest_signpost_position = closest_signpost_node.GetWorldPosition();

    // set the output at the starting point
    output = point;

    do {
      // then slowly get closer to the signpost position
      output = VecInterpolate(output, closest_signpost_position, 0.05);

      // update the water depth
      water_depth = theGame.GetWorld().GetWaterDepth(output);

    // while the water depth is not over 5000 which means there is a body of water
    // at the current position
    } while (water_depth < 5000);

    NLOG("safe position = " + VecToString(output));

    return output;
  }

  // the goal of this function is to move the supplied from outside pre-defined
  // safe areas in the world. The safe areas were made because the original bounds
  // are rectangular and sometimes to avoid a single unreachable area it would mean
  // removing 50% of the bound width, which i don't want.
  // The safe areas are circles with a radius, and the start by all the safe areas
  // the point is in. And then we add to a displacement vector all the translations
  // needed to move the point out of the areas. Because we don't do it one by one
  // and instead add all the translations needed, it creates a sort of "mean"
  // vector that will gracefully move the point outside of ALL areas.
  public function moveCoordinatesAwayFromSafeAreas(point: Vector): Vector {
    var current_distance_percentage: float;
    var distance_from_center: float;
    var displacement_vector: Vector;
    var safe_areas: array<Vector>;
    var squared_radius: float;
    var i: int;

    safe_areas = this.getSafeAreasByRegion(
      AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea())
    );

    NLOG("moveCoordinatesAwayFromSafeAreas 1.");

    for (i = 0; i < safe_areas.Size(); i += 1) {
      squared_radius = safe_areas[i].Z * safe_areas[i].Z;
      distance_from_center = VecDistanceSquared2D(safe_areas[i], point);

      // the point is not inside the circle, skip
      if (distance_from_center > squared_radius) {
        continue;
      }

      current_distance_percentage = distance_from_center / squared_radius;

      NLOG("moveCoordinatesAwayFromSafeAreas, squared radius = " + squared_radius + " distance_percentage = " + current_distance_percentage);

      displacement_vector += VecInterpolate(
        Vector(safe_areas[i].X, safe_areas[i].Y, point.Z),
        point,
        1 - current_distance_percentage
      );
    }

    NLOG("moveCoordinatesAwayFromSafeAreas 2.");

    return point + displacement_vector;
  }

  // the safe areas are Vectors where X and Y are used for the coordinates,
  // and Z is the radius. I didn't want to create yet another struct for it.
  public function getSafeAreasByRegion(region: string): array<Vector> {
    var areas: array<Vector>;

    /*
    // the javascript code used to generate the coordinates.
    // combined with the rergetpincoord command
    {
    // center of the circle
    const a = { x: -340, y: -450 };
    // edge of the circle
    const b = { x: -140, y: -320 };

    const radius = Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));

    `areas.PushBack(Vector(${a.x}, ${a.y}, ${Math.round(radius)}));`
    }

    */

    switch (region) {
      case 'prolog_village':
      case 'prolog_village_winter':
      break;

      case 'no_mans_land':
      case 'novigrad':
      areas.PushBack(Vector(340, 1980, 502)); // novigrad
      areas.PushBack(Vector(1760, 900, 215)); // oxenfurt

      break;

      case 'skellige':
      areas.PushBack(Vector(-100, -636, 110)); // kaer trolde
      areas.PushBack(Vector(-90, -800, 162)); // big mountain south of the main island
      areas.PushBack(Vector(-1700, -1000, 304)); // forge mountain on the giant's island
      break;

      case 'kaer_morhen':
      areas.PushBack(Vector(-11, 19, 95)); // the keep
      areas.PushBack(Vector(130, 210, 183)); // the big mountain north of the keep
      areas.PushBack(Vector(-500, -700, 330)); // the mountain south west of the map
      areas.PushBack(Vector(-340, -450, 239)); // same
      areas.PushBack(Vector(-620, 500, 330)); // a mountain north west of the map
      areas.PushBack(Vector(-100, -106, 30)); // the tower near the keep
      break;

      case 'bob':
      break;
    }

    return areas;
  }

  // return the maximum progress the bounty will have for this seed. Each progress
  // level is a group of creatures.
  public function getNumberOfGroupsForSeed(seed: int): int {
    var min: int;
    var max: int;

    min = 3;
    // for every 20 levels bounties have a chance to get 1 more group
    max = 2 + (int)(this.getDifficultyForSeed(seed) * 0.05) + min;

    NLOG("getNumberOfGroupsForSeed(" + seed + ") - " + RandNoiseF(seed, max, min) + " " + max);

    // a difficulty 0 seed has maximum 5 monster groups in it
    // the difficulty seed step divided by 100 means that a difficulty 100 seed
    // will double the amount of creatures.
    return (int)(RandNoiseF(seed, max, min));
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

      this.spawnNearbyBountyGroups();

    }

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