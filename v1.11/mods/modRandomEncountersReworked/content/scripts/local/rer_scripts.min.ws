
enum RER_Biome {
  BiomeForest = 0,
  BiomeSwamp = 1,
  BiomeWater = 2
}

enum RER_RegionConstraint {
  RER_RegionConstraint_NONE = 0,
  RER_RegionConstraint_ONLY_WHITEORCHARD = 1,
  RER_RegionConstraint_ONLY_VELEN = 2,
  RER_RegionConstraint_ONLY_SKELLIGE = 3,
  RER_RegionConstraint_ONLY_TOUSSAINT = 4,
  RER_RegionConstraint_NO_WHITEORCHARD = 5,
  RER_RegionConstraint_NO_VELEN = 6,
  RER_RegionConstraint_NO_SKELLIGE = 7,
  RER_RegionConstraint_NO_TOUSSAINT = 8
}

class RER_CreaturePreferences {

  public function reset(): RER_CreaturePreferences {
    this.only_biomes.Clear();
    this.disliked_biomes.Clear();
    this.liked_biomes.Clear();

    return this;
  }

  public var creature_type: CreatureType;
  public function setCreatureType(type: CreatureType): RER_CreaturePreferences {
    this.creature_type = type;

    return this;
  }

  // If the creature can only spawn in a biome
  public var only_biomes: array<RER_Biome>;
  public function addOnlyBiome(biome: RER_Biome): RER_CreaturePreferences {
    this.only_biomes.PushBack(biome);

    return this;
  }

  // If the creature has its chance reduce by the external factor
  // when in the biomes
  public var disliked_biomes: array<RER_Biome>;
  public function addDislikedBiome(biome: RER_Biome): RER_CreaturePreferences {
    this.disliked_biomes.PushBack(biome);

    return this;
  }

  // If the creature has its chance increased by the external factor
  // when in the biomes
  public var liked_biomes: array<RER_Biome>;
  public function addLikedBiome(biome: RER_Biome): RER_CreaturePreferences {
    this.liked_biomes.PushBack(biome);

    return this;
  }

  public var chance_day: int;
  public var chance_night: int;
  public function setChances(day, night: int): RER_CreaturePreferences {
    this.chance_day = day;
    this.chance_night = night;

    return this;
  }

  //#region persistent values
  // value is not reset
  public var is_night: bool;
  public function setIsNight(value: bool): RER_CreaturePreferences {
    this.is_night = value;

    return this;
  }

  public var city_spawn_allowed: bool;
  public function setCitySpawnAllowed(value: bool): RER_CreaturePreferences {
    this.city_spawn_allowed = value;

    return this;
  }

  public var region_constraint: RER_RegionConstraint;
  default region_constraint = RER_RegionConstraint_NONE;
  public function setRegionConstraint(constraint: RER_RegionConstraint): RER_CreaturePreferences {
    this.region_constraint = constraint;

    return this;
  }

  // value is not reset
  public var external_factors_coefficient: float;
  public function setExternalFactorsCoefficient(value: float): RER_CreaturePreferences {
    this.external_factors_coefficient = value;
    
    return this;
  }

  // value is not reset
  public var is_near_water: bool;
  public function setIsNearWater(value: bool): RER_CreaturePreferences {
    this.is_near_water = value;

    return this;
  }

  // value is not reset
  public var is_in_forest: bool;
  public function setIsInForest(value: bool): RER_CreaturePreferences {
    this.is_in_forest = value;

    return this;
  }

  // value is not reset
  public var is_in_swamp: bool;
  public function setIsInSwamp(value: bool): RER_CreaturePreferences {
    this.is_in_swamp = value;

    return this;
  }

  public var current_region: string;
  public function setCurrentRegion(region: string): RER_CreaturePreferences {
    this.current_region = region;

    return this;
  }

  public var is_in_city: bool;
  public function setIsInCity(city: bool): RER_CreaturePreferences {
    this.is_in_city = city;

    return this;
  }
  //#endregion persistent values

  public function getChances(): int {
    var i: int;
    var can_spawn: bool;
    var spawn_chances: int;
    var is_in_disliked_biome: bool;
    var is_in_liked_biome: bool;

    if (this.is_in_city && !this.city_spawn_allowed) {
      return 0;
    }

    can_spawn = true;

    if (this.region_constraint == RER_RegionConstraint_NO_VELEN && (this.current_region == "no_mans_land" || this.current_region == "novigrad")
    ||  this.region_constraint == RER_RegionConstraint_NO_SKELLIGE && (this.current_region == "skellige" || this.current_region == "kaer_morhen")
    ||  this.region_constraint == RER_RegionConstraint_NO_TOUSSAINT && this.current_region == "bob"
    ||  this.region_constraint == RER_RegionConstraint_NO_WHITEORCHARD && this.current_region == "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_TOUSSAINT && this.current_region != "bob"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_WHITEORCHARD && this.current_region != "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_SKELLIGE && this.current_region != "skellige" && this.current_region != "kaer_morhen"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_VELEN && this.current_region != "no_mans_land" && this.current_region != "novigrad") {
      // LogChannel('modRandomEncounters', "creature removed from region constraints, at " + this.region_constraint + " and current region = " + this.current_region + " for " + this.creature_type);

      can_spawn = false;
    }

    if (!can_spawn) {
      return 0;
    }

    can_spawn = false;

    for (i = 0; i < this.only_biomes.Size(); i += 1) {
      if (this.only_biomes[i] == BiomeSwamp && this.is_in_swamp) {
        can_spawn = true;
      }

      if (this.only_biomes[i] == BiomeForest && this.is_in_forest) {
        can_spawn = true;
      }

      if (this.only_biomes[i] == BiomeWater && this.is_near_water) {
        can_spawn = true;
      }
    }

    // no allowed biome, return 0 directly.
    if (this.only_biomes.Size() > 0 && !can_spawn) {
      LogChannel('modRandomEncounters', "creature removed from only biome, for " + this.creature_type);

      return 0;
    }

    if (this.is_night) {
      spawn_chances = this.chance_night;
    }
    else {
      spawn_chances = this.chance_day;
    }

    
    // being in a disliked biome reduces the spawn chances
    is_in_disliked_biome = false;
    for (i = 0; i < this.disliked_biomes.Size(); i += 1) {
      if (this.disliked_biomes[i] == BiomeSwamp && this.is_in_swamp) {
        is_in_disliked_biome = true;
      }

      if (this.disliked_biomes[i] == BiomeForest && this.is_in_forest) {
        is_in_disliked_biome = true;
      }

      if (this.disliked_biomes[i] == BiomeWater && this.is_near_water) {
        is_in_disliked_biome = true;
      }
    }

    if (is_in_disliked_biome) {
      spawn_chances = this.applyCoefficientToCreatureDivide(spawn_chances);
    }

    // being in a liked biome increases the spawn chances
    is_in_liked_biome = false;
    for (i = 0; i < this.liked_biomes.Size(); i += 1) {
      if (this.liked_biomes[i] == BiomeSwamp && this.is_in_swamp) {
        is_in_liked_biome = true;
      }

      if (this.liked_biomes[i] == BiomeForest && this.is_in_forest) {
        is_in_liked_biome = true;
      }

      if (this.liked_biomes[i] == BiomeWater && this.is_near_water) {
        is_in_liked_biome = true;
      }
    }

    if (is_in_disliked_biome) {
      spawn_chances = this.applyCoefficientToCreature(spawn_chances);
    }

    // LogChannel('modRandomEncounters', "chances = " + spawn_chances + " for " + this.creature_type);

    return spawn_chances;
  }

  public function fillSpawnRoller(spawn_roller: SpawnRoller):  RER_CreaturePreferences {
    spawn_roller.setCreatureCounter(this.creature_type, this.getChances());

    return this.reset();
  }

  public function fillSpawnRollerThirdParty(spawn_roller: SpawnRoller): RER_CreaturePreferences {
    spawn_roller.setThirdPartyCreatureCounter(this.creature_type, this.getChances());

    return this.reset();
  }

  private function applyCoefficientToCreature(chances: int): int {
    return (int)(chances * this.external_factors_coefficient);
  }

  private function applyCoefficientToCreatureDivide(chances: int): int {
    return (int)(chances / this.external_factors_coefficient);
  }
}

enum EHumanType
{
  HT_BANDIT       = 0,
  HT_NOVBANDIT    = 1,
  HT_SKELBANDIT   = 2,
  HT_SKELBANDIT2  = 3,
  HT_CANNIBAL     = 4,
  HT_RENEGADE     = 5,
  HT_PIRATE       = 6,
  HT_SKELPIRATE   = 7,
  HT_NILFGAARDIAN = 8,
  HT_WITCHHUNTER  = 9,

  HT_MAX          = 10,
  HT_NONE         = 11
}

enum CreatureType {
  CreatureHUMAN        = 0,
  CreatureARACHAS      = 1,
  CreatureENDREGA      = 2,
  CreatureGHOUL        = 3,
  CreatureALGHOUL      = 4,
  CreatureNEKKER       = 5,
  CreatureDROWNER      = 6,
  CreatureROTFIEND     = 7,
  CreatureWOLF         = 8,
  CreatureWRAITH       = 9,
  CreatureHARPY        = 10,
  CreatureSPIDER       = 11,
  CreatureCENTIPEDE    = 12,
  CreatureDROWNERDLC   = 13,  
  CreatureBOAR         = 14,  
  CreatureBEAR         = 15,
  CreaturePANTHER      = 16,  
  CreatureSKELETON     = 17,
  CreatureECHINOPS     = 18,
  CreatureKIKIMORE     = 19,
  CreatureBARGHEST     = 20,
  CreatureSKELWOLF     = 21,
  CreatureSKELBEAR     = 22,
  CreatureWILDHUNT     = 23,
  CreatureBERSERKER    = 24,
  CreatureSIREN        = 25,

  // large creatures below
  CreatureDRACOLIZARD  = 26,
  CreatureGARGOYLE     = 27,
  CreatureLESHEN       = 28,
  CreatureWEREWOLF     = 29,
  CreatureFIEND        = 30,
  CreatureEKIMMARA     = 31,
  CreatureKATAKAN      = 32,
  CreatureGOLEM        = 33,
  CreatureELEMENTAL    = 34,
  CreatureNIGHTWRAITH  = 35,
  CreatureNOONWRAITH   = 36,
  CreatureCHORT        = 37,
  CreatureCYCLOP      = 38,
  CreatureTROLL        = 39,
  CreatureHAG          = 40,
  CreatureFOGLET       = 41,
  CreatureBRUXA        = 42,
  CreatureFLEDER       = 43,
  CreatureGARKAIN      = 44,
  CreatureDETLAFF      = 45,
  CreatureGIANT        = 46,  
  CreatureSHARLEY      = 47,
  CreatureWIGHT        = 48,
  CreatureGRYPHON      = 49,
  CreatureCOCKATRICE   = 50,
  CreatureBASILISK     = 51,
  CreatureWYVERN       = 52,
  CreatureFORKTAIL     = 53,
  CreatureSKELTROLL    = 54,

  // It is important to keep the numbers continuous.
  // The `SpawnRoller` classes uses these numbers to
  // to fill its arrays.
  // (so that i dont have to write 40 lines by hand)
  CreatureMAX          = 55,
  CreatureNONE         = 56,
}


enum EncounterType {
  // default means an ambush.
  EncounterType_DEFAULT  = 0,
  
  EncounterType_HUNT     = 1,
  EncounterType_CONTRACT = 2,
  EncounterType_MAX      = 3
}


enum OutOfCombatRequest {
  OutOfCombatRequest_TROPHY_CUTSCENE = 0,
  OutOfCombatRequest_TROPHY_NONE     = 1
}

enum TrophyVariant {
  TrophyVariant_PRICE_LOW = 0,
  TrophyVariant_PRICE_MEDIUM = 1,
  TrophyVariant_PRICE_HIGH = 2
}

enum RER_Difficulty {
  RER_Difficulty_EASY = 0,
  RER_Difficulty_MEDIUM = 1,
  RER_Difficulty_HARD = 2,
  RER_Difficulty_RANDOM = 3
}

// gpc for GetPlayerCoordinates
exec function rergpc() {
  var entities: array<CGameplayEntity>;
  var message: string;
  var i: int;

  FindGameplayEntitiesInRange(
    entities,
    thePlayer,
    25, // radius
    10, // max number of entities
    , // tag
    FLAG_Attitude_Hostile + FLAG_ExcludePlayer + FLAG_OnlyAliveActors,
    thePlayer, // target
    'CNewNPC'
  );

  message += "position: " + VecToString(thePlayer.GetWorldPosition()) + "<br/>";
  
  if (entities.Size() > 0) {
    message += "nearby entities:<br/>";
  }

  for (i = 0; i < entities.Size(); i += 1) {
    message += " - " + StrAfterFirst(entities[i].ToString(), "::") + "<br/>";
  }

  NDEBUG(message);
}

exec function rerbestiarycanspawn(creature: CreatureType) {
  var rer_entity : CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, creature);
  exec_runner.GotoState('RunBestiaryCanSpawn');
}

exec function rera(optional creature: CreatureType) {
  _rer_start_ambush(creature);
}
exec function rer_start_ambush(optional creature: CreatureType) {
  _rer_start_ambush(creature);
}
function _rer_start_ambush(optional creature: CreatureType) {
  var rer_entity : CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, creature);
  exec_runner.GotoState('RunCreatureAmbush');
}

exec function rerh(optional creature: CreatureType) {
  _rer_start_hunt(creature);
}
exec function rer_start_hunt(optional creature: CreatureType) {
  _rer_start_hunt(creature);
}
function _rer_start_hunt(optional creature: CreatureType) {
  var rer_entity : CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, creature);
  exec_runner.GotoState('RunCreatureHunt');
}


exec function rerhu(optional human_type: EHumanType, optional count: int) {
  _rer_start_human(human_type, count);
}
exec function rer_start_human(optional human_type: EHumanType, optional count: int) {
  _rer_start_human(human_type, count);
}
function _rer_start_human(optional human_type: EHumanType, optional count: int) {
  var rer_entity: CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>");

    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, CreatureNONE);

  exec_runner.human_type = human_type;
  exec_runner.count = count;

  exec_runner.GotoState('RunHumanAmbush');
}

exec function rer_test_camera(optional scene_id: int) {
  var rer_entity: CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>");

    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, CreatureNONE);

  exec_runner.count = scene_id;

  exec_runner.GotoState('TestCameraScenePlayer');
}

// Why a statemachine and a whole class for exec functions
// and console commands?
// Most of RER functions are latent functions to keep things
// asynchronous and not hurt the framerates.
// The only way to call a latent function is from an entry function
// or another latent function. This is why this class is a statemachine.
// Entry functions are called when the statemachine enters a specific
// state.
statemachine class RER_ExecRunner extends CEntity {
  var master: CRandomEncounters;
  var creature: CreatureType;
  var human_type: EHumanType;
  var count: int;


  public function init(master: CRandomEncounters, creature: CreatureType) {
    this.master = master;
    this.creature = creature;
  }
}

state RunCreatureAmbush in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State RunCreatureAmbush");

    this.RunCreatureAmbush_main();
  }

  entry function RunCreatureAmbush_main() {
    createRandomCreatureAmbush(parent.master, parent.creature);
  }
}

state RunCreatureHunt in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State RunCreatureHunt");

    this.RunCreatureHunt_main();
  }

  entry function RunCreatureHunt_main() {
    createRandomCreatureHunt(parent.master, parent.creature);
  }
}

state RunHumanAmbush in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State RunHumanAmbush");

    this.RunHumanAmbush_main(parent.human_type, parent.count);
  }

  entry function RunHumanAmbush_main(human_type: EHumanType, count: int) {
    var composition: CreatureAmbushWitcherComposition;

    composition = new CreatureAmbushWitcherComposition in parent.master;

    composition.init(parent.master.settings);
    composition.setBestiaryEntry(parent.master.bestiary.human_entries[human_type])
      .setNumberOfCreatures(count)
      .spawn(parent.master);
  }
}

state TestCameraScenePlayer in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State TestCameraScenePlayer");

    if (parent.count == 0) {
      this.TestCameraScenePlayer_main();
    }
    else {
      this.TestCameraScenePlayer_one();
    }
  }

  entry function TestCameraScenePlayer_main() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    
    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = thePlayer.GetWorldPosition() + Vector(3, 3, 3);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_NODE;
    scene.look_at_target_node = thePlayer;

    // scene.velocity = Vector(0, 0.01, 0);
    // scene.velocity_type = RER_CameraVelocityType_RELATIVE;

    scene.position_blending_ratio = 0.5;
    scene.rotation_blending_ratio = 0.5;

    scene.duration = 5;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene, true);
  }

  entry function TestCameraScenePlayer_one() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    
    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    // scene.position = parent.investigation_center_position + Vector(0, 0, 5);
    scene.position = thePlayer.GetWorldPosition() + Vector(5, 0, 5);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    scene.look_at_target_static = thePlayer.GetWorldPosition();

    scene.velocity_type = RER_CameraVelocityType_RELATIVE;
    scene.velocity = Vector(0, 0.05, 0);

    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    scene.duration = 10;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene);
  }
}

state RunBestiaryCanSpawn in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State RunBestiaryCanSpawn");

    this.RunBestiaryCanSpawn_main(parent.human_type, parent.count);
  }

  entry function RunBestiaryCanSpawn_main(human_type: EHumanType, count: int) {
    var manager : CWitcherJournalManager;
    var can_spawn_creature: bool;
    
    manager = theGame.GetJournalManager();
  
    can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(
      parent.master.bestiary.entries[parent.creature].template_list,
      manager
    );

    NDEBUG("Can spawn creature [" + parent.creature + "] = " + can_spawn_creature);
  }
}

// Sometimes solo creatures can be accompanied by smaller creatures,
// this is what i call a group composition. Imagine a leshen and a few wolves
// or a giant fighting humans.

latent function makeGroupComposition(encounter_type: EncounterType, random_encounters_class: CRandomEncounters) {
  if (encounter_type == EncounterType_HUNT) {
    LogChannel('modRandomEncounters', "spawning - HUNT");
    createRandomCreatureHunt(random_encounters_class, CreatureNONE);

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "MiscFreshTracks" );
    }
  }
  else if (encounter_type == EncounterType_DEFAULT) {
    LogChannel('modRandomEncounters', "spawning - AMBUSH");
    createRandomCreatureAmbush(random_encounters_class, CreatureNONE);

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "BattleCryBadSituation" );
    }
  }
  else {
    LogChannel('modRandomEncounters', "spawning - CONTRACT");
    createRandomCreatureContract(random_encounters_class, new RER_BestiaryEntryNull in random_encounters_class);

    if (random_encounters_class.settings.geralt_comments_enabled) {
      // TODO: find a unique voiceset for the contract
      thePlayer.PlayVoiceset( 90, "MiscFreshTracks" );
    }
  }
}

abstract class CompositionSpawner {

  // When you need to force a creature type
  var _bestiary_entry: RER_BestiaryEntry;
  var _bestiary_entry_null: bool;
  default _bestiary_entry_null = true;

  public function setBestiaryEntry(bentry: RER_BestiaryEntry): CompositionSpawner {
    this._bestiary_entry = bentry;
    this._bestiary_entry_null = bentry.isNull();

    return this;
  }

  // When you need to force a number of creatures
  var _number_of_creatures: int;
  default _number_of_creatures = 0;

  public function setNumberOfCreatures(count: int): CompositionSpawner {
    this._number_of_creatures = count;

    return this;
  }

  // When you need to force the spawn position
  var spawn_position: Vector;
  var spawn_position_force: bool;
  default spawn_position_force = false;
  
  public function setSpawnPosition(position: Vector): CompositionSpawner {
    this.spawn_position = position;
    this.spawn_position_force = true;

    return this;
  }

  // When using a random position
  // this will be the max radius used
  var _random_position_max_radius: float;
  default _random_position_max_radius = 200;

  public function setRandomPositionMaxRadius(radius: float): CompositionSpawner {
    this._random_position_max_radius = radius;

    return this;
  }

  // When using a random position
  // this will be the min radius used
  var _random_positition_min_radius: float;
  default _random_positition_min_radius = 150;

  public function setRandomPositionMinRadius(radius: float): CompositionSpawner {
    this._random_positition_min_radius = radius;

    return this;
  }

  // when spawning multiple creature
  var _group_positions_density: float;
  default _group_positions_density = 0.01;

  public function setGroupPositionsDensity(density: float): CompositionSpawner {
    this._group_positions_density = density;

    return this;
  }

  // the distance at which an RER creature is killed
  var automatic_kill_threshold_distance: float;
  default automatic_kill_threshold_distance = 200;

  public function setAutomaticKillThresholdDistance(distance: float): CompositionSpawner {
    this.automatic_kill_threshold_distance = distance;

    return this;
  }

  // should the creature drop a trophy on death
  var allow_trophy: bool;
  default allow_trophy = true;

  public function setAllowTrophy(value: bool): CompositionSpawner {
    this.allow_trophy = value;

    return this;
  }

  // should the creature trigger a loot pickup cutscene on death
  var allow_trophy_pickup_scene: bool;
  default allow_trophy_pickup_scene = false;

  public function setAllowTrophyPickupScene(value: bool): CompositionSpawner {
    this.allow_trophy_pickup_scene = value;

    return this;
  }

  // tell which type of encounter the composition is from
  // especially used when retrieving a random monster from the bestiary
  var encounter_type: EncounterType;
  default encounter_type = EncounterType_DEFAULT;
  public function setEncounterType(encounter_type: EncounterType): CompositionSpawner {
    this.encounter_type = encounter_type;

    return this;
  }

  var master: CRandomEncounters;
  var bestiary_entry: RER_BestiaryEntry;
  var initial_position: Vector;
  var created_entities: array<CEntity>;

  public latent function spawn(master: CRandomEncounters) {
    var i: int;
    var success: bool;

    this.master = master;

    this.bestiary_entry = this.getBestiaryEntry(master);

    if (!this.getInitialPosition(this.initial_position)) {
      LogChannel('modRandomEncounters', "could not find proper spawning position");

      return;
    }

    success = this.beforeSpawningEntities();
    if (!success) {
      return;
    }

    this.created_entities = this.bestiary_entry.spawn(
      master,
      this.initial_position,
      this._number_of_creatures,
      this._group_positions_density,
      this.allow_trophy,
      this.encounter_type
    );

    for (i = 0; i < this.created_entities.Size(); i += 1) {
      this.forEachEntity(
        this.created_entities[i]
      );
    }

    success = this.afterSpawningEntities();
    if (!success) {
      return;
    }
  }

  // A method to override if needed,
  // such as creating a custom class for handling the fight.
  // If it returns false the spawn is cancelled.
  protected latent function beforeSpawningEntities(): bool {
    return true;
  }

  // A method to override if needed,
  // such as creating a custom class and attaching it.
  protected latent function forEachEntity(entity: CEntity) {}

  // A method to override if needed,
  // such as creating a custom class for handling the fight.
  // If it returns false the spawn is cancelled.
  protected latent function afterSpawningEntities(): bool {
    return true;
  }


  protected latent function getBestiaryEntry(master: CRandomEncounters): RER_BestiaryEntry {
    var bestiary_entry: RER_BestiaryEntry;

    if (this._bestiary_entry_null) {
      bestiary_entry = master
        .bestiary
        .getRandomEntryFromBestiary(master, this.encounter_type);

      return bestiary_entry;
    }

    return this._bestiary_entry;
  }

  protected function getInitialPosition(out initial_position: Vector): bool {
    var attempt: bool;

    if (this.spawn_position_force) {
      initial_position = this.spawn_position;

      return true;
    }

    attempt = getRandomPositionBehindCamera(
      initial_position,
      this._random_position_max_radius,
      this._random_positition_min_radius,
      10
    );

    return attempt;
  }

}

class CRandomEncounterInitializer extends CEntityMod {
  default modName = 'Random Encounters Reworked';
  default modAuthor = "Aeltoth";
  default modUrl = "http://www.nexusmods.com/witcher3/mods/5018";
  default modVersion = '1.7.1';

  default logLevel = MLOG_DEBUG;

  default template = "dlc\modtemplates\randomencounterreworkeddlc\data\rer_initializer.w2ent";
}


function modCreate_RandomEncountersReworked() : CMod {
  return new CRandomEncounterInitializer in thePlayer;
}

statemachine class CRandomEncounters extends CEntity {
  var rExtra: CModRExtra;
  var settings: RE_Settings;
  var resources: RE_Resources;
  var spawn_roller: SpawnRoller;
  var events_manager: RER_EventsManager;
  var bestiary: RER_Bestiary;
  var static_encounter_manager: RER_StaticEncounterManager;

  var ticks_before_spawn: int;

  event OnSpawned(spawn_data: SEntitySpawnData) {
    var ents: array<CEntity>;

    LogChannel('modRandomEncounters', "RandomEncounter spawned");

    theGame.GetEntitiesByTag('RandomEncounterTag', ents);

    if (ents.Size() > 1) {
      this.Destroy();
    }
    else {
      this.AddTag('RandomEncounterTag');

      theInput.RegisterListener(this, 'OnRefreshSettings', 'OnRefreshSettings');
      theInput.RegisterListener(this, 'OnSpawnMonster', 'RandomEncounter');
      theInput.RegisterListener(this, 'OnRER_enabledToggle', 'OnRER_enabledToggle');

      super.OnSpawned(spawn_data);

      rExtra = new CModRExtra in this;
      settings = new RE_Settings in this;
      resources = new RE_Resources in this;
      spawn_roller = new SpawnRoller in this;
      events_manager = new RER_EventsManager in this;
      bestiary = new RER_Bestiary in this;
      static_encounter_manager = new RER_StaticEncounterManager in this;

      this.initiateRandomEncounters();
    }
  }

  event OnRefreshSettings(action: SInputAction) {
    LogChannel('modRandomEncounters', "settings refreshed");
    
    if (IsPressed(action)) {
      this.settings
        .loadXMLSettingsAndShowNotification();
      
      this.events_manager
        .start();

      this.bestiary.init();
      this.bestiary.loadSettings();

      this.GotoState('Loading');
    }
  }

  event OnSpawnMonster(action: SInputAction) {
    LogChannel('modRandomEncounters', "on spawn event");
  
    if (this.ticks_before_spawn > 5) {
      this.ticks_before_spawn = 5;
    }
  }

  event OnRER_enabledToggle(action: SInputAction) {
    if (IsPressed(action)) {
      LogChannel('modRandomEncounters', "RER enabled state toggle");

      this.settings.toggleEnabledSettings();

      if (!this.settings.hide_next_notifications) {
        if (this.settings.is_enabled) {
          displayRandomEncounterEnabledNotification();
        }
        else {
          displayRandomEncounterDisabledNotification();
        }
      }
    }
  }

  private function initiateRandomEncounters() {
    this.spawn_roller.fill_arrays();
    
    this.bestiary.init();
    this.bestiary.loadSettings();
    
    this.settings.loadXMLSettings();
    this.resources.load_resources();

    this.events_manager.init(this);
    this.events_manager.start();

    AddTimer('onceReady', 3.0, false);
    this.GotoState('Loading');
  }

  timer function onceReady(optional delta: float, optional id: Int32) {
    if (!this.settings.hide_next_notifications) {
      displayRandomEncounterEnabledNotification();
    }
  }

  //#region OutOfCombat action
  private var out_of_combat_requests: array<OutOfCombatRequest>;

  // add the requested action for when the player will leave combat
  public function requestOutOfCombatAction(request: OutOfCombatRequest): bool {
    var i: int;
    var already_added: bool;

    already_added = false;

    LogChannel('modRandomEncounters', "adding request out of combat: " + request);

    for (i = 0; i < this.out_of_combat_requests.Size(); i += 1) {
      if (this.out_of_combat_requests[i] == request) {
        already_added = true;
      }
    }

    if (!already_added) {
      this.out_of_combat_requests.PushBack(request);

      this.RemoveTimer('waitOutOfCombatTimer');
      this.AddTimer('waitOutOfCombatTimer', 0.1f, true);
    }

    // to return if something was added
    return !already_added;
  }

  timer function waitOutOfCombatTimer(optional delta: float, optional id: Int32) {
    var i: int;

    if (thePlayer.IsInCombat()) {
      return;
    }

    this.RemoveTimer('waitOutOfCombatTimer');


    for (i = 0; i < this.out_of_combat_requests.Size(); i += 1) {
      switch (this.out_of_combat_requests[i]) {
        case OutOfCombatRequest_TROPHY_CUTSCENE:
          // three times because some lootbags can take time to appear
          this.AddTimer('lootTrophiesAndPlayCutscene', 1.5, false);
          this.AddTimer('lootTrophiesAndPlayCutscene', 2.25, false);
          this.AddTimer('lootTrophiesAndPlayCutscene', 3, false);
        break;
      }
    }

    this.out_of_combat_requests.Clear();
  }

  timer function lootTrophiesAndPlayCutscene(optional delta: float, optional id: Int32) {
    var scene: CStoryScene;
    var will_play_cutscene: bool;

    // is set to true only if trophies were picked up
    will_play_cutscene = lootTrophiesInRadius();

    if (will_play_cutscene) {
      LogChannel('modRandomEncounters', "playing out of combat cutscene");
      
      scene = (CStoryScene)LoadResource(
        "dlc\modtemplates\randomencounterreworkeddlc\data\mh_taking_trophy_no_dialogue.w2scene",
        true
      );

      theGame
      .GetStorySceneSystem()
      .PlayScene(scene, "Input");
      
      // Play some oneliners about the trophies
      if (RandRange(10) < 2) {
        REROL_hang_your_head_from_sadle_sync();
      }
      else if (RandRange(10) < 2) {
        REROL_someone_pay_for_trophy_sync();
      }
      else if (RandRange(10) < 2) {
        REROL_good_size_wonder_if_someone_pay_sync();
      }
    }
  }
  //#endregion OutOfCombat action



  event OnDestroyed() {
    var ents: array<CEntity>;
    var i: int;

    LogChannel('modRandomEncounters', "On destroyed called on RER main class");

    theGame.GetEntitiesByTag('RandomEncountersReworked_Entity', ents);

    LogChannel('modRandomEncounters', "found " + ents.Size() + " RER entities");

    for (i = 0; i < ents.Size(); i += 1) {
      ents[i].Destroy();
    }

    // super.OnDestroyed();
  }

  event OnDeath( damageAction : W3DamageAction ) {
    
    LogChannel('modRandomEncounters', "On death called on RER main class");

    // super.OnDeath( damageAction );
  }
}

function getRandomEncounters(out rer_entity: CRandomEncounters): bool {
  var entities : array<CEntity>;

  theGame.GetEntitiesByTag('RandomEncounterTag', entities);
		
  if (entities.Size() == 0) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
    return false;
  }

  rer_entity = (CRandomEncounters)entities[0];

  return true;
}


statemachine class RER_MonsterClue extends W3MonsterClue {

  public var voiceline_type: name;
  default voiceline_type = 'RER_MonsterClue';

  event OnInteraction( actionName : string, activator : CEntity  )
	{
    // NDEBUG("interacting");
		if ( activator == thePlayer && thePlayer.IsActionAllowed( EIAB_InteractionAction ) )
		{
      super.OnInteraction(actionName, activator);

      if (this.GetCurrentStateName() != 'Interacting') {
        this.GotoState('Interacting');
      }
    }
  }
}

state Interacting in RER_MonsterClue {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('RER', "RER_MonsterClue - State Interacting");
    this.start();
  }

  entry function start() {
    this.playOneliner();
    this.playAnimation();

    parent.GotoState('Waiting');
  }

  latent function playOneliner() {
    LogChannel('RER', "voiceline_type = " + parent.voiceline_type);

    switch (parent.voiceline_type) {
      case 'RER_MonsterClueNekker':
        REROL_tracks_a_nekker(true);
        break;

      case 'RER_MonsterClueDrowner':
        REROL_more_drowners(true);
        break;

      case 'RER_MonsterClueGhoul':
        REROL_ghouls_there_is_corpses(true);
        break;

      case 'RER_MonsterClueAlghoul':
        REROL_ghouls_there_is_corpses(true);
        break;

      case 'RER_MonsterClueFiend':
        REROL_a_fiend(true);
        break;

      case 'RER_MonsterClueChort':
        REROL_a_fiend(true);
        break;

      case 'RER_MonsterClueWerewolf':
        REROL_a_werewolf(true);
        break;

      case 'RER_MonsterClueLeshen':
        REROL_a_leshen_a_young_one(true);
        break;

      case 'RER_MonsterClueKatakan':
        REROL_where_is_katakan(true);
        break;

      case 'RER_MonsterClueEkimmara':
        REROL_gotta_be_an_ekimmara(true);
        break;

      case 'RER_MonsterClueElemental':
        REROL_an_earth_elemental(true);
        break;

      case 'RER_MonsterClueGolem':
        REROL_an_earth_elemental(true);
        break;

      case 'RER_MonsterClueGiant':
        REROL_giant_wind_up_here(true);
        break;

      case 'RER_MonsterClueCyclop':
        REROL_giant_wind_up_here(true);
        break;

      case 'RER_MonsterClueGryphon':
        REROL_griffin_this_close_village(true);
        break;

      case 'RER_MonsterClueWyvern':
        REROL_wyvern_wonderful(true);
        break;

      case 'RER_MonsterClueCockatrice':
        REROL_a_cockatrice(true);
        break;

      case 'RER_MonsterClueBasilisk':
        REROL_a_cockatrice(true);
        break;

      case 'RER_MonsterClueForktail':
        REROL_a_flyer_forktail(true);
        break;

      case 'RER_MonsterClueWight':
        REROL_impossible_wight(true);
        break;

      case 'RER_MonsterClueSharley':
        REROL_a_shaelmaar_is_close(true);
        break;

      case 'RER_MonsterClueHag':
        REROL_gotta_be_a_grave_hag(true);
        break;

      case 'RER_MonsterClueFoglet':
        REROL_dealing_with_foglet(true);
        break;

      case 'RER_MonsterClueTroll':
        REROL_a_rock_troll(true);
        break;

      case 'RER_MonsterClueBruxa':
        REROL_bruxa_gotta_be(true);
        break;

      case 'RER_MonsterClueDetlaff':
        REROL_bruxa_gotta_be(true);
        break;

      case 'RER_MonsterClueGarkain':
        REROL_a_garkain(true);
        break;

      case 'RER_MonsterClueFleder':
        // no unique voiceline for the fleder
        REROL_a_garkain(true);
        break;

      case 'RER_MonsterClueNightwraith':
        REROL_a_nightwraith(true);
        break;

      case 'RER_MonsterClueGargoyle':
        REROL_an_earth_elemental(true);
        break;

      case 'RER_MonsterClueKikimore':
        REROL_kikimores_dammit(true);
        break;

      case 'RER_MonsterClueCentipede':
        REROL_what_lured_centipedes(true);
        break;

      case 'RER_MonsterClueWolf':
        REROL_where_did_wolf_prints_come_from(true);
        break;

      case 'RER_MonsterClueBerserker':
        REROL_half_man_half_bear(true);
        break;

      case 'RER_MonsterClueBear':
        REROL_animal_hair(true);
        break;

      case 'RER_MonsterClueBoar':
        REROL_animal_hair(true);
        break;

      case 'RER_MonsterCluePanther':
        REROL_animal_hair(true);
        break;

      case 'RER_MonsterClueSpider':
        REROL_animal_hair(true);
        break;

      case 'RER_MonsterClueWildhunt':
        REROL_the_wild_hunt(true);
        break;

      case 'RER_MonsterClueArachas':
        REROL_an_arachas(true);
        break;

      case 'RER_MonsterClueHarpy':
        REROL_harpy_feather(true);
        break;

      case 'RER_MonsterClueSiren':
        REROL_siren_tracks(true);
        break;

      case 'RER_MonsterClueRotfiend':
        REROL_necrophages_great(true);
        break;

      case 'RER_MonsterClueEndrega':
        REROL_insectoid_excretion(true);
        break;

      case 'RER_MonsterClueEchinops':
        REROL_insectoid_excretion(true);
        break;

      case 'RER_MonsterClueDracolizard':
        REROL_so_its_a_slyzard(true);
        break;

      case 'RER_MonsterClueHuman':
        REROL_well_armed_bandits(true);
        break;

      default:
        REROL_interesting(true);
        break;
    }
  }

  latent function playAnimation() {
    parent.interactionAnim = PEA_ExamineGround;
    parent.PlayInteractionAnimation();
  }
}
function displayRandomEncounterEnabledNotification() {
  theGame
  .GetGuiManager()
  .ShowNotification(
    GetLocStringByKey("option_rer_enabled")
  );
}

function displayRandomEncounterDisabledNotification() {
  theGame
  .GetGuiManager()
  .ShowNotification(
    GetLocStringByKey("option_rer_disabled")
  );
}

function NDEBUG(message: string, optional duration: float) {
  theGame
  .GetGuiManager()
  .ShowNotification(message, duration);
}
// Geralt: Died recently, wonder what killed it
// from "Mysterious Tracks" monster hunt.
// when interacting with a dead fiend.
latent function REROL_died_recently() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\generic_quests\no_mans_land\quest_files\mh107_fiend\scenes\mh107_geralts_oneliners.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "ClueDeadBies");

  Sleep(2.7); // Approved duration
}

// Geralt: Claw marks, bite marks… But no fire damage. Interesting.
latent function REROL_no_dragon() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\generic_quests\skellige\quest_files\mh208_forktail\scenes\mh208_geralt_oneliners.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "NoDragon");

  Sleep(5.270992); // Approved duration
}

// Geralt: Corpses… that's what drew the ghouls.
latent function REROL_what_drew_the_ghouls() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\minor_quests\no_mans_land\quest_files\mq1039_uninvited_guests\scenes\mq1039_geralt_oneliner.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "interaction");

  Sleep(2.933915); // Approved duration
}

// Geralt: So many corpses… And the war's just started.
latent function REROL_so_many_corpses() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\prologue\quest_files\q001_beggining\scenes\q001_0_geralt_comments.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "battlefield_comment");

  Sleep(3.502878); // Approved duration
}

// Geralt: Hm… Wonder where these clues'll lead me…
latent function REROL_wonder_clues_will_lead_me(optional do_not_wait: bool) {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\generic_quests\novigrad\quest_files\mh307_minion\scenes\mh307_02_investigation.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "All_clues_in");

  if (!do_not_wait) {
    Sleep(3.8); // Approved duration
  }
}

// Geralt: What a shitty way to die
latent function REROL_shitty_way_to_die() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests/part_2/quest_files/q106_tower/scenes_pickup/q106_14f_ppl_in_cages.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "Input");

  Sleep(2.6); // Approved duration
}

// Geralt: There you are...
latent function REROL_there_you_are(optional do_not_wait: bool) {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests/part_1/quest_files/q103_daughter/scenes/q103_08f_gameplay_geralt.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "spot_goat_in");

  if (!do_not_wait) {
    Sleep(1.32); // Approved duration
  }
}

// Geralt: That was tough...
latent function REROL_that_was_tough() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(321440, true);

  Sleep(1.155367); // Approved duration
}

// Geralt: Damn… Can't smell a thing. Must've lost the trail.
latent function REROL_cant_smell_a_thing() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(5399670, true);

  Sleep(1.155367); // Approved duration
}

// Geralt: Necrophages, great.
latent function REROL_necrophages_great(optional do_not_wait: bool) {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "dlc/dlc15/data/quests/quest_files/scenes/mq1058_geralt_oneliners.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "NecropphagesComment"); // no typo from me there, the two "p"

  if (!do_not_wait) {
    Sleep(2); // Approved duration
  }
}

// Geralt: The Wild Hunt.
latent function REROL_the_wild_hunt(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(539883, true);

  if (!do_not_wait) {
    Sleep(1.72); // Approved duration
  }
}

// Geralt: Go away or i'll kill you.
latent function REROL_go_or_ill_kill_you() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(476195, true);

  Sleep(2.684654); // Approved duration
}

// Geralt: Air's strange… Like dropping into a deep
// cellar on a hot day… And the mist…
latent function REROL_air_strange_and_the_mist(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1061986, true);

  if (!do_not_wait) {
    Sleep(6.6); // Approved duration
  }
}

// Geralt: Clawed and gnawed. Necrophages fed here… but all the wounds they inflicted are post-mortem.
latent function REROL_clawed_gnawed_not_necrophages() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(470573, true);

  Sleep(7.430004); // Approved duration
}

// Geralt: Wild Hunt killed them.
latent function REROL_wild_hunt_killed_them() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1047779, true);

  Sleep(2.36); // Approved duration
}

// Geralt: Should look around.
latent function REROL_should_look_around(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(397220, true);

  if (!do_not_wait) {
    Sleep(1.390483); // Approved duration
  }
}

// Geralt: Hm… Definitely came through here.
latent function REROL_came_through_here(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(382001, true);

  if (!do_not_wait) {
    Sleep(2.915713); // Approved duration
  }
}

// Geralt: Another victim.
latent function REROL_another_victim() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1002812, true);

  Sleep(1.390316); // Approved duration
}

// Geralt: Miles and miles and miles…
latent function REROL_miles_and_miles_and_miles() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1077634, true);

  Sleep(2.68); // Approved duration
}

// Geralt: I'm gonna hand your head from my sadle
latent function REROL_hang_your_head_from_sadle() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  REROL_hang_your_head_from_sadle_sync();

  Sleep(4); // Approved duration
}
function REROL_hang_your_head_from_sadle_sync() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1192331, true);
}

// Geralt: Someone'll pay for this trophy. No doubt about it.
latent function REROL_someone_pay_for_trophy() {
  REROL_someone_pay_for_trophy_sync();

  Sleep(3); // Approved duration
}
function REROL_someone_pay_for_trophy_sync() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(426514, true);
}

// Geralt: Good size. Wonder if this piece of rot'll get me anything.
latent function REROL_good_size_wonder_if_someone_pay() {
  REROL_good_size_wonder_if_someone_pay_sync();

  Sleep(3.648103); // Approved duration
}
function REROL_good_size_wonder_if_someone_pay_sync() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(376063, true);
}

// Geralt: Ground's splattered with blood for a few feet around. A lot of it.
latent function REROL_ground_splattered_with_blood() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(433486, true);

  Sleep(4.238883); // Approved duration
}

// Geralt: Another trail.
latent function REROL_another_trail() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(382013, true);

  Sleep(3); // Approved duration
}

// Geralt: Monsters… Can feel 'em… Coming closer… They're everywhere.
latent function REROL_monsters_everywhere_feel_them_coming() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(506666, true);

  Sleep(5.902488); // Approved duration
}

// Geralt: Should scour the local notice boards. Someone might've posted a contract for whatever lives here.
latent function REROL_should_scour_noticeboards(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1206920, true);

  if (!do_not_wait) {
    Sleep(10); // Could not find Approved duration
  }
}

// Geralt choice: I'll take the contract.
latent function REROL_ill_take_the_contract() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1181938, true);

  Sleep(5); // Could not find Approved duration
}

// Geralt: Pretty unusual contract…
latent function REROL_unusual_contract() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1154439, true);

  Sleep(5); // Could not find Approved duration
}

// Geralt: All right, time I got to work. Where'll I find this monster?
latent function REROL_where_will_i_find_this_monster() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(551205, true);

  Sleep(3.900127); // Approved duration
}

// Geralt: I'll tend to the monster
latent function REROL_ill_tend_to_the_monster() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1014194, true);

  Sleep(1.773995); // Approved duration
}

// Geralt: I accept the challenge
latent function REROL_i_accept_the_challenge() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1005381, true);

  Sleep(1.93088); // Approved duration
}

// Geralt: Mhm…
latent function REROL_mhm() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1185176, true);

  Sleep(2); // could not find Approved duration
}

// Geralt: It's over.
latent function REROL_its_over() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(485943, true);

  Sleep(2); // could not find Approved duration
}

// Geralt: Mff… Smell of a rotting corpse. Blood spattered all around.
latent function REROL_smell_of_a_rotting_corpse(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(471806, true);

  if (!do_not_wait) {
    Sleep(4.861064); // Approved duration
  }
}

// Geralt: Tracks - a nekker… A big one.
latent function REROL_tracks_a_nekker(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1042065, true);

  if (!do_not_wait) {
    Sleep(3.444402); // Approved duration
  }
}

// Geralt: Ooh. More drowners.
latent function REROL_more_drowners(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1002915, true);

  if (!do_not_wait) {
    Sleep(2.397404); // Approved duration
  }
}

// Geralt: Ghouls… And where there's ghouls… there's usually corpses…
latent function REROL_ghouls_there_is_corpses(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(552454, true);

  if (!do_not_wait) {
    Sleep(4.044985); // Approved duration
  }
}

// Geralt: A fiend.
latent function REROL_a_fiend(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1039017, true);

  if (!do_not_wait) {
    Sleep(1.181657); // Approved duration
  }
}

// Geralt: A werewolf…
latent function REROL_a_werewolf(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(577129, true);

  if (!do_not_wait) {
    Sleep(1.114805); // Approved duration
  }
}

// Geralt: Everything says leshen, a young one. Must've arrived here recently. Need to find its totem.
latent function REROL_a_leshen_a_young_one(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(566287, true);

  if (!do_not_wait) {
    Sleep(6.950611); // Approved duration
  }
}

// Geralt: Where's that damned katakan?
latent function REROL_where_is_katakan(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(569579, true);

  if (!do_not_wait) {
    Sleep(1.694507); // Approved duration
  }
}

// Geralt: Gotta be an ekimmara.
latent function REROL_gotta_be_an_ekimmara(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1038390, true);

  if (!do_not_wait) {
    Sleep(1.589184); // Approved duration
  }
}

// Geralt: An earth elemental. Pretty powerful, too.
latent function REROL_an_earth_elemental(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(573116, true);

  if (!do_not_wait) {
    Sleep(2.965688); // Approved duration
  }
}

// Geralt choice: How'd a giant wind up here?
latent function REROL_giant_wind_up_here(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1167973, true);

  if (!do_not_wait) {
    Sleep(10); // Approved duration
  }
}

// Geralt: So… a griffin this close to the village? Strange.
latent function REROL_griffin_this_close_village(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1048275, true);

  if (!do_not_wait) {
    Sleep(4.37948); // Approved duration
  }
}

// Geralt: Wyvern. Wonderful.
latent function REROL_wyvern_wonderful(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1065583, true);

  if (!do_not_wait) {
    Sleep(2.04); // Approved duration
  }
}

// Geralt: A cockatrice…
latent function REROL_a_cockatrice(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(553797, true);

  if (!do_not_wait) {
    Sleep(2.04); // Approved duration
  }
}

// Geralt: Draconid, gotta be. Maybe a basilisk? Except… these prints don't belong to any variety I know. Just a liiiitle different.
latent function REROL_basilisk_a_little_different(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1170780, true);

  if (!do_not_wait) {
    Sleep(2.04); // Approved duration
  }
}

// Geralt: A flyer, swooped down… Judging by the claw marks, gotta be a wyvern or a forktail.
latent function REROL_a_flyer_forktail(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1034842, true);

  if (!do_not_wait) {
    Sleep(6.459111); // Approved duration
  }
}

// Geralt: Impossible. My brethren hunted down every last spotted wight before I was born.
latent function REROL_impossible_wight(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1179588, true);

  if (!do_not_wait) {
    Sleep(10); // Approved duration
  }
}

// Geralt: Whoa-ho. Shaelmaar's close…
latent function REROL_a_shaelmaar_is_close(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1169885, true);

  if (!do_not_wait) {
    Sleep(10); // Approved duration
  }
}

// Geralt: Gotta be a grave hag.
latent function REROL_gotta_be_a_grave_hag(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1022247, true);

  if (!do_not_wait) {
    Sleep(1.757565); // Approved duration
  }
}

// Geralt: Guess I'm dealing with an old foglet… hiding behind an illusion.
latent function REROL_dealing_with_foglet(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(550020, true);

  if (!do_not_wait) {
    Sleep(3.873405); // Approved duration
  }
}

// Geralt: A rock troll, looks like…
latent function REROL_a_rock_troll(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(579959, true);

  if (!do_not_wait) {
    Sleep(1.767925); // Approved duration
  }
}

// Geralt: Bruxa. Gotta be.
latent function REROL_bruxa_gotta_be(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1194000, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: Venom glands, long claws, a bloodsucker… must be a garkain. A pack leader, an alpha.
latent function REROL_a_garkain(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1176030, true);

  if (!do_not_wait) {
    Sleep(10); // Approved duration
  }
}

// Geralt: A nightwraith…
latent function REROL_a_nightwraith(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1019137, true);

  if (!do_not_wait) {
    Sleep(1.030744); // Approved duration
  }
}

// Geralt: Kikimores. Dammit.
latent function REROL_kikimores_dammit(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1164863, true);

  if (!do_not_wait) {
    Sleep(5); // Approved duration
  }
}

// Geralt: Wonder what lured the giant centipedes.
latent function REROL_what_lured_centipedes(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1200276, true);

  if (!do_not_wait) {
    Sleep(5); // Approved duration
  }
}

// Geralt: Where'd the wolf prints come from?
latent function REROL_where_did_wolf_prints_come_from(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(470770, true);

  if (!do_not_wait) {
    Sleep(1.614695); // Approved duration
  }
}

// Geralt: Half-man, half-bear. Something like a lycanthrope.
latent function REROL_half_man_half_bear(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(587721, true);

  if (!do_not_wait) {
    Sleep(5.995551); // Approved duration
  }
}

// Geralt: Animal hair.
latent function REROL_animal_hair(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1104764, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: An arachas.
latent function REROL_an_arachas(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(521492, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: Harpy feather, a rectrix.
latent function REROL_harpy_feather(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1000722, true);

  if (!do_not_wait) {
    Sleep(2.868078); // Approved duration
  }
}

// Geralt: Siren tracks. A very big siren.
latent function REROL_siren_tracks(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1025599, true);

  if (!do_not_wait) {
    Sleep(3.97284); // Approved duration
  }
}

// Geralt: Interesting.
latent function REROL_interesting(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(376165, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: Insect excretions…
latent function REROL_insectoid_excretion(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(376165, true);

  if (!do_not_wait) {
    Sleep(1.685808); // Approved duration
  }
}

// Geralt: Aha. So it's a slyzard…
latent function REROL_so_its_a_slyzard(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1204696, true);

  if (!do_not_wait) {
    Sleep(5); // Approved duration
  }
}

// Geralt choice: Pretty well armed, those bandits…
latent function REROL_well_armed_bandits(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1178439, true);

  if (!do_not_wait) {
    Sleep(7); // Approved duration
  }
}

// Geralt: Trail ends here.
latent function REROL_trail_ends_here(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1091477, true);

  if (!do_not_wait) {
    Sleep(4); // Approved duration
  }
}

// Geralt: Damn, trail breaks off. Could find something else, though.
latent function REROL_trail_breaks_off(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(525769, true);

  if (!do_not_wait) {
    Sleep(5.24); // Approved duration
  }
}


// Geralt: Hmm, trail goes on. Good thing it doesn't end here.
latent function REROL_trail_goes_on(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(393988, true);

  if (!do_not_wait) {
    Sleep(4.365868); // Approved duration
  }
}

// Geralt choice: Wonder why they split up.
latent function REROL_wonder_they_split(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(568165, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}
class RE_Resources {
  public var blood_splats : array<string>;

  function load_resources() {
    this.load_blood_splats();
  }

  private function load_blood_splats() {
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_big.w2ent");  
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium.w2ent");    
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium_2.w2ent");  
    blood_splats.PushBack("living_world\treasure_hunting\th1003_lynx\entities\generic_clue_blood_splat.w2ent");
  }

                  //////////////////////
                  // PUBLIC FUNCTIONS //
                  //////////////////////

  public latent function getBloodSplatsResources(): array<RER_TrailMakerTrack> {
    var i: int;
    var output: array<RER_TrailMakerTrack>;

    for (i = 0; i < this.blood_splats.Size(); i += 1) {
      output.PushBack(
        RER_TrailMakerTrack(
          (CEntityTemplate)LoadResourceAsync(
            this.blood_splats[i],
            true
          )
        )
      );
    }

    return output;
  }

  public latent function getCorpsesResources(): array<RER_TrailMakerTrack> {
    var corpse_resources: array<RER_TrailMakerTrack>;

    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_01.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_03.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_05.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_06.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_02_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_03_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_04_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_05_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_06_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_07_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_08_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_01_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_02_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_03_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_04_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_05_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_06_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_07_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_01_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_02_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_03_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_04_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_05_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_01.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_02.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_03.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_01.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_02.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_03.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_04.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_05.w2ent", true)));

    return corpse_resources;
  }

  public latent function getPortalResource(): CEntityTemplate {
    var entity_template: CEntityTemplate;

    entity_template = (CEntityTemplate)LoadResourceAsync( "gameplay\interactive_objects\rift\rift.w2ent", true);
    
    return entity_template;
  }
}

function isHeartOfStoneActive(): bool {
  return theGame.GetDLCManager().IsEP1Available() && theGame.GetDLCManager().IsEP1Enabled();
}

function isBloodAndWineActive(): bool {
  return theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled();
}


enum RER_CameraTargetType {
  // when you want the camera to target a node, the node can move
  RER_CameraTargetType_NODE = 0,

  // when you want the camera to target a static position
  RER_CameraTargetType_STATIC = 1,

  // when you want the camera to target a bone component, it can move
  RER_CameraTargetType_BONE = 3
}

enum RER_CameraPositionType {
  // the position will be absolute positions
  RER_CameraPositionType_ABSOLUTE = 0,

  // the position will be relative to the camera's current position.
  RER_CameraPositionType_RELATIVE = 1,
}

enum RER_CameraVelocityType {
  // relative to the rotation of the camera
  RER_CameraVelocityType_RELATIVE = 0,

  RER_CameraVelocityType_ABSOLUTE = 1,
  
  RER_CameraVelocityType_FORWARD = 2,
}

struct RER_CameraScene {
  // where the camera is placed
  var position_type: RER_CameraPositionType;
  var position: Vector;

  // where the camera is looking
  var look_at_target_type: RER_CameraTargetType;
  var look_at_target_node: CNode;
  var look_at_target_static: Vector;
  var look_at_target_bone: CAnimatedComponent;

  var duration: float;

  var velocity_type: RER_CameraVelocityType;
  var velocity: Vector;

  // 1 means no blending at all, while 0 means so much blending it won't move at
  // all
  var position_blending_ratio: float;
  var rotation_blending_ratio: float;

  // var deactivation_duration: float;
  // default deactivation_duration = 1.5;

  // var activation_duration: float;
  // default activation_duration = 1.5;
}

class RER_StaticCamera extends CStaticCamera {
  public function start() {
    this.Run();
  }

  public latent function playCameraScenes(scenes: array<RER_CameraScene>) {
    var i: int;
    var current_scene: RER_CameraScene;

    for (i = 0; i < scenes.Size(); i += 1) {
      current_scene = scenes[i];

      playCameraScene(current_scene);
    }
  }

  private function getRotation(scene: RER_CameraScene, current_position: Vector): EulerAngles {
    var current_rotation: EulerAngles;

    switch (scene.look_at_target_type) {
      // TODO:
      // case RER_CameraTargetType_BONE:
      //   this.LookAtBone(scene.look_at_target_bone, scene.duration, scene.blend_time);
      //   break;

      case RER_CameraTargetType_STATIC:
        current_rotation = VecToRotation(scene.look_at_target_static - current_position);
        break;

      case RER_CameraTargetType_NODE:
        current_rotation = VecToRotation(scene.look_at_target_node.GetWorldPosition() - current_position);
        break;
    }

    // because the Pitch (Y axis) is inverted by default
    current_rotation.Pitch *= -1;

    return current_rotation;
  }

  public latent function playCameraScene(scene: RER_CameraScene, optional destroy_after: bool) {
    var current_rotation: EulerAngles;
    var current_position: Vector;

    // this option was added because immersive camera doesn't like the blending 
    // options, and the game would crash.
    if (!theGame.GetInGameConfigWrapper().GetVarValue('RERoptionalFeatures', 'RERcameraBlendingDisabled')
    ||  (thePlayer.IsUsingHorse() || thePlayer.IsInCombat())
    && theGame.GetInGameConfigWrapper().GetVarValue('RERoptionalFeatures', 'RERcameraScenesDisabledOnHorse')) {
      this.deactivationDuration = 1.5;
      this.activationDuration = 1.5;
    }

    this.SetFov(theCamera.GetFov());

    if (scene.position_type == RER_CameraPositionType_RELATIVE) {
      this.TeleportWithRotation(thePlayer.GetWorldPosition() + scene.position, this.getRotation(scene, scene.position));
    }
    else {
      this.TeleportWithRotation(scene.position, this.getRotation(scene, scene.position));
    }

    this.Run();
    Sleep(this.activationDuration);

    // 1. we always start from the camera's position and its rotation
    // only if not relative, because relative position starts from (0, 0, 0)
    // if (scene.position_type != RER_CameraPositionType_RELATIVE) {
    current_position = theCamera.GetCameraPosition();
    // }

    current_rotation = theCamera.GetCameraRotation();

    // 2. then we move the camera there and start running
    this.TeleportWithRotation(current_position, current_rotation);

    // 3. we start looping to animate the camera toward the scene goals
    this.blendToScene(scene, current_position, current_rotation);

    this.Stop();

    // if (destroy_after) {
      // removed because it cancels the blending
      // this.Destroy();
    // }
  }

  private latent function blendToScene(scene: RER_CameraScene, out current_position: Vector, out current_rotation: EulerAngles) {
    var goal_rotation: EulerAngles;
    var starting_time: float;
    var ending_time: float;
    var time_progress: float; // it's a %

    starting_time = theGame.GetEngineTimeAsSeconds();
    ending_time = starting_time + scene.duration;
    while (theGame.GetEngineTimeAsSeconds() < ending_time) {
      time_progress = MinF((theGame.GetEngineTimeAsSeconds() - starting_time) / scene.duration, 0.5);

      // 1 we do the position & rotation blendings
      // 1.1 we do the position blending
      if (scene.position_type == RER_CameraPositionType_RELATIVE) {
        current_position += (thePlayer.GetWorldPosition() + scene.position - current_position) * scene.position_blending_ratio * time_progress;
      }
      else {
        current_position += (scene.position - current_position) * scene.position_blending_ratio * time_progress;
      }

      // 1.2 we do the rotation blending
      goal_rotation = this.getRotation(scene, current_position);
      current_rotation.Roll += AngleNormalize180(goal_rotation.Roll - current_rotation.Roll) * scene.rotation_blending_ratio * time_progress;
      current_rotation.Yaw += AngleNormalize180(goal_rotation.Yaw - current_rotation.Yaw) * scene.rotation_blending_ratio * time_progress;
      current_rotation.Pitch += AngleNormalize180(goal_rotation.Pitch - current_rotation.Pitch) * scene.rotation_blending_ratio * time_progress;

      // 2 we update the goal position using the velocity
      if (scene.velocity_type == RER_CameraVelocityType_ABSOLUTE) {
        scene.position += scene.velocity; // todo: use delta
      } else if (scene.velocity_type == RER_CameraVelocityType_FORWARD) {
        scene.position += VecNormalize(RotForward(current_rotation)) * scene.velocity;
      }
      else if (scene.velocity_type == RER_CameraVelocityType_RELATIVE) {
        scene.position += VecFromHeading(theCamera.GetCameraHeading()) * scene.velocity;
      }

      // 3 we finally teleport the camera
      this.TeleportWithRotation(current_position, current_rotation);
      
      SleepOneFrame();
    }
  }

}


latent function RER_getStaticCamera(): RER_StaticCamera {
  var template: CEntityTemplate;
  var camera: RER_StaticCamera;

  template = (CEntityTemplate)LoadResourceAsync("dlc\modtemplates\randomencounterreworkeddlc\data\rer_static_camera.w2ent", true);
  camera = (RER_StaticCamera)theGame.CreateEntity( template, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

  return camera;
}
class RE_Settings {

  public var is_enabled: bool;
  
  public var customDayMax, customDayMin, customNightMax, customNightMin  : int;
  public var all_monster_hunt_chance_day: int;
  public var all_monster_contract_chance_day: int;
  public var all_monster_ambush_chance_day: int;
  public var all_monster_hunt_chance_night: int;
  public var all_monster_contract_chance_night: int;
  public var all_monster_ambush_chance_night: int;
  public var monster_contract_longevity: float;
  public var enableTrophies : bool;
  public var selectedDifficulty : RER_Difficulty;
  public var enemy_count_multiplier : int;

  public var allow_big_city_spawns: bool;

  // controls whether or not geralt will comment
  // when an encounter appears
  public var geralt_comments_enabled: bool;

  // controls whether or not RER shows notifications
  public var hide_next_notifications: bool;

  // controls whether or not RER encounters will drop loot
  public var enable_encounters_loot: bool;

  // tells how much impact an external factor has on a creature
  // spawning chances.
  public var external_factors_coefficient: float;

  public var minimum_spawn_distance: float;
  public var spawn_diameter: float;
  public var kill_threshold_distance: float;

  public var trophies_enabled_by_encounter: array<bool>;

  // uses the enum EncounterType as the index
  public var crowns_amounts_by_encounter: array<int>;

  public var trophy_pickup_scene: bool;

  public var only_known_bestiary_creatures: bool;

  public var max_level_allowed: int;
  public var min_level_allowed: int;

  public var trophy_price: TrophyVariant;

  public var event_system_interval: float;

  public var foottracks_ratio: int;

  public var use_pathfinding_for_trails: bool;

  public var disable_camera_scenes : bool;

  // scenes that play when ambushed, or when a contract start nearby, etc...
  public var enable_action_camera_scenes : bool;

  function loadXMLSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    if (this.shouldResetRERSettings(inGameConfigWrapper)) {
      LogChannel('modRandomEncounters', 'reset RER settings');
      this.resetRERSettings(inGameConfigWrapper);
    }

    this.loadMainMenuSettings(inGameConfigWrapper);
    this.loadModEnabledSettings(inGameConfigWrapper);
    this.loadMonsterHuntsChances(inGameConfigWrapper);
    this.loadMonsterContractsChances(inGameConfigWrapper);
    this.loadMonsterAmbushChances(inGameConfigWrapper);
    this.loadMonsterContractsLongevity(inGameConfigWrapper);
    this.loadCustomFrequencies(inGameConfigWrapper);

    this.loadDifficultySettings(inGameConfigWrapper);
    this.loadCitySpawnSettings(inGameConfigWrapper);

    this.fillSettingsArrays();
    this.loadTrophiesSettings(inGameConfigWrapper);
    this.loadCrownsSettings(inGameConfigWrapper);
    this.loadGeraltCommentsSettings(inGameConfigWrapper);
    this.loadHideNextNotificationsSettings(inGameConfigWrapper);
    this.loadEnableEncountersLootSettings(inGameConfigWrapper);
    this.loadExternalFactorsCoefficientSettings(inGameConfigWrapper);
    this.loadAdvancedDistancesSettings(inGameConfigWrapper);
    this.loadAdvancedLevelsSettings(inGameConfigWrapper);
    this.loadOnlyKnownBestiaryCreaturesSettings(inGameConfigWrapper);
    this.loadAdvancedEventSystemSettings(inGameConfigWrapper);
    this.loadAdvancedPerformancesSettings(inGameConfigWrapper);
  }

  function loadXMLSettingsAndShowNotification() {
    this.loadXMLSettings();

    theGame
    .GetGuiManager()
    .ShowNotification("Random Encounters Reworked settings loaded");
  }

  private function loadMainMenuSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.enable_action_camera_scenes = inGameConfigWrapper.GetVarValue('RERoptionalFeatures', 'enableActionCameraScenes');
  }

  private function loadDifficultySettings(inGameConfigWrapper: CInGameConfigWrapper) {
    selectedDifficulty = StringToInt(inGameConfigWrapper.GetVarValue('RERmain', 'Difficulty'));
    this.enemy_count_multiplier = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureTypeMultiplier', 'RERenemyCountMultiplier'));
  }

  private function loadGeraltCommentsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.geralt_comments_enabled = inGameConfigWrapper.GetVarValue('RERoptionalFeatures', 'geraltComments');
  }

  private function loadHideNextNotificationsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.hide_next_notifications = inGameConfigWrapper.GetVarValue('RERoptionalFeatures', 'hideNextNotifications');
  }

  private function loadEnableEncountersLootSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.enable_encounters_loot = inGameConfigWrapper.GetVarValue('RERoptionalFeatures', 'enableEncountersLoot');
  }

  private function loadExternalFactorsCoefficientSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.external_factors_coefficient = StringToFloat(
      inGameConfigWrapper.GetVarValue('RERmain', 'externalFactorsImpact')
    );
  }

  private function loadOnlyKnownBestiaryCreaturesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.only_known_bestiary_creatures = inGameConfigWrapper.GetVarValue('RERoptionalFeatures', 'RERonlyKnownBestiaryCreatures');
  }

  private function loadTrophiesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.trophies_enabled_by_encounter[EncounterType_DEFAULT] = inGameConfigWrapper.GetVarValue('RERmonsterTrophies', 'RERtrophiesAmbush');
    this.trophies_enabled_by_encounter[EncounterType_HUNT] = inGameConfigWrapper.GetVarValue('RERmonsterTrophies', 'RERtrophiesHunt');
    this.trophies_enabled_by_encounter[EncounterType_CONTRACT] = inGameConfigWrapper.GetVarValue('RERmonsterTrophies', 'RERtrophiesContract');
    this.trophy_pickup_scene = inGameConfigWrapper.GetVarValue('RERoptionalFeatures', 'RERtrophyPickupAnimation');


    this.trophy_price = StringToInt(inGameConfigWrapper.GetVarValue('RERmonsterTrophies', 'RERtrophiesPrices'));
  }

  private function loadCrownsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.crowns_amounts_by_encounter[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('RERmonsterCrowns', 'RERcrownsAmbush'));
    this.crowns_amounts_by_encounter[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('RERmonsterCrowns', 'RERcrownsHunt'));
    this.crowns_amounts_by_encounter[EncounterType_CONTRACT] = StringToInt(inGameConfigWrapper.GetVarValue('RERmonsterCrowns', 'RERcrownsContract'));
  }

  private function loadCustomFrequencies(inGameConfigWrapper: CInGameConfigWrapper) {
    customDayMax = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'customdFrequencyHigh'));
    customDayMin = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'customdFrequencyLow'));
    customNightMax = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'customnFrequencyHigh'));
    customNightMin = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'customnFrequencyLow'));  
  }

  private function loadMonsterHuntsChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_hunt_chance_day = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersHuntDay', 'allMonsterHuntChanceDay'));
    this.all_monster_hunt_chance_night = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersHuntNight', 'allMonsterHuntChanceNight'));
  }

  private function loadMonsterContractsChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_contract_chance_day = StringToInt(
      inGameConfigWrapper.GetVarValue('RERencountersContractDay', 'allMonsterContractChanceDay')
    );

    this.all_monster_contract_chance_night = StringToInt(
      inGameConfigWrapper.GetVarValue('RERencountersContractNight', 'allMonsterContractChanceNight')
    );
  }

  private function loadMonsterAmbushChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_ambush_chance_day = StringToInt(
      inGameConfigWrapper.GetVarValue('RERencountersAmbushDay', 'allMonsterAmbushChanceDay')
    );

    this.all_monster_ambush_chance_night = StringToInt(
      inGameConfigWrapper.GetVarValue('RERencountersAmbushNight', 'allMonsterAmbushChanceNight')
    );
  }

  private function loadMonsterContractsLongevity(inGameConfigWrapper: CInGameConfigWrapper) {
    this.monster_contract_longevity = StringToFloat(
      inGameConfigWrapper.GetVarValue('RERencountersContractDay', 'RERMonsterContractLongevity')
    );
  }

  private function shouldResetRERSettings(inGameConfigWrapper: CInGameConfigWrapper): bool {
    return !inGameConfigWrapper.GetVarValue('RERmain', 'RERmodInitialized');
  }

  private function loadModEnabledSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.is_enabled = inGameConfigWrapper.GetVarValue('RERmain', 'RERmodEnabled');
  }

  private function resetRERSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    inGameConfigWrapper.ApplyGroupPreset('RERmain', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencounters', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersGeneral', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersConstraints', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersSettlement', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersAmbushDay', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersAmbushNight', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersHuntDay', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersHuntNight', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersContractDay', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencountersContractNight', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERevents', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERoptionalFeatures', 0);
    
    inGameConfigWrapper.SetVarValue('RERmain', 'RERmodInitialized', 1);
    theGame.SaveUserSettings();
  }
  

  private function fillSettingsArrays() {
    var i: int;

    if (this.trophies_enabled_by_encounter.Size() == 0) {
      for (i = 0; i < EncounterType_MAX; i += 1) {
        this.trophies_enabled_by_encounter.PushBack(false);
      }
    }

    if (this.crowns_amounts_by_encounter.Size() == 0) {
      for (i = 0; i < EncounterType_MAX; i += 1) {
        this.crowns_amounts_by_encounter.PushBack(0);
      }
    }
  }

  private function loadAdvancedEventSystemSettings(out inGameConfigWrapper : CInGameConfigWrapper) {
    this.event_system_interval = StringToFloat(inGameConfigWrapper.GetVarValue('RERevents', 'eventSystemInterval'));
  }

  private function loadAdvancedDistancesSettings(out inGameConfigWrapper : CInGameConfigWrapper) {
    this.minimum_spawn_distance   = StringToFloat(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'minSpawnDistance'));
    this.spawn_diameter           = StringToFloat(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'spawnDiameter'));
    this.kill_threshold_distance  = StringToFloat(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'killThresholdDistance'));

    if (this.minimum_spawn_distance < 10 || this.spawn_diameter < 10 || this.kill_threshold_distance < 100) {
      inGameConfigWrapper.ApplyGroupPreset('RERadvancedDistances', 0);

      this.minimum_spawn_distance   = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'minSpawnDistance'));
      this.spawn_diameter           = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'spawnDiameter'));
      this.kill_threshold_distance  = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'killThresholdDistance'));
      theGame.SaveUserSettings();
    }
  }

  private function loadAdvancedLevelsSettings(out inGameConfigWrapper: CInGameConfigWrapper) {
    this.min_level_allowed = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'RERminLevelRange'));
    this.max_level_allowed = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'RERmaxLevelRange'));
  }

  private function loadAdvancedPerformancesSettings(out inGameConfigWrapper : CInGameConfigWrapper) {
    this.foottracks_ratio = 100 / Max(
      StringToInt(inGameConfigWrapper.GetVarValue('RERencountersGeneral', 'RERfoottracksRatio')),
      1
    );
    this.disable_camera_scenes = inGameConfigWrapper.GetVarValue( 'RERoptionalFeatures', 'RERcameraScenesDisabled' );
    this.use_pathfinding_for_trails = inGameConfigWrapper.GetVarValue('RERoptionalFeatures', 'RERtrailsUsePathFinding');
  }

  private function loadCitySpawnSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.allow_big_city_spawns = inGameConfigWrapper.GetVarValue('RERencountersSettlement', 'allowSpawnInBigCities');
  }

  public function toggleEnabledSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    inGameConfigWrapper.SetVarValue(
      'RERmain',
      'RERmodEnabled',
      !this.is_enabled
    );

    theGame.SaveUserSettings();

    this.loadModEnabledSettings(inGameConfigWrapper);
  }
}

// I could not find a better name for it so `SpawnRoller` it is!
// It's a huge list of all entities and a counter for each one
// whenever you want to randomly pick an entity, you call
// one of the roll methods and it gives you a random entity in return.
//
//
// You're maybe asking yourself "why did he make all this?"
// well, the old solution of adding types to an array and picking into the array
// was great until we had to push more than 200 times into the array!
// so much memory write/delete for so little...
// and instead we use much more CPU power, i don't know which is better.
// 
// NOTE: the class currently uses arrays, i could not find a hashmap type/class.
// It would greatly improve performances though...
class SpawnRoller {

  // It uses the enum CreatureType as the index
  // and the value as the counter.
  private var creatures_counters: array<int>;
  private var humans_variants_counters: array<int>;
  
  private var third_party_creatures_counters: array<int>;

  public function fill_arrays() {
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      this.creatures_counters.PushBack(0);
    }

    for (i = 0; i < HT_MAX; i += 1) {
      this.humans_variants_counters.PushBack(0);
    }
  }

  // To use before rolling,
  // set all the counters to 0.
  public function reset() {
    var i: int;
    
    for (i = 0; i < CreatureMAX; i += 1) {
      this.creatures_counters[i] = 0;
    }

    for (i = 0; i < HT_MAX; i += 1) {
      this.humans_variants_counters[i] = 0;
    }
  }

  public function setCreatureCounter(type: CreatureType, count: int) {
    this.creatures_counters[type] = count;
  }

  public function setHumanVariantCounter(type: EHumanType, count: int) {
    this.humans_variants_counters[type] = count;
  }

  public function setThirdPartyCreatureCounter(type: int, count: int) {
    this.third_party_creatures_counters[type] = count;
  }

  public function rollCreatures(optional third_party_creatures_count: int): SpawnRoller_Roll {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;
    var spawn_roll: SpawnRoller_Roll;

    total = 0;

    for (i = 0; i < CreatureMAX; i += 1) {
      total += this.creatures_counters[i];
    }

    for (i = 0; i < third_party_creatures_count; i += 1) {
      total += this.third_party_creatures_counters[i];
    }

    // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
    // added so the user can disable all CreatureType and it would
    // cancel the spawn. Useful when the user wants no spawn during the day.
    if (total <= 0) {
      spawn_roll.type = SpawnRoller_RollTypeCREATURE;
      spawn_roll.roll = CreatureNONE;

      return spawn_roll;
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < CreatureMAX; i += 1) {
      // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
      // `this.creatures_counters[i] > 0` is add so the user can
      // disable a CreatureType completely.
      if (this.creatures_counters[i] > 0 && roll <= current_position + this.creatures_counters[i]) {
        spawn_roll.type = SpawnRoller_RollTypeCREATURE;
        spawn_roll.roll = i;
        
        return spawn_roll;
      }

      current_position += this.creatures_counters[i];
    }

    for (i = 0; i < third_party_creatures_count; i += 1) {
      if (this.third_party_creatures_counters[i] > 0 && roll <= current_position + this.third_party_creatures_counters[i]) {
        spawn_roll.type = SpawnRoller_RollTypeTHIRDPARTY;
        spawn_roll.roll = i;
        
        return spawn_roll;
      }
    }

    // not supposed to get here but hey, who knows.
    spawn_roll.type = SpawnRoller_RollTypeCREATURE;
    spawn_roll.roll = CreatureNONE;

    return spawn_roll;
  }

  public function rollHumansVariants(): EHumanType {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;

    for (i = 0; i < HT_MAX; i += 1) {
      total += this.humans_variants_counters[i];
    }

    // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
    // if for any reason no human variant is available return HT_NONE
    if (total <= 0) {
      return HT_NONE;
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < HT_MAX; i += 1) {
      // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
      // ignore the variants at 0
      if (this.humans_variants_counters[i] > 0 && roll <= current_position + this.humans_variants_counters[i]) {
        return i;
      }

      current_position += this.humans_variants_counters[i];
    }

    // not supposed to get here but hey, who knows.
    return HT_NONE;
  }

}

enum SpawnRoller_RollType {
  SpawnRoller_RollTypeCREATURE = 0,
  SpawnRoller_RollTypeTHIRDPARTY = 1
}

struct SpawnRoller_Roll {
  var type: SpawnRoller_RollType;
  var roll: CreatureType;
}

class RER_StaticEncounterManager {

  var encounters: array<RER_StaticEncounter>;

  var already_spawned_registered_encounters: bool;
  default already_spawned_registered_encounters = false;

  public latent function registerStaticEncounter(master: CRandomEncounters, encounter: RER_StaticEncounter) {
    this.encounters.PushBack(encounter);

    // instantly spawn the encounter if the RER already spawned the registered
    // static encounters
    if (this.already_spawned_registered_encounters) {
      this.trySpawnStaticEncounter(master, encounter);
    }
  }

  /**
   * Returns the amount of encounters spawned
   */
  public latent function spawnStaticEncounters(master: CRandomEncounters): int {
    var encounters_spawn_count: int;
    var has_spawned: bool;
    var i: int;

    encounters_spawn_count = 0;

    for (i = 0; i < this.encounters.Size(); i += 1) {
      has_spawned = this.trySpawnStaticEncounter(master, this.encounters[i]);

      // NDEBUG("has spawned: " + has_spawned);

      if (has_spawned) {
        encounters_spawn_count += 1;
      }
    }

    this.already_spawned_registered_encounters = true;

    return encounters_spawn_count;
  }

  private latent function trySpawnStaticEncounter(master: CRandomEncounters, encounter: RER_StaticEncounter): bool {

    LogChannel('modRandomEncounters', "can spawn?" + encounter.canSpawn());
    if (!encounter.canSpawn()) {
      LogChannel('modRandomEncounters', "can spawn: NO");
      return false;
    }

    LogChannel('modRandomEncounters', "can spawn: YES");

    encounter.bestiary_entry.spawn(
      master,
      encounter.getSpawningPosition(),
      , // count
      , // density
      true, // allow_trophies
    );

    return true;
  }

}

class RER_StaticEncounter {

  var bestiary_entry: RER_BestiaryEntry;

  var position: Vector;

  var region_constraint: RER_RegionConstraint;

  // used to fetch the spawning chance from the menu.
  var type: RER_StaticEncounterType;
  default type = StaticEncounterType_SMALL;

  var radius: float;
  default radius = 0.01;

  public function canSpawn(): bool {
    var entities: array<CGameplayEntity>;
    var current_region: string;
    var i: int;

    current_region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    if (this.region_constraint == RER_RegionConstraint_NO_VELEN && (current_region == "no_mans_land" || current_region == "novigrad")
    ||  this.region_constraint == RER_RegionConstraint_NO_SKELLIGE && (current_region == "skellige" || current_region == "kaer_morhen")
    ||  this.region_constraint == RER_RegionConstraint_NO_TOUSSAINT && current_region == "bob"
    ||  this.region_constraint == RER_RegionConstraint_NO_WHITEORCHARD && current_region == "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_TOUSSAINT && current_region != "bob"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_WHITEORCHARD && current_region != "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_SKELLIGE && current_region != "skellige" && current_region != "kaer_morhen"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_VELEN && current_region != "no_mans_land" && current_region != "novigrad") {
      return false;
    }

    if (!this.rollSpawningChance()) {
      return false;
    }

    // check if the player is nearby, cancel spawn.
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), this.position) < this.radius * this.radius) {
      LogChannel('modRandomEncounters', "StaticEncounter player too close");
      return false;
    }

    // check if an enemy from the `bestiary_entry` is nearby, cancel spawn.
    FindGameplayEntitiesCloseToPoint(
      entities,
      this.position,
      this.radius + 10, // the +10 is to still catch monster on small radius in case they move
      1 * (int)this.radius,
      , // tags
      , // queryflags
      , // target
      'CNewNPC'
    );

    for (i = 0; i < entities.Size(); i += 1) {
      // we found a nearby enemy that is from the same template
      if (this.isTemplateInEntry(entities[i])) {
        LogChannel('modRandomEncounters', "StaticEncounter already spawned");

        return false;
      }
    }

    LogChannel('modRandomEncounters', "StaticEncounter can spawn");

    return true;
  }

  private function isTemplateInEntry(template: string): bool {
    var i: int;

    for (i = 0; i < this.bestiary_entry.template_list.templates.Size(); i += 1) {
      if (this.bestiary_entry.template_list.templates[i].template == template) {
        return true;
      }
    }

    return false;
  }

  public function getSpawningPosition(): Vector {
    var max_attempt_count: int;
    var current_spawn_position: Vector;
    var i: int;

    max_attempt_count = 10;

    for (i = 0; i < max_attempt_count; i += 1) {
      current_spawn_position = this.position
        + VecRingRand(0, this.radius);

      if (getGroundPosition(current_spawn_position, , this.radius)) {
        return current_spawn_position;
      }
    }

    return this.position;
  }

  //
  // return `true` if the roll succeeded, and false if it didn't.
  private function rollSpawningChance(): bool {
    var spawn_chance: float;

    spawn_chance = this.getSpawnChance();

    if (RandRangeF(100) < spawn_chance) {
      return true;
    }

    return false;
  }

  //
  // fetch the spawning chance from the mod menu based on the static encounter type
  private function getSpawnChance(): float {
    var config_wrapper: CInGameConfigWrapper;

    config_wrapper = theGame.GetInGameConfigWrapper();

    if (this.type == StaticEncounterType_LARGE) {
      return StringToFloat(
        config_wrapper
        .GetVarValue('RERencountersGeneral', 'RERstaticEncounterLargeSpawnChance')
      );
    }
    else {
      return StringToFloat(
        config_wrapper
        .GetVarValue('RERencountersGeneral', 'RERstaticEncounterSmallSpawnChance')
      );
    }
  }

}

enum RER_StaticEncounterType {
  StaticEncounterType_SMALL = 0,
  StaticEncounterType_LARGE = 1,
}
struct SEnemyTemplate {
  var template : string;
  var max      : int;
  var count    : int;
  var bestiary_entry: string;
}

function makeEnemyTemplate(template: string, optional max: int, optional count: int, optional bestiary_entry: string): SEnemyTemplate {
  var enemy_template: SEnemyTemplate;

  enemy_template.template = template;
  enemy_template.max = max;
  enemy_template.count = count;
  enemy_template.bestiary_entry = bestiary_entry;

  return enemy_template;
}
 
struct DifficultyFactor {
  var minimum_count_easy: int;
  var maximum_count_easy: int;
  
  var minimum_count_medium: int;
  var maximum_count_medium: int;
  
  var minimum_count_hard: int;
  var maximum_count_hard: int;
}

struct EnemyTemplateList {
  var templates: array<SEnemyTemplate>;
  var difficulty_factor: DifficultyFactor;
}

function mergeEnemyTemplateLists(a, b: EnemyTemplateList): EnemyTemplateList {
  var output: EnemyTemplateList;
  var i: int;

  output.difficulty_factor.minimum_count_easy
    = a.difficulty_factor.minimum_count_easy
    + b.difficulty_factor.minimum_count_easy;

  output.difficulty_factor.maximum_count_easy
    = a.difficulty_factor.maximum_count_easy
    + b.difficulty_factor.maximum_count_easy;
  
  output.difficulty_factor.minimum_count_medium
    = a.difficulty_factor.minimum_count_medium
    + b.difficulty_factor.minimum_count_medium;
  
  output.difficulty_factor.maximum_count_medium 
    = a.difficulty_factor.maximum_count_medium
    + b.difficulty_factor.maximum_count_medium;
  
  output.difficulty_factor.minimum_count_hard
    = a.difficulty_factor.minimum_count_hard
    + b.difficulty_factor.minimum_count_hard;

  output.difficulty_factor.maximum_count_hard
    = a.difficulty_factor.maximum_count_hard
    + b.difficulty_factor.maximum_count_hard;

  for (i = 0; i < a.templates.Size(); i += 1) {
    output.templates.PushBack(a.templates[i]);
  }

  for (i = 0; i < b.templates.Size(); i += 1) {
    output.templates.PushBack(b.templates[i]);
  }

  return output;
}

function getMaximumCountBasedOnDifficulty(out factor: DifficultyFactor, difficulty: RER_Difficulty, optional added_factor: float): int {
  if (added_factor == 0) {
    added_factor = 1;
  }

  if (difficulty >= 2) {
    return FloorF(factor.maximum_count_hard * added_factor);
  }

  if (difficulty >= 1) {
    return FloorF(factor.maximum_count_medium * added_factor);
  }

  return FloorF(factor.maximum_count_easy * added_factor);
}

function getMinimumCountBasedOnDifficulty(out factor: DifficultyFactor, difficulty: RER_Difficulty, optional added_factor: float): int {
  if (added_factor == 0) {
    added_factor = 1;
  }

  if (difficulty >= 2) {
    return FloorF(factor.minimum_count_hard * added_factor);
  }

  if (difficulty >= 1) {
    return FloorF(factor.minimum_count_medium * added_factor);
  }

  return FloorF(factor.minimum_count_easy * added_factor);
}

function rollDifficultyFactor(out factor: DifficultyFactor, difficulty: RER_Difficulty, optional added_factor: float): int {
  if (added_factor == 0) {
    added_factor = 1;
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/34
  // if the selected difficulty is RANDOM, then we randomly pick the difficulty
  if (difficulty == RER_Difficulty_RANDOM) {
    difficulty = RandRange(RER_Difficulty_RANDOM - 1);
  }
  
  return RandRange(
    getMinimumCountBasedOnDifficulty(factor, difficulty, added_factor),
    getMaximumCountBasedOnDifficulty(factor, difficulty, added_factor) + 1  // +1 because RandRange is [min;max[
  );
}

// return true if atleast of the bestiary entries is known.
// if all entries are unknown then return false
latent function bestiaryCanSpawnEnemyTemplateList(template_list: EnemyTemplateList, manager: CWitcherJournalManager): bool {
  // we use a list too avoid loading twice the same journal entry
  var already_checked_journals: array<string>;
  var can_spawn: bool;
	
  var i, j: int;

  var resource : CJournalResource;
	var entryBase : CJournalBase;

  for (i = 0; i < template_list.templates.Size(); i += 1) {
    // 1. first checking if the entry was already checked
    for (j = 0; j < already_checked_journals.Size(); j += 1) {
      // 2. the entry was checked already, we skip it
      if (already_checked_journals[j] == template_list.templates[i].bestiary_entry) {
        continue;
      }
    }

    // 3. check the entry
    can_spawn = bestiaryCanSpawnEnemyTemplate(template_list.templates[i], manager);
    if (can_spawn) {
      return true;
    }

    // 4. entry unknown, add it to the checked list
    already_checked_journals.PushBack(template_list.templates[i].bestiary_entry);
  }

  return false;
}

latent function bestiaryCanSpawnEnemyTemplate(enemy_template: SEnemyTemplate, manager: CWitcherJournalManager): bool {
  var resource : CJournalResource;
	var entryBase : CJournalBase;

  if (enemy_template.bestiary_entry == "") {
    LogChannel('modRandomEncounters', "bestiary entry has no value, returning true");

    return true;
  }

  resource = (CJournalResource)LoadResourceAsync(
    enemy_template.bestiary_entry, true
  );

  if (resource) {
    entryBase = resource.GetEntry();

    if (entryBase) {
      if (manager.GetEntryHasAdvancedInfo(entryBase)) {
        // LogChannel('modRandomEncounters', "bestiary can spawn enemy: " + enemy_template.bestiary_entry + " TRUE");


        return true;
      }
    }
    else {
      // LogChannel('modRandomEncounters', "unknown bestiary entryBase for entry " + enemy_template.bestiary_entry);
    }
  }
  else {
    // LogChannel('modRandomEncounters', "unknown bestiary resource: " + enemy_template.bestiary_entry);
  }

  // LogChannel('modRandomEncounters', "bestiary can spawn enemy: " + enemy_template.bestiary_entry + " FALSE");

  return false;
}


struct RER_TrailMakerTrack {
  var template: CEntityTemplate;
  var monster_clue_type: name;

  // some track templates need a higher trail ratio
  // so when you add a track with a multiplier greater than 1
  // the TrailMaker trail ratio will increased to accomodate.
  // the TrailMaker uses the highest trail_ratio_multiplier among
  // its track lists.
  var trail_ratio_multiplier: float;
  default trail_ratio_multiplier = 1;
}

// the trail maker is class used to create trails of blood or tracks on the
// ground. It handles cases where you must draw a trail from point A to point B,
// or simple cases where you only need one track at a specific location.
//
// It has optimizations where it can draw only 25% of the asked tracks to keep
// performances when drawing GPU heavy trails with fogs. This using a ratio
// where we can say only draw 0.25 or 0.50, etc...
class RER_TrailMaker {

  // tells how many are skipped when drawing a trail. If it is set at `1` then
  // it will draw every track, if set at `2` it will draw every 2 tracks.
  private var trail_ratio: int;
  default trail_ratio = 1;

  private var trail_ratio_index: int;
  default trail_ratio_index = 1;

  public function setTrailRatio(ratio: int) {
    this.trail_ratio = RoundF(ratio * this.getHighestTrailRatioMultiplier());
    this.trail_ratio_index = 1;
  }

  // loops through the tracks and find the highest trail ratio multiplier
  private function getHighestTrailRatioMultiplier(): float {
    var i: int;
    var highest_multiplier: float;

    highest_multiplier = 0;

    for (i = 0; i < this.track_resources.Size(); i += 1) {
      if (this.track_resources[i].trail_ratio_multiplier > highest_multiplier) {
        highest_multiplier = this.track_resources[i].trail_ratio_multiplier;
      }
    }

    return highest_multiplier;
  }

  // an array containing entities for the tracks when
  // using the functions to add a track on the ground
  // it adds one to the array, unless we reached the maximum
  // number of tracks. At this moment we come back to 0 and
  // start using the tracks_index and set tracks_looped  
  // to true to tell we have already reached the maximum once.
  // And now instead of creating a new track Entity we simply
  // move the old one at tracks_index.
  private var tracks_entities: array<RER_MonsterClue>;
  private var tracks_index: int;
  private var tracks_looped: bool;
  default tracks_looped = false;
  
  private var tracks_maximum: int;
  default tracks_maximum = 200;

  public function setTracksMaximum(maximum: int) {
    this.tracks_maximum = maximum;
  }

  private var track_resources: array<RER_TrailMakerTrack>;
  private var track_resources_size: int;

  public function setTrackResources(resources: array<RER_TrailMakerTrack>) {
    this.track_resources.Clear();
    this.track_resources = resources;
    this.track_resources_size = this.track_resources.Size();
  }

  private function getRandomTrackResource(): RER_TrailMakerTrack {
    if (track_resources_size == 1) {
      return this.track_resources[0];
    }

    return this.track_resources[RandRange(this.track_resources_size)];
  }

  public function init(ratio: int, maximum: int, resources: array<RER_TrailMakerTrack>) {
    this.setTrailRatio(ratio);
    this.setTracksMaximum(maximum);
    this.setTrackResources(resources);
  }

  private var last_track_position: Vector;

  public function addTrackHere(position: Vector, optional heading: EulerAngles) {
    var new_entity: RER_MonsterClue;
    var track_resource: RER_TrailMakerTrack;

    if (VecDistanceSquared2D(position, this.last_track_position) < PowF(0.5 * this.trail_ratio, 2)) {
      return;
    }

    this.last_track_position = position;

    if (trail_ratio_index < trail_ratio) {
      trail_ratio_index += 1;

      return;
    }

    trail_ratio_index = 1;

    if (!this.tracks_looped) {
      track_resource = this.getRandomTrackResource();

      new_entity = (RER_MonsterClue)theGame.CreateEntity(
        track_resource.template,
        position,
        heading
      );

      new_entity.voiceline_type = track_resource.monster_clue_type;

      this.tracks_entities.PushBack(new_entity);

      if (this.tracks_entities.Size() == this.tracks_maximum) {
        this.tracks_looped = true;
      }

      return;
    }

    this.tracks_entities[this.tracks_index]
      .TeleportWithRotation(position, RotRand(0, 360));

    this.tracks_index = (this.tracks_index + 1) % this.tracks_maximum;
  }

  public function getLastPlacedTrack(): RER_MonsterClue {
    if (this.tracks_looped) {
      return this.tracks_entities[this.tracks_index];
    }
    
    return this.tracks_entities[this.tracks_entities.Size() - 1];
  }

  // `use_failsage` stops the trail if it drew more than `this.tracks_maximum`
  // tracks. It can be useful if the trail is too long, to avoid a crash
  public latent function drawTrail(
    from: Vector,
    to: Vector,
    destination_radius: float,

    /* set both trails_details parameters or none at all */
    optional trail_details_maker: RER_TrailDetailsMaker,
    optional trail_details_chances: float,

    optional use_failsafe: bool,
    optional use_pathfinding: bool) {

    var total_distance_to_final_point: float;
    var current_track_position: Vector;
    var current_track_translation: Vector;
    var distance_to_final_point: float;
    var final_point_radius: float;
    var number_of_tracks_created: int;
    var distance_left: float; // it's a % going from 100% to 0%
    var volume_path_manager: CVolumePathManager;
    var i: int;

    number_of_tracks_created = 0;
    final_point_radius = destination_radius * destination_radius;
    current_track_position = from;

    total_distance_to_final_point = VecDistanceSquared2D(from, to);
    distance_to_final_point = total_distance_to_final_point;

    if (use_pathfinding) {
      volume_path_manager = theGame.GetVolumePathManager();
    }

    LogChannel('modRandomEncounters', "TrailMaker, drawing trail");

    do {
      // 50 / 100 = 0.5
      // it's a % going from 100% to 0% as we get closer
      distance_left = 1 - (total_distance_to_final_point - distance_to_final_point) / total_distance_to_final_point;

      current_track_translation = VecConeRand(
        VecHeading(to - current_track_position),

        // the closer we get to the final point, the smaller the degrees randomness is
        40 + 50 * distance_left, 

        // the closer we get to the final point, the smaller the distance between
        // tracks is.
        0.5 + distance_left * 0.5,
        1 + 1 * distance_left
      );

      if (use_pathfinding && volume_path_manager.IsPathfindingNeeded(current_track_position, to)) {
        current_track_position = volume_path_manager.GetPointAlongPath(
          current_track_position,
          current_track_position + current_track_translation,
          2
          // 1 + 1 * distance_left
        );

        // LogChannel('RER', " P - tracks position = " + VecToString(current_track_position) + " destination = " + VecToString(to));
      }
      else {
        current_track_position += current_track_translation;
      }


      FixZAxis(current_track_position);

      this.addTrackHere(
        current_track_position,
        VecToRotation(to - current_track_position)
      );

      distance_to_final_point = VecDistanceSquared2D(current_track_position, to);
      number_of_tracks_created += 1;

      if (use_failsafe && number_of_tracks_created >= this.tracks_maximum) {
        break;
      }

      // small chance to add a corpse near the tracks
      if (trail_details_chances > 0 && RandRange(100) < trail_details_chances) {
        trail_details_maker.placeDetailsHere(current_track_position);
      }

      SleepOneFrame();
    } while (distance_to_final_point > final_point_radius);
  }

  public function hidePreviousTracks() {
    var i: int;
    var max: int;
    var where: Vector;

    max = this.tracks_entities.Size();
    where = thePlayer.GetWorldPosition() + VecRingRand(1000, 2000);

    for (i = 0; i < max; i += 1) {
      this.tracks_entities[i].Teleport(where);
    }
  }

  public function clean() {
    var i: int;
    
    for (i = 0; i < this.tracks_entities.Size(); i += 1) {
      this.tracks_entities[i].Destroy();
    }

    this.tracks_entities.Clear();
  }

  event OnDestroyed() {
    this.clean();
  }

}

// the `TrailDetailsMaker` is a class used by the `TrailMaker` class when
// drawing a trail. It is an abstract class with only one method:
//  ```
//    placeDetailsHere(position: Vector)
//  ```
// when drawing a trail there is a chance we add small details among the tracks
// such as corpses, blood around the tracks, a creature, etc... This is what
//  this class is for.
//
// So how should we use it? We create a new class that extends this one and we
// override the method(s). Then when we use the `TrailMaker::drawTrail` we pass
// this new class we just created and that's it.
abstract class RER_TrailDetailsMaker {
  
  // override it
  public latent function placeDetailsHere(position: Vector) {}

}


class RER_CorpseAndBloodTrailDetailsMaker extends RER_TrailDetailsMaker {
  
  // because it creates corpses and blood spills, we must set these to members
  // before using this DetailsMaker
  public var corpse_maker: RER_TrailMaker;
  public var blood_maker: RER_TrailMaker;

  public latent function placeDetailsHere(position: Vector) {
    var number_of_blood_spills: int;
    var current_clue_position: Vector;
    var i: int;

    current_clue_position = position;

    FixZAxis(current_clue_position);

    this
      .corpse_maker
      .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));

    number_of_blood_spills = RandRange(10, 5);

    for (i = 0; i < number_of_blood_spills; i += 1) {
      current_clue_position = position + VecRingRand(0, 1.5);

      FixZAxis(current_clue_position);

      this
        .blood_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }
  }

}
//--- RandomEncounters ---
// Made by Erxv
enum EREZone {
  REZ_UNDEF   = 0,
  REZ_NOSPAWN = 1,
  REZ_SWAMP   = 2,
  REZ_CITY    = 3,
}

class CModRExtra { 
  public function getCustomZone(pos : Vector) : EREZone {
    var zone : EREZone;
    var currentArea : string;
     
    zone = REZ_UNDEF;
    currentArea = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
     
    if (currentArea == "novigrad")
    {
      if ( (pos.X < 730 && pos.X > 290)  && (pos.Y < 2330 && pos.Y > 1630))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 730 && pos.X > 450)  && (pos.Y < 1640 && pos.Y > 1530))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 930 && pos.X > 700)  && (pos.Y < 2080 && pos.Y > 1635))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 1900 && pos.X > 1600)  && (pos.Y < 1200 && pos.Y > 700))
      {
        //zone = "oxenfurt";
        zone = REZ_CITY;
      }
      else if ( (pos.X < 315 && pos.X > 95)  && (pos.Y < 240 && pos.Y > 20))
      {
        //zone = "crows";
        zone = REZ_CITY;
      }
      else if ( (pos.X < 2350 && pos.X > 2200)  && (pos.Y < 2600 && pos.Y > 2450))
      {
        //zone = "HoS Wedding";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < 2255 && pos.X > 2135)  && (pos.Y < 2180 && pos.Y > 2010))
      {
        //zone = "HoS Creepy Mansion";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < 1550 && pos.X > 930)  && (pos.Y < 1320 && pos.Y > 950))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 1400 && pos.X > 940)  && (pos.Y < -460 && pos.Y > -720))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 1790 && pos.X > 1320)  && (pos.Y < -400 && pos.Y > -540))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 2150 && pos.X > 1750)  && (pos.Y < -490 && pos.Y > -1090))
      {
        zone = REZ_SWAMP;
      }
    }
    else if (currentArea == "skellige")
    {
      if ( (pos.X < 30 && pos.X > -290)  && (pos.Y < 790 && pos.Y > 470))
      {
        //zone = "trolde";
        zone = REZ_CITY;
      }
    }
    else if (currentArea == "bob")
    {
      if ( (pos.X < -292 && pos.X > -417)  && (pos.Y < -755 && pos.Y > -872))
      {
        //zone = "corvo";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < -414 && pos.X > -636)  && (pos.Y < -863 && pos.Y > -1088))
      {
        //zone = "tourney";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < -142 && pos.X > -871)  && (pos.Y < -1082 && pos.Y > -1637))
      {
        //zone = "city";
        zone = REZ_CITY;
      }
    } 
    else if (currentArea == "wyzima_castle" || currentArea == "island_of_mist" || currentArea == "spiral")
    {
      zone = REZ_NOSPAWN;
    } 
  
    return zone; 
  }

  private function isNearNoticeboard(radius_check: float): bool {
    var entities: array<CGameplayEntity>;

     // 'W3NoticeBoard' for noticeboards, 'W3FastTravelEntity' for signpost
    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      radius_check, // range
      1, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'W3NoticeBoard'
    );

    return entities.Size() > 0;
  }

  private function isNearGuards(radius_check: float): bool {
    var entities: array<CGameplayEntity>;
    var i: int;

    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      radius_check, // range
      100, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'CNewNPC'
    );

    for (i = 0; i < entities.Size(); i += 1) {
      if (((CNewNPC)entities[i]).GetNPCType() == ENGT_Guard) {
        return true;
      }
    }

    return false;
  }

  public function isPlayerInSettlement(optional radius_check: float): bool {
    var current_area : EAreaName;

    if (radius_check <= 0) {
      radius_check = 50;
    }

    current_area = theGame.GetCommonMapManager().GetCurrentArea();

    // HACK: it can be a great way to see if a settlement is nearby
    // by looking for a noticeboard. Though some settlements don't have
    // any noticeboard.
    if (this.isNearNoticeboard(radius_check)) {
      return true;
    }

    // the .isInSettlement() method doesn't work when is skellige
    // it always returns true.
    if (current_area == AN_Skellige_ArdSkellig) {
      
      return this.isNearGuards(radius_check);
    }
    
    return thePlayer.IsInSettlement();
  }

  public function getRandomHumanTypeByCurrentArea(): EHumanType {
    var current_area: string;
    var spawn_roller: SpawnRoller;

    spawn_roller = new SpawnRoller in this;
    spawn_roller.fill_arrays();
    spawn_roller.reset();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    if (current_area == "prolog_village") {
      spawn_roller.setHumanVariantCounter(HT_BANDIT, 3);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 2);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
    }
    else if (current_area == "skellige") {
      spawn_roller.setHumanVariantCounter(HT_SKELBANDIT, 3);
      spawn_roller.setHumanVariantCounter(HT_SKELBANDIT2, 3);
      spawn_roller.setHumanVariantCounter(HT_SKELPIRATE, 2);
    }
    else if (current_area == "kaer_morhen") {
      spawn_roller.setHumanVariantCounter(HT_BANDIT, 3);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 2);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
    }
    else if (current_area == "novigrad" || current_area == "no_mans_land") {
      spawn_roller.setHumanVariantCounter(HT_NOVBANDIT, 2);
      spawn_roller.setHumanVariantCounter(HT_PIRATE, 2);
      spawn_roller.setHumanVariantCounter(HT_NILFGAARDIAN, 1);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 2);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
      spawn_roller.setHumanVariantCounter(HT_WITCHHUNTER, 1);
    }
    else if (current_area == "bob") {
      spawn_roller.setHumanVariantCounter(HT_NOVBANDIT, 1);
      spawn_roller.setHumanVariantCounter(HT_BANDIT, 4);
      spawn_roller.setHumanVariantCounter(HT_NILFGAARDIAN, 1);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 1);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
    }
    else {
      spawn_roller.setHumanVariantCounter(HT_NOVBANDIT, 1);
      spawn_roller.setHumanVariantCounter(HT_BANDIT, 4);
      spawn_roller.setHumanVariantCounter(HT_NILFGAARDIAN, 1);
      spawn_roller.setHumanVariantCounter(HT_CANNIBAL, 1);
      spawn_roller.setHumanVariantCounter(HT_RENEGADE, 2);
    }

    return spawn_roller.rollHumansVariants();
  }

  public function IsPlayerNearWater() : bool {
    var i, j : int;
    var pos, newPos : Vector;
    var vectors : array<Vector>;
    var world : CWorld;
    var waterDepth : float;

    pos = thePlayer.GetWorldPosition();

    world = theGame.GetWorld();

    for (i = 2; i <= 50; i += 2) {
      vectors = VecSphere(10, i);

      for (j = 0; j < vectors.Size(); j += 1) {
        newPos = pos + vectors[j];
        FixZAxis(newPos);
        waterDepth = world.GetWaterDepth(newPos, true);

        if (waterDepth > 1.0f && waterDepth != 10000.0) {
          return true;
        }
      }
    }

    return false;
  }

  public function IsPlayerInSwamp() : bool {
    var i, j : int;
    var pos, newPos : Vector;
    var vectors : array<Vector>;
    var world : CWorld;
    var waterDepth : float;
    var wetTerrainQuantity : int;

    pos = thePlayer.GetWorldPosition();

    world = theGame.GetWorld();

    wetTerrainQuantity = 0;

    for (i = 2; i <= 50; i += 2) {
      vectors = VecSphere(10, i);
  
      for (j = 0; j < vectors.Size(); j += 1) {
        newPos = pos + vectors[j];
        FixZAxis(newPos);
        waterDepth = world.GetWaterDepth(newPos, true);

        if (waterDepth > 0 && waterDepth < 1.5f) {
          wetTerrainQuantity += 1;
        }
        else {
          wetTerrainQuantity -= 1;
        }
      }
    }

    return wetTerrainQuantity > -300;
  }

  public function IsPlayerInForest() : bool {
		// var entity: CEntity;
    // var forestTrigger: W3ForestTrigger;

    // entity = theGame.GetEntityByTag('forest');		//PFTODO: only one? shouldn't we get all?
		
    // if (entity) {
		// 	forestTrigger = (W3ForestTrigger)entity;
    // }

    // return forestTrigger.IsPlayerInForest();

    // var collision_group_names: array<name>;
    // var hit_entities: array<CEntity>;
    // var number_of_hit_entities: int;
    // var radius: float;

    // radius = 100;

    // collision_group_names.PushBack('Foliage');
    
    // number_of_hit_entities = theGame
    //   .GetWorld()
    //   .SphereOverlapTest(hit_entities, thePlayer.GetWorldPosition(), radius, collision_group_names);

    // LogChannel('modRandomEncounters', "number of hit foliage = " + number_of_hit_entities + hit_entities.Size());

    // return number_of_hit_entities > 5;

    var cg : array<name>;
    var i, j, k : int;
    var compassPos : array<Vector>;
    var angles : array<int>;
    var angle : int;
    var vectors : array<Vector>;
    var tracePosStart, tracePosEnd : Vector;
    var material : name;
    var component : CComponent;
    var outPos, normal : Vector;
    var angularQuantity, totalQuantity : int;
    var lastPos : Vector;
    var skip : bool;
    var skipIdx : int;

    cg.PushBack('Foliage');

    compassPos = VecSphere(90, 20);
    compassPos.Insert(0, thePlayer.GetWorldPosition());

    for (i = 1; i < compassPos.Size(); i += 1) {
      compassPos[i] = compassPos[0] + compassPos[i];
      FixZAxis(compassPos[i]);
      compassPos[i].Z += 10;
    }

    compassPos[0].Z += 10;

    angles.PushBack(0);
    angles.PushBack(90);
    angles.PushBack(180);
    angles.PushBack(270);

    totalQuantity = 0;

    skip = false;
    skipIdx = -1;

    for (i = 0; i < compassPos.Size(); i += 1) {
      for (j = 0; j < angles.Size(); j += 1) {
        angularQuantity = 0;
        angle = angles[j];
        vectors = VecArc(angle, angle+90, 5, 25);

        for (k = 0; k < vectors.Size(); k += 1) {
          tracePosStart = compassPos[i];
          tracePosEnd = tracePosStart;
          tracePosEnd.Z -= 10;
          tracePosEnd = tracePosEnd + vectors[k];
          FixZAxis(tracePosEnd);
          tracePosEnd.Z += 10;

          if (theGame.GetWorld().StaticTraceWithAdditionalInfo(tracePosStart, tracePosEnd, outPos, normal, material, component, cg)) {
            if (material == 'default' && !component) {
              if (VecDistanceSquared(lastPos, outPos) > 10) {
                lastPos = outPos;
                angularQuantity += 1;
                totalQuantity += 1;
              }
            }
          }
        }

        if (angularQuantity < 1) {
          if (i > 0 && (!skip || skipIdx == i)) {
            skip = true;
            skipIdx = i;
          }
          else {
            continue;
            // return false;
          }
        }
      }
    }

    LogChannel('modRandomEncounters', "number of hit foliage = " + totalQuantity);


    return totalQuantity > 10;
  }
}


function FixZAxis(out pos : Vector) {
  var world : CWorld;
  var z : float;

  world = theGame.GetWorld();

  if (world.NavigationComputeZ(pos, pos.Z - 128, pos.Z + 128, z)) {
    pos.Z = z;
  }

  if (world.PhysicsCorrectZ(pos, z)) {
    pos.Z = z;
  }
}

function VecArc(angleStart : int, angleEnd : int, angleStep : int, radius : float) : array<Vector> {
  var i : int;
  var angle : float;
  var v : Vector;
  var vectors: array<Vector>;

  for (i = angleStart; i < angleEnd; i += angleStep)
  {
      angle = Deg2Rad(i);
      v = Vector(radius * CosF(angle), radius * SinF(angle), 0.0, 1.0);
      vectors.PushBack(v);
  }

  return vectors;
}

function VecSphere(angleStep : int, radius : float) : array<Vector> {
  var i : int;
  var angle : float;
  var v : Vector;
  var vectors: array<Vector>;

  for (i = 0; i < 360; i += angleStep)
  {
      angle = Deg2Rad(i);
      v = Vector(radius * CosF(angle), radius * SinF(angle), 0.0, 1.0);
      vectors.PushBack(v);
  }

  return vectors;
}

class RER_Bestiary {
  var entries: array<RER_BestiaryEntry>;
  var human_entries: array<RER_BestiaryEntry>;

  public function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;
    var i: int;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    for (i = 0; i < this.entries.Size(); i += 1) {
      this.entries[i].loadSettings(inGameConfigWrapper);
    }

    for (i = 0; i < this.human_entries.Size(); i += 1) {
      this.human_entries[i].loadSettings(inGameConfigWrapper);
    }
  }

  public latent function getRandomEntryFromBestiary(master: CRandomEncounters, encounter_type: EncounterType): RER_BestiaryEntry {
    var creatures_preferences: RER_CreaturePreferences;
    var spawn_roll: SpawnRoller_Roll;
    var manager : CWitcherJournalManager;
    var can_spawn_creature: bool;
    var i: int;

    master.spawn_roller.reset();

    creatures_preferences = new RER_CreaturePreferences in this;
    creatures_preferences
      .setIsNight(theGame.envMgr.IsNight())
      .setExternalFactorsCoefficient(master.settings.external_factors_coefficient)
      .setIsNearWater(master.rExtra.IsPlayerNearWater())
      .setIsInForest(master.rExtra.IsPlayerInForest())
      .setIsInSwamp(master.rExtra.IsPlayerInSwamp())
      .setCurrentRegion(AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea()))
      .setIsInCity(master.rExtra.isPlayerInSettlement() || master.rExtra.getCustomZone(thePlayer.GetWorldPosition()) == REZ_CITY);

    for (i = 0; i < CreatureMAX; i += 1) {
      this.entries[i]
        .setCreaturePreferences(creatures_preferences, encounter_type)
        .fillSpawnRoller(master.spawn_roller);
    }

    for (i = 0; i < this.third_party_entries.Size(); i += 1) {
      this.third_party_entries[i]
        .setCreaturePreferences(creatures_preferences, encounter_type)
        .fillSpawnRollerThirdParty(master.spawn_roller);
    }

    // when the option "Only known bestiary creatures" is ON
    // we remove every unknown creatures from the spawning pool
    if (master.settings.only_known_bestiary_creatures) {
      manager = theGame.GetJournalManager();

      for (i = 0; i < CreatureMAX; i += 1) {
        can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(this.entries[i].template_list, manager);
        
        if (!can_spawn_creature) {
          master.spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    spawn_roll = master.spawn_roller.rollCreatures(this.third_party_creature_counter);

    if (spawn_roll.roll == CreatureNONE) {
      return new RER_BestiaryEntryNull in this;
    }

    if (spawn_roll.type == SpawnRoller_RollTypeCREATURE && spawn_roll.roll == CreatureHUMAN) {
      return this.human_entries[master.rExtra.getRandomHumanTypeByCurrentArea()];
    }

    if (spawn_roll.type == SpawnRoller_RollTypeCREATURE) {
     return this.entries[spawn_roll.roll];
    }

    return this.third_party_entries[spawn_roll.roll];
  }

  public function doesAllowCitySpawns(): bool {
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      if (this.entries[i].city_spawn) {
        return true;
      }
    }

    return false;
  }

  public function init() {
    var empty_entry: RER_BestiaryEntry;
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      this.entries.PushBack(empty_entry);
    }

    for (i = 0; i < HT_MAX; i += 1) {
      this.human_entries.PushBack(empty_entry);
    }

    this.entries[CreatureALGHOUL] = new RER_BestiaryAlghoul in this;
    this.entries[CreatureARACHAS] = new RER_BestiaryArachas in this;
    this.entries[CreatureBARGHEST] = new RER_BestiaryBarghest in this;
    this.entries[CreatureBASILISK] = new RER_BestiaryBasilisk in this;
    this.entries[CreatureBEAR] = new RER_BestiaryBear in this;
    this.entries[CreatureBERSERKER] = new RER_BestiaryBerserker in this;
    this.entries[CreatureBOAR] = new RER_BestiaryBoar in this;
    this.entries[CreatureBRUXA] = new RER_BestiaryBruxa in this;
    // this.entries[CreatureBRUXACITY] = new RER_BestiaryBruxacity in this;
    this.entries[CreatureCENTIPEDE] = new RER_BestiaryCentipede in this;
    this.entries[CreatureCHORT] = new RER_BestiaryChort in this;
    this.entries[CreatureCOCKATRICE] = new RER_BestiaryCockatrice in this;
    this.entries[CreatureCYCLOP] = new RER_BestiaryCyclop in this;
    this.entries[CreatureDETLAFF] = new RER_BestiaryDetlaff in this;
    this.entries[CreatureDRACOLIZARD] = new RER_BestiaryDracolizard in this;
    this.entries[CreatureDROWNER] = new RER_BestiaryDrowner in this;
    this.entries[CreatureECHINOPS] = new RER_BestiaryEchinops in this;
    this.entries[CreatureEKIMMARA] = new RER_BestiaryEkimmara in this;
    this.entries[CreatureELEMENTAL] = new RER_BestiaryElemental in this;
    this.entries[CreatureENDREGA] = new RER_BestiaryEndrega in this;
    this.entries[CreatureFIEND] = new RER_BestiaryFiend in this;
    this.entries[CreatureFLEDER] = new RER_BestiaryFleder in this;
    this.entries[CreatureFOGLET] = new RER_BestiaryFogling in this;
    this.entries[CreatureFORKTAIL] = new RER_BestiaryForktail in this;
    this.entries[CreatureGARGOYLE] = new RER_BestiaryGargoyle in this;
    this.entries[CreatureGARKAIN] = new RER_BestiaryGarkain in this;
    this.entries[CreatureGHOUL] = new RER_BestiaryGhoul in this;
    this.entries[CreatureGIANT] = new RER_BestiaryGiant in this;
    this.entries[CreatureGOLEM] = new RER_BestiaryGolem in this;
    this.entries[CreatureDROWNERDLC] = new RER_BestiaryGravier in this;
    this.entries[CreatureGRYPHON] = new RER_BestiaryGryphon in this;
    this.entries[CreatureHAG] = new RER_BestiaryHag in this;
    this.entries[CreatureHARPY] = new RER_BestiaryHarpy in this;
    this.entries[CreatureHUMAN] = new RER_BestiaryHuman in this;
    this.entries[CreatureKATAKAN] = new RER_BestiaryKatakan in this;
    this.entries[CreatureKIKIMORE] = new RER_BestiaryKikimore in this;
    this.entries[CreatureLESHEN] = new RER_BestiaryLeshen in this;
    this.entries[CreatureNEKKER] = new RER_BestiaryNekker in this;
    this.entries[CreatureNIGHTWRAITH] = new RER_BestiaryNightwraith in this;
    this.entries[CreatureNOONWRAITH] = new RER_BestiaryNoonwraith in this;
    this.entries[CreaturePANTHER] = new RER_BestiaryPanther in this;
    this.entries[CreatureROTFIEND] = new RER_BestiaryRotfiend in this;
    this.entries[CreatureSHARLEY] = new RER_BestiarySharley in this;
    this.entries[CreatureSIREN] = new RER_BestiarySiren in this;
    this.entries[CreatureSKELBEAR] = new RER_BestiarySkelbear in this;
    this.entries[CreatureSKELETON] = new RER_BestiarySkeleton in this;
    this.entries[CreatureSKELTROLL] = new RER_BestiarySkeltroll in this;
    this.entries[CreatureSKELWOLF] = new RER_BestiarySkelwolf in this;
    this.entries[CreatureSPIDER] = new RER_BestiarySpider in this;
    this.entries[CreatureTROLL] = new RER_BestiaryTroll in this;
    this.entries[CreatureWEREWOLF] = new RER_BestiaryWerewolf in this;
    this.entries[CreatureWIGHT] = new RER_BestiaryWight in this;
    this.entries[CreatureWILDHUNT] = new RER_BestiaryWildhunt in this;
    this.entries[CreatureWOLF] = new RER_BestiaryWolf in this;
    this.entries[CreatureWRAITH] = new RER_BestiaryWraith in this;
    this.entries[CreatureWYVERN] = new RER_BestiaryWyvern in this;

    this.human_entries[HT_BANDIT] = new RER_BestiaryHumanBandit in this;
    this.human_entries[HT_CANNIBAL] = new RER_BestiaryHumanCannibal in this;
    this.human_entries[HT_NILFGAARDIAN] = new RER_BestiaryHumanNilf in this;
    this.human_entries[HT_NOVBANDIT] = new RER_BestiaryHumanNovbandit in this;
    this.human_entries[HT_PIRATE] = new RER_BestiaryHumanPirate in this;
    this.human_entries[HT_RENEGADE] = new RER_BestiaryHumanRenegade in this;
    this.human_entries[HT_SKELBANDIT2] = new RER_BestiaryHumanSkel2bandit in this;
    this.human_entries[HT_SKELBANDIT] = new RER_BestiaryHumanSkelbandit in this;
    this.human_entries[HT_SKELPIRATE] = new RER_BestiaryHumanSkelpirate in this;
    this.human_entries[HT_WITCHHUNTER] = new RER_BestiaryHumanWhunter in this;

    for (i = 0; i < CreatureMAX; i += 1) {
      this.entries[i].init();
    }

    for (i = 0; i < HT_MAX; i += 1) {
      this.human_entries[i].init();
    }
  }




  //#region 3rd party code
  // everything in here is code to handle third party encounters/creatures in 
  // the bestiary

  private var third_party_creature_counter: int;
  default third_party_creature_counter = 0;
  
  public function getThirdPartyCreatureId(): int {
    var chosen_id: int;

    this.third_party_creature_counter = chosen_id;
    this.third_party_creature_counter += 1;

    return chosen_id;
  }

  var third_party_entries: array<RER_BestiaryEntry>;

  public function addThirdPartyCreature(third_party_id: int, bestiary_entry: RER_BestiaryEntry) {
    if (this.hasThirdPartyCreature(third_party_id)) {
      LogChannel('modRandomEncounters', "3rd party creature with id [" + third_party_id + "], name [" + bestiary_entry.menu_name + "] denied because id already exists");
      
      return;
    }

    this.third_party_entries.PushBack(bestiary_entry);
  }

  public function hasThirdPartyCreature(third_party_id: int): bool {
    var i: int;

    for (i = 0; i < this.third_party_entries.Size(); i += 1) {
      if (this.third_party_entries[i].type == third_party_id) {
        return true;
      }
    }

    return false;
  }

  //#endregion 3rd party code







}
abstract class RER_BestiaryEntry {
  var type: CreatureType;

  var template_list: EnemyTemplateList;

  // names for this entity trophies
  // uses the enum TrophyVariant as index
  var trophy_names: array<name>;

  // the name used in the mod menus
  var menu_name: name;

  // both use the enum EncounterType as index
  var chances_day: array<int>;
  var chances_night: array<int>;

  // the custom multiplier the user set for this specific creature type. By default
  // it's set at 1.
  var creature_type_multiplier: float;
  default creature_type_multiplier = 1;

  var trophy_chance: float;

  var crowns_percentage: float;

  var region_constraint: RER_RegionConstraint;

  var city_spawn: bool;

  public function init() {}

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences {
    return preferences
      .setCreatureType(this.type)
      .setChances(this.chances_day[encounter_type], this.chances_night[encounter_type])
      .setCitySpawnAllowed(this.city_spawn)
      .setRegionConstraint(this.region_constraint);
  }

  public function loadSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    var i: int;

    this.city_spawn = inGameConfigWrapper.GetVarValue('RERencountersSettlement', this.menu_name);
    this.trophy_chance = StringToInt(inGameConfigWrapper.GetVarValue('RERmonsterTrophies', this.menu_name));
    this.region_constraint = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersConstraints', this.menu_name));

    this.chances_day.Clear();
    this.chances_night.Clear();

    for (i = 0; i < EncounterType_MAX; i += 1) {
      this.chances_day.PushBack(0);
      this.chances_night.PushBack(0);
    }

    this.chances_day[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersAmbushDay', this.menu_name));
    this.chances_night[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersAmbushNight', this.menu_name));
    this.chances_day[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersHuntDay', this.menu_name));
    this.chances_night[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersHuntNight', this.menu_name));
    this.chances_day[EncounterType_CONTRACT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersContractDay', this.menu_name));
    this.chances_night[EncounterType_CONTRACT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersContractNight', this.menu_name));
    this.creature_type_multiplier = StringToFloat(inGameConfigWrapper.GetVarValue('RERcreatureTypeMultiplier', this.menu_name));
    this.crowns_percentage = StringToFloat(inGameConfigWrapper.GetVarValue('RERmonsterCrowns', this.menu_name)) / 100.0f;

    // LogChannel('modRandomEncounters', "settings " + this.menu_name + " = " + this.city_spawn + " - " + this.trophy_chance + " " + this.chance_day + " " + this.region_constraint + " " );
  }

  public function isNull(): bool {
    return this.type == CreatureNONE;
  }

  public latent function spawn(master: CRandomEncounters, position: Vector, optional count: int, optional density: float, optional allow_trophies: bool, optional encounter_type: EncounterType): array<CEntity> {
    var creatures_templates: EnemyTemplateList;
    var group_positions: array<Vector>;
    var current_template: CEntityTemplate;
    var current_entity_template: SEnemyTemplate;
    var current_rotation: EulerAngles;
    var created_entity: CEntity;
    var created_entities: array<CEntity>;
    var group_positions_index: int;
    var i: int;
    var j: int;

    if (count == 0) {
      count = rollDifficultyFactor(
        this.template_list.difficulty_factor,
        master.settings.selectedDifficulty,
        master.settings.enemy_count_multiplier * this.creature_type_multiplier
      );
    }

    if (density <= 0) {
      density = 0.01;
    }

    LogChannel('RER', "BestiaryEntry, spawn() count = " + count);

    creatures_templates = fillEnemyTemplateList(
      this.template_list,
      count,
      master.settings.only_known_bestiary_creatures
    );

    group_positions = getGroupPositions(
      position,
      count,
      density
    );

    group_positions_index = 0;

    for (i = 0; i < creatures_templates.templates.Size(); i += 1) {
      current_entity_template = creatures_templates.templates[i];

      if (current_entity_template.count > 0) {
        current_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);
        current_rotation = VecToRotation(VecRingRand(1, 2));

        FixZAxis(group_positions[group_positions_index]);

        for (j = 0; j < current_entity_template.count; j += 1) {
          created_entity = theGame.CreateEntity(
            current_template,
            group_positions[group_positions_index],
            current_rotation
          );

          ((CNewNPC)created_entity).SetLevel(
            getRandomLevelBasedOnSettings(master.settings)
          );

          if (allow_trophies && RandRange(100) < this.trophy_chance) {
            LogChannel('modRandomEncounters', "adding 1 trophy " + this.type);
            
            ((CActor)created_entity)
              .GetInventory()
              .AddAnItem(
                this.trophy_names[master.settings.trophy_price],
                1
              );
          }

          // add crowns to the entity, based on the settings
          ((CActor)created_entity)
          .GetInventory()
          .AddMoney(
            (int)(
              master.settings.crowns_amounts_by_encounter[encounter_type]
              * this.crowns_percentage
              * RandRangeF(1.2, 0.8) // a random value between 80% and 120%
            )
          );

          if (!master.settings.enable_encounters_loot) {
            ((CActor)created_entity)
              .GetInventory()
              .EnableLoot(false);
          }

          created_entities.PushBack(created_entity);

          group_positions_index += 1;
        }
      }
    }

    return created_entities;
  }
}

class RER_BestiaryEntryNull extends RER_BestiaryEntry {
  default type = CreatureNONE;

  public function isNull(): bool {
    return true;
  }
}
class RER_BestiaryAlghoul extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureALGHOUL;
    this.menu_name = 'Alghouls';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // dark
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl2.w2ent", 3,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // dark reddish
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl3.w2ent", 2,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // greyish
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl4.w2ent", 1,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__miscreant_greater.w2ent",,,
      "gameplay\journal\bestiary\bestiarymiscreant.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 2;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 3;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryArachas extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureARACHAS;
    this.menu_name = 'Arachas';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\arachas_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarycrabspider.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\arachas_lvl2__armored.w2ent", 2,,
        "gameplay\journal\bestiary\armoredarachas.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\arachas_lvl3__poison.w2ent", 2,,
        "gameplay\journal\bestiary\poisonousarachas.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 2;
      this.template_list.difficulty_factor.minimum_count_medium = 2;
      this.template_list.difficulty_factor.maximum_count_medium = 3;
      this.template_list.difficulty_factor.minimum_count_hard = 3;
      this.template_list.difficulty_factor.maximum_count_hard = 4;

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryBarghest extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBARGHEST;
    this.menu_name = 'Barghest';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\barghest.w2ent",,,
      "dlc\bob\journal\bestiary\barghests.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 2;
    this.template_list.difficulty_factor.minimum_count_hard = 2;
    this.template_list.difficulty_factor.maximum_count_hard = 2;

  

    this.trophy_names.PushBack('modrer_spirit_trophy_low');
    this.trophy_names.PushBack('modrer_spirit_trophy_medium');
    this.trophy_names.PushBack('modrer_spirit_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp);
  }
}

class RER_BestiaryBasilisk extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBASILISK;
    this.menu_name = 'Basilisk';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\basilisk_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarybasilisk.journal"
        )
      );
    
    if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
      this.template_list.templates.PushBack(
        makeEnemyTemplate(
          "dlc\bob\data\characters\npc_entities\monsters\basilisk_white.w2ent",,,
          "dlc\bob\journal\bestiary\mq7018basilisk.journal"
        )
      );
    }

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_basilisk_trophy_low');
    this.trophy_names.PushBack('modrer_basilisk_trophy_medium');
    this.trophy_names.PushBack('modrer_basilisk_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryBear extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBEAR;
    this.menu_name = 'Bears';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\bear_lvl1__black.w2ent",,,
        "gameplay\journal\bestiary\bear.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\bear_lvl2__grizzly.w2ent",,,
        "gameplay\journal\bestiary\bear.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\bear_lvl3__grizzly.w2ent",,,
        "gameplay\journal\bestiary\bear.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 2;

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryBerserker extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBERSERKER;
    this.menu_name = 'Berserkers';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\bear_berserker_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bear.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 2;

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryBoar extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBOAR;
    this.menu_name = 'Boars';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\wild_boar_ep1.w2ent",,,
      "dlc\bob\journal\bestiary\ep2boar.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 2;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryBruxa extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBRUXA;
    this.menu_name = 'Bruxa';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa.w2ent",,,
      "dlc\bob\journal\bestiary\bruxa.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_alp.w2ent",,,
      "dlc\bob\journal\bestiary\alp.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_vampire_trophy_low');
    this.trophy_names.PushBack('modrer_vampire_trophy_medium');
    this.trophy_names.PushBack('modrer_vampire_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryBruxacity extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureBRUXA;
    this.menu_name = 'Bruxacity';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent",,,
      "dlc\bob\journal\bestiary\alp.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent",,,
      "dlc\bob\journal\bestiary\bruxa.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_vampire_trophy_low');
    this.trophy_names.PushBack('modrer_vampire_trophy_medium');
    this.trophy_names.PushBack('modrer_vampire_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryCentipede extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureCENTIPEDE;
    this.menu_name = 'Centipede';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\scolopendromorph.w2ent",,,
      "dlc\bob\journal\bestiary\scolopedromorph.journal"
    )
  ); //worm
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\mq7023_albino_centipede.w2ent",,,
      "dlc\bob\journal\bestiary\scolopedromorph.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 2;
    this.template_list.difficulty_factor.minimum_count_hard = 2;
    this.template_list.difficulty_factor.maximum_count_hard = 3;

  

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryChort extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureCHORT;
    this.menu_name = 'Chorts';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\czart_lvl1.w2ent",,,
        "gameplay\journal\bestiary\czart.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_fiend_trophy_low');
    this.trophy_names.PushBack('modrer_fiend_trophy_medium');
    this.trophy_names.PushBack('modrer_fiend_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp);
  }
}

class RER_BestiaryCockatrice extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureCOCKATRICE;
    this.menu_name = 'Cockatrice';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\cockatrice_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarycockatrice.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_cockatrice_trophy_low');
    this.trophy_names.PushBack('modrer_cockatrice_trophy_medium');
    this.trophy_names.PushBack('modrer_cockatrice_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryCyclop extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureCYCLOP;
    this.menu_name = 'Cyclops';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\cyclop_lvl1.w2ent",,,
        "gameplay\journal\bestiary\cyclops.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\ice_giant.w2ent",,,
        "gameplay\journal\bestiary\icegiant.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_cyclop_trophy_low');
    this.trophy_names.PushBack('modrer_cyclop_trophy_medium');
    this.trophy_names.PushBack('modrer_cyclop_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryDetlaff extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureDETLAFF;
    this.menu_name = 'HigherVamp';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\dettlaff_vampire.w2ent", 1,,
      "dlc\bob\journal\bestiary\dettlaffmonster.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_vampire_trophy_low');
    this.trophy_names.PushBack('modrer_vampire_trophy_medium');
    this.trophy_names.PushBack('modrer_vampire_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addDislikedBiome(BiomeForest);
  }
}

class RER_BestiaryDracolizard extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureDRACOLIZARD;
    this.menu_name = 'Dracolizards';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\oszluzg_young.w2ent",,,
        "dlc\bob\journal\bestiary\dracolizard.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_dracolizard_trophy_low');
    this.trophy_names.PushBack('modrer_dracolizard_trophy_medium');
    this.trophy_names.PushBack('modrer_dracolizard_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryDrowner extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureDROWNER;
    this.menu_name = 'Drowners';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl1.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // drowner
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl2.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // drowner
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl3.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // pink drowner
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl4__dead.w2ent", 2,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 5;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeSwamp)
    .addOnlyBiome(BiomeWater);
  }
}

class RER_BestiaryEchinops extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureECHINOPS;
    this.menu_name = 'Echinops';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_hard.w2ent", 1,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_normal.w2ent",,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_normal_lw.w2ent",,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent", 1,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 2;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 3;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryEkimmara extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureEKIMMARA;
    this.menu_name = 'Ekimmara';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_ekima_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryekkima.journal"
    )
  );    // white vampire

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_ekimmara_trophy_low');
    this.trophy_names.PushBack('modrer_ekimmara_trophy_medium');
    this.trophy_names.PushBack('modrer_ekimmara_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryElemental extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureELEMENTAL;
    this.menu_name = 'Elementals';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );      // earth elemental        
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );      // stronger and cliffier elemental
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl3__ice.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );

  if(theGame.GetDLCManager().IsEP2Available()  &&   theGame.GetDLCManager().IsEP2Enabled()){
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\mq7007_item__golem_grafitti.w2ent",,,
        "gameplay\journal\bestiary\bestiaryelemental.journal"
      )
    );
  }

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_elemental_trophy_low');
    this.trophy_names.PushBack('modrer_elemental_trophy_medium');
    this.trophy_names.PushBack('modrer_elemental_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryEndrega extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureENDREGA;
    this.menu_name = 'Endrega';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl1__worker.w2ent",,,
      "gameplay\journal\bestiary\bestiaryendriag.journal"
    )
  );      // small endrega
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent", 2,,
      "gameplay\journal\bestiary\endriagatruten.journal"
    )
  );      // bigger tailed endrega
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl3__spikey.w2ent", 1,,
      "gameplay\journal\bestiary\endriagaworker.journal"
    ),
  );      // big tailless endrega

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 5;

  

    this.trophy_names.PushBack('modrer_endrega_trophy_low');
    this.trophy_names.PushBack('modrer_endrega_trophy_medium');
    this.trophy_names.PushBack('modrer_endrega_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryFiend extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFIEND;
    this.menu_name = 'Fiends';

    this.template_list.templates.PushBack(makeEnemyTemplate(
      "characters\npc_entities\monsters\bies_lvl1.w2ent",,,
      "gameplay\journal\bestiary\fiend2.journal" // TODO: confirm journal
      )
    );     
    this.template_list.templates.PushBack(makeEnemyTemplate(
      "characters\npc_entities\monsters\bies_lvl2.w2ent",,,
      "gameplay\journal\bestiary\fiend2.journal" // TODO: confirm journal
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_fiend_trophy_low');
    this.trophy_names.PushBack('modrer_fiend_trophy_medium');
    this.trophy_names.PushBack('modrer_fiend_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp);
  }
}

class RER_BestiaryFleder extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFLEDER;
    this.menu_name = 'Fleder';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\fleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\fleder.journal"
    )
  );this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\q704_protofleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\protofleder.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_garkain_trophy_low');
    this.trophy_names.PushBack('modrer_garkain_trophy_medium');
    this.trophy_names.PushBack('modrer_garkain_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryFogling extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFOGLET;
    this.menu_name = 'Fogling';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl1.w2ent",,,
      "gameplay\journal\bestiary\fogling.journal"
    )
  );          // normal fogling
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl2.w2ent",,,
      "gameplay\journal\bestiary\fogling.journal"
    )
  );        // normal fogling
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl3__willowisp.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal"
    )
  );  // green fogling

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_fogling_trophy_low');
    this.trophy_names.PushBack('modrer_fogling_trophy_medium');
    this.trophy_names.PushBack('modrer_fogling_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp)
    .addLikedBiome(BiomeWater);
  }
}

class RER_BestiaryForktail extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureFORKTAIL;
    this.menu_name = 'Forktails';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\forktail_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiaryforktail.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\forktail_lvl2.w2ent",,,
        "gameplay\journal\bestiary\bestiaryforktail.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\forktail_mh.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh208.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_forktail_trophy_low');
    this.trophy_names.PushBack('modrer_forktail_trophy_medium');
    this.trophy_names.PushBack('modrer_forktail_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryGargoyle extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGARGOYLE;
    this.menu_name = 'Gargoyles';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\monsters\gargoyle_lvl1_lvl25.w2ent",,,
      "gameplay\journal\bestiary\gargoyle.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_elemental_trophy_low');
    this.trophy_names.PushBack('modrer_elemental_trophy_medium');
    this.trophy_names.PushBack('modrer_elemental_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryGarkain extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGARKAIN;
    this.menu_name = 'Garkain';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\garkain.w2ent",,,
      "dlc\bob\journal\bestiary\garkain.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\garkain_mh.w2ent",,,
      "dlc\bob\journal\bestiary\q704alphagarkain.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_garkain_trophy_low');
    this.trophy_names.PushBack('modrer_garkain_trophy_medium');
    this.trophy_names.PushBack('modrer_garkain_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryGhoul extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGHOUL;
    this.menu_name = 'Ghouls';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // normal ghoul   spawns from the ground
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // red ghoul   spawns from the ground
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 5;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryGiant extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGIANT;
    this.menu_name = 'Giant';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\q701_dagonet_giant.w2ent",,,
      "dlc\bob\journal\bestiary\dagonet.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\q704_cloud_giant.w2ent",,,
      "dlc\bob\journal\bestiary\q704cloudgiant.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_giant_trophy_low');
    this.trophy_names.PushBack('modrer_giant_trophy_medium');
    this.trophy_names.PushBack('modrer_giant_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryGolem extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGOLEM;
    this.menu_name = 'Golems';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );          // normal greenish golem        
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl2__ifryt.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );      // fire golem  
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );          // weird yellowish golem

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_elemental_trophy_low');
    this.trophy_names.PushBack('modrer_elemental_trophy_medium');
    this.trophy_names.PushBack('modrer_elemental_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryGravier extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureDROWNERDLC;
    this.menu_name = 'DrownerDLC';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\gravier.w2ent",,,
      "dlc\bob\journal\bestiary\parszywiec.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeSwamp)
    .addOnlyBiome(BiomeWater);
  }
}

class RER_BestiaryGryphon extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureGRYPHON;
    this.menu_name = 'Gryphons';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\gryphon_lvl1.w2ent",,,
        "gameplay\journal\bestiary\griffin.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\gryphon_lvl3__volcanic.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\gryphon_mh__volcanic.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;

      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;

      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_griffin_trophy_low');
    this.trophy_names.PushBack('modrer_griffin_trophy_medium');
    this.trophy_names.PushBack('modrer_griffin_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryHag extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHAG;
    this.menu_name = 'Hags';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_grave_lvl1.w2ent",,,
      "gameplay\journal\bestiary\gravehag.journal"
    )
  );          // grave hag 1        
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_lvl1.w2ent",,,
      "gameplay\journal\bestiary\waterhag.journal"
    )
  );          // grey  water hag    
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_lvl2.w2ent",,,
      "gameplay\journal\bestiary\waterhag.journal"
    )
  );          // greenish water hag

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh203.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_grave_hag_trophy_low');
    this.trophy_names.PushBack('modrer_grave_hag_trophy_medium');
    this.trophy_names.PushBack('modrer_grave_hag_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeSwamp)
    .addOnlyBiome(BiomeWater);
  }
}

class RER_BestiaryHarpy extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHARPY;
    this.menu_name = 'Harpies';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl1.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl2.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl3__erynia.w2ent", 1,,
      "gameplay\journal\bestiary\erynia.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 4;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 5;
    this.template_list.difficulty_factor.maximum_count_hard = 7;
  
  

    this.trophy_names.PushBack('modrer_harpy_trophy_low');
    this.trophy_names.PushBack('modrer_harpy_trophy_medium');
    this.trophy_names.PushBack('modrer_harpy_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryHuman extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_axe_normal.w2ent"));        
    this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_bow.w2ent", 3));        
    this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_sword_easy.w2ent"));        
    this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\novigrad_bandit_shield_1haxe.w2ent"));        
    this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\novigrad_bandit_shield_1hclub.w2ent"));

      this.template_list.difficulty_factor.minimum_count_easy = 3;
      this.template_list.difficulty_factor.maximum_count_easy = 4;
      this.template_list.difficulty_factor.minimum_count_medium = 3;
      this.template_list.difficulty_factor.maximum_count_medium = 5;
      this.template_list.difficulty_factor.minimum_count_hard = 4;
      this.template_list.difficulty_factor.maximum_count_hard = 6;

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryKatakan extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureKATAKAN;
    this.menu_name = 'Katakan';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarykatakan.journal"
    )
  );  // cool blinky vampire     
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarykatakan.journal"
    )
  );  // cool blinky vamp
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_mh.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh304.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_katakan_trophy_low');
    this.trophy_names.PushBack('modrer_katakan_trophy_medium');
    this.trophy_names.PushBack('modrer_katakan_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryKikimore extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureKIKIMORE;
    this.menu_name = 'Kikimore';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\kikimore.w2ent", 1,,
      "dlc\bob\journal\bestiary\kikimoraworker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\kikimore_small.w2ent",,,
      "dlc\bob\journal\bestiary\kikimora.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 2;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 3;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryLeshen extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureLESHEN;
    this.menu_name = 'Leshens';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_lvl1.w2ent",,,
        "gameplay\journal\bestiary\leshy1.journal"
      )
    );
    
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_lvl2__ancient.w2ent",,,
        "gameplay\journal\bestiary\sq204ancientleszen.journal" // TODO: seems bugged
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_mh.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh302.journal" // TODO: seems bugged
      )
    );
    
    if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
      this.template_list.templates.PushBack(
        makeEnemyTemplate(
          "dlc\bob\data\characters\npc_entities\monsters\spriggan.w2ent",,,
          "dlc\bob\journal\bestiary\mq7002spriggan.journal"
        )
      );
    }

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_leshen_trophy_low');
    this.trophy_names.PushBack('modrer_leshen_trophy_medium');
    this.trophy_names.PushBack('modrer_leshen_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeForest);
  }
}

class RER_BestiaryNekker extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureNEKKER;
    this.menu_name = 'Nekkers';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl1.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl2.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl3_customize.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl3__warrior.w2ent", 2,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_mh__warrior.w2ent", 1,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh202.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 4;
    this.template_list.difficulty_factor.maximum_count_easy = 5;
    this.template_list.difficulty_factor.minimum_count_medium = 4;
    this.template_list.difficulty_factor.maximum_count_medium = 6;
    this.template_list.difficulty_factor.minimum_count_hard = 5;
    this.template_list.difficulty_factor.maximum_count_hard = 7;

  

    this.trophy_names.PushBack('modrer_nekker_trophy_low');
    this.trophy_names.PushBack('modrer_nekker_trophy_medium');
    this.trophy_names.PushBack('modrer_nekker_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryNightwraith extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureNIGHTWRAITH;
    this.menu_name = 'NightWraiths';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );

  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee.w2ent",,,
        "dlc\bob\journal\bestiary\beanshie.journal"
      )
    );
  }

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_nightwraith_trophy_low');
    this.trophy_names.PushBack('modrer_nightwraith_trophy_medium');
    this.trophy_names.PushBack('modrer_nightwraith_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryNoonwraith extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureNOONWRAITH;
    this.menu_name = 'NoonWraiths';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );       
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__noonwright_pesta.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_noonwraith_trophy_low');
    this.trophy_names.PushBack('modrer_noonwraith_trophy_medium');
    this.trophy_names.PushBack('modrer_noonwraith_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryPanther extends RER_BestiaryEntry {
  public function init() {
    this.type = CreaturePANTHER;
    this.menu_name = 'Panther';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_black.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_leopard.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_mountain.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 2;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryRotfiend extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureROTFIEND;
    this.menu_name = 'Rotfiends';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\rotfiend_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarygreaterrotfiend.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\rotfiend_lvl2.w2ent", 1,,
      "gameplay\journal\bestiary\bestiarygreaterrotfiend.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_necrophage_trophy_low');
    this.trophy_names.PushBack('modrer_necrophage_trophy_medium');
    this.trophy_names.PushBack('modrer_necrophage_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp)
    .addLikedBiome(BiomeWater);
  }
}

class RER_BestiarySharley extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSHARLEY;
    this.menu_name = 'Sharley';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );  // rock boss things
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_mh.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_q701.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_q701_normal_scale.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_sharley_trophy_low');
    this.trophy_names.PushBack('modrer_sharley_trophy_medium');
    this.trophy_names.PushBack('modrer_sharley_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater);
  }
}

class RER_BestiarySiren extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSIREN;
    this.menu_name = 'Sirens';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl1.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl2__lamia.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl3.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 4;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 5;
    this.template_list.difficulty_factor.maximum_count_hard = 7;
  
  

    this.trophy_names.PushBack('modrer_harpy_trophy_low');
    this.trophy_names.PushBack('modrer_harpy_trophy_medium');
    this.trophy_names.PushBack('modrer_harpy_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeSwamp)
    .addOnlyBiome(BiomeWater);
  }
}

class RER_BestiarySkelbear extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSKELBEAR;
    this.menu_name = 'SkelligeBears';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\bear_lvl3__white.w2ent",,,
        "gameplay\journal\bestiary\bear.journal"
      )
    );      // polarbear

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 2;

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiarySkeleton extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSKELETON;
    this.menu_name = 'Skeleton';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon.w2ent",,,
      "dlc\bob\journal\bestiary\beanshie.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon_skeleton.w2ent",,,
      "dlc\bob\journal\bestiary\beanshie.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_spirit_trophy_low');
    this.trophy_names.PushBack('modrer_spirit_trophy_medium');
    this.trophy_names.PushBack('modrer_spirit_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiarySkeltroll extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSKELTROLL;
    this.menu_name = 'SkelligeTroll';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl3__ice.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );  // ice   
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl4__ice.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );  // ice
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_ice_lvl13.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );    // ice

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 3;

  

    this.trophy_names.PushBack('modrer_troll_trophy_low');
    this.trophy_names.PushBack('modrer_troll_trophy_medium');
    this.trophy_names.PushBack('modrer_troll_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiarySkelwolf extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSKELWOLF;
    this.menu_name = 'SkelligeWolves';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_white_lvl2.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // lvl 51 white wolf    STEEL     
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_white_lvl3__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );  // lvl 51 white wolf     STEEL  37

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiarySpider extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureSPIDER;
    this.menu_name = 'Spiders';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider.w2ent",,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider_large.w2ent",2,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 3;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_insectoid_trophy_low');
    this.trophy_names.PushBack('modrer_insectoid_trophy_medium');
    this.trophy_names.PushBack('modrer_insectoid_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addDislikedBiome(BiomeSwamp)
    .addDislikedBiome(BiomeWater)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryTroll extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureTROLL;
    this.menu_name = 'Troll';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl1.w2ent",,,
      "gameplay\journal\bestiary\trollcave.journal"
    )
  );    // grey

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 3;

  

    this.trophy_names.PushBack('modrer_troll_trophy_low');
    this.trophy_names.PushBack('modrer_troll_trophy_medium');
    this.trophy_names.PushBack('modrer_troll_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryWerewolf extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWEREWOLF;
    this.menu_name = 'Werewolves';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl2.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl3__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    );  
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl4__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    );  
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl5__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf_01.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf_02.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_werewolf_trophy_low');
    this.trophy_names.PushBack('modrer_werewolf_trophy_medium');
    this.trophy_names.PushBack('modrer_werewolf_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryWight extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWIGHT;
    this.menu_name = 'Wight';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\spooncollector.w2ent",1,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );  // spoon
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\wicht.w2ent",2,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );     // wight

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;

  

    this.trophy_names.PushBack('modrer_wight_trophy_low');
    this.trophy_names.PushBack('modrer_wight_trophy_medium');
    this.trophy_names.PushBack('modrer_wight_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeSwamp)
    .addLikedBiome(BiomeWater)
    .addDislikedBiome(BiomeForest);
  }
}

class RER_BestiaryWildhunt extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWILDHUNT;
    this.menu_name = 'WildHunt';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_axe.w2ent", 2,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_halberd.w2ent", 2,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_hammer.w2ent", 1,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_spear.w2ent", 2,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_sword.w2ent", 1,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\wildhunt_minion_lvl1.w2ent", 2,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );  // hound of the wild hunt   
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\wildhunt_minion_lvl2.w2ent", 1,,
        "gameplay\journal\bestiary\whminion.journal"
      )
    );  // spikier hound

      this.template_list.difficulty_factor.minimum_count_easy = 3;
      this.template_list.difficulty_factor.maximum_count_easy = 4;
      this.template_list.difficulty_factor.minimum_count_medium = 4;
      this.template_list.difficulty_factor.maximum_count_medium = 6;
      this.template_list.difficulty_factor.minimum_count_hard = 5;
      this.template_list.difficulty_factor.maximum_count_hard = 7;

    this.trophy_names.PushBack('modrer_wildhunt_trophy_low');
    this.trophy_names.PushBack('modrer_wildhunt_trophy_medium');
    this.trophy_names.PushBack('modrer_wildhunt_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryWolf extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWOLF;
    this.menu_name = 'Wolves';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );        // +4 lvls  grey/black wolf STEEL
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // +4 lvls brown warg      STEEL

    this.template_list.difficulty_factor.minimum_count_easy = 2;
    this.template_list.difficulty_factor.maximum_count_easy = 3;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 4;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_beast_trophy_low');
    this.trophy_names.PushBack('modrer_beast_trophy_medium');
    this.trophy_names.PushBack('modrer_beast_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addLikedBiome(BiomeForest);
  }
}

class RER_BestiaryWraith extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWRAITH;
    this.menu_name = 'Wraiths';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl4.w2ent", 2,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 2;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 3;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 4;

  

    this.trophy_names.PushBack('modrer_wraith_trophy_low');
    this.trophy_names.PushBack('modrer_wraith_trophy_medium');
    this.trophy_names.PushBack('modrer_wraith_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryWyvern extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWYVERN;
    this.menu_name = 'Wyverns';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\wyvern_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarywyvern.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\wyvern_lvl2.w2ent",,,
        "gameplay\journal\bestiary\bestiarywyvern.journal"
      )
    );

      this.template_list.difficulty_factor.minimum_count_easy = 1;
      this.template_list.difficulty_factor.maximum_count_easy = 1;
      this.template_list.difficulty_factor.minimum_count_medium = 1;
      this.template_list.difficulty_factor.maximum_count_medium = 1;
      this.template_list.difficulty_factor.minimum_count_hard = 1;
      this.template_list.difficulty_factor.maximum_count_hard = 1;

    this.trophy_names.PushBack('modrer_wyvern_trophy_low');
    this.trophy_names.PushBack('modrer_wyvern_trophy_medium');
    this.trophy_names.PushBack('modrer_wyvern_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanBandit extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_axe_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_bow.w2ent", 3));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_sword_easy.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\novigrad_bandit_shield_1haxe.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\novigrad_bandit_shield_1hclub.w2ent"));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanCannibal extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_boss.w2ent", 1));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_melee.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_melee_spear.w2ent", 3));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_ranged.w2ent", 3));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanNilf extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_bow.w2ent", 3));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_shield.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_sword_hard.w2ent"));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanNovbandit extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_club.w2ent"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_mace_t1.w2ent"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_2h_hammer.w2ent"
    )
  );
  this.template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_sword_t1.w2ent"
    )
  );
  
    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanPirate extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_axe_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_blunt.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_bow.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_crossbow.w2ent", 1));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_easy.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_normal.w2ent"));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanRenegade extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_2h_axe.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_axe.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_blunt.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_boss.w2ent", 1));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_bow.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_crossbow.w2ent", 1));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_shield.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_sword_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_sword_normal.w2ent"));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanSkel2bandit extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe1h_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe1h_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_blunt_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_blunt_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_shield_axe1h_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_shield_mace1h_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe2h.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_easy.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_hard.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_normal.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_hammer2h.w2ent", 1));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_bow.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_crossbow.w2ent", 1));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanSkelbandit extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_axe_t1.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_club.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_bow.w2ent", 3));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_2h_spear.w2ent", 3));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_axe_t1.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_club.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_axe_t2.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_sword.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_axe_t2.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_sword.w2ent"));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanSkelpirate extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe1h_hard.w2ent"));
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe1h_normal.w2ent"));      
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe2h.w2ent", 2));
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_blunt_hard.w2ent"));     
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_blunt_normal.w2ent"));  
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_bow.w2ent", 2));    
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_crossbow.w2ent", 1));    
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_hammer2h.w2ent", 1));
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_swordshield.w2ent"));
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_easy.w2ent"));
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_hard.w2ent"));
  this.template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_normal.w2ent"));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

class RER_BestiaryHumanWhunter extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureHUMAN;
    this.menu_name = 'Humans';

    

  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_1h_sword_t2.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_1h_mace_t2.w2ent"));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_crossbow.w2ent", 2));        
  this.template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_2h_sword.w2ent"));

    this.template_list.difficulty_factor.minimum_count_easy = 3;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 3;
    this.template_list.difficulty_factor.maximum_count_medium = 5;
    this.template_list.difficulty_factor.minimum_count_hard = 4;
    this.template_list.difficulty_factor.maximum_count_hard = 6;

  

    this.trophy_names.PushBack('modrer_human_trophy_low');
    this.trophy_names.PushBack('modrer_human_trophy_medium');
    this.trophy_names.PushBack('modrer_human_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

// This composition is different, it is not really a composition because it
// doesn't use the CompositionSpawner.
// Because this class isn't a class of type "one instance per entity" but
// instead a single class handling the whole encounter.
latent function createRandomCreatureContract(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry, optional position: Vector) {
  var composition: CreatureContractComposition;

  composition = new CreatureContractComposition in master;

  composition.init(master.settings);

  // Kind of a hack, if there is a forced position it means the contract was
  // started from a noticeboard. Because it's the only place where the position
  // is forced.
  if (position.X != 0 || position.Y != 0 || position.Z != 0) {
    composition.setSpawnPosition(position);

    composition.started_from_noticeboard = true;
  }  

  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

class CreatureContractComposition extends CompositionSpawner {
  public var started_from_noticeboard: bool;
  default started_from_noticeboard = false;

  public function init(settings: RE_Settings) {
    LogChannel('modRandomEncounters', "CreatureContractComposition");

    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance)
      .setRandomPositionMaxRadius(settings.minimum_spawn_distance + settings.spawn_diameter)
      .setEncounterType(EncounterType_CONTRACT)

      // these settings aren't used when it's an entity manager.
      // I leave them here for the day where i'll update the CompositionSpawner
      // to work with the new classes.
      // .setAutomaticKillThresholdDistance(settings.kill_threshold_distance)
      // .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_DEFAULT])
      // .setAllowTrophyPickupScene(settings.trophy_pickup_scene)

      // we force -1 creatures here because the contract entity will spawn the
      // creatures later based on the phases.
      // and 0 is the default value the bestiary_entry checks for before rolling
      // a random value.
      .setNumberOfCreatures(-1);

  }

  protected latent function afterSpawningEntities(): bool {
    var rer_entity: RandomEncountersReworkedContractEntity;
    var rer_entity_template: CEntityTemplate;

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_contract_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedContractEntity)theGame.CreateEntity(rer_entity_template, this.initial_position, thePlayer.GetWorldRotation());
    rer_entity.started_from_noticeboard = this.started_from_noticeboard;
    rer_entity.startEncounter(this.master, this.bestiary_entry);

    return true;
  }
}
latent function createRandomCreatureHunt(master: CRandomEncounters, optional creature_type: CreatureType) {
  var bestiary_entry: RER_BestiaryEntry;

  LogChannel('modRandomEncounters', "making create hunt");

  if (creature_type == CreatureNONE) {
    bestiary_entry = master
      .bestiary
      .getRandomEntryFromBestiary(master, EncounterType_HUNT);
  }
  else {
    bestiary_entry = master
      .bestiary
      .entries[creature_type];
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (bestiary_entry.isNull()) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }

  if (bestiary_entry.type == CreatureGRYPHON) {
    makeGryphonCreatureHunt(master);
  }
  else {
    makeDefaultCreatureHunt(master, bestiary_entry);
  }
}


latent function makeGryphonCreatureHunt(master: CRandomEncounters) {
  var composition: CreatureHuntGryphonComposition;

  composition = new CreatureHuntGryphonComposition in master;

  composition.init(master.settings);
  composition
    .setBestiaryEntry(master.bestiary.entries[CreatureGRYPHON])
    .spawn(master);
}

class CreatureHuntGryphonComposition extends CompositionSpawner {
  public function init(settings: RE_Settings) {
    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance * 3)
      .setRandomPositionMaxRadius((settings.minimum_spawn_distance + settings.spawn_diameter) * 3)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance * 3)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_HUNT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene)
      .setNumberOfCreatures(1);
  }

  var rer_entity_template: CEntityTemplate;
  var blood_splats_templates: array<RER_TrailMakerTrack>;

  protected latent function beforeSpawningEntities(): bool {
    this.rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_flying_hunt_entity.w2ent",
      true
    );

    this.blood_splats_templates = this
      .master
      .resources
      .getBloodSplatsResources();

    return true;
  }

  var rer_entities: array<RandomEncountersReworkedGryphonHuntEntity>;

  protected latent function forEachEntity(entity: CEntity) {
    var current_rer_entity: RandomEncountersReworkedGryphonHuntEntity;

    current_rer_entity = (RandomEncountersReworkedGryphonHuntEntity)theGame.CreateEntity(
      rer_entity_template,
      initial_position,
      thePlayer.GetWorldRotation()
    );

    current_rer_entity.attach(
      (CActor)entity,
      (CNewNPC)entity,
      entity,
      this.master
    );

    if (this.allow_trophy) {
      // if the user allows trophy pickup scene, tell the entity
      // to send RER a request on its death.
      current_rer_entity.pickup_animation_on_death = this.allow_trophy_pickup_scene;
    }

    current_rer_entity.automatic_kill_threshold_distance = this
      .automatic_kill_threshold_distance;

    if (!master.settings.enable_encounters_loot) {
      current_rer_entity.removeAllLoot();
    }

    current_rer_entity.startEncounter(this.blood_splats_templates);


    this.rer_entities.PushBack(current_rer_entity);
  }
}


latent function makeDefaultCreatureHunt(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry) {
  var composition: CreatureHuntComposition;

  composition = new CreatureHuntComposition in master;

  composition.init(master.settings);
  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

// CAUTION, it extends `CreatureAmbushWitcherComposition`
class CreatureHuntComposition extends CreatureAmbushWitcherComposition {
  public function init(settings: RE_Settings) {
    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance * 2)
      .setRandomPositionMaxRadius((settings.minimum_spawn_distance + settings.spawn_diameter) * 2)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance * 2)
      .setEncounterType(EncounterType_HUNT)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_HUNT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene);
  }

  protected latent function afterSpawningEntities(): bool {
    var rer_entity: RandomEncountersReworkedHuntEntity;
    var rer_entity_template: CEntityTemplate;

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunt_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntEntity)theGame.CreateEntity(rer_entity_template, this.initial_position, thePlayer.GetWorldRotation());
    rer_entity.startEncounter(this.master, this.created_entities, this.bestiary_entry);

    return true;
  }
}

enum CreatureComposition {
  CreatureComposition_AmbushWitcher = 1
}

latent function createRandomCreatureAmbush(out master: CRandomEncounters, creature_type: CreatureType) {
  var creature_composition: CreatureComposition;
  var bestiary_entry: RER_BestiaryEntry;

  creature_composition = CreatureComposition_AmbushWitcher;

  if (creature_type == CreatureNONE) {
    bestiary_entry = master
      .bestiary
      .getRandomEntryFromBestiary(master, EncounterType_DEFAULT);
  }
  else {
    bestiary_entry = master
      .bestiary
      .entries[creature_type];
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (bestiary_entry.isNull()) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }

  LogChannel('modRandomEncounters', "spawning ambush - " + bestiary_entry.type);

  if (creature_type == CreatureWILDHUNT) {
    makeCreatureWildHunt(master);
  }
  else {
    switch (creature_composition) {
      case CreatureComposition_AmbushWitcher:
        makeCreatureAmbushWitcher(bestiary_entry, master);
        break;
    }
  }
}


          //////////////////////////////////////
          // maker functions for compositions //
          //////////////////////////////////////

// TODO: the wild hunt should change the weather when they spawn.
// I can't add it now because there is no way for me to know if 
// all the creatures are alive or not. 
latent function makeCreatureWildHunt(out master: CRandomEncounters) {
  var composition: WildHuntAmbushWitcherComposition;

  composition = new WildHuntAmbushWitcherComposition in master;

  composition.init(master.settings);
  composition.setBestiaryEntry(master.bestiary.entries[CreatureWILDHUNT])
    .spawn(master);
}

class WildHuntAmbushWitcherComposition extends CreatureAmbushWitcherComposition {
  var portal_template: CEntityTemplate;
  var rifts: array<CRiftEntity>;


  protected latent function beforeSpawningEntities(): bool {
    var success: bool;

    success = super.beforeSpawningEntities();
    if (!success) {
      return false;
    }

    this.portal_template = master.resources.getPortalResource();

    return true;
  }

  protected latent function forEachEntity(entity: CEntity) {
    var rift: CRiftEntity;

    super.forEachEntity(entity);

    ((CNewNPC)entity)
        .SetTemporaryAttitudeGroup('hostile_to_player', AGP_Default);
      
    ((CNewNPC)entity)
      .NoticeActor(thePlayer);

    rift = (CRiftEntity)theGame.CreateEntity(
      this.portal_template,
      entity.GetWorldPosition(),
      entity.GetWorldRotation()
    );
    rift.ActivateRift();

    rifts.PushBack(rift);
  }
}


latent function makeCreatureAmbushWitcher(bestiary_entry: RER_BestiaryEntry, out master: CRandomEncounters) {
  var composition: CreatureAmbushWitcherComposition;

  composition = new CreatureAmbushWitcherComposition in master;

  composition.init(master.settings);
  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

class CreatureAmbushWitcherComposition extends CompositionSpawner {
  public function init(settings: RE_Settings) {
    LogChannel('modRandomEncounters', "CreatureAmbushWitcherComposition");

    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance)
      .setRandomPositionMaxRadius(settings.minimum_spawn_distance + settings.spawn_diameter)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance)
      .setEncounterType(EncounterType_DEFAULT)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_DEFAULT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene);
  }

  protected latent function afterSpawningEntities(): bool {
    var rer_entity: RandomEncountersReworkedHuntEntity;
    var rer_entity_template: CEntityTemplate;

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunt_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntEntity)theGame.CreateEntity(rer_entity_template, this.initial_position, thePlayer.GetWorldRotation());
    rer_entity.startEncounter(this.master, this.created_entities, this.bestiary_entry, true);

    return true;
  }
}

struct ContractEntitySettings {
  var kill_threshold_distance: float;
  var allow_trophies: bool;
  var allow_trophy_pickup_scene: bool;
  var enable_loot: bool;
}

// This "Entity" is different from the others (gryphon/default) because
// it is not the entity itself but more of a manager who controls multiple
// entities.
//
// It has many states, so i'll explain what each state does and in which
// order it enters these states.
//
// - The first state called `CluesInvestigate` is where it all starts, Geralt find clues
//   on the ground and can choose to follow them.
//   A few tracks are created and if the player gets near them it goes to the
//   `CluesFollow` state.
//   
// - the`CluesFollow` state creates more tracks up to a point. When Geralt
//   reaches this point he can find another `CluesStart` or the next state.
//   During the `CluesStart` state Geralt can also be ambushes by either necrophages
//   or bandits.
//
// - The `Combat` state, it's just Geralt fighting the monsters until they die.
//   On death the monster drops a few crowns and also some items belonging
//   to the villagers Geralt found on `CluesStart`.
//   After this state it can either end here or loop to either `CluesFollow`
//   or the next state `CombatAmbush`
//
// - The `CombatAmbush` is a small state where it prepares an ambush after the initial
//   `Combat` state. This state simply creates an ambush and it goes back to `Combat`
statemachine class RandomEncountersReworkedContractEntity extends CEntity {
  var master: CRandomEncounters;

  var entities: array<CEntity>;

  var bestiary_entry: RER_BestiaryEntry;
  
  var number_of_creatures: int;

  var entity_settings: ContractEntitySettings;

  var trail_maker: RER_TrailMaker;

  var blood_maker: RER_TrailMaker;

  var corpse_maker: RER_TrailMaker;

  // this boolean is mainly used in the starting phases, to know if a camera scene
  // should be played or not, or if a series of oneliners should run.
  var started_from_noticeboard: bool;

  // this variable stores the last important position from the previous phase
  // It's useful when chaining many phases and when the next phase needs to know
  // where the previous phase ended
  var previous_phase_checkpoint: Vector;

  // everytime the entity goes into the PhasePick state, it stores the previous
  // phase that was played. It's useful when a state needs to know how many times
  // it's been played already, or if it needs to know if another state was played
  var played_phases: array<name>;

  // this variables stores the longevity of the encounter. Once the float value
  // reaches 0, it means the encounter cannot create any more phases and it should
  // stop after the current phase. It is a float an not a int because some phases
  // will cost more than some others. And some may have a 0.5 cost while other could
  // go up to 2 or 3.
  var longevity: float;

  public latent function startEncounter(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry) {
    this.master = master;
    this.bestiary_entry = bestiary_entry;
    this.number_of_creatures = rollDifficultyFactor(
      this.bestiary_entry.template_list.difficulty_factor,
      this.master.settings.selectedDifficulty,
      this.master.settings.enemy_count_multiplier
    );
    this.loadSettings(master);
    this.previous_phase_checkpoint = thePlayer.GetWorldPosition();

    this.AddTimer('intervalLifeCheck', 10.0, true);
    this.GotoState('Loading');
  }

  private function loadSettings(master: CRandomEncounters) {
    this.entity_settings.kill_threshold_distance = master.settings.kill_threshold_distance;
    this.entity_settings.allow_trophy_pickup_scene = master.settings.trophy_pickup_scene;
    
    this.entity_settings.allow_trophies = master
      .settings
      .trophies_enabled_by_encounter[EncounterType_CONTRACT];
    
    this.entity_settings.enable_loot = master
      .settings
      .enable_encounters_loot;

    this.longevity = master
      .settings
      .monster_contract_longevity;
  }

  public latent function clean() {
    var i: int;

    LogChannel(
      'modRandomEncounters',
      "RandomEncountersReworkedContractEntity destroyed"
    );

    this.RemoveTimer('intervalLifeCheck');

    for (i = 0; i < this.entities.Size(); i += 1) {
      ((CActor)this.entities[i])
        .Kill('RandomEncountersReworkedContractEntity', true);
    }

    trail_maker.clean();
    blood_maker.clean();
    corpse_maker.clean();

    this.Destroy();
  }

  timer function intervalLifeCheck(optional dt : float, optional id : Int32) {
    var distance_from_player: float;

    if (this.GetCurrentStateName() == 'Ending') {
      return;
    }

    distance_from_player = VecDistance(
      this.previous_phase_checkpoint,
      thePlayer.GetWorldPosition()
    );

    if (distance_from_player > this.entity_settings.kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.entity_settings.kill_threshold_distance);
      this.endContract();

      return;
    }
  }

  ///////////////////////////////////////////////////
  // below are helper functions used in the states //
  ///////////////////////////////////////////////////

  //
  // get the number of times the supplied phase was played
  public function playedPhaseCount(phase: name): int {
    var i: int;
    var count: int;

    count = 0;

    for (i = 0; i < this.played_phases.Size(); i += 1) {
      if (phase == this.played_phases[i]) {
        count += 1;
      }
    }

    return count;
  }

  //
  // get the name of the previous phase (excluding the 'phase_pick' phase)
  public function getPreviousPhase(optional ignore_phase: name): name {
    var count: int;
    var phase: name;

    count = this.played_phases.Size();

    if (count == 0) {
      return 'Loading';
    }

    phase = this.played_phases[count - 1];

    // this function excludes the PhasePick phase, so if the previous phase was
    // PhasePick we try to go one phase lower.
    if (phase == 'PhasePick' || phase == ignore_phase) {
      count -= 1;

      if (count == 0) {
        return '';
      }

      phase = this.played_phases[count - 1];
    }

    return phase;
  }

  //
  // removes the loot of all current entities
  public function removeAllLoot() {
    var inventory: CInventoryComponent;
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      inventory = ((CActor)this.entities[i]).GetInventory();

      inventory.EnableLoot(false);
    }
  }

  //
  // returns if all current entities are dead
  public function areAllEntitiesDead(): bool {
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).IsAlive()) {
        return false;
      }
    }

    return true;
  }

  //
  // remove the dead entities from the list of entities
  public function removeDeadEntities() {
     var i: int;
     var max: int;

     max = this.entities.Size();

     for (i = 0; i < max; i += 1) {
       if (!((CActor)this.entities[i]).IsAlive()) {
         this.entities.Remove(this.entities[i]);

         max -= 1;
         i -= 1;
       }
     }
  }

  //
  // returns if one of the current entities has geralt as a target
  public function hasOneOfTheEntitiesGeraltAsTarget(): bool {
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).HasAttitudeTowards(thePlayer) || ((CNewNPC)this.entities[i]).GetTarget() == thePlayer) {
        return true;
      }
    }

    return false;
  }

  //
  // returns true if none of the contract entities is nearby
  // can also be used to know if at least one creature is nearby
  function areAllEntitiesFarFromPlayer(): bool {
    var player_position: Vector;
    var i: int;

    player_position = thePlayer.GetWorldPosition();

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (VecDistanceSquared(this.entities[i].GetWorldPosition(), player_position) < 30 * 30) {
        return false;
      }
    }

    return true;
  }

  //
  // play a camera scene that will show the supplied position. Mainly used in the
  // starting phases if the contract was started from a noticeboard, to show
  // the player where the contract is.
  public latent function playContractEncounterCameraScene(position: Vector) {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;

    if(this.master.settings.disable_camera_scenes) {
      return;
    }

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(0.3, 0, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    scene.look_at_target_static = position;

    // scene.velocity_type = RER_CameraVelocityType_FORWARD;
    // scene.velocity = Vector(0.005, 0.005, 0.02);

    scene.duration = 3;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();
    camera.playCameraScene(scene, true);
  }

  //
  // ends the encounter by going into the Ending state
  public function endContract() {
    if (this.GetCurrentStateName() != 'Ending') {
      this.GotoState('Ending');
    }
  }

  event OnDestroyed() {
    LogChannel('modRandomEncounters', "Contract hit destroyed");
    // super.OnDestroyed();
  }
}

// The Ambush state is quite simple, it's a stationnary phase where Monsters appear
// around Geralt and ambush him. Then it goes directly in the Combat phase.
state Ambush in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Ambush");

    this.Ambush_main();
  }

  entry function Ambush_main() {
    this.spawnRandomMonster();

    parent.GotoState('Combat');
  }

  latent function spawnRandomMonster() {
    var bestiary_entry: RER_BestiaryEntry;
    var spawning_position: Vector;

    if (!getRandomPositionBehindCamera(spawning_position, 10, 15)) {
      spawning_position = parent.previous_phase_checkpoint;
    }

    bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary(parent.master, EncounterType_CONTRACT);

    parent.entities = bestiary_entry.spawn(parent.master, spawning_position);
  }
}

// This phase places clues on the ground and sometimes creatures at the previous
// checkpoint. It waits for the player to enter the radius and then enters in
// combat or in PhasePicker if there is no creature.
state CluesInvestigate in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State CluesInvestigate");

    this.CluesInvestigate_Main();
  }

  entry function CluesInvestigate_Main() {
    this.createClues();
    this.playStatingOnelinerAndCameraScene();
    this.waitUntilPlayerReachesFirstClue();
    this.createLastClues();
    this.waitUntilPlayerReachesLastClue();
    
    this.CluesInvestigate_GotoNextState();
  }

  latent function playStatingOnelinerAndCameraScene() {
    if (!parent.started_from_noticeboard) {
      return;
    }

    REROL_where_will_i_find_this_monster();
    parent.playContractEncounterCameraScene(this.investigation_center_position);
  }

  var investigation_center_position: Vector;
  var investigation_radius: int;
  default investigation_radius = 15;

  var has_monsters_with_clues: bool;

  var eating_animation_slot: CAIPlayAnimationSlotAction;

  latent function createClues() {
    var max_number_of_clues: int;
    var current_clue_position: Vector;
    var i: int;

    this.investigation_center_position = parent.previous_phase_checkpoint;

    // 1. we place the clues randomly
    // 1.1 first by placing the corpses
    max_number_of_clues = RandRange(20, 10);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = this.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .corpse_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // 1.2 then we place some random tracks
    max_number_of_clues = RandRange(60, 30);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = this.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .trail_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // 1.3 then we place lots of blood
    max_number_of_clues = RandRange(100, 50);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = this.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent
        .blood_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // 2. we play a camera scene after we created all the clues.
    //    if set to true, will play a oneliner and camera scene when the
    //    investigation position is finally determined. Meaning, now.
    //    the cutscene plays only if the contract is close enough from the player
    //    camera scene plays if above condition is met and camera scenes are
    //    not disabled from the menu
    // TODO:
    if (!parent.started_from_noticeboard) {
      this.startOnSpawnCutscene();
    }

    // 3. there is a chance necrophages are feeding on the corpses
    if (RandRange(10) < 6) {
      this.addMonstersWithClues();
    }
  }

  private latent function startOnSpawnCutscene() {
    var minimum_spawn_distance: float;

    minimum_spawn_distance = parent.master.settings.minimum_spawn_distance * 1.5;

    if (VecDistanceSquared(thePlayer.GetWorldPosition(), this.investigation_center_position) > minimum_spawn_distance * minimum_spawn_distance) {
      return;
    }

    if (parent.master.settings.geralt_comments_enabled) {
      REROL_smell_of_a_rotting_corpse(true);
    }

    if (!parent.master.settings.disable_camera_scenes
    && parent.master.settings.enable_action_camera_scenes) {
      playCameraSceneOnSpawn();
    }
  }

  private latent function playCameraSceneOnSpawn() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var look_at_position: Vector;

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(0.3, 0, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    look_at_position = this.investigation_center_position;
    scene.look_at_target_static = look_at_position;

    scene.velocity_type = RER_CameraVelocityType_FORWARD;
    scene.velocity = Vector(0.001, 0.001, 0);

    scene.duration = 2;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene, true);
  }

  private latent function addMonstersWithClues() {
    var monsters_bestiary_entry: RER_BestiaryEntry;
    var created_entities: array<CEntity>;
    var i: int;

    // 1. pick the type of monsters we'll add near the clues
    //    it's either necropages or Wild hunt soldiers if
    //    the bestiary type for this encounter is Wild Hunt
    if (parent.bestiary_entry.type == CreatureWILDHUNT) {
      monsters_bestiary_entry = parent
        .master
        .bestiary
        .entries[CreatureWILDHUNT];

      this.addWildHuntClues();
    }
    else {
      monsters_bestiary_entry = parent
        .master
        .bestiary
        .entries[CreatureGHOUL];
    }

    this.has_monsters_with_clues = true;

    // mainly used for the necrophages
    this.eating_animation_slot = new CAIPlayAnimationSlotAction in this;
    this.eating_animation_slot.OnCreated();
    this.eating_animation_slot.animName = 'exploration_eating_loop';
    this.eating_animation_slot.blendInTime = 1.0f;
    this.eating_animation_slot.blendOutTime = 1.0f;  
    this.eating_animation_slot.slotName = 'NPC_ANIM_SLOT';

    // 2. we spawn the monsters
    created_entities = monsters_bestiary_entry
      .spawn(
        parent.master,
        parent.previous_phase_checkpoint,,,
        parent.entity_settings.allow_trophies
      );

    for (i = 0; i < created_entities.Size(); i += 1) {
      parent.entities.PushBack(created_entities[i]);
    }
  }

  private var rifts: array<CRiftEntity>;

  private latent function addWildHuntClues() {
    var portal_template: CEntityTemplate;
    var number_of_rifts: int;
    var rift: CRiftEntity;
    var i: int;

    number_of_rifts = RandRange(3, 1);

    portal_template = parent.master.resources.getPortalResource();
    for (i = 0; i < number_of_rifts; i += 1) {
      rift = (CRiftEntity)theGame.CreateEntity(
        portal_template,
        this.investigation_center_position + VecRingRand(0, this.investigation_radius)
      );

      rift.ActivateRift();

      this.rifts.PushBack(rift);
    }
  }

  latent function waitUntilPlayerReachesFirstClue() {
    var distance_from_player: float;

    var has_set_weather_snow: bool;
    
    has_set_weather_snow = false;

    // 1. first we wait until the player is in the investigation radius
    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.investigation_center_position);

      if (this.has_monsters_with_clues) {
        if (parent.hasOneOfTheEntitiesGeraltAsTarget()) {
          break;
        }

        if (parent.bestiary_entry.type != CreatureWILDHUNT) {
          this.playEatingAnimationNecrophages();
        }

        // if the chosen type is the wildhunt and there are wild hunt members
        // the weather should be snowy.
        if (parent.bestiary_entry.type == CreatureWILDHUNT
        && !has_set_weather_snow) {

          if (distance_from_player < this.investigation_radius * this.investigation_radius * 3) {
            RequestWeatherChangeTo('WT_Snow', 7, false);

            REROL_air_strange_and_the_mist(false);
            has_set_weather_snow = true;
          }
        }
      }

      Sleep(0.5);
    } while (distance_from_player > this.investigation_radius * this.investigation_radius * 1.5);

    // 2. once the player is in the radius, we play sone oneliners
    //    cannot play if there were necrophages around the corpses.
    if (this.has_monsters_with_clues) {
      if (parent.bestiary_entry.type == CreatureWILDHUNT) {
        REROL_the_wild_hunt();
      }
      else if (!parent.areAllEntitiesDead()) {
        REROL_necrophages_great();
      }

      this.makeNecrophagesTargetPlayer();

      this.waitUntilAllEntitiesAreDead();

      RequestWeatherChangeTo('WT_Clear',30,false);

      Sleep(2);

      if (parent.bestiary_entry.type == CreatureWILDHUNT) {
        REROL_wild_hunt_killed_them();
      }
      else {
        REROL_clawed_gnawed_not_necrophages();
      }

      parent.entities.Clear();

    }
    else {
      if (RandRange(10) < 2) {
        REROL_so_many_corpses();

        // a small sleep to leave some space between the oneliners
        Sleep(0.5);
      }
      REROL_died_recently();
    }

    REROL_should_look_around(true);
  }

  private latent function playEatingAnimationNecrophages() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'q104_avallach_friendly_to_all',
        AGP_Default
      );

      ((CNewNPC)parent.entities[i]).ForgetAllActors();

      ((CActor)parent.entities[i]).ForceAIBehavior(this.eating_animation_slot, BTAP_Emergency);
    }
  }

  private latent function makeNecrophagesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'monsters',
        AGP_Default
      );

      ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
    }
  }

  private latent function waitUntilAllEntitiesAreDead() {
    while (!parent.areAllEntitiesDead() || thePlayer.IsInCombat()) {
      Sleep(0.4);
    }

    parent.entities.Clear();
  }

  var investigation_last_clues_position: Vector;

  latent function createLastClues() {
    var number_of_foot_paths: int;
    var current_track_position: Vector;
    var i: int;
    
    LogChannel('modRandomEncounters', "creating Last clues");

    // 1. we search for a random position around the site.
    this.investigation_last_clues_position = this.investigation_center_position + VecRingRand(
      this.investigation_radius * 2,
      this.investigation_radius * 1.6
    );

    // 2. we place the last clues, tracks leaving the investigation site
    // from somewhere in the investigation radius to the last clues position.
    // We do this multiple times
    number_of_foot_paths = parent.number_of_creatures;

    for (i = 0; i < number_of_foot_paths; i += 1) {
      // 2.1 we find a random position in the investigation radius
      current_track_position = this.investigation_center_position + VecRingRand(
        0,
        this.investigation_radius
      );

      // 2.2 we start drawing the trail
      parent
        .trail_maker
        .drawTrail(
          current_track_position,
          this.investigation_last_clues_position,
          6, // the radius
          ,, // no details used
          true, // uses the failsafe
          parent.master.settings.use_pathfinding_for_trails
        );
    }
  }

  latent function waitUntilPlayerReachesLastClue() {
    var distance_from_player: float;
    var has_played_oneliner: bool;

    has_played_oneliner = false;

    Sleep(1);

    // 1. first we wait until the player is near the last investigation clues
    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.investigation_last_clues_position);

      if (!has_played_oneliner && RandRange(10000) < 0.00001) {
        REROL_ground_splattered_with_blood();

        has_played_oneliner = true;
      }

      Sleep(0.2);
    } while (distance_from_player > 15 * 15);

    // 2. once the player is near, we play some oneliners
    if (RandRange(10) < 5) {
      REROL_wonder_clues_will_lead_me(true);
    } else {
      REROL_came_through_here(true);
    }
  }

  latent function CluesInvestigate_GotoNextState() {
    parent.previous_phase_checkpoint = parent.trail_maker.getLastPlacedTrack().GetWorldPosition();
    
    parent.GotoState('PhasePick');
  }
}

// This phase waits for a bit, then wait until all current creatures are killed
// and finally waits until Geralt leaves combat (because other creatures could
// have joined the fight in the meantime)
state Combat in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Combat");

    this.Combat_main();
  }

  entry function Combat_main() {
    this.makeEntitiesTargetPlayer();
    this.waitUntilPlayerFinishesCombat();

    parent.GotoState('PhasePick');
  }

  function makeEntitiesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'monsters',
        AGP_Default
      );

      ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
    }
  }

  latent function waitUntilPlayerFinishesCombat() {
    // 1. we wait until the player is out of combat
    while (!parent.areAllEntitiesFarFromPlayer() || thePlayer.IsInCombat()) {
      parent.removeDeadEntities();
      Sleep(1);
    }
  }
}

// A trail is created is created from the previous checkpoint to a random position
// where creatures will be waiting
state FinalTrailCombat in RandomEncountersReworkedContractEntity extends TrailCombat {
  event OnEnterState(previous_state_name: name) {
    LogChannel('modRandomEncounters', "Contract - State FinalTrailCombat");

    this.FinalTrailCombat_main();
  }

  entry function FinalTrailCombat_main() {
    this.TrailCombat_start();
  }

  latent function spawnRandomMonster() {
    var bestiary_entry: RER_BestiaryEntry;

    bestiary_entry = parent.bestiary_entry;

    parent.entities = bestiary_entry.spawn(parent.master, this.destination);
  }
}

// This phase starts an animation and a oneliner instantly and then goes to
// the PhasePicker state.
state KneelInteraction in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State KneelInteraction");

    this.KneelInteraction_main();
  }

  entry function KneelInteraction_main() {
    parent.previous_phase_checkpoint = thePlayer.GetWorldPosition();

    this.KneelInteraction_createTracks();
    this.KneelInteraction_playAnimation();
    parent.GotoState('PhasePick');
  }

  latent function KneelInteraction_createTracks() {
    var max_number_of_clues: int;
    var current_clue_position: Vector;
    var i: int;

    max_number_of_clues = RandRange(8, 3);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.previous_phase_checkpoint 
        + VecRingRand(0, 5);

      FixZAxis(current_clue_position);

      parent
        .trail_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }

    // and we had a clue right on Geralt for the animation
    current_clue_position = parent.previous_phase_checkpoint + VecRingRand(0, 1);

    parent.trail_maker.addTrackHere(
      current_clue_position,
      thePlayer.GetWorldRotation()
    );
  }

  latent function KneelInteraction_playAnimation() {
    var monster_clue: RER_MonsterClue;

    REROL_mhm();
    Sleep(0.5);
    
    monster_clue = parent.trail_maker.getLastPlacedTrack();
    monster_clue.GotoState('Interacting');

    if (!parent.master.settings.disable_camera_scenes) {
      this.playCameraScene();
      Sleep(3);
    }
    else {
      Sleep(7);
    }
  }

  private latent function playCameraScene() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var look_at_position: Vector;

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(2, 2, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    look_at_position = thePlayer.GetWorldPosition();
    scene.look_at_target_static = look_at_position;

    scene.velocity_type = RER_CameraVelocityType_FORWARD;
    scene.velocity = Vector(0.001, 0.001, 0);

    scene.duration = 2;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene, true);
  }
}

// The TrailBreakoff state is a simple phase to lead Geralt to a point, where
// he will then say something along the line of "Lost the trail, should look around"
// the trail starts from the previous checkpoint and goes to a random position.
//
// This phase is useful to move Geralt around and then play another phase such as
// the ambush phase. Because the ambush phase is a stationary phase without any trail.
// So by combining TrailBreakoff and Ambush you get Geralt being ambushed while
// following a trail.
state TrailBreakoff in RandomEncountersReworkedContractEntity extends TrailPhase {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailBreakoff");

    this.TrailBreakoff_main();
  }

  var destination: Vector;

  entry function TrailBreakoff_main() {
    if (!this.getNewTrailDestination(this.destination, 0.5)) {
      LogChannel('modRandomEncounters', "Contract - State TrailBreakoff, could not find trail destination");
      parent.endContract();

      return;
    }

    this.play_oneliner_begin();

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination,
      parent.number_of_creatures
    );

    this.waitForPlayerToReachPoint(this.destination, 10);

    this.play_oneliner_end();

    parent.previous_phase_checkpoint = parent.trail_maker.getLastPlacedTrack().GetWorldPosition();

    parent.GotoState('PhasePick');
  }

  latent function play_oneliner_begin() {
    var previous_phase: name;

    previous_phase = parent.getPreviousPhase('Ambush');

    if (previous_phase == 'TrailBreakoff') {
      REROL_trail_goes_on(true);
    }
  }

  latent function play_oneliner_end() {
    if (RandRange(10) < 5) {
      REROL_trail_ends_here();
    }
    else {
      REROL_trail_breaks_off();
    }
  }
}

// Many trails are created around the previous checkpoint and the player has to
// follow one. He cannot go back and follow another one.
// It's almost like the TrailSplit phase but the trails aren't created exactly
// on the previous checkpoint, but in a radius around it. It's more suited for
// phases like Combat, Ambush, CluesInvestigate, etc...
state TrailChoice in RandomEncountersReworkedContractEntity extends TrailPhase {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailChoice");

    this.TrailChoice_main();
  }

  var destination_one: Vector;
  var destination_two: Vector;

  entry function TrailChoice_main() {
    var picked_destination: int;

    this.trail_origin_radius = 10;

    this.createTrails();

    this.play_oneliner_begin();

    picked_destination = this.waitForPlayerToReachOnePoint();

    this.updateCheckpoint(picked_destination);

    parent.GotoState('PhasePick');
  }


  //
  // controls how far from the previous checkpoint the trails start
  public var trail_origin_radius: float;
  default trail_origin_radius = 0.5;

  latent function createTrails() {
    var origin: Vector;
    var picked_destination: int;
    var checkpoint_save: Vector;

    checkpoint_save = parent.previous_phase_checkpoint;

    // kind of a hack, because `getNewTrailDestination` uses `parent.previous_phase_checkpoint`
    // as the origin. And we want to be able to choose where it starts
    parent.previous_phase_checkpoint = checkpoint_save + VecRingRand(0, trail_origin_radius);
    if (!this.getNewTrailDestination(this.destination_one, 0.1)) {
      LogChannel('modRandomEncounters', "Contract - State TrailBreakoff, could not find trail destination one");
      parent.endContract();

      return;
    }

    parent.previous_phase_checkpoint = checkpoint_save + VecRingRand(0, trail_origin_radius);
    if (!this.getNewTrailDestination(this.destination_two, 0.1)) {
      LogChannel('modRandomEncounters', "Contract - State TrailBreakoff, could not find trail destination two");
      parent.endContract();

      return;
    }

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination_one,
      Max(parent.number_of_creatures / 2, 1)
    );

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination_two,
      Max(parent.number_of_creatures / 2, 1)
    );
  }

  latent function play_oneliner_begin() {
    var previous_phase: name;

    previous_phase = parent.getPreviousPhase('Ambush');

    if (previous_phase == 'TrailBreakoff') {
      REROL_trail_goes_on(true);
    }
    else {
      REROL_should_look_around(true);
    }

    Sleep(2);

    REROL_wonder_they_split(true);
  }

  latent function updateCheckpoint(picked_destination: int) {
    if (picked_destination == 1) {     
      parent.previous_phase_checkpoint = this.destination_one;
    }
    else {
      parent.previous_phase_checkpoint = this.destination_two;
    }
  }

  //
  // returns the number corresponding to the destination
  latent function waitForPlayerToReachOnePoint(): int {
    var distance_from_player: float;
    var radius: float;

    radius = 5 * 5;

    // squared radius to save performances by using VecDistanceSquared
    distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.destination_one);

    while (true) {
      SleepOneFrame();

      // 1. first the destination_one
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.destination_one);

      if (distance_from_player < radius) {
        return 1;
      }

      // 2. then the destination_two
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), this.destination_two);

      if (distance_from_player < radius) {
        return 2;
      }
    }

    return 1;
  }
}

// A trail is created is created from the previous checkpoint to a random position
// where creatures will be waiting
state TrailCombat in RandomEncountersReworkedContractEntity extends TrailPhase {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailCombat");

    this.TrailCombat_main();
  }

  var destination: Vector;

  entry function TrailCombat_main() {
    this.TrailCombat_start();
  }

  latent function TrailCombat_start() {
    if (!this.getNewTrailDestination(this.destination, 0.5)) {
      LogChannel('modRandomEncounters', "Contract - State TrailCombat, could not find trail destination");
      parent.endContract();

      return;
    }

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination,
      parent.number_of_creatures
    );

    this.play_oneliner_begin();

    this.spawnRandomMonster();

    this.waitForPlayerToReachPoint(this.destination, 15);

    REROL_there_you_are(true);

    parent.previous_phase_checkpoint = parent.trail_maker.getLastPlacedTrack().GetWorldPosition();

    parent.GotoState('Combat');
  }

  latent function play_oneliner_begin() {
    var previous_phase: name;

    previous_phase = parent.getPreviousPhase('Ambush');

    if (previous_phase == 'TrailBreakoff') {
      REROL_trail_goes_on(true);
    }
  }

  latent function spawnRandomMonster() {
    var bestiary_entry: RER_BestiaryEntry;

    bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary(parent.master, EncounterType_CONTRACT);

    parent.entities = bestiary_entry.spawn(parent.master, this.destination);
  }

  latent function waitForPlayerToReachPoint_action(): bool {
    this.keepCreaturesOnPoint(this.destination, 20);

    // tell it to stop waiting if one creature targets Geralt
    return parent.hasOneOfTheEntitiesGeraltAsTarget();
  }

}

// Two trails are created at the previous checkpoint and the player has to follow
// one or the other, he cannot follow one and go back later.
state TrailSplit in RandomEncountersReworkedContractEntity extends TrailChoice {
  event OnEnterState(previous_state_name: name) {

    LogChannel('modRandomEncounters', "Contract - State TrailSplit");

    this.TrailSplit_main();
  }

  entry function TrailSplit_main() {
    var picked_destination: int;

    this.trail_origin_radius = 0.1;

    this.createTrails();

    REROL_wonder_they_split(true);

    picked_destination = this.waitForPlayerToReachOnePoint();

    this.updateCheckpoint(picked_destination);

    parent.GotoState('PhasePick');
  }
}

state Ending in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    Sleep(1);
    REROL_its_over();

    parent.clean();
  }
}

state Loading in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Loading");

    this.Loading_main();
  }

  entry function Loading_main() {
    this.Loading_loadTrailMakers();
    this.Loading_loadBasicVariables();    

    parent.GotoState('PhasePick');
  }

  latent function Loading_loadTrailMakers() {
    var trail_resources: array<RER_TrailMakerTrack>;
    var blood_resources: array<RER_TrailMakerTrack>;
    var corpse_resources: array<RER_TrailMakerTrack>;
    var trail_ratio: int;

    switch (parent.bestiary_entry.type) {
      case CreatureBARGHEST :
      case CreatureWILDHUNT :
      case CreatureNIGHTWRAITH :
      case CreatureNOONWRAITH :
      case CreatureWRAITH :
        // these are the type of creatures where we use fog
        // so we increase the ratio to save performances.
        trail_ratio = parent.master.settings.foottracks_ratio * 4;

      default :
        trail_ratio = parent.master.settings.foottracks_ratio * 1;
    }

    parent.trail_maker = new RER_TrailMaker in this;

    LogChannel('RER', "loading trail_maker, ratio = " + parent.master.settings.foottracks_ratio);
    
    trail_resources.PushBack(
      getTracksTemplateByCreatureType(
        parent.bestiary_entry.type
      )
    );

    parent.trail_maker.init(
      trail_ratio,
      600,
      trail_resources
    );

    LogChannel('RER', "loading blood_maker");

    blood_resources = parent
        .master
        .resources
        .getBloodSplatsResources();
    
    parent.blood_maker = new RER_TrailMaker in this;
    parent.blood_maker.init(
      parent.master.settings.foottracks_ratio,
      100,
      blood_resources
    );

    LogChannel('RER', "loading corpse_maker");

    corpse_resources = parent
        .master
        .resources
        .getCorpsesResources();

    parent.corpse_maker = new RER_TrailMaker in this;
    parent.corpse_maker.init(
      parent.master.settings.foottracks_ratio,
      50,
      corpse_resources
    );
  }

  function Loading_loadBasicVariables() {
    parent.previous_phase_checkpoint = parent.GetWorldPosition();
  }
}

struct RER_PhasePickRegisteredPhase {
  var phase_name: name;
  var phase_chance: int;
  var longevity_cost: float;
}

state PhasePick in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State PhasePick");

    if (parent.longevity > 0) {
      this.PhasePick_pickNextPhase();
    }
    else {
      parent.endContract();
    }
  }

  entry function PhasePick_pickNextPhase() {
    var previous_phase: name;
    // represents the n-1 phase.
    var n1_phase: name;
    var registered_phases: array<RER_PhasePickRegisteredPhase>;
    var picked_phase: RER_PhasePickRegisteredPhase;

    delayIncomingEncounters();

    previous_phase = parent.getPreviousPhase();
    n1_phase = parent.getPreviousPhase(previous_phase);

    // When the longevity is this low, force the end of the contract with
    // the picked creature type. 
    if (parent.longevity <= 2) {
      // And it's always a trailcombat to give the player the time to prepare
      // for the fight in case it's a large creature.
      registered_phases.PushBack(RER_PhasePickRegisteredPhase(
        'FinalTrailCombat',
        50,
        2
      ));

      picked_phase = this.rollRegisteredPhases(registered_phases);
      
      parent.longevity = -1;
      parent.GotoState(picked_phase.phase_name);

      return;
    }

    switch (previous_phase) {
      case 'Loading':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('CluesInvestigate', 10, 1));
        if (!thePlayer.IsUsingHorse()) {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase('KneelInteraction', 10, 1));
        }
        break;

      case 'CluesInvestigate':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailChoice', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        break;

      case 'KneelInteraction':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailChoice', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 10, 2));
        break;

      case 'TrailCombat':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 10, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailChoice', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        if (n1_phase != 'KneelInteraction') {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase('KneelInteraction', 10, 1));
        }
        break;
      
      case 'TrailSplit':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 4, 2));
        break;

      case 'TrailChoice':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 4, 2));
        break;

      case 'TrailBreakoff':
        if (n1_phase != 'KneelInteraction') {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase('KneelInteraction', 5, 0.5));
        }
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 5, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailSplit', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        break;

      case 'Ambush':
        if (n1_phase != 'KneelInteraction') {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase('KneelInteraction', 10, 0.5));
        }
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailChoice', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 5, 2));
        break;
    }

    picked_phase = this.rollRegisteredPhases(registered_phases);

    this.printContractPhasesTree(picked_phase);

    switch (picked_phase.phase_name) {
      case 'TrailChoice':
      case 'KneelAnimation':
      case 'Ambush':
      case 'TrailBreakoff':
        if (previous_phase != 'KneelAnimation') {
          parent.trail_maker.hidePreviousTracks();
        }
        break;
    }
    
    if (picked_phase.phase_name != '__unknown__') {
      parent.longevity -= picked_phase.longevity_cost;
      parent.played_phases.PushBack(picked_phase.phase_name);
      parent.GotoState(picked_phase.phase_name);
    }
    else {
      NDEBUG("RER encountered an error, contract ending");
      LogChannel('modRandomEncounters', "Contract - State PhasePick: could not find the next phase");
      parent.endContract();
    }
  }

  // During my tests i could not finish a single contracts not because of the
  // difficulty of the contract, but because there were hunts and ambushes
  // that interrupted the gameplay and made everything harder.
  // This function was created so that whenever a phase is finished and the contract
  // goes in this state, if an encounter is supposed to be created in the new few
  // minutes, it will be delayed.
  function delayIncomingEncounters() {
    //                                     5 minutes
    if (parent.master.ticks_before_spawn < 60 * 5) {
      parent.master.GotoState('SpawningDelayed');
    }
  }

  function rollRegisteredPhases(phases: array<RER_PhasePickRegisteredPhase>): RER_PhasePickRegisteredPhase {
    var i: int;
    var max: int;
    var roll: int;

    max = 0;
    for (i = 0; i < phases.Size(); i += 1) {
      max += phases[i].phase_chance;
    }

    roll = RandRange(max);

    for (i = 0; i < phases.Size(); i += 1) {
      if (roll < phases[i].phase_chance) {
        return phases[i];
      }

      roll -= phases[i].phase_chance;
    }

    // return the last one if the list is not empty
    i = phases.Size();
    if (i > 0) {
      return phases[i - 1];
    }

    return RER_PhasePickRegisteredPhase('__unknown__', 0, 0);
  }

  public function printContractPhasesTree(next_phase: RER_PhasePickRegisteredPhase) {
    var i: int;
    var message: string;

    message = "Loading";

    for (i = 0; i < parent.played_phases.Size(); i += 1) {
      message += " -> " + NameToString(parent.played_phases[i]);
    }

    message += " -> [" + NameToString(next_phase.phase_name) + "]";
    

    LogChannel('modRandomEncounters', "Contract - State PhasePick, phases tree BEGIN");
    LogChannel('modRandomEncounters', message);
    LogChannel('modRandomEncounters', "Contract - State PhasePick, current longevity = " + parent.longevity + ", next phase cost = " + next_phase.longevity_cost);
    LogChannel('modRandomEncounters', "Contract - State PhasePick, phases tree END.");
  }
}

// The `TrailPhase` state is kind of an abstract state other states should inherit from.
// It offers the needed functions for any state that wants to be an
// intermediary/repeatable state.
state TrailPhase in RandomEncountersReworkedContractEntity {

  // Draws a trail from the previous checkpoint. This function is used when the player
  // is expected to follow a trail before reaching the destination point
  latent function drawTrailsTo(destination: Vector, trails_count: int) {
    var radius: float;
    var use_failsafe: bool;
    var i: int;

    trails_count = Min(trails_count, 1);
    radius = 3;
    use_failsafe = true;

    for (i = 0; i < trails_count; i += 1) {
      parent
      .trail_maker
      .drawTrail(
        parent.previous_phase_checkpoint,
        destination,
        radius,
        ,
        ,
        use_failsafe,
        parent.master.settings.use_pathfinding_for_trails
      );
    }
  }

  latent function drawTrailsToWithCorpseDetailsMaker(destination: Vector, trails_count: int) {
    var corpse_and_blood_details_maker: RER_CorpseAndBloodTrailDetailsMaker;
    var radius: float;
    var use_failsafe: bool;
    var details_chance: float;
    var i: int;

    trails_count = Min(trails_count, 1);
    radius = 3;
    use_failsafe = true;
    details_chance = 1;

    corpse_and_blood_details_maker = new RER_CorpseAndBloodTrailDetailsMaker in this;
    corpse_and_blood_details_maker.corpse_maker = parent.corpse_maker;
    corpse_and_blood_details_maker.blood_maker = parent.blood_maker;

    for (i = 0; i < trails_count; i += 1) {
      parent
      .trail_maker
      .drawTrail(
        parent.previous_phase_checkpoint,
        destination,
        radius,
        corpse_and_blood_details_maker,
        details_chance,
        use_failsafe,
        parent.master.settings.use_pathfinding_for_trails
      );
    }
  }

  // Get a new random trail destination and returns true if it found one, or false
  // if it didn't.
  function getNewTrailDestination(out destination: Vector, optional distance_multiplier: float): bool {
    var found_destination: bool;
    var max_attempt_count: int;
    var current_search_destination: Vector;
    var search_heading: float;
    var min_radius: float;
    var max_radius: float;
    var i: int;

    if (distance_multiplier == 0) {
      distance_multiplier = 1;
    }

    max_attempt_count = 10;
    search_heading = VecHeading(parent.previous_phase_checkpoint - thePlayer.GetWorldPosition());
    min_radius = 100 * distance_multiplier;
    max_radius = 200 * distance_multiplier;

    for (i = 0; i < max_attempt_count; i += 1) {
      current_search_destination = parent.previous_phase_checkpoint
          + VecConeRand(search_heading, 270, min_radius, max_radius);

      found_destination = getGroundPosition(current_search_destination, 5);
      if (found_destination) {
        destination = current_search_destination;

        return true;
      }
    }

    return false;
  }

  // waits for the player to reach the supplied position. It's a latent function
  // that will sleep until the player reaches the point. Be careful.
  latent function waitForPlayerToReachPoint(position: Vector, radius: float) {
    var distance_from_player: float;
    var should_cancel: bool;

    // squared radius to save performances by using VecDistanceSquared
    radius *= radius;
    distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), position);

    while (distance_from_player > radius && !parent.hasOneOfTheEntitiesGeraltAsTarget()) {
      SleepOneFrame();

      should_cancel = this.waitForPlayerToReachPoint_action();
      if (should_cancel) {
        break;
      };

      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), position);
    }
  }

  // override the function if necessary
  latent function waitForPlayerToReachPoint_action(): bool { return false; }

  // Checks if one of the creatures is outside the given point and its radius
  // and teleports it back into the circle  ifthe creature is indeed outside.
  // The function is supposed to be called in a fast while loop to keep the
  // creatures on point in an efficient way.
  latent function keepCreaturesOnPoint(position: Vector, radius: float) {
    var distance_from_point: float;
    var old_position: Vector;
    var new_position: Vector;
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      old_position = parent.entities[i].GetWorldPosition();

      distance_from_point = VecDistanceSquared(
        old_position,
        position
      );

      if (distance_from_point > radius) {
        new_position = VecInterpolate(
          old_position,
          position,
          1 / radius
        );

        FixZAxis(new_position);

        if (new_position.Z < old_position.Z) {
          new_position.Z = old_position.Z;
        }

        parent
          .entities[i]
          .Teleport(new_position);
      }
    }
  }

}
statemachine class RandomEncountersReworkedGryphonHuntEntity extends CEntity {
  public var bait_position: Vector;

  // ticks variable used in some states. 
  // often used to run a timer for set period.
  public var ticks: int;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  public var animation_slot: CAIPlayAnimationSlotAction;
	public var animation_slot_idle : CAIPlayAnimationSlotAction;

  public var automatic_kill_threshold_distance: float;
  default automatic_kill_threshold_distance = 600;


  public var blood_resources: array<RER_TrailMakerTrack>;
  public var blood_resources_size: int;

  public var pickup_animation_on_death: bool;
  default pickup_animation_on_death = false;

  var blood_maker: RER_TrailMaker;

  var horse_corpse_near_geralt: CEntity;
  var horse_corpse_near_gryphon: CEntity;

  var master: CRandomEncounters;

  event OnSpawned( spawnData : SEntitySpawnData ){
    super.OnSpawned(spawnData);

    animation_slot = new CAIPlayAnimationSlotAction in this;
    this.animation_slot.OnCreated();
    this.animation_slot.animName = 'monster_gryphon_special_attack_tearing_up_loop';
    this.animation_slot.blendInTime = 1.0f;
    this.animation_slot.blendOutTime = 1.0f;  
    this.animation_slot.slotName = 'NPC_ANIM_SLOT';

    this.animation_slot_idle = new CAIPlayAnimationSlotAction in this;
		this.animation_slot_idle.OnCreated();
		this.animation_slot_idle.animName = 'monster_gryphon_idle';	
		this.animation_slot_idle.blendInTime = 1.0f;
		this.animation_slot_idle.blendOutTime = 1.0f;	
		this.animation_slot_idle.slotName = 'NPC_ANIM_SLOT';

    this.this_actor.SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

    LogChannel('modRandomEncounters', "RandomEncountersReworkedGryphonHuntEntity spawned");
  }

  public function attach(actor: CActor, newnpc: CNewNPC, this_entity: CEntity, master: CRandomEncounters) {
    this.this_actor = actor;
    this.this_newnpc = newnpc;
    this.this_entity = this_entity;

    this.master = master;

    this.CreateAttachment( this_entity );
    this.AddTag('RandomEncountersReworked_Entity');
    newnpc.AddTag('RandomEncountersReworked_Entity');
  }

  // ENTRY-POINT for the gryphon fight
  public function startEncounter(blood_resources: array<RER_TrailMakerTrack>) {
    LogChannel('modRandomEncounters', "RandomEncountersReworkedGryphonHuntEntity encounter started");

    this.blood_maker = new RER_TrailMaker in this;
    this.blood_maker.init(
      this.master.settings.foottracks_ratio,
      200,
      blood_resources
    );

    this.AddTimer('intervalLifecheckFunction', 1, true);
    
    if (RandRange(10) >= 5) {
      this.GotoState('WaitingForPlayer');
    }
    else {
      this.GotoState('FlyingAbovePlayer');
    }
  }

  public function killNearbyEntities(center: CNode) {
    var entities_in_range : array<CGameplayEntity>;
    var i: int;

    FindGameplayEntitiesInRange(entities_in_range , center, 20, 50, /*NOP*/, /*NOP*/, /*NOP*/, 'CNewNPC');

    for(i=0;i<entities_in_range.Size();i+=1) {
      if ((CActor)entities_in_range[i] != this.this_actor
      &&  (CActor)entities_in_range[i] != this
      &&  (CNode)entities_in_range[i] != center
      &&  !((CNewNPC)entities_in_range[i]).HasTag('RandomEncountersReworked_Entity')
      &&  (
            ((CNewNPC)entities_in_range[i]).HasTag('animal')
        ||  ((CActor)entities_in_range[i]).IsMonster()
        ||  ((CActor)entities_in_range[i]).GetAttitude( thePlayer ) == AIA_Hostile
      )) {

        ((CActor)entities_in_range[i]).Kill('RandomEncounters',true);

      }
    }
  }

  public function removeAllLoot() {
    var inventory: CInventoryComponent;

    inventory = this.this_actor.GetInventory();

    inventory.EnableLoot(false);
  }

  event OnDestroyed() {
    this.clean();
  }

  timer function intervalLifecheckFunction(optional dt : float, optional id : Int32) {
    var distance_from_player: float;

    if (!this.this_newnpc.IsAlive()) {
      this.clean();

      return;
    }

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    if (distance_from_player > this.automatic_kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
      this.clean();

      return;
    }
  }

  private function clean() {
    var i: int;

    LogChannel('modRandomEncounters', "RandomEncountersReworkedGryphonHuntEntity destroyed");
    
    RemoveTimer('intervalDefaultFunction');

    this.horse_corpse_near_geralt.Destroy();
    this.horse_corpse_near_gryphon.Destroy();

    this.GotoState('ExitEncounter');

    theSound.SoundEvent("stop_music");
		theSound.InitializeAreaMusic( theGame.GetCommonMapManager().GetCurrentArea() );

    this.this_actor.Kill('RandomEncountersReworked_Entity', true);

    if (this.pickup_animation_on_death) {
      this.master.requestOutOfCombatAction(OutOfCombatRequest_TROPHY_CUTSCENE);
    }
    
    this.Destroy();
  }
}

state ExitEncounter in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
  }
}


// When the gryphon is fighting with the player. 
// The gryphon is fighting with you until a health threshold. Where he
// will start fleeing
// MULTIPLE state. Can be used multiple times in the encounter
state GryphonFightingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  var can_flee_fight: bool;
  var starting_health: float;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    if (previous_state_name == 'FlyingAbovePlayer') {
      this.can_flee_fight = true;
    }
    else {
      this.can_flee_fight = false;
    }

    this.starting_health = parent.this_actor.GetHealthPercents();

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFightingPlayer");

    theSound.SoundEvent("stop_music");
    theSound.SoundEvent("play_music_nomansgrad");
    theSound.SoundEvent("mus_griffin_combat");

    parent.AddTimer('GryphonFightingPlayer_intervalDefaultFunction', 0.5, true);
  }

  timer function GryphonFightingPlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    LogChannel('modRandomEncounters', "health loss: " + (this.starting_health - parent.this_actor.GetHealthPercents()));

    if (this.can_flee_fight && this.starting_health - parent.this_actor.GetHealthPercents() > 0.45) {
      parent.GotoState('GryphonFleeingPlayer');
    }
  }

  event OnLeaveState( nextStateName : name ) {
    parent.RemoveTimer('GryphonFightingPlayer_intervalDefaultFunction');

    theSound.SoundEvent("stop_music");
    theSound.InitializeAreaMusic( theGame.GetCommonMapManager().GetCurrentArea() );


    super.OnLeaveState(nextStateName);
  }
}

// The gryphon is fleeing far from the player.
// The gryphon is hurt, he's bleeding and start flying far from the
// player at low speed. So the player can catch him with or without
// Roach. It ends when the gryphon is exhausted and goes on the ground
// SINGLE state. Used once in the encounter (more would be annoying)
state GryphonFleeingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  var is_bleeding: bool;
  var bait: CEntity;
  var ai_behavior_flight: CAIFlightIdleFreeRoam;
  var ai_behavior_combat: CAIFlyingMonsterCombat;
  var flight_heading: float;
  var distance_threshold: float;
  var starting_position: Vector;
  
  // if found_landing_position is set to true,
  // The gryphon will go to the landing position
  var found_landing_position: bool;
  var landing_position: Vector;



  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    // the gryphon bleeds only if a fight happened before.
    if (previous_state_name == 'GryphonFightingPlayer') {
      this.is_bleeding = true;
    }
    else {
      this.is_bleeding = false;
    }

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFleeingPlayer");

    this.GryphonFleeingPlayer_main();
  }


  entry function GryphonFleeingPlayer_main() {
    var i: int;

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFleeingPlayer - main");

    (parent.this_actor).SetImmortalityMode(AIM_Invulnerable, AIC_Default);
    (parent.this_actor).EnableCharacterCollisions(false);
    (parent.this_actor).EnableDynamicCollisions(false);

    bait = theGame.CreateEntity(
      (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
      parent.this_entity.GetWorldPosition(),
      thePlayer.GetWorldRotation(),
      true,
      false,
      false,
      PM_DontPersist
    );

    for(i=0;i<100;i+=1) {
      parent.this_newnpc.CancelAIBehavior(i);
    }

    ((CNewNPC)this.bait).SetGameplayVisibility(false);
    ((CNewNPC)this.bait).SetVisibility(false);    
    ((CActor)this.bait).EnableCharacterCollisions(false);
    ((CActor)this.bait).EnableDynamicCollisions(false);
    ((CActor)this.bait).EnableStaticCollisions(false);
    ((CActor)this.bait).SetImmortalityMode(AIM_Immortal, AIC_Default);

    parent.this_newnpc.SetUnstoppable(true);

    theSound.SoundEvent("stop_music");
    theSound.SoundEvent("mus_griffin_chase");

    // this.GryphonFleeingPlayer_startFlying();
    this.GryphonFleeingPlayer_forgetPlayer();

    parent.AddTimer('GryphonFleeingPlayer_startFlying', 2, false);
    parent.AddTimer('GryphonFleeingPlayer_forgetPlayer', 0.05, true);

    // in case something unexpected happened.
    // the timer is removed if the gryphon is waiting for the player
    // the gryphon will enter into the FlyingAbovePlayer state.
    // meaning il will come back to the player.
    parent.AddTimer('GryphonFleeingPlayer_GiveUp', 60, true);
  }

  timer function GryphonFleeingPlayer_forgetPlayer(optional dt : float, optional id : Int32) {
    parent.this_newnpc.ForgetActor(thePlayer);
  }

  timer function GryphonFleeingPlayer_startFlying(optional dt : float, optional id : Int32) {
    this.ai_behavior_flight = new CAIFlightIdleFreeRoam in this;

    this.flight_heading = VecHeading(
      parent.this_entity.GetWorldPosition() - thePlayer.GetWorldPosition()
    );

    parent.this_actor.SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );
    parent.this_newnpc.ForgetActor(thePlayer);
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    this.distance_threshold = 150 * 150; // squared value for performances
    this.starting_position = thePlayer.GetWorldPosition();

    theSound.SoundEvent("stop_music");
    theSound.SoundEvent("play_music_nomansgrad");
    theSound.SoundEvent("mus_griffin_chase");

    parent.AddTimer('GryphonFleeingPlayer_intervalDefaultFunction', 2, true);

    if (this.is_bleeding) {
      parent.AddTimer('GryphonFleeingPlayer_intervalDropBloodFunction', 0.3, true);
    }
  }


  timer function GryphonFleeingPlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    var bait_position: Vector;

    LogChannel('modRandomEncounters', "gryphon fleeing");

    parent.this_actor.SetTemporaryAttitudeGroup( 'monsters', AGP_Default );

    bait_position = parent.this_entity.GetWorldPosition();
    bait_position += VecConeRand(this.flight_heading, 1, 100, 100);

    FixZAxis(bait_position);

    bait_position.Z += 50;

    this.bait.Teleport(bait_position);
    
    parent.this_newnpc.ForgetAllActors();
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    parent.this_actor.SetHealthPerc(parent.this_actor.GetHealthPercents() + 0.01);

    // attempt at forcing the gryphon to fly
    parent.this_entity.Teleport(parent.this_entity.GetWorldPosition() + Vector(0, 0, 0.1));

    // distance_threshold is already squared
    if (VecDistanceSquared(this.starting_position, parent.this_actor.GetWorldPosition()) > distance_threshold) {
      LogChannel('modRandomEncounters', "Gryphon looking for ground position");

      parent.RemoveTimer('GryphonFleeingPlayer_intervalDefaultFunction');
      parent.AddTimer('GryphonFightingPlayer_intervalLookingForGroundPositionFunction', 1, true);

      // the gryphon is coming down, set back his collisions.
      (parent.this_actor).SetImmortalityMode(AIM_Invulnerable, AIC_Default);
      (parent.this_actor).EnableCharacterCollisions(true);
      (parent.this_actor).EnableDynamicCollisions(true);
      parent.this_newnpc.SetUnstoppable(false);

    }
  }

  timer function GryphonFightingPlayer_intervalLookingForGroundPositionFunction(optional dt: float, optional id: Int32) {
    var bait_position: Vector;

    bait_position = VecRingRand(1, 20) + parent.this_entity.GetWorldPosition();
    bait_position.Z -= 20;

    // the bait is close enough for the ground.
    // we look for a safe landing position
    if (!this.found_landing_position && ((CActor)bait).GetDistanceFromGround(500) <= 20) {
      this.landing_position = bait_position;
      
      if (theGame.GetWorld().NavigationFindSafeSpot(this.landing_position, 2, 100, this.landing_position)
      // if (getGroundPosition(this.landing_position, 3.0)
      && theGame.GetWorld().GetWaterLevel(this.landing_position, true) <= this.landing_position.Z) {

        LogChannel('modRandomEncounters', "found landing position");
        this.found_landing_position = true;
        
        // so the bait is not completely into the ground
        this.landing_position.Z += 0.5;

        bait_position = this.landing_position;
      }
    }

    if (this.found_landing_position) {
      bait_position = this.landing_position;
    }

    this.bait.Teleport(bait_position);
    parent.this_actor.SetTemporaryAttitudeGroup( 'monsters', AGP_Default );
    parent.this_newnpc.ForgetActor(thePlayer);
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    // attempt at making the gryphon land gracefully
    if (parent.this_actor.GetDistanceFromGround(500) > 5) {
      parent.this_entity.Teleport(parent.this_entity.GetWorldPosition() - Vector(0, 0, 0.05));
    }

    parent.this_actor.SetHealthPerc(parent.this_actor.GetHealthPercents() + 0.01);

    if (this.found_landing_position) {
      parent.killNearbyEntities(this.bait);
    }

    if (this.found_landing_position && parent.this_actor.GetDistanceFromGround(500) < 5) {
      (parent.this_actor).EnableCharacterCollisions(true);
      (parent.this_actor).EnableDynamicCollisions(true);
      (parent.this_actor).EnableStaticCollisions(true);
      parent.this_newnpc.SetUnstoppable(false);


      LogChannel('modRandomEncounters', "Gryphon landed");

      parent.RemoveTimer('GryphonFightingPlayer_intervalLookingForGroundPositionFunction');
      // the gryphon found a landing spot, giving up now would not make sense.
      parent.RemoveTimer('GryphonFleeingPlayer_GiveUp');

      this.cancelAIBehavior();

      this.ai_behavior_combat = new CAIFlyingMonsterCombat in this;
      parent.this_actor.ForceAIBehavior( this.ai_behavior_combat, BTAP_Emergency );
      
      parent.AddTimer('GryphonFleeingPlayer_intervalWaitPlayerFunction', 0.5, true);
    }
  }

  timer function GryphonFleeingPlayer_intervalWaitPlayerFunction(optional dt : float, optional id : Int32) {
    var gryphon_position: Vector;
		var mac 	: CMovingPhysicalAgentComponent;

    this.bait.Teleport(this.landing_position);

    parent.this_newnpc.ForgetActor(thePlayer);
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    parent.this_newnpc.ChangeStance( NS_Normal );
    parent.this_newnpc.SetBehaviorVariable( '2high', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 1 );

    parent.this_newnpc.SetBehaviorVariable( 'DistanceFromGround', 0 );
		parent.this_newnpc.SetBehaviorVariable( 'GroundContact', 1.0 );		
		
		mac = ((CMovingPhysicalAgentComponent)parent.this_newnpc.GetMovingAgentComponent());
		parent.this_newnpc.ChangeStance( NS_Wounded );
		mac.SetAnimatedMovement( false );
		parent.this_newnpc.EnablePhysicalMovement( false );
		mac.SnapToNavigableSpace( true );
    parent.this_newnpc.PlayEffect( 'hit_ground' );

    parent.this_actor.SetHealthPerc(parent.this_actor.GetHealthPercents() + 0.005);

    if (VecDistanceSquared(parent.this_actor.GetWorldPosition(), thePlayer.GetWorldPosition()) < 625) {
      parent.GotoState('GryphonFightingPlayer');
    }
  }

  function cancelAIBehavior() {
    var i: int;
    
    for(i=0;i<100;i+=1)
    {
      parent.this_newnpc.CancelAIBehavior(i);
    }
  }

  timer function GryphonFleeingPlayer_intervalDropBloodFunction(optional dt : float, optional id: Int32) {
    var position: Vector;

    position = parent.this_actor.GetWorldPosition();

    FixZAxis(position);
    parent.blood_maker.addTrackHere(position);
  }

  timer function GryphonFleeingPlayer_GiveUp(optional dt : float, optional id: Int32) {
    parent.GotoState('FlyingAbovePlayer');
  }

  event OnLeaveState( nextStateName : name ) {
    this.bait.Destroy();
    parent.RemoveTimer('GryphonFleeingPlayer_intervalDefaultFunction');
    parent.RemoveTimer('GryphonFleeingPlayer_intervalWaitPlayerFunction');
    parent.RemoveTimer('GryphonFleeingPlayer_intervalDropBloodFunction');
    parent.RemoveTimer('GryphonFleeingPlayer_forgetPlayer');
    parent.RemoveTimer('GryphonFleeingPlayer_GiveUp');

    (parent.this_actor).SetImmortalityMode(AIM_None, AIC_Default);
    (parent.this_actor).EnableCharacterCollisions(true);
    (parent.this_actor).EnableDynamicCollisions(true);
    (parent.this_actor).EnableStaticCollisions(true);

    parent.this_newnpc.SetUnstoppable(false);


    super.OnLeaveState(nextStateName);
  }
}

// When the gryphon flies over the player, then comes back to attack it
// Imagine it flying at high-speed above you, he sees you and screems
// then he does a complete turn and starts attacking you
// ENTRY-POINT state.
state FlyingAbovePlayer in RandomEncountersReworkedGryphonHuntEntity {
  var bait: CEntity;
  var ai_behavior_flight: CAIFlightIdleFreeRoam;
  var bait_distance_from_player: float;
  var flight_heading: float;
  var distance_threshold: float;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State FlyingAbovePlayer, from " + previous_state_name);

    parent.this_actor.SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

    if (previous_state_name != 'GryphonFleeingPlayer') {
      parent.this_entity.Teleport(parent.this_entity.GetWorldPosition() + Vector(0, 0, 80));
    }

    this.FlyingAbovePlayer_main();
  }

  entry function FlyingAbovePlayer_main() {
    var i: int;

    bait = theGame.CreateEntity(
      (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
      parent.this_entity.GetWorldPosition(),
      thePlayer.GetWorldRotation(),
      true,
      false,
      false,
      PM_DontPersist
    );

    for(i=0;i<100;i+=1)
    {
      parent.this_newnpc.CancelAIBehavior(i);
    }

    ((CNewNPC)this.bait).SetGameplayVisibility(false);
    ((CNewNPC)this.bait).SetVisibility(false);    
    ((CActor)this.bait).EnableCharacterCollisions(false);
    ((CActor)this.bait).EnableDynamicCollisions(false);
    ((CActor)this.bait).EnableStaticCollisions(false);
    ((CActor)this.bait).SetImmortalityMode(AIM_Immortal, AIC_Default);

    this.ai_behavior_flight = new CAIFlightIdleFreeRoam in this;

    this.flight_heading = VecHeading(
        thePlayer.GetWorldPosition() - parent.this_entity.GetWorldPosition()
    );
    
    parent.this_actor.ForceAIBehavior( this.ai_behavior_flight, BTAP_Emergency );
    parent.this_actor.SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );

    this.distance_threshold = VecDistanceSquared(
      parent.this_entity.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    ) + 100;

    // The two seconds here is important, the gryphon doesn't fly without it
    parent.AddTimer('FlyingAbovePlayer_intervalDefaultFunction', 2, true);
  }

  timer function FlyingAbovePlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    var bait_position: Vector;

    parent.this_actor.SetTemporaryAttitudeGroup( 'monsters', AGP_Default );

    bait_position = parent.this_entity.GetWorldPosition();
    bait_position += VecConeRand(this.flight_heading, 1, 100, 100);
    
    this.bait.Teleport(bait_position);

    if (((CActor)bait).GetDistanceFromGround(500) < 100) {
      bait_position.Z += 30;
    }
    else {
      bait_position.Z -= 10;
    }

    this.bait.Teleport(bait_position);
    
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    // distance_threshold is already squared
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.this_actor.GetWorldPosition()) > distance_threshold) {
      parent.RemoveTimer('FlyingAbovePlayer_intervalDefaultFunction');
      parent.AddTimer('FlyingAbovePlayer_intervalComingToPlayer', 0.5, true);
    }
  }

  timer function FlyingAbovePlayer_intervalComingToPlayer(optional dt : float, optional id : Int32) {
    this.bait.Teleport(thePlayer.GetWorldPosition());

    parent.this_newnpc.NoticeActor((CActor)this.bait);

    // 20 * 20 = 400
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.this_actor.GetWorldPosition()) < 400) {
      parent.GotoState('GryphonFightingPlayer');
    }
  }

  event OnLeaveState( nextStateName : name ) {
    parent.RemoveTimer('FlyingAbovePlayer_intervalDefaultFunction');
    parent.RemoveTimer('FlyingAbovePlayer_intervalComingToPlayer');

    this.bait.Destroy();

    super.OnLeaveState(nextStateName);
  }
}


// When the gryphon is on the ground waiting for the player to attack it
// The gryphon is feeding on a dead beast on the ground. You have to find
// it with tracks and blood spills on the ground.
// ENTRY-POINT state.
state WaitingForPlayer in RandomEncountersReworkedGryphonHuntEntity {
  var bloodtrail_current_position: Vector;
  var bloodtrail_target_position: Vector;
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State WaitingForPlayer");

    this.WaitingForPlayer_Main();
  }

  entry function WaitingForPlayer_Main() {
    this.bloodtrail_target_position = parent.this_actor.GetWorldPosition();
    this.bloodtrail_current_position = thePlayer.GetWorldPosition() + VecRingRand(2, 4);

    parent.horse_corpse_near_geralt = this.placeHorseCorpse(this.bloodtrail_current_position);
    parent.horse_corpse_near_gryphon = this.placeHorseCorpse(this.bloodtrail_target_position, true);

		thePlayer.PlayVoiceset( 90, "MiscBloodTrail" );  

    parent.AddTimer('WaitingForPlayer_drawLineOfBloodToGryphon', 0.25, true);
    parent.AddTimer('WaitingForPlayer_intervalDefaultFunction', 0.5, true);

    parent.this_newnpc.ChangeStance( NS_Normal );
    parent.this_newnpc.SetBehaviorVariable( '2high', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 1 );

    parent.this_newnpc.SetUnstoppable(true);
  }

  private latent function placeHorseCorpse(position: Vector, optional horse_flat_on_ground: bool): CEntity {
    var horse_template: CEntityTemplate;
    var horse_rotation: EulerAngles;

    horse_rotation = RotRand(0, 360);

    if (horse_flat_on_ground) {
      horse_rotation.Yaw = 95;
    }

    horse_template = (CEntityTemplate)LoadResourceAsync(
      "items\quest_items\q103\q103_item__horse_corpse_with_head_lying_beside_it_02.w2ent",
      true
    );

    FixZAxis(position);

    return theGame.CreateEntity(horse_template, position, horse_rotation);
  }

  timer function WaitingForPlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    parent.killNearbyEntities(parent.this_actor);
    
    parent.this_actor.SetTemporaryAttitudeGroup(
      'q104_avallach_friendly_to_all',
      AGP_Default
    );

    parent.this_newnpc.ForgetAllActors();

    if (parent.this_actor.IsInCombat() && parent.this_actor.GetTarget() == thePlayer
    // the distance here is squared for performances reasons, so 400 = 20*20
    // the squareroot is a costly operation. So it's better to multiply the other
    // side and compare it to the squared value (distance).
     || VecDistanceSquared(thePlayer.GetWorldPosition(), parent.this_actor.GetWorldPosition()) < 400
     || parent.this_actor.GetDistanceFromGround(1000) > 3
    ) {
      parent.GotoState('GryphonFleeingPlayer');

      return;
    }

    parent.this_newnpc.ChangeStance( NS_Normal );
    parent.this_newnpc.SetBehaviorVariable( '2high', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 1 );

    parent.this_actor.ForceAIBehavior(parent.animation_slot, BTAP_Emergency);
  }

  // I'm making it a timer because spawning too many entities
  // in one go did not go well for the game. It crashed sometimes.
  // It's a way to drop blood splats smoothly over time.
  // the cons is that if the player is running really fast he can
  // see the blood splats appearing.
  timer function WaitingForPlayer_drawLineOfBloodToGryphon(optional dt : float, optional id : Int32) {
    var heading_to_target: float;

    heading_to_target = VecHeading(this.bloodtrail_target_position - this.bloodtrail_current_position);

    this.bloodtrail_current_position += VecConeRand(
      heading_to_target,
      80, // 80 degrees randomness
      1,
      2
    );

    FixZAxis(this.bloodtrail_current_position);

    LogChannel('modRandomEncounters', "line of blood to gryphon, current position: " + VecToString(this.bloodtrail_current_position) + " target position: " + VecToString(this.bloodtrail_target_position));

    parent.blood_maker.addTrackHere(this.bloodtrail_current_position);

    if (VecDistanceSquared(this.bloodtrail_current_position, this.bloodtrail_target_position) < 5 * 5) {
      parent.RemoveTimer('WaitingForPlayer_drawLineOfBloodToGryphon');
    }
  }

  event OnLeaveState( nextStateName : name ) {
    var i: int;

    parent.RemoveTimer('WaitingForPlayer_intervalDefaultFunction');
    parent.RemoveTimer('WaitingForPlayer_drawLineOfBloodToGryphon');

    // copied from regular RE, not sure about it.
    for(i=0; i<100; i+=1) {
      parent.this_actor.CancelAIBehavior(i);
    }

    parent.this_newnpc.SetUnstoppable(false);


    super.OnLeaveState(nextStateName);
  }
}

// Not used anywhere.
latent function flyStartFromLand(npc: CNewNPC) {
	var animation_slot : CAIPlayAnimationSlotAction;
  var ticket 				: SMovementAdjustmentRequestTicket;
  var movementAdjustor	: CMovementAdjustor;
  var slidePos 			: Vector;
  var i: float;
  var duration_in_seconds: float;
  var time_per_step: float;
  var translation_per_step: Vector;

  animation_slot = new CAIPlayAnimationSlotAction in npc;
  animation_slot.OnCreated();
  animation_slot.animName = 'monster_gryphon_fly_start_from_ground';			
  animation_slot.blendInTime = 1.0f;
  animation_slot.blendOutTime = 1.0f;	
  animation_slot.slotName = 'NPC_ANIM_SLOT';

  npc.ForceAIBehavior(animation_slot, BTAP_Emergency);
  
  duration_in_seconds = 2.0f;
  time_per_step = 0.02f;
  translation_per_step = Vector(0, 0, 10 / (duration_in_seconds / time_per_step));


  i = 0;
  while (i < duration_in_seconds) {
    npc.Teleport(npc.GetWorldPosition() + translation_per_step);
    // npc.SetBehaviorVariable( 'GroundContact', 0.0 );
    // npc.SetBehaviorVariable( 'DistanceFromGround', 100 );
    
    i += time_per_step;
    Sleep(time_per_step);
  }

  // npc.SetBehaviorVariable( 'GroundContact', 0.0 );
  // npc.SetBehaviorVariable( 'DistanceFromGround', 10 );
}

// It works but it's completely bugged. I don't understand how to use the functions
// to controls the gryphon animations. Nothing fully works :(
// Not used anywhere
latent function flyTo(npc: CNewNPC, destination_point: Vector, destination_radius: float, optional height_from_ground: float) : EBTNodeStatus {
  var traceStartPos, traceEndPos, traceEffect, normal, groundLevel : Vector;
  var should_land: bool;
  var landing_point_set: bool;
  var random: int;
  var npcPos: Vector;
  var full_distance: float;

  flyStartFromLand(npc);

  npc.ChangeStance( NS_Fly );
  npc.SetBehaviorVariable( '2high', 1 );
  npc.SetBehaviorVariable( '2low', 0 );
  npc.SetBehaviorVariable( '2ground', 0 );

  npcPos = npc.GetWorldPosition();

  // Z of destination_point can be under terrain so it must be checked
  traceStartPos = destination_point;
  traceEndPos = destination_point;
  traceStartPos.Z += 200;

  if (theGame.GetWorld().StaticTrace(traceStartPos, traceEndPos, traceEffect, normal)) {
    if (traceEffect.Z > destination_point.Z) {
      destination_point = traceEffect;
    }
  }

  destination_point.Z += MaxF(height_from_ground, 20.0);

  should_land = false;
  landing_point_set = false;
  full_distance = VecDistance(npcPos, destination_point);

  while (true) {
    npc.SetBehaviorVariable( 'GroundContact', 0.0 );
    npc.SetBehaviorVariable( 'DistanceFromGround', 100 );
    
    if (should_land) {
      // ((CMovingAgentComponent)npc.GetMovingAgentComponent()).SnapToNavigableSpace( false );

      if (VecDistance(npcPos, destination_point) < destination_radius) {
        return BTNS_Completed;
      }
    }
    else { // should_land = false
      npc.SetBehaviorVariable( 'GroundContact', 0.0 );
      npc.SetBehaviorVariable( 'DistanceFromGround', 0.0 );
      npc.SetBehaviorVariable( 'FlySpeed', 0.0f );
      
    }

    UsePathFinding(npcPos, destination_point, 2.0);
    CalculateBehaviorVariables(npc, destination_point, full_distance);

    Sleep(0.1f);

    if (VecDistance(npcPos, destination_point) < 10) {
      should_land = true;
    }
  }

  return BTNS_Completed;
}

function CalculateBehaviorVariables( npc: CNewNPC, dest : Vector, full_distance: float )
{
  var flySpeed					: float;
  var flyPitch, flyYaw 			: float;
  var turnSpeedScale				: float;
  var npcToDestVector				: Vector;
  var npcToDestVector2			: Vector;
  var npcToDestDistance			: float;
  var npcToDestAngle				: float;
  var npcPos, npcHeadingVec		: Vector;
  var normal, collision			: Vector;
  
  npcPos = npc.GetWorldPosition();
  npcHeadingVec = npc.GetHeadingVector();
  
  npcToDestVector = dest - npcPos;		
  npcToDestVector2 = npcToDestVector;
  npcToDestVector2.Z = 0;
  npcToDestDistance = VecDistance( npcPos, dest );
  
  // Calculate Fly Speed
  npcToDestAngle = AbsF( AngleDistance( VecHeading( dest - npcPos ), VecHeading( npcHeadingVec ) ) );
  
  if ( npcToDestAngle > 60 || npcToDestAngle < -60 )
  {
    flySpeed = 1.f;
  }
  else
  {
    flySpeed = 2.f;
  }

  turnSpeedScale = 2.75f;

  // Calculate Pitch
  flyPitch = Rad2Deg( AcosF( VecDot( VecNormalize( npcToDestVector ), VecNormalize( npcToDestVector2 ) ) ) );
  if ( npcPos.X == dest.X && npcPos.Y == dest.Y )
  {
    flyPitch = 90;
  }
  
  flyPitch = flyPitch/90;
  flyPitch = flyPitch * PowF( turnSpeedScale, flyPitch );

  if ( flyPitch > 1 )
  {
    flyPitch = 1.f;
  }
  else if ( flyPitch < -1 )
  {
    flyPitch = -1.f;
  }
  
  if ( dest.Z < npcPos.Z )
  {
    flyPitch *= -1;
  }
  
  // Calculate Yaw
  flyYaw = AngleDistance( VecHeading( npcToDestVector ), VecHeading( npcHeadingVec ) ) ;
  flyYaw = flyYaw / 180;
  flyYaw = flyYaw * PowF( turnSpeedScale , AbsF( flyYaw ) );
  
  if ( flyYaw > 1 )
  {
    flyYaw = 1.f;
  }
  else if ( flyYaw < -1 )
  {
    flyYaw = -1.f;
  }
  
  // If there is an obstacle in the direction we're trying to turn, go the other way around
  // If going forward
  if( flyYaw > -0.5 && flyYaw < 0.5 && theGame.GetWorld().StaticTrace( npcPos, npcPos + npc.GetWorldForward(), collision, normal ) )
  {
    //npc.GetVisualDebug().AddText( 'VolumetricObstacleText', "Volumetric obstacle Forward", collision + Vector(0,0,0.4f), true, 0, Color( 255, 255, 0 ), true, 1 );
    //npc.GetVisualDebug().AddArrow('ToVolumetricObstacle', npc.GetWorldPosition(), collision, 0.8f, 0.5f, 0.6f, true, Color( 255, 255, 0 ), true, 1 );
    flyYaw = -1;
  }
  // If turning right
  if( flyYaw < -0.5 && theGame.GetWorld().StaticTrace( npcPos, npcPos + npc.GetWorldRight(), collision, normal ) )
  {
    flyYaw  = 1;			
    //npc.GetVisualDebug().AddText( 'VolumetricObstacleText', "Volumetric obstacle Right", collision + Vector(0,0,0.4f), true, 0, Color( 255, 255, 0 ), true, 1 );
    //npc.GetVisualDebug().AddArrow('ToVolumetricObstacle', npc.GetWorldPosition(), collision, 0.8f, 0.5f, 0.6f, true, Color( 255, 255, 0 ), true, 1 );
  }
  // If turning left
  else if ( flyYaw > 0.5 && theGame.GetWorld().StaticTrace( npcPos, npcPos + ( npc.GetWorldRight() * -1 ) , collision, normal ) )
  {
    flyYaw  = -1;
    //npc.GetVisualDebug().AddText( 'VolumetricObstacleText', "Volumetric obstacle Left", collision + Vector(0,0,0.4f), true, 0, Color( 255, 255, 0 ), true, 1 );
    //npc.GetVisualDebug().AddArrow('ToVolumetricObstacle', npc.GetWorldPosition(), collision, 0.8f, 0.5f, 0.6f, true, Color( 255, 255, 0 ), true, 1 );			
  }
  
  
  
  npc.SetBehaviorVariable( 'FlyYaw', flyYaw );
  npc.SetBehaviorVariable( 'FlyPitch', flyPitch );
  npc.SetBehaviorVariable( 'FlySpeed', flySpeed );

  LogChannel('modRandomEncounters', "flyYaw" + flyYaw + " flyPitch" + flyPitch + " flySpeed" + flySpeed);
  
  // DebugDisplayDestination( dest );
  
}

function UsePathFinding( currentPosition : Vector, out targetPosition : Vector, optional predictionDist : float ) : bool
{
	var path : array<Vector>;	

  if( theGame.GetVolumePathManager().IsPathfindingNeeded( currentPosition, targetPosition ) )
  {
    path.Clear();
    if ( theGame.GetVolumePathManager().GetPath( currentPosition, targetPosition, path ) )
    {
      targetPosition = path[1];
      return true;
    }
    return false;
    //targetPosition = theGame.GetVolumePathManager().GetPointAlongPath( currentPosition, targetPosition, predictionDist );
  }
  return true;
}

struct HuntEntitySettings {
  var kill_threshold_distance: float;
  var allow_trophy_pickup_scene: bool;
}

statemachine class RandomEncountersReworkedHuntEntity extends CEntity {
  var master: CRandomEncounters;
  
  var entities: array<CEntity>;

  var bestiary_entry: RER_BestiaryEntry;

  var entity_settings: HuntEntitySettings;

  var bait_entity: CEntity;

  var trail_maker: RER_TrailMaker;

  var bait_moves_towards_player: bool;

  public function startEncounter(master: CRandomEncounters, entities: array<CEntity>, bestiary_entry: RER_BestiaryEntry, optional bait_moves_towards_player: bool) {
    this.master = master;
    this.entities = entities;
    this.bestiary_entry = bestiary_entry;
    this.bait_moves_towards_player = bait_moves_towards_player;
    this.loadSettings(master);
    this.GotoState('Loading');
  }

  private function loadSettings(master: CRandomEncounters) {
    this.entity_settings.kill_threshold_distance = master.settings.kill_threshold_distance;
    this.entity_settings.allow_trophy_pickup_scene = master.settings.trophy_pickup_scene;
  }

  public latent function clean() {
    var i: int;

    LogChannel(
      'modRandomEncounters',
      "RandomEncountersReworkedHuntEntity destroyed"
    );

    this.RemoveTimer('randomEncounterTick');

    for (i = 0; i < this.entities.Size(); i += 1) {
      this.killEntity(this.entities[i]);
    }

    trail_maker.clean();

    this.Destroy();
  }

  ///////////////////////////////////////////////////
  // below are helper functions used in the states //
  ///////////////////////////////////////////////////

  public function areAllEntitiesDead(): bool {
    var i: int;

    // LogChannel('RER', "HuntEntity - areAllEntitiesDead, entity size = " + this.entities.Size());

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).IsAlive()) {
        return false;
      }
    }

    return true;
  }

  //
  // remove the dead entities from the list of entities
  public function removeDeadEntities() {
     var i: int;
     var max: int;

     max = this.entities.Size();

     for (i = 0; i < max; i += 1) {
       if (!((CActor)this.entities[i]).IsAlive()) {
         this.entities.Remove(this.entities[i]);

         max -= 1;
         i -= 1;
       }
     }
  }

  public function areAllEntitiesFarFromPlayer(): bool {
    var player_position: Vector;
    var i: int;

    player_position = thePlayer.GetWorldPosition();

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (VecDistanceSquared(this.entities[i].GetWorldPosition(), player_position) < 20 * 20) {
        return false;
      }
    }

    return true;
  }

  public function killEntity(entity: CEntity): bool {
    ((CActor)entity).Kill('RandomEncountersReworked_Entity', true);

    return this.entities.Remove(entity);
  }

  public function getRandomEntity(): CEntity {
    var entity: CEntity;

    entity = this.entities[RandRange(this.entities.Size())];

    return entity;
  }
}

state Combat in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Hunt - State Combat");

    this.Combat_Main();
  }

  entry function Combat_Main() {
    // to know if it's an ambush
    // if true, will play a oneliner and a camera scene
    // the camera scene plays only if player is not busy and doesn't have camera scenes disabled from menu
    if (parent.bait_moves_towards_player) {
      this.startAmbushCutscene();
    }

    this.resetEntitiesAttitudes();
    this.makeEntitiesTargetPlayer();
    this.waitUntilPlayerFinishesCombat();

    if (parent.entity_settings.allow_trophy_pickup_scene) {
      parent
        .master
        .requestOutOfCombatAction(OutOfCombatRequest_TROPHY_CUTSCENE);
    }

    this.Combat_goToNextState();
  }

  private latent function startAmbushCutscene() {
    if (isPlayerBusy()) {
      return;
    }

    if (parent.master.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "BattleCryBadSituation" );
    }

    if(!parent.master.settings.disable_camera_scenes
    && parent.master.settings.enable_action_camera_scenes) {
      playAmbushCameraScene();
    }
  }

  private latent function playAmbushCameraScene() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var look_at_position: Vector;

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(0, 0, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    look_at_position = parent.getRandomEntity().GetWorldPosition();
    scene.look_at_target_static = look_at_position + Vector(0, 0, 0);

    scene.velocity_type = RER_CameraVelocityType_FORWARD;
    scene.velocity = Vector(0.001, 0.001, 0);

    scene.duration = 0.2;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();

    camera.playCameraScene(scene, true);
  }

  private latent function resetEntitiesAttitudes() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i])
        .ResetTemporaryAttitudeGroup(AGP_Default);
    }
  }

  private latent function makeEntitiesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      // ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
      //   'monsters',
      //   AGP_Default
      // );

      if (((CActor)parent.entities[i]).GetTarget() != thePlayer && !((CActor)parent.entities[i]).HasAttitudeTowards(thePlayer)) {
        ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
        ((CActor)parent.entities[i]).SetAttitude(thePlayer, AIA_Hostile);
      }
    }
  }

  latent function waitUntilPlayerFinishesCombat() {
    // sleep a bit before entering the loop, to avoid a really fast loop if the
    // player runs away from the monster
    Sleep(3);

    while (!parent.areAllEntitiesDead() && !parent.areAllEntitiesFarFromPlayer()) {
      this.makeEntitiesTargetPlayer();
      parent.removeDeadEntities();

      Sleep(1);
    }
  }

  latent function Combat_goToNextState() {
    if (parent.areAllEntitiesDead()) {
      parent.GotoState('Ending');
    }
    else {
      parent.GotoState('Wandering');
    }
  }
}

state Ending in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntEntity - State Ending");

    this.Ending_main();
  }

  entry function Ending_main() {
    parent.clean();
  }
}

state Loading in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntEntity - State Loading");
    this.Loading_main();
  }

  entry function Loading_main() {
    var template: CEntityTemplate;
    var tracks_templates: array<RER_TrailMakerTrack>;

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

    tracks_templates.PushBack(getTracksTemplateByCreatureType(parent.bestiary_entry.type));

    parent.trail_maker = new RER_TrailMaker in parent;
    parent.trail_maker.init(
      parent.master.settings.foottracks_ratio,
      200,
      tracks_templates
    );

    // to calculate the initial position we go from the
    // monsters position and use the inverse tracks_heading to
    // cross ThePlayer's path.
    parent.trail_maker
      .drawTrail(
        VecInterpolate(
          parent.GetWorldPosition(),
          thePlayer.GetWorldPosition(),
          1.3
        ),

        parent.GetWorldPosition(),
        20,,,
        true,
        parent.master.settings.use_pathfinding_for_trails
      );


    parent.GotoState('Wandering');
  }

  
}

state Wandering in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntEntity - State Wandering");
    this.Wandering_main();
  }

  entry function Wandering_main() {
    this.resetEntitiesActions();
    this.makeEntitiesMoveTowardsBait();
    this.resetEntitiesActions();

    parent.GotoState('Combat');
  }

  latent function makeEntitiesMoveTowardsBait() {
    var distance_from_player: float;
    var distance_from_bait: float;
    var current_entity: CEntity;
    var current_heading: float;
    var i: int;

    do {
      if (parent.areAllEntitiesDead()) {
        LogChannel('modRandomEncounters', "HuntEntity - wandering state, all entities dead");

        parent.GotoState('Ending');

        break;
      }

      for (i = parent.entities.Size() - 1; i >= 0; i -= 1) {
        current_entity = parent.entities[i];

        distance_from_player = VecDistance(
          current_entity.GetWorldPosition(),
          thePlayer.GetWorldPosition()
        );

        if (distance_from_player > parent.entity_settings.kill_threshold_distance) {
          LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + parent.entity_settings.kill_threshold_distance);

          parent.killEntity(current_entity);

          continue;
        }

        if (distance_from_player < 15
        || distance_from_player < 20 && ((CActor)current_entity).HasAttitudeTowards(thePlayer)) {
          // leave the function, it will automatically enter in the Combat state
          // and the creatures will attack the player.
          return;
        }

        distance_from_bait = VecDistanceSquared(
          current_entity.GetWorldPosition(),
          parent.bait_entity.GetWorldPosition()
        );

        if (distance_from_bait < 5 * 5) {
          if (isPlayerBusy()) {
            teleportBaitEntityOnMonsters();
          }
          else {
            this.teleportBaitEntity();
          }
        }

        if (!((CActor)current_entity).IsMoving()) {
          ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
            'monsters',
            AGP_Default
          );

          ((CActor)current_entity).ActionCancelAll();

          ((CNewNPC)current_entity)
            .NoticeActor((CActor)parent.bait_entity);
        }

        parent.trail_maker.addTrackHere(
          current_entity.GetWorldPosition(),
          current_entity.GetWorldRotation()
        );
      }

      // to keep the bait near the player at all time
      if (parent.bait_moves_towards_player) {
        if (isPlayerBusy()) {
          teleportBaitEntityOnMonsters();
        }
        else {
          this.teleportBaitEntity();
        }
      }

      Sleep(0.5);
    } while (true);
  }

  private function teleportBaitEntity() {
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;

    // NDEBUG("towards player " + parent.bait_moves_towards_player);

    if (parent.bait_moves_towards_player) {
      new_bait_position = thePlayer.GetWorldPosition();
      new_bait_rotation = parent.bait_entity.GetWorldRotation();
    }
    else {
      new_bait_position = parent.getRandomEntity().GetWorldPosition() + VecConeRand(parent.bait_entity.GetHeading(), 90, 10, 20);
      new_bait_rotation = parent.bait_entity.GetWorldRotation();
      new_bait_rotation.Yaw += RandRange(-20,20);
    }
    
    parent.bait_entity.TeleportWithRotation(
      new_bait_position,
      new_bait_rotation
    );
  }

  // This function always teleports the bait on the monsters
  // often used to pause the hunt during cutscenes or when the player is busy.
  latent function teleportBaitEntityOnMonsters() {
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;
    var random_entity: CEntity;

    new_bait_position = parent.getRandomEntity().GetWorldPosition();
    new_bait_rotation = parent.bait_entity.GetWorldRotation();
    
    parent.bait_entity.TeleportWithRotation(
      new_bait_position,
      new_bait_rotation
    );
  }

  latent function resetEntitiesActions() {
    var i: int;
    var current_entity: CEntity;
    
    for (i = parent.entities.Size() - 1; i >= 0; i -= 1) {
      current_entity = parent.entities[i];

      ((CActor)current_entity).ActionCancelAll();

      ((CActor)current_entity)
          .GetMovingAgentComponent()
          .ResetMoveRequests();

      ((CActor)current_entity)
          .GetMovingAgentComponent()
          .SetGameplayMoveDirection(0.0f);
    }
  }
}

function copyEnemyTemplateList(list_to_copy: EnemyTemplateList): EnemyTemplateList {
  var copy: EnemyTemplateList;
  var i: int;

  copy.difficulty_factor = list_to_copy.difficulty_factor;

  for (i = 0; i < list_to_copy.templates.Size(); i += 1) {
    copy.templates.PushBack(
      makeEnemyTemplate(
        list_to_copy.templates[i].template,
        list_to_copy.templates[i].max,
        list_to_copy.templates[i].count,
        list_to_copy.templates[i].bestiary_entry
      )
    );
  }

  return copy;
}

/**
 * NOTE: it makes a copy of the list
 **/
latent function fillEnemyTemplateList(enemy_template_list: EnemyTemplateList, total_number_of_enemies: int, optional use_bestiary: bool): EnemyTemplateList {
  var template_list: EnemyTemplateList;
  var selected_template_to_increment: int;
  var max_tries: int;
  var i: int;
  var manager : CWitcherJournalManager;
  var can_spawn_creature: bool;

  template_list = copyEnemyTemplateList(enemy_template_list);

  max_tries = 0;

  for (i = 0; i < template_list.templates.Size(); i += 1) {
    if (template_list.templates[i].max == 0) {
      max_tries = total_number_of_enemies * 2;

      break;
    }

    max_tries += template_list.templates[i].max;
  }

  LogChannel('modRandomEncounters', "maximum number of tries: " + max_tries);

  if (use_bestiary) {
    manager = theGame.GetJournalManager();

    // we multiply the max tries number by two
    // because it can be hard to find a lonely entry in a list
    max_tries *= 2;
  }


  while (total_number_of_enemies > 0 && max_tries > 0) {
    max_tries -= 1;

    selected_template_to_increment = RandRange(template_list.templates.Size());

    LogChannel('modRandomEncounters', "selected template: " + selected_template_to_increment);

    if (template_list.templates[selected_template_to_increment].max > 0
      && template_list.templates[selected_template_to_increment].count >= template_list.templates[selected_template_to_increment].max) {
      continue;
    }

    // when use_bestiary is true, we only take known bestiary entries
    // ignore all unknown entries.
    
    if (use_bestiary) {
      can_spawn_creature = bestiaryCanSpawnEnemyTemplate(template_list.templates[selected_template_to_increment], manager);

      if (!can_spawn_creature) {
        continue;
      }
    }

    template_list.templates[selected_template_to_increment].count += 1;

    total_number_of_enemies -= 1;
  }

  return template_list;
}

function getCreatureHeight(entity: CActor): float {
  return ((CMovingPhysicalAgentComponent)entity.GetMovingAgentComponent())
    .GetCapsuleHeight();
}
function getGroundPosition(out input_position: Vector, optional personal_space: float, optional max_height_check: float): bool {
  var output_position: Vector;
  var point_z: float;
  var collision_normal: Vector;
  var result: bool;

  output_position = input_position;

  personal_space = MaxF(personal_space, 1.0);

  if (max_height_check == 0) {
    max_height_check = 30.0;
  }

  // first search for ground based on navigation data.
  theGame
  .GetWorld()
  .NavigationComputeZ(
    output_position,
    output_position.Z - max_height_check,
    output_position.Z + max_height_check,
    point_z
  );

	output_position.Z = point_z;

  if (!theGame.GetWorld().NavigationFindSafeSpot(output_position, personal_space, 10, output_position)) {
    return false;
  }

  // then do a static trace to find the position on ground
  // ... okay i'm not sure anymore, is the static trace needed?
  // theGame
  // .GetWorld()
  // .StaticTrace(
  //   output_position + Vector(0,0,1.5),// + 5,// Vector(0,0,5),
  //   output_position - Vector(0,0,1.5),// - 5,//Vector(0,0,5),
  //   output_position,
  //   collision_normal
  // );

  // finally, return if the position is above water level
  if (output_position.Z < theGame.GetWorld().GetWaterLevel(output_position, true)) {
    return false;
  }

  input_position = output_position;

  return true;
}

function getGroupPositions(initial_position: Vector, count: int, density: float): array<Vector> {
  var s, r, x, y: float;
  var pos_fin: Vector;
  var output_positions: array<Vector>;
  
  var i: int;
  var sign: int;

  //const values used in the loop
  pos_fin.Z = initial_position.Z;
  s = count / density; // maintain a constant density of `density` unit per m2
  r = SqrtF(s/Pi());

  for (i = 0; i < count; i += 1) {
    x = RandF() * r;        // add random value within range to X
    y = RandF() * (r - x);  // add random value to Y so that the point is within the disk

    if(RandRange(2))        // randomly select the sign for misplacement
      sign = 1;
    else
      sign = -1;
      
    pos_fin.X = initial_position.X + sign * x;  //final X pos
    
    if(RandRange(2))        // randomly select the sign for misplacement
      sign = 1;
    else
      sign = -1;
      
    pos_fin.Y = initial_position.Y + sign * y;  //final Y pos

    // return false means it could not find ground position
    // in this case, take the default position
    // if return true, then pos_fin is updated with the correct position
    if (!getGroundPosition(pos_fin)) {
      pos_fin = initial_position;
    }

    output_positions.PushBack(pos_fin);
  }

  return output_positions;
}

latent function getTracksTemplateByCreatureType(create_type: CreatureType): RER_TrailMakerTrack {
  var track: RER_TrailMakerTrack;

  switch(create_type) {
    case CreatureBARGHEST :
    case CreatureNIGHTWRAITH :
    case CreatureNOONWRAITH :
    case CreatureWRAITH :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        // "quests\generic_quests\skellige\quest_files\mh207_wraith\entities\mh207_area_fog.w2ent",
        // "fx\quest\sq108\sq108_fog.w2ent", // insane GPU cost.
        true
      );

      track.monster_clue_type = 'RER_MonsterClueNightwraith';

      // only 1 out of 10 clouds of mist are created.
      // track.trail_ratio_multiplier = 5;

      return track;
      break;
        
    case CreatureHUMAN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\generic_footprints_clue.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueHuman';
      break;

    case CreatureDROWNER:
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueDrowner';
      break;

    case CreatureDROWNERDLC:
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueDrowner';
      break;

    case CreatureROTFIEND:
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueRotfiend';
      break;

    case CreatureNEKKER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueNekker';
      break;

    case CreatureGHOUL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGhoul';
      break;

    case CreatureALGHOUL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueAlghoul';
      break;

    case CreatureFIEND :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueFiend';
      break;

    case CreatureCHORT :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueChort';
      break;

    case CreatureWEREWOLF :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWerewolf';
      break;

    case CreatureLESHEN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueLeshen';
      break;

    case CreatureKATAKAN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueKatakan';
      break;

    case CreatureEKIMMARA :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueEkimmara';
      break;

    case CreatureELEMENTAL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueElemental';
      break;

    case CreatureGOLEM :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGolem';
      break;
    
    case CreatureGIANT :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGiant';
      break;

    case CreatureCYCLOP :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueCyclop';
      break;

    case CreatureGRYPHON :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGryphon';
      break;

    case CreatureWYVERN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWyvern';
      break;

    case CreatureCOCKATRICE :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueCockatrice';
      break;

    case CreatureBASILISK :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBasilisk';
      break;

    case CreatureFORKTAIL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueForktail';
      break;

    case CreatureWIGHT :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWight';
      break;

    case CreatureSHARLEY :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueSharley';
      break;

    case CreatureHAG :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueHag';
      break;

    case CreatureFOGLET :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueFoglet';
      break;

    case CreatureTROLL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueTroll';
      break;

    case CreatureBRUXA :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBruxa';
      break;

    case CreatureDETLAFF :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueDetlaff';
      break;

    case CreatureGARKAIN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGarkain';
      break;
    
    case CreatureFLEDER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueFleder';
      break;

    case CreatureGARGOYLE :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGargoyle';
      break;

    case CreatureKIKIMORE :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueKikimore';
      break;

    case CreatureCENTIPEDE :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueCentipede';
      break;

    case CreatureBERSERKER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBerserker';
      break;

    case CreatureWOLF :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWolf';
      break;

    case CreatureBEAR :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBear';
      break;

    case CreatureBOAR :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBoar';
      break;

    case CreaturePANTHER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBoar';
      break;

    case CreatureSPIDER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBoar';
      break;

    case CreatureWILDHUNT :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWildhunt';
      break;

    case CreatureARACHAS :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueArachas';
      break;

    case CreatureHARPY :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueHarpy';
      break;

    case CreatureSIREN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueSiren';
      break;

    case CreatureENDREGA :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueEndrega';
      break;

    case CreatureECHINOPS :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueEchinops';
      break;

    case CreatureDRACOLIZARD :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueDracolizard';
      break;

    default :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClue';
      break;

    // case CreatureNIGHTWRAITH :
    //   track.template = (CEntityTemplate)LoadResourceAsync(
    //     "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
    //     true
    //   );

    //   // dynamically assigning the monster_clue_type to our own. Easier than to create
    //   // 32 w2ent files
    //   track.monster_clue_type = 'RER_MonsterClueFleder';
    //   break;
  }

  return track;
}

// return true in cases where the player is busy in a cutscene or in the boat.
// When a spawn should be cancelled.
function isPlayerBusy(): bool {
  return thePlayer.IsInInterior()
      || thePlayer.IsInCombat()
      || thePlayer.IsUsingBoat()
      || thePlayer.IsInFistFightMiniGame()
      || thePlayer.IsSwimming()
      || thePlayer.IsInNonGameplayCutscene()
      || thePlayer.IsInGameplayScene()
      || thePlayer.IsCiri()
      || theGame.IsDialogOrCutscenePlaying()
      || theGame.IsCurrentlyPlayingNonGameplayScene()
      || theGame.IsFading()
      || theGame.IsBlackscreen();
}
function lootTrophiesInRadius(): bool {
  var entities : array<CGameplayEntity>;
  var items_guids: array<SItemUniqueId>;
  var looted_a_trophy: bool;
  var i: int;
  var guid_used_for_notification: SItemUniqueId;

  looted_a_trophy = false;

  LogChannel('modRandomEncounters', "searching lootbag nearby");
  FindGameplayEntitiesInRange( entities, thePlayer, 25, 30, , FLAG_ExcludePlayer/*,, 'W3Container'*/ );

  for (i = 0; i < entities.Size(); i += 1) {
    if (((W3Container)entities[i])) {
      LogChannel('modRandomEncounters', "lootbag - giving all RER_Trophy to player");
      items_guids = ((W3Container)entities[i]).GetInventory().GetItemsByTag('RER_Trophy');

      // set `looted_a_trophy` if a trophy was found
      looted_a_trophy = looted_a_trophy || items_guids.Size() > 0;

      if (items_guids.Size() > 0) {
        guid_used_for_notification = items_guids[0];
      }
      
      LogChannel('modRandomEncounters', "lootbag - found " + items_guids.Size() + " trophies");
      ((W3Container)entities[i]).GetInventory()
        .GiveItemsTo(thePlayer.GetInventory(), items_guids);
    }
  }

  return looted_a_trophy;
}

function getRandomPositionBehindCamera(out initial_pos: Vector, optional distance: float, optional minimum_distance: float, optional attempts: int): bool {
  var player_position: Vector;
  var point_z: float;
  var attempts_left: int;

  if (minimum_distance == 0.0) {
    minimum_distance = 20.0;
  }

  // value of `0.0` means the parameter was not supplied
  if (distance == 0.0) {
    distance = 40;
  }

  else if (distance < minimum_distance) {
    distance = minimum_distance; // meters
  }

  player_position = thePlayer.GetWorldPosition();
  attempts_left = Max(attempts, 3);

  for (attempts_left; attempts_left > 0; attempts_left -= 1) {
    initial_pos = player_position + VecConeRand(theCamera.GetCameraHeading(), 270, -minimum_distance, -distance);

    if (getGroundPosition(initial_pos)) {
      LogChannel('modRandomEncounters', initial_pos.X + " " + initial_pos.Y + " " + initial_pos.Z);

      if (initial_pos.X == 0
       || initial_pos.Y == 0
       || initial_pos.Z == 0) {
        return false;
      }

      return true;
    }
  }

  return false;
}

// File containing helper functions used for creatures levels.
// It uses values from the settings to calculate their levels.
//

function getRandomLevelBasedOnSettings(settings: RE_Settings): int {
  var player_level: int;
  var max_level_allowed: int;
  var min_level_allowed: int;
  var level: int;

  player_level = thePlayer.GetLevel();

  // if for some reason the user set the max lower than the min value
  if (settings.max_level_allowed >= settings.min_level_allowed) {
    max_level_allowed = settings.max_level_allowed;
    min_level_allowed = settings.min_level_allowed;
  }
  else {
    max_level_allowed = settings.min_level_allowed;
    min_level_allowed = settings.max_level_allowed;
  }

  level = RandRange(player_level + max_level_allowed, player_level + min_level_allowed);

  LogChannel('modRandomEnocunters', "random creature level = " + level);

  return level;
}

function shouldAbortCreatureSpawn(settings: RE_Settings, rExtra: CModRExtra, bestiary: RER_Bestiary): bool {
  var current_state: CName;
  var is_meditating: bool;
  var current_zone: EREZone;


  current_state = thePlayer.GetCurrentStateName();
  is_meditating = current_state == 'Meditation' && current_state == 'MeditationWaiting';
  current_zone = rExtra.getCustomZone(thePlayer.GetWorldPosition());

  return is_meditating 
      || current_zone == REZ_NOSPAWN
      
      || current_zone == REZ_CITY
      && !settings.allow_big_city_spawns

      || isPlayerBusy()

      || rExtra.isPlayerInSettlement()
      && !bestiary.doesAllowCitySpawns();
}

state Loading in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state LOADING");

    this.startLoading();
  }

  entry function startLoading() {
    this.registerStaticEncounters();

    // give time for other mods to register their static encounters
    Sleep(10);

    parent.static_encounter_manager.spawnStaticEncounters(parent);

    parent.GotoState('Waiting');
  }

  latent function registerStaticEncounters() {

    // A random swamp in velen
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(360, -375, 0),
      RER_RegionConstraint_ONLY_VELEN,
      50,
      StaticEncounterType_SMALL
    );

    // A burnt house near the water
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(620, -477, 0.9),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // A forest near water
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(730, -500, 11),
      RER_RegionConstraint_ONLY_VELEN,
      50,
      StaticEncounterType_SMALL
    );

    // A abandonned house with skeletons and hanged people in the forest
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(1060, -305, 6),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // a mountain near the swamp
    this.makeStaticEncounter(
      CreatureFORKTAIL,
      Vector(1310, -373, 22),
      RER_RegionConstraint_ONLY_VELEN,
      50,
      StaticEncounterType_LARGE
    );

    // a flat surface in the mountain near the swamp
    this.makeStaticEncounter(
      CreatureWYVERN,
      Vector(1329, -326, 43),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // abandonned human camp
    this.makeStaticEncounter(
      CreatureBEAR,
      Vector(990, -189, 15),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // a ruined castle near a swamp
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(1060, 1057, 7),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // mountains with lots of harpies
    this.makeStaticEncounter(
      CreatureHARPY,
      Vector(-200, 795, 31),
      RER_RegionConstraint_ONLY_VELEN,
      25,
      StaticEncounterType_SMALL
    );

    // castle with vanilla wyvern
    this.makeStaticEncounter(
      CreatureWYVERN,
      Vector(-286, 920, 14),
      RER_RegionConstraint_ONLY_VELEN,
      25,
      StaticEncounterType_LARGE
    );

    // castle basilisk from ciri scene
    this.makeStaticEncounter(
      CreatureBASILISK,
      Vector(-240, 565, 11),
      RER_RegionConstraint_ONLY_VELEN,
      50,
      StaticEncounterType_LARGE
    );

    // burning pyre full of human corpses
    this.makeStaticEncounter(
      CreatureROTFIEND,
      Vector(530, 956, 1),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // burning pyre full of human corpses
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(530, 956, 1),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // forest full of endregas
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(567, 1246, 9),
      RER_RegionConstraint_ONLY_VELEN,
      15,
      StaticEncounterType_SMALL
    );

    // forest full of endregas
    this.makeStaticEncounter(
      CreatureGRYPHON,
      Vector(604, 1200, 12),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // a beach in novigrad
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(375, 1963, 1),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // rotfiend nest
    this.makeStaticEncounter(
      CreatureROTFIEND,
      Vector(350, 980, 1.5),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // rotfiend nest
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(350, 980, 1.5),
      RER_RegionConstraint_ONLY_VELEN,
      20,
      StaticEncounterType_SMALL
    );

    // abandoned village near the swamp with blood everywhere
    this.makeStaticEncounter(
      CreatureWEREWOLF,
      Vector(638, -644, 2.5),
      RER_RegionConstraint_ONLY_VELEN,
      20,
      StaticEncounterType_LARGE
    );

    // White Orchard: ghouls in the cemetery
    this.makeStaticEncounter(
      CreatureGHOUL,
      Vector(-24, 284, 1.5),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      20,
      StaticEncounterType_SMALL
    );

    // White Orchard: Devil by the well
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(22, -264, 13),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // White Orchard: Devil by the well, lake nearby
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(117, -208, -0.7),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // White Orchard: An autel, somewhere in the forest
    this.makeStaticEncounter(
      CreatureBEAR,
      Vector(88, -136, 4.25),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      5,
      StaticEncounterType_SMALL
    );

    // White Orchard: Place where you kill the griffin
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(65, 230, 12.6),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // White Orchard: Wall with a gate, near the map limit
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(400, 208, 15),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // White Orchard: Battle field, with lots of corpses
    this.makeStaticEncounter(
      CreatureGHOUL,
      Vector(552, 186, 20),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // var example_static_encounter: RER_StaticEncounter;

    // example_static_encounter = new RER_StaticEncounter in this;
    // example_static_encounter.bestiary_entry = parent.bestiary.entries[CreatureTROLL];
    // example_static_encounter.position = Vector(2444, 2344, 3);
    // example_static_encounter.region_constraint = RER_RegionConstraint_ONLY_VELEN;
    // example_static_encounter.radius = 5;

    // parent
    //   .static_encounter_manager
    //   .registerStaticEncounter(parent, example_static_encounter);
  }

  private latent function makeStaticEncounter(type: CreatureType, position: Vector, constraint: RER_RegionConstraint, radius: float, encounter_type: RER_StaticEncounterType) {
    var new_static_encounter: RER_StaticEncounter;

    new_static_encounter = new RER_StaticEncounter in parent;
    new_static_encounter.bestiary_entry = parent.bestiary.entries[type];
    new_static_encounter.position = position;
    new_static_encounter.region_constraint = constraint;
    new_static_encounter.radius = radius;
    new_static_encounter.type = encounter_type;

    parent
      .static_encounter_manager
      .registerStaticEncounter(parent, new_static_encounter);
  }
}

state Spawning in CRandomEncounters {
  private var is_spawn_forced: bool;

  event OnEnterState(previous_state_name: name) {
    parent.RemoveTimer('randomEncounterTick');

    super.OnEnterState(previous_state_name);

    // Set is_spawn_forced if the previous state was SpawningForced
    this.is_spawn_forced = previous_state_name == 'SpawningForced';


    LogChannel('modRandomEncounters', "Entering state SPAWNING");

    triggerCreaturesSpawn();
  }

  entry function triggerCreaturesSpawn() {
    var picked_encounter_type: EncounterType;

    LogChannel('modRandomEncounters', "creatures spawning triggered");

    picked_encounter_type = this.getRandomEncounterType();
    
    // we start by checking if the creature spawn should be cancelled.
    if (
       // first if RER is disabled, any spawn should be cancelled
       !parent.settings.is_enabled

       // then, if the spawn is not forced we check if the player
       // is in a place where a spawn in accepted.
    || !this.is_spawn_forced
    && shouldAbortCreatureSpawn(parent.settings, parent.rExtra, parent.bestiary)) {
      parent.GotoState('SpawningCancelled');

      return;
    }

    LogChannel('modRandomEncounters', "picked encounter type: " + picked_encounter_type);

    makeGroupComposition(
      picked_encounter_type,
      parent
    );

    parent.GotoState('Waiting');
  }

  function getRandomEncounterType(): EncounterType {
    var monster_ambush_chance: int;
    var monster_hunt_chance: int;
    var monster_contract_chance: int;

    var max_roll: int;
    var roll: int;

    if (theGame.envMgr.IsNight()) {
      monster_ambush_chance = parent.settings.all_monster_ambush_chance_night;
      monster_hunt_chance = parent.settings.all_monster_hunt_chance_night;
      monster_contract_chance = parent.settings.all_monster_contract_chance_night;
    } else {
      monster_ambush_chance = parent.settings.all_monster_ambush_chance_day;
      monster_hunt_chance = parent.settings.all_monster_hunt_chance_day;
      monster_contract_chance = parent.settings.all_monster_contract_chance_day;
    }

    max_roll = monster_hunt_chance
             + monster_contract_chance
             + monster_ambush_chance;

    roll = RandRange(max_roll);
    if (roll < monster_hunt_chance) {
      return EncounterType_HUNT;
    }

    roll -= monster_hunt_chance;
    if (roll < monster_contract_chance) {
      return EncounterType_CONTRACT;
    }

    return EncounterType_DEFAULT;
  }
}

state SpawningCancelled in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('ModRandomEncounters', "entering state SPAWNING-CANCELLED");

    parent.GotoState('Waiting');
  }
}

// Pretty much the same as SpawningCancelled, but without the reduced delay
// that happens after a cancel.
state SpawningDelayed in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('ModRandomEncounters', "entering state SPAWNING-DELAYED");

    parent.GotoState('Waiting');
  }
}

state SpawningForced in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('ModRandomEncounters', "entering state SPAWNING-FORCED");

    parent.GotoState('Spawning');
  }
}

state Waiting in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state WAITING");

    parent.ticks_before_spawn = this.calculateRandomTicksBeforeSpawn();

    if (previous_state_name == 'SpawningCancelled') {
      parent.ticks_before_spawn = parent.ticks_before_spawn / 3;
    }

    LogChannel('modRandomEncounters', "waiting " + parent.ticks_before_spawn + " ticks");

    this.startWaiting();
  }

  entry function startWaiting() {
    parent.AddTimer('randomEncounterTick', 1.0, true);
  }

  timer function randomEncounterTick(optional delta: float, optional id: Int32) {
    if (parent.ticks_before_spawn < 0) {
      parent.GotoState('Spawning');
    }

    parent.ticks_before_spawn -= 1;
  }

  function calculateRandomTicksBeforeSpawn(): int {
    if (theGame.envMgr.IsNight()) {
      return RandRange(parent.settings.customNightMin, parent.settings.customNightMax);
    }

    return RandRange(parent.settings.customDayMin, parent.settings.customDayMax);
  }
}

abstract class RER_EventsListener {
  public var active: bool;
  
  public var is_ready: bool;
  default is_ready = false;

  public latent function onReady(manager: RER_EventsManager) {
    this.active = true;

    this.loadSettings();
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    // Do your thing and return if a spawn was triggered or not

    return was_spawn_already_triggered;
  }

  public latent function loadSettings() {}
}

statemachine class RER_EventsManager extends CEntity {

  //#region listeners
  public var listeners: array<RER_EventsListener>;
  
  public function addListener(listener: RER_EventsListener) {
    this.listeners.PushBack(listener);
  }
  //#endregion listeners

  public var master: CRandomEncounters;

  public function init(master: CRandomEncounters) {
    this.master = master;

    this.addListener(new RER_ListenerFightNoise in this);
    this.addListener(new RER_ListenerBloodNecrophages in this);
    this.addListener(new RER_ListenerFillCreaturesGroup in this);
    this.addListener(new RER_ListenerBodiesNecrophages in this);
    this.addListener(new RER_ListenerEntersSwamp in this);
    this.addListener(new RER_ListenerMeditationAmbush in this);
    this.addListener(new RER_ListenerNoticeboardContract in this);
  }

  public var internal_cooldown: float;

  public var delay: float;

  // this exists because i don't want the the event % chances to trigger
  // to scale on the interval. Because it means if a player wants his events
  // to trigger less often he has to either increase the interval or reduce 
  // the % chances one by one. And the interval should NOT be increased unless
  // for performance reasons. 
  public var chance_scale: float;
  
  public function start() {
    LogChannel('modRandomEncounters', "RER_EventsManager - start()");

    this.delay = this.master.settings.event_system_interval;
    
    // only start the system if the delay is above 0
    if (this.delay > 0) {
      this.GotoState('Starting');
    }
  }
}

// When the player is hurt (not full life) necrophages ambush can appear around him
class RER_ListenerBloodNecrophages extends RER_EventsListener {
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var trigger_chance: float;

  private var already_spawned_this_combat: bool;


  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventBloodNecrophages')
    );

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var type: CreatureType;
    var is_in_combat: bool;
    var health_missing_perc: float;

    is_in_combat = thePlayer.IsInCombat();

    // to avoid triggering more than one event per fight
    if (is_in_combat && (was_spawn_already_triggered || this.already_spawned_this_combat)) {
      this.already_spawned_this_combat = true;

      return false;
    }

    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;

      return false;
    }
    
    this.already_spawned_this_combat = false;

    // this will be used to scale the % chances based on the missing health
    // the lower the health the higher the chances.
    health_missing_perc = 1 - thePlayer.GetHealthPercents();

    if (RandRangeF(100) < this.trigger_chance * chance_scale * health_missing_perc) {
      if (shouldAbortCreatureSpawn(master.settings, master.rExtra, master.bestiary)) {
        LogChannel('modRandomEncounters', "RER_ListenerBloodNecrophages - cancelled");

        return false;
      }

      type = this.getRandomNecrophageType(master);
      createRandomCreatureAmbush(master, type);

      // so that we don't spawn an ambush too frequently
      this.time_before_other_spawn += master.events_manager.internal_cooldown;
      
      LogChannel('modRandomEncounters', "RER_ListenerBloodNecrophages - spawn triggered type = " + type);

      return true;
    }

    return false;
  }

  private latent function getRandomNecrophageType(master: CRandomEncounters): CreatureType {
    var spawn_roller: SpawnRoller;
    var creatures_preferences: RER_CreaturePreferences;
    var i: int;
    var can_spawn_creature: bool;
    var manager : CWitcherJournalManager;
    var roll: SpawnRoller_Roll;

    spawn_roller = new SpawnRoller in this;
    spawn_roller.fill_arrays();

    creatures_preferences = new RER_CreaturePreferences in this;
    creatures_preferences
      .setIsNight(theGame.envMgr.IsNight())
      .setExternalFactorsCoefficient(master.settings.external_factors_coefficient)
      .setIsNearWater(master.rExtra.IsPlayerNearWater())
      .setIsInForest(master.rExtra.IsPlayerInForest())
      .setIsInSwamp(master.rExtra.IsPlayerInSwamp())
      .setIsInCity(master.rExtra.isPlayerInSettlement() || master.rExtra.getCustomZone(thePlayer.GetWorldPosition()) == REZ_CITY);

    creatures_preferences
      .reset();
      
    master.bestiary.entries[CreatureGHOUL]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureGHOUL]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureALGHOUL]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureDROWNER]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureDROWNERDLC]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureROTFIEND]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureWEREWOLF]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureEKIMMARA]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureKATAKAN]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureHAG]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureFOGLET]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureBRUXA]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureFLEDER]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);
    master.bestiary.entries[CreatureGARKAIN]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureDETLAFF]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    // when the option "Only known bestiary creatures" is ON
    // we remove every unknown creatures from the spawning pool
    if (master.settings.only_known_bestiary_creatures) {
      manager = theGame.GetJournalManager();

      for (i = 0; i < CreatureMAX; i += 1) {
        can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(master.bestiary.entries[i].template_list, manager);
        
        if (!can_spawn_creature) {
          spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    roll = spawn_roller.rollCreatures();
    return roll.roll;
  }
}
// When remains are near the player, necrophages can spawn
class RER_ListenerBodiesNecrophages extends RER_EventsListener {
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var trigger_chance: float;

  var already_spawned_this_combat: bool;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventBodiesNecrophages')
    );
    
    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var type: CreatureType;

    var is_in_combat: bool;

    is_in_combat = thePlayer.IsInCombat();

    // to avoid triggering more than one event per fight
    if (is_in_combat && (was_spawn_already_triggered || this.already_spawned_this_combat)) {
      this.already_spawned_this_combat = true;

      return false;
    }

    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;

      return false;
    }
    
    this.already_spawned_this_combat = false;

    if (this.areThereRemainsNearby() && RandRangeF(100) < this.trigger_chance * chance_scale) {
      if (shouldAbortCreatureSpawn(master.settings, master.rExtra, master.bestiary)) {
        LogChannel('modRandomEncounters', "RER_ListenerBodiesNecrophages - cancelled");

        return false;
      }
      
      type = this.getRandomNecrophageType(master);
      createRandomCreatureAmbush(master, type);

      // so that we don't spawn an ambush too frequently
      this.time_before_other_spawn += master.events_manager.internal_cooldown;
      
      LogChannel('modRandomEncounters', "RER_ListenerBodiesNecrophages - spawn triggered type = " + type);

      return true;
    }

    return false;
  }

  private function areThereRemainsNearby(): bool {
    var entities : array<CGameplayEntity>;
    var i: int;

    FindGameplayEntitiesInRange( entities, thePlayer, 25, 30, , FLAG_ExcludePlayer,, 'W3ActorRemains' );

    return entities.Size() > 0;
  }

  private latent function getRandomNecrophageType(master: CRandomEncounters): CreatureType {
    var spawn_roller: SpawnRoller;
    var creatures_preferences: RER_CreaturePreferences;
    var i: int;
    var can_spawn_creature: bool;
    var manager : CWitcherJournalManager;
    var roll: SpawnRoller_Roll;

    spawn_roller = new SpawnRoller in this;
    spawn_roller.fill_arrays();

    creatures_preferences = new RER_CreaturePreferences in this;
    creatures_preferences
      .setIsNight(theGame.envMgr.IsNight())
      .setExternalFactorsCoefficient(master.settings.external_factors_coefficient)
      .setIsNearWater(master.rExtra.IsPlayerNearWater())
      .setIsInForest(master.rExtra.IsPlayerInForest())
      .setIsInSwamp(master.rExtra.IsPlayerInSwamp())
      .setIsInCity(master.rExtra.isPlayerInSettlement() || master.rExtra.getCustomZone(thePlayer.GetWorldPosition()) == REZ_CITY);

    creatures_preferences
      .reset();
      
    master.bestiary.entries[CreatureGHOUL]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureGHOUL]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureALGHOUL]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureDROWNER]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureDROWNERDLC]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureROTFIEND]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureWEREWOLF]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureEKIMMARA]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureKATAKAN]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureHAG]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureFOGLET]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureBRUXA]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureFLEDER]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);
    master.bestiary.entries[CreatureGARKAIN]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureDETLAFF]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    // when the option "Only known bestiary creatures" is ON
    // we remove every unknown creatures from the spawning pool
    if (master.settings.only_known_bestiary_creatures) {
      manager = theGame.GetJournalManager();

      for (i = 0; i < CreatureMAX; i += 1) {
        can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(master.bestiary.entries[i].template_list, manager);
        
        if (!can_spawn_creature) {
          spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    roll = spawn_roller.rollCreatures();
    return roll.roll;
  }
}
// When the player enters a swamp, there is a small chance for drowners or hags to appear
class RER_ListenerEntersSwamp extends RER_EventsListener {
  var was_in_swamp_last_run: bool;
  var type: CreatureType;

  var trigger_chance: float;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventEntersSwamp')
    );

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var is_in_swamp_now: bool;

    if (was_spawn_already_triggered) {
      return false;
    }

    is_in_swamp_now = master.rExtra.IsPlayerInSwamp();

    // the player is now in a swamp and was not in one last run
    // it means he just entered it this run.
    if (is_in_swamp_now && !was_in_swamp_last_run && RandRangeF(100) < this.trigger_chance * chance_scale) {
      type = this.getRandomSwampCreatureType(master);

      LogChannel('modRandomEncounters', "RER_ListenerEntersSwamp - swamp ambush triggered, " + type);

      createRandomCreatureAmbush(master, type);

      return true;
    }

    return false;
  }

  private latent function getRandomSwampCreatureType(master: CRandomEncounters): CreatureType {
    var spawn_roller: SpawnRoller;
    var creatures_preferences: RER_CreaturePreferences;
    var i: int;
    var can_spawn_creature: bool;
    var manager : CWitcherJournalManager;
    var roll: SpawnRoller_Roll;

    spawn_roller = new SpawnRoller in this;
    spawn_roller.fill_arrays();

    creatures_preferences = new RER_CreaturePreferences in this;
    creatures_preferences
      .setIsNight(theGame.envMgr.IsNight())
      .setExternalFactorsCoefficient(master.settings.external_factors_coefficient)
      .setIsNearWater(master.rExtra.IsPlayerNearWater())
      .setIsInForest(master.rExtra.IsPlayerInForest())
      .setIsInSwamp(master.rExtra.IsPlayerInSwamp())
      .setIsInCity(master.rExtra.isPlayerInSettlement() || master.rExtra.getCustomZone(thePlayer.GetWorldPosition()) == REZ_CITY);

    creatures_preferences
      .reset();

    master.bestiary.entries[CreatureDROWNER]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureDROWNERDLC]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureROTFIEND]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureWEREWOLF]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureHAG]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureFOGLET]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    // when the option "Only known bestiary creatures" is ON
    // we remove every unknown creatures from the spawning pool
    if (master.settings.only_known_bestiary_creatures) {
      manager = theGame.GetJournalManager();

      for (i = 0; i < CreatureMAX; i += 1) {
        can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(master.bestiary.entries[i].template_list, manager);
        
        if (!can_spawn_creature) {
          spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    roll = spawn_roller.rollCreatures();
    return roll.roll;
  }
}

// When the player is in a combat, there is a small chance a new encounter appears
// around him.
class RER_ListenerFightNoise extends RER_EventsListener {
  private var already_spawned_this_combat: bool;
  
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var trigger_chance: float;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventFightNoise')
    );

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var is_in_combat: bool;

    is_in_combat = thePlayer.IsInCombat();

    // to avoid triggering more than one event per fight
    if (is_in_combat && (was_spawn_already_triggered || this.already_spawned_this_combat)) {
      this.already_spawned_this_combat = true;

      return false;
    }

    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;

      return false;
    }

    this.already_spawned_this_combat = false;

    if (is_in_combat && RandRangeF(100) < this.trigger_chance * chance_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerFightNoise - triggered");

      if (shouldAbortCreatureSpawn(master.settings, master.rExtra, master.bestiary)) {
        LogChannel('modRandomEncounters', "RER_ListenerFightNoise - cancelled");

        return false;
      }
      
      // we disable it for the fight so it doesn't spawn non-stop
      this.already_spawned_this_combat = is_in_combat;

      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      // create a random ambush with no creature type chosen, let RER pick one
      // randomly.
      createRandomCreatureAmbush(master, CreatureNONE);

      return true;
    }

    return false;
  }
}

// Randomly add more creatures to groups of creatures in the world.
class RER_ListenerFillCreaturesGroup extends RER_EventsListener {
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var trigger_chance: float;

  var can_duplicate_creatures_in_combat: bool;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventFillCreaturesGroup')
    );

    this.can_duplicate_creatures_in_combat = inGameConfigWrapper
      .GetVarValue('RERevents', 'eventFillCreaturesGroupAllowCombat');

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var random_entity_to_duplicate: CNewNPC;
    var creature_height: float;
    
    if (was_spawn_already_triggered) {
      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - spawn already triggered");

      return false;
    }

    if (this.time_before_other_spawn > 0) {
      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - delay between spawns");

      time_before_other_spawn -= delta;

      return false;
    }

    if (!this.getRandomNearbyEntity(random_entity_to_duplicate)) {
      return false;
    }

    if (RandRangeF(100) < this.trigger_chance * chance_scale) {
      // it's done inside the if and only after a successful roll to avoid retrieving
      // the creature's height every interval. It's an attempt at optimizing it.
      //
      // small creatures will have a higher chance to pass, while larger creatures
      // will have a lower chance. The height is divided by two because some creatures
      // are 4 meters tall like fiends and dividing their chances by 4 would be
      // too much. So instead we divide their chance by 4meters / 2.
      // because the height is almost divided by two, lots of creatures will
      // automatically pass the test. For example, werewolves are 1.8 meters tall
      // so the 0.6 is an attempt at avoiding this.
      creature_height = getCreatureHeight(random_entity_to_duplicate) * 0.6;
      
      if (creature_height > 1 && RandRangeF(creature_height) < 1) {
        return false;
      }

      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - duplicateRandomNearbyEntity");
      
      this.duplicateEntity(master, random_entity_to_duplicate);
      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      // NOTE: this event SHOULD return true but doesn't because it doesn't affect
      // the other events. Other events use the "true" to know if another event
      // spawned a creature. But as this one only add creatures that are out of
      // combat it should not infer with the other event.
      return false;
    }

    return false;
  }

  private function getRandomNearbyEntity(out entity: CNewNPC): bool {
    var entities : array<CGameplayEntity>;
    var picked_npc_list: array<CNewNPC>;
    var picked_npc_index: int;
    var i: int;
    var picked_npc: CNewNPC;
    var boss_tag: name;

    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      300, // radius
      100, // max number of entities
      , // tag
      FLAG_Attitude_Hostile + FLAG_ExcludePlayer + FLAG_OnlyAliveActors,
      thePlayer, // target
      'CNewNPC'
    );

    // to avoid duplicating bosses
    boss_tag = thePlayer.GetBossTag();

    for (i = 0; i < entities.Size(); i += 1) {
      if (((CNewNPC)entities[i])
      && ((CNewNPC)entities[i]).GetNPCType() == ENGT_Enemy
      
      // this one removes animals like bears, wolves
      // and also humans like bandits
      // && ((CNewNPC)entities[i]).IsMonster()
      
      // if the user allows even creatures who are in combat
      // or if the creature is not in combat
      && (
        this.can_duplicate_creatures_in_combat
        || !((CNewNPC)entities[i]).IsInCombat()
      )
      && !((CNewNPC)entities[i]).HasTag(boss_tag)) {
        picked_npc_list.PushBack((CNewNPC)entities[i]);
      }
    }

    if (picked_npc_list.Size() == 0) {
      return false;
    }

    picked_npc_index = RandRange(picked_npc_list.Size());
    entity = picked_npc_list[picked_npc_index];

    return true;
  }

  private latent function duplicateEntity(master: CRandomEncounters, entity: CNewNPC) {
    var entity_template: CEntityTemplate;
    var created_entity: CEntity;

    LogChannel('modRandomEncounters', "duplicating = " + StrAfterFirst(entity.ToString(), "::"));

    entity_template = (CEntityTemplate)LoadResourceAsync(
      StrAfterFirst(entity.ToString(), "::"),
      true
    );

    created_entity = theGame.CreateEntity(
      entity_template,
      entity.GetWorldPosition(),
      entity.GetWorldRotation()
    );

    ((CNewNPC)created_entity).SetLevel(
      getRandomLevelBasedOnSettings(master.settings)
    );
  }
}

// When the player enters a swamp, there is a small chance for drowners or hags to appear
class RER_ListenerMeditationAmbush extends RER_EventsListener {
  var trigger_chance: float;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventMeditationAmbush')
    );

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var time_spent_meditating: int;
  var last_meditation_time: GameTime;

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var current_state: CName;
    var is_meditating: bool;
    
    if (was_spawn_already_triggered) {
      return false;
    }

    current_state = thePlayer.GetCurrentStateName();
    is_meditating = current_state == 'Meditation' || current_state == 'MeditationWaiting';

    // LogChannel('modRandomEncounters', "current state = " + current_state);

    // if the player is not meditating right now
    // we can early cancel the event here.
    if (!is_meditating) {
      time_spent_meditating = 0;

      return false;
    }

    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;

      return false;
    }

    // at this point it means the player is meditating

    // the player just started meditating
    if (time_spent_meditating == 0) {
      time_spent_meditating = CeilF(delta);
    }
    else {
      time_spent_meditating += GameTimeToSeconds(theGame.GetGameTime() - last_meditation_time);
    }

    last_meditation_time = theGame.GetGameTime();

    // LogChannel('modRandomEncounters', "chance  = "
    //   + this.trigger_chance + " increase = "
    //   + (float)(time_spent_meditating / 3600) + " final = "
    //   + (this.trigger_chance * (0.8f + (float)(time_spent_meditating / 3600) / 12.0f)) * chance_scale);
    
    // once we know how many seconds the player meditated, 
    // we can increase the chances
    // 12 hours increase the chances by 100%, 24h by 200%.
    // the default value is 80% of what the user set in the settings
    // so when starting a meditation we're at 80%
    // 12 hours later it's at 180%
    // 24 hours later it's at 280%
    if (RandRangeF(100) < (this.trigger_chance * (0.8f + (float)(time_spent_meditating / 3600) / 12.0f)) * chance_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerMeditationAmbush - triggered, % increased by meditation = " + time_spent_meditating / 3600);

      // this check is done only when the event has triggered to avoid doing it too often
      if (shouldAbortCreatureSpawn(master.settings, master.rExtra, master.bestiary)) {
        LogChannel('modRandomEncounters', "RER_ListenerMeditationAmbush - cancelled");

        return false;
      }

      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      // create a random ambush with no creature type chosen, let RER pick one
      // randomly.
      createRandomCreatureAmbush(master, CreatureNONE);

      return true;
    }

    return false;
  }
}

// When the player is near a noticeboard, if the noticeboard has no contracts left
// it will start a CONTRACT encounter
class RER_ListenerNoticeboardContract extends RER_EventsListener {
  // if this boolean is set to true, it means the event triggered when Geralt was
  // near a noticeboard. So if it is true the event will instead wait for Geralt
  // to leave the city instead of looking for nearby noticeboards
  private var was_triggered: bool;

  // this is the position that will be stored when the event will first be
  // triggered. This is the position near the noticeboard.
  // It is used to draw a cone from the noticeboard to the player's position
  // outside the city and to spawn the contract in this cone.
  private var position_near_noticeboard: Vector;

  // if set to true, the next time the event interval will run it will trigger
  // the noticeboard cutscene.
  private var force_noticeboard_event: bool;
  
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var menu_slider_value: float;
  var trigger_chance: float;
  var settlement_radius_check: float;
  var distance_trigger_chance_scale: float;
  var minimum_distance_multiplier: float;
  var maximum_distance_multiplier: float;

  var allow_automatic_cutscene: bool;

  var last_known_position_in_city: Vector;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.menu_slider_value = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventNoticeboardContract')
    );

    this.allow_automatic_cutscene = inGameConfigWrapper
      .GetVarValue('RERevents', 'eventNoticeboardContractAutomaticCutscene');

    this.trigger_chance = 100 - this.menu_slider_value;
    this.settlement_radius_check = this.menu_slider_value;
    this.distance_trigger_chance_scale = 50 + this.menu_slider_value;
    this.minimum_distance_multiplier = this.menu_slider_value / 200 + 1.2;
    this.maximum_distance_multiplier = this.menu_slider_value / 100 + 1.2;

    // always set it to true to listen to the keybind
    this.active = true;

    theInput.RegisterListener(this, 'OnRERforceNoticeboardEvent', 'OnRERforceNoticeboardEvent');
  }

  event OnRERforceNoticeboardEvent(action: SInputAction) {
    if (IsPressed(action)) {
      this.force_noticeboard_event = true;
    }
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var has_spawned: bool;

    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;
    }

    if (isPlayerBusy()) {
      return false;
    }

    if (this.was_triggered) {
      has_spawned = this.waitForPlayerToLeaveCity(master, chance_scale);
    }
    else {
      has_spawned = this.lookForNearbyNoticeboards(master);
    }

    return has_spawned;
  }

  private latent function waitForPlayerToLeaveCity(master: CRandomEncounters, chance_scale: float): bool {
    var meters_from_city: float;

    if (master.rExtra.isPlayerInSettlement(this.settlement_radius_check)) {
      // NDEBUG("in settlement, radius = " + this.settlement_radius_check);

      this.last_known_position_in_city = thePlayer.GetWorldPosition();
      
      return false;
    }

    meters_from_city = VecDistance(this.last_known_position_in_city, thePlayer.GetWorldPosition());

    // NDEBUG("" + this.trigger_chance * chance_scale + meters_from_city / this.distance_trigger_chance_scale);

    // every 100 meters walked add 1%. One percent here is huge, due to the low
    // default value (around 1.5%)
    if (this.force_noticeboard_event || RandRangeF(100) < this.trigger_chance * chance_scale + meters_from_city / this.distance_trigger_chance_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerNoticeboardContract - triggered encounter");

      this.createContractEncounter(master);

      // so that it can start from a noticeboard again
      this.was_triggered = false;

      return true;
    }

    return false;
  }

  private latent function createContractEncounter(master: CRandomEncounters) {
    var contract_position: Vector;
    var player_distance_from_noticeboard: float;
    var position_attempts: int;
    var found_position: bool;

    player_distance_from_noticeboard = VecDistance(thePlayer.GetWorldPosition(), this.position_near_noticeboard);

    for (position_attempts = 0; position_attempts < 10; position_attempts += 1) {
      contract_position = this.position_near_noticeboard + VecConeRand(
        VecHeading(thePlayer.GetWorldPosition() - this.position_near_noticeboard),
        25, // small angle to increase the chances the player will see the encounter
        player_distance_from_noticeboard * this.minimum_distance_multiplier,
        player_distance_from_noticeboard * this.maximum_distance_multiplier
      );

      if (getGroundPosition(contract_position)) {
        found_position = true;

        break;
      }
    }

    if (!found_position) {
      contract_position = thePlayer.GetWorldPosition();
    }

    createRandomCreatureContract(master, new RER_BestiaryEntryNull in this, contract_position);
  }

  private latent function lookForNearbyNoticeboards(master: CRandomEncounters): bool {
    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      return false;
    }

    // cancel only if the event wasn't forced
    if (!this.allow_automatic_cutscene && !this.force_noticeboard_event) {
      return false;
    }

    if (this.isThereEmptyNoticeboardNearby()) {
      LogChannel('modRandomEncounters', "RER_ListenerNoticeboardContract - triggered nearby noticeboard");

      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      this.position_near_noticeboard = thePlayer.GetWorldPosition();

      // play a few consecutive oneliners and a camera scene targeting the nearest noticeboard
      // if one exists and if camera scenes aren't disabled from the menu
      this.startNoticeboardCutscene(master);

      this.was_triggered = true;
    }

    return false;
  }

  private latent function startNoticeboardCutscene(master: CRandomEncounters) {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var noticeboards: array<CGameplayEntity>;
    var noticeboard: CGameplayEntity;
    var look_at_position: Vector;

    noticeboards = this.getNearbyNoticeboards();

    if (noticeboards.Size() == 0) {
      return;
    }

    noticeboard = noticeboards[0];
    
    if( !master.settings.disable_camera_scenes ) {
      REROL_should_scour_noticeboards(true);
      playNoticeboardCameraScene(noticeboard);
    }
    else {
      REROL_should_scour_noticeboards(false);
    }

    if (RandRange(10) < 2) {
      REROL_unusual_contract();
    }

    Sleep(0.4);
    REROL_mhm();
    Sleep(0.1);

    if (RandRange(10) < 5) {
      REROL_ill_tend_to_the_monster();
    }
    else {
      REROL_i_accept_the_challenge();
    }
    // else {
    //   REROL_ill_take_the_contract();
    // }
  }

  private latent function playNoticeboardCameraScene( noticeboard: CGameplayEntity ) {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var look_at_position: Vector;

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(0.3, 0, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    look_at_position = noticeboard.GetWorldPosition();
    FixZAxis(look_at_position);
    scene.look_at_target_static = look_at_position + Vector(0, 0, 0);

    scene.velocity_type = RER_CameraVelocityType_FORWARD;
    scene.velocity = Vector(0.001, 0.001, 0);

    scene.duration = 6;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene, true);
  }

  private function getNearbyNoticeboards(): array<CGameplayEntity> {
    var entities: array<CGameplayEntity>;

     // 'W3NoticeBoard' for noticeboards, 'W3FastTravelEntity' for signpost
    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      5, // range, we'll have to check if 50 is too big/small
      1, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'W3NoticeBoard'
    );

    return entities;
  }

  private function isThereEmptyNoticeboardNearby(): bool {
    var noticeboards: array<CGameplayEntity>;
    var current_noticeboard: W3NoticeBoard;
    var i: int;

    noticeboards = this.getNearbyNoticeboards();

    // no noticeboad nearby, we can leave
    if (noticeboards.Size() == 0) {
      return false;
    }

    if (this.force_noticeboard_event) {
      this.force_noticeboard_event = false;

      return true;
    }

    for (i = 0; i < noticeboards.Size(); i += 1) {
      if ((W3NoticeBoard)noticeboards[i]) {
        current_noticeboard = (W3NoticeBoard)noticeboards[i];

        if (!current_noticeboard.HasAnyQuest()) {
          return true;
        }
      }
    }
    
    return false;
  }
}

state ListeningForEvents in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    // LogChannel('modRandomEncounters', "RER_EventsManager - State ListeningForEvents");

    this.ListeningForEvents_main();
  }

  entry function ListeningForEvents_main() {
    var i: int;
    var listener: RER_EventsListener;
    var was_spawn_already_triggered: bool;
    var spawn_asked: bool;

    was_spawn_already_triggered = false;

    // LogChannel('modRandomEncounters', "RER_EventsManager - State ListeningForEvents - listening started");

    if (!parent.master.settings.is_enabled) {
      parent.GotoState('Waiting');
    }

    for (i = 0; i < parent.listeners.Size(); i += 1) {
      listener = parent.listeners[i];

      if (!listener.is_ready) {
        listener.onReady(parent);
      }

      if (!listener.active) {
        continue;
      }

      was_spawn_already_triggered = listener
        .onInterval(was_spawn_already_triggered, parent.master, parent.delay, parent.chance_scale) || was_spawn_already_triggered;
    }

    // LogChannel('modRandomEncounters', "RER_EventsManager - State ListeningForEvents - listening finished");
    
    parent.GotoState('Waiting');
  }
}

state Starting in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_EventsManager - State Starting");

    this.Starting_main();
  }

  entry function Starting_main() {
    var inGameConfigWrapper: CInGameConfigWrapper;
    var listener: RER_EventsListener;
    var i: int;


    for (i = 0; i < parent.listeners.Size(); i += 1) {
      listener = parent.listeners[i];

      if (!listener.is_ready) {
        listener.onReady(parent);
      }

      listener.loadSettings();
    }

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    parent.internal_cooldown = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERevents', 'eventSystemICD')
    );

    parent.chance_scale = parent.delay / parent.internal_cooldown;

    LogChannel('modRandomEncounters', "RER_EventsManager - chance_scale = " + parent.chance_scale + ", delay =" + parent.delay);
    
    parent.GotoState('Waiting');
  }
}

state Waiting in RER_EventsManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    // LogChannel('modRandomEncounters', "RER_EventsManager - State Waiting");

    this.Waiting_main();
  }

  entry function Waiting_main() {
    // LogChannel('modRandomEncounters', "RER_EventsManager - Waiting_main()");
    
    Sleep(parent.delay);

    parent.GotoState('ListeningForEvents');
  }
}
