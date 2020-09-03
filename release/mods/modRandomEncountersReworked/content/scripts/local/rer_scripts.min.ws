
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
  CreatureHuman        = 0,
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

  // large creatures below
  CreatureLESHEN       = 24,
  CreatureWEREWOLF     = 25,
  CreatureFIEND        = 26,
  CreatureEKIMMARA     = 27,
  CreatureKATAKAN      = 28,
  CreatureGOLEM        = 29,
  CreatureELEMENTAL    = 30,
  CreatureNIGHTWRAITH  = 31,
  CreatureNOONWRAITH   = 32,
  CreatureCHORT        = 33,
  CreatureCYCLOPS      = 34,
  CreatureTROLL        = 35,
  CreatureHAG          = 36,
  CreatureFOGLET       = 37,
  CreatureBRUXA        = 38,
  CreatureFLEDER       = 39,
  CreatureGARKAIN      = 40,
  CreatureDETLAFF      = 41,
  CreatureGIANT        = 42,  
  CreatureSHARLEY      = 43,
  CreatureWIGHT        = 44,
  CreatureGRYPHON      = 45,
  CreatureCOCKATRICE   = 46,
  CreatureBASILISK     = 47,
  CreatureWYVERN       = 48,
  CreatureFORKTAIL     = 49,
  CreatureSKELTROLL    = 50,

  // It is important to keep the numbers continuous.
  // The `SpawnRoller` classes uses these numbers to
  // to fill its arrays.
  // (so that i dont have to write 40 lines by hand)
  CreatureMAX          = 51,
  CreatureNONE         = 52,
}


enum EncounterType {
  EncounterType_DEFAULT  = 0,
  EncounterType_HUNT     = 1,
  EncounterType_CONTRACT = 2,
  EncounterType_MAX      = 3
}


enum OutOfCombatRequest {
  OutOfCombatRequest_TROPHY_CUTSCENE = 0,
  OutOfCombatRequest_TROPHY_NONE     = 1
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
  else {
    LogChannel('modRandomEncounters', "spawning - NOT HUNT");
    createRandomCreatureComposition(random_encounters_class, CreatureNONE);

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "BattleCryBadSituation" );
    }
  }
}

abstract class CompositionSpawner {

  // When you need to force a creature type
  var _creature_type: CreatureType;
  default _creature_type = CreatureNONE;

  public function setCreatureType(type: CreatureType): CompositionSpawner {
    this._creature_type = type;

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

  // When you need to force the creature template
  var _creatures_templates: EnemyTemplateList;
  var _creatures_templates_force: bool;
  default _creatures_templates_force = false;

  public function setCreaturesTemplates(templates: EnemyTemplateList): CompositionSpawner {
    this._creatures_templates = templates;
    this._creatures_templates_force = true;

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

  var master: CRandomEncounters;
  var creature_type: CreatureType;
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;
  var initial_position: Vector;
  var group_positions: array<Vector>;
  var created_entities: array<CEntity>;

  public latent function spawn(master: CRandomEncounters) {
    var current_entity_template: SEnemyTemplate;
    var current_template: CEntityTemplate;
    var i: int;
    var j: int;
    var group_positions_index: int;
    var success: bool;

    this.master = master;

    this.creature_type = this.getCreatureType(master);
    this.creatures_templates = this.getCreaturesTemplates(this.creature_type);
    this.number_of_creatures = this.getNumberOfCreatures(this.creatures_templates);

    this.creatures_templates = fillEnemyTemplateList(
      this.creatures_templates,
      this.number_of_creatures,
      master.settings.only_known_bestiary_creatures
    );

    if (!this.getInitialPosition(this.initial_position)) {
      LogChannel('modRandomEncounters', "could not find proper spawning position");

      return;
    }

    this.group_positions = getGroupPositions(
      this.initial_position,
      this.number_of_creatures,
      this._group_positions_density
    );

    LogChannel('modRandomEncounters', "GroupComposition span - " + creature_type);
    LogChannel('modRandomEncounters', "GroupComposition span - number of creatures: " + number_of_creatures);
    LogChannel('modRandomEncounters', "GroupComposition span - initial position: " + VecToString(initial_position));

    success = this.beforeSpawningEntities();
    if (!success) {
      return;
    }

    for (i = 0; i < this.creatures_templates.templates.Size(); i += 1) {
      current_entity_template = this.creatures_templates.templates[i];

      if (current_entity_template.count > 0) {
        current_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);

        for (j = 0; j < current_entity_template.count; j += 1) {
          created_entities.PushBack(
            this.createEntity(
              current_template,
              group_positions[group_positions_index],
              thePlayer.GetWorldRotation()
            )
          );

          group_positions_index += 1;
        }
      }
    }


    for (i = 0; i < this.created_entities.Size(); i += 1) {
      this.forEachEntity(
        this.created_entities[i]
      );

      LogChannel('modRandomEncounters', "creature trophy chances: " + master.settings.monster_trophies_chances[this.creature_type]);

      if (this.allow_trophy && RandRange(100) < master.settings.monster_trophies_chances[this.creature_type]) {
        LogChannel('modRandomEncounters', "adding 1 trophy " + this.creature_type);
        
        ((CActor)this.created_entities[i])
          .GetInventory()
          .AddAnItem(
            master.resources.getCreatureTrophy(this.creature_type),
            1
          );
      }
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

  protected latent function createEntity(template: CEntityTemplate, position: Vector, rotation: EulerAngles): CEntity {
    return theGame.CreateEntity(
      template,
      position,
      rotation
    );
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



  protected latent function getCreatureType(master: CRandomEncounters): CreatureType {
    var creature_type: CreatureType;

    if (this._creature_type == CreatureNONE) {
      creature_type = master.rExtra.getRandomCreatureByCurrentArea(
        master.settings,
        master.spawn_roller,
        master.resources
      );

      return creature_type;
    }

    return this._creature_type;
  }

  protected function getCreaturesTemplates(creature_type: CreatureType): EnemyTemplateList {
    if (this._creatures_templates_force) {
      return this._creatures_templates;
    }

    return master
      .resources
      .getCreatureResourceByCreatureType(creature_type, master.rExtra);
  }

  protected function getNumberOfCreatures(creatures_templates: EnemyTemplateList): int {
    if (this._number_of_creatures != 0) {
      return this._number_of_creatures;
    }

    return rollDifficultyFactor(
      creatures_templates.difficulty_factor,
      master.settings.selectedDifficulty
    );
  }

  protected function getInitialPosition(out initial_position: Vector): bool {
    var attempt: bool;

    if (this.spawn_position_force) {
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
  default modVersion = '0.9.4.1';

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

      super.OnSpawned(spawn_data);

      rExtra = new CModRExtra in this;
      settings = new RE_Settings in this;
      resources = new RE_Resources in this;
      spawn_roller = new SpawnRoller in this;

      this.spawn_roller.fill_arrays();

      this.initiateRandomEncounters();
    }
  }

  event OnRefreshSettings(action: SInputAction) {
    LogChannel('modRandomEncounters', "settings refreshed");
    
    if (IsPressed(action)) {
      this.settings.loadXMLSettingsAndShowNotification();
      this.GotoState('Waiting');
    }
  }

  event OnSpawnMonster(action: SInputAction) {
    LogChannel('modRandomEncounters', "on spawn event");
  
    if (this.ticks_before_spawn > 5) {
      this.ticks_before_spawn = 5;
    }
  }

  private function initiateRandomEncounters() {

    this.settings.loadXMLSettings();
    this.resources.load_resources();

    AddTimer('onceReady', 3.0, false);
    this.GotoState('Waiting');
  }

  timer function onceReady(optional delta: float, optional id: Int32) {
    if (!this.settings.hide_next_notifications) {
      displayRandomEncounterEnabledNotification();
    }
  }

  //#region OutOfCombat action
  private var out_of_combat_requests: array<OutOfCombatRequest>;

  // add the requested action for when the player will the combat
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
          this.AddTimer('outOfCombatTrophyCutscene', 1.5, false);
        break;
      }
    }

    this.out_of_combat_requests.Clear();
  }

  timer function outOfCombatTrophyCutscene(optional delta: float, optional id: Int32) {
    var scene: CStoryScene;
    var entities : array<CGameplayEntity>;
    var i: int;
    var items_guids: array<SItemUniqueId>;

    LogChannel('modRandomEncounters', "playing out of combat cutscene");

    scene = (CStoryScene)LoadResource(
      "dlc\modtemplates\randomencounterreworkeddlc\data\mh_taking_trophy_no_dialogue.w2scene",
      true
    );
    
    theGame
      .GetStorySceneSystem()
      .PlayScene(scene, "Input");

    LogChannel('modRandomEncounters', "searching lootbag nearby");
    FindGameplayEntitiesInRange( entities, thePlayer, 10, 10, , FLAG_ExcludePlayer,, 'W3Container' );

    for (i = 0; i < entities.Size(); i += 1) {
      LogChannel('modRandomEncounters', "lootbag - giving all RER_Trophy to player");
      items_guids = ((W3Container)entities[i]).GetInventory().GetItemsByTag('RER_Trophy');
      
      LogChannel('modRandomEncounters', "lootbag - found " + items_guids.Size() + " trophies");
      ((W3Container)entities[i]).GetInventory()
        .GiveItemsTo(thePlayer.GetInventory(), items_guids);
    }

    PlayItemEquipSound('trophy');
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

// exec function rer_start_encounter(optional creature: CreatureType) {
//   var rer_entity : CRandomEncounters;
//   var entities : array<CEntity>;

//   theGame.GetEntitiesByTag('RandomEncounterTag', entities);
		
//   if (entities.Size() == 0) {
//     LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
//     return;
//   }

//   rer_entity = (CRandomEncounters)entities[0];

//   createRandomCreatureComposition(rer_entity, creature);
// }

// exec function rer_start_hunt(optional creature: CreatureType) {
//   var rer_entity : CRandomEncounters;
//   var entities : array<CEntity>;

//   theGame.GetEntitiesByTag('RandomEncounterTag', entities);
		
//   if (entities.Size() == 0) {
//     LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
//     return;
//   }

//   rer_entity = (CRandomEncounters)entities[0];

//   createRandomCreatureHunt(rer_entity, creature);
// }
function displayRandomEncounterEnabledNotification() {
  theGame
  .GetGuiManager()
  .ShowNotification(
    GetLocStringByKey("option_rer_enabled")
  );
}

class RE_Resources {
  public var blood_splats : array<string>;

  public var creatures_resources: array<EnemyTemplateList>;
  public var humans_resources: array<EnemyTemplateList>;

  function load_resources() {
    var i: int;
    var empty_enemy_template_list: EnemyTemplateList;

    if (this.creatures_resources.Size() == 0) {
      for (i = 0; i < CreatureMAX; i += 1) {
        this.creatures_resources.PushBack(empty_enemy_template_list);
      }
    }

    if (this.humans_resources.Size() == 0) {
      for (i = 0; i < HT_MAX; i += 1) {
        this.humans_resources.PushBack(empty_enemy_template_list);
      }
    }

    this.load_blood_splats();
    this.load_default_entities();

    if (isBloodAndWineActive()) {
      this.loadBloodAndWineResources();
    }

    if (isHeartOfStoneActive()) {
      this.loadHearOfStoneResources();
    }
  }

  public function getHumanResourcesByHumanType(human_type: EHumanType): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get human resource by human type: " + human_type);

    return this.humans_resources[human_type];
  }

  public function getCreatureResourceByCreatureType(creature_type: CreatureType, out rExtra: CModRExtra): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get creature resource by creature type: " + creature_type);

    if (creature_type == CreatureHuman) {
      return this.getHumanResourcesByHumanType(
        rExtra.getRandomHumanTypeByCurrentArea()
      );
    }

    return this.creatures_resources[creature_type];
  }

  private function load_blood_splats() {
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_big.w2ent");  
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium.w2ent");    
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium_2.w2ent");  
    blood_splats.PushBack("living_world\treasure_hunting\th1003_lynx\entities\generic_clue_blood_splat.w2ent");
  }

  private function loadBloodAndWineResources() {
    this.creatures_resources[CreatureWIGHT] = re_wight();
    this.creatures_resources[CreatureSHARLEY] = re_sharley();
    this.creatures_resources[CreatureCENTIPEDE] = re_centipede();
    this.creatures_resources[CreatureGIANT] = re_giant();
    this.creatures_resources[CreaturePANTHER] = re_panther();
    this.creatures_resources[CreatureKIKIMORE] = re_kikimore();
    this.creatures_resources[CreatureDROWNERDLC] = re_gravier();
    this.creatures_resources[CreatureGARKAIN] = re_garkain();
    this.creatures_resources[CreatureFLEDER] = re_fleder();
    this.creatures_resources[CreatureECHINOPS] = re_echinops();
    this.creatures_resources[CreatureBRUXA] = re_bruxa();
    this.creatures_resources[CreatureBARGHEST] = re_barghest();
    this.creatures_resources[CreatureSKELETON] = re_skeleton();
    this.creatures_resources[CreatureDETLAFF] = re_detlaff();
  }

  private function loadHearOfStoneResources() {
    this.creatures_resources[CreatureSPIDER] = re_spider();
    this.creatures_resources[CreatureBOAR] = re_boar();
  }

  private function load_default_entities() {
    this.creatures_resources[CreatureGRYPHON] = re_gryphon();
    this.creatures_resources[CreatureFORKTAIL] = re_forktail();
    this.creatures_resources[CreatureWYVERN] = re_wyvern();
    this.creatures_resources[CreatureCOCKATRICE] = re_cockatrice();
    //cockatricef = re_cockatricef();
    this.creatures_resources[CreatureBASILISK] = re_basilisk();
    //basiliskf = re_basiliskf();
    this.creatures_resources[CreatureFIEND] = re_fiend();
    this.creatures_resources[CreatureCHORT] = re_chort();
    this.creatures_resources[CreatureENDREGA] = re_endrega();
    this.creatures_resources[CreatureFOGLET] = re_fogling();
    this.creatures_resources[CreatureGHOUL] = re_ghoul();
    this.creatures_resources[CreatureALGHOUL] = re_alghoul();
    this.creatures_resources[CreatureBEAR] = re_bear();
    
    
    this.creatures_resources[CreatureGOLEM] = re_golem();
    this.creatures_resources[CreatureELEMENTAL] = re_elemental();
    this.creatures_resources[CreatureHAG] = re_hag();
    this.creatures_resources[CreatureNEKKER] = re_nekker();
    this.creatures_resources[CreatureEKIMMARA] = re_ekimmara();
    this.creatures_resources[CreatureKATAKAN] = re_katakan();
    
    
    this.creatures_resources[CreatureDROWNER] = re_drowner();
    this.creatures_resources[CreatureROTFIEND] = re_rotfiend();
    this.creatures_resources[CreatureNIGHTWRAITH] = re_nightwraith();
    this.creatures_resources[CreatureNOONWRAITH] = re_noonwraith();
    this.creatures_resources[CreatureTROLL] = re_troll();
    
    this.creatures_resources[CreatureWOLF] = re_wolf();
    
    this.creatures_resources[CreatureWRAITH] = re_wraith();    
    this.creatures_resources[CreatureHARPY] = re_harpy();
    this.creatures_resources[CreatureLESHEN] = re_leshen();
    this.creatures_resources[CreatureWEREWOLF] = re_werewolf();
    this.creatures_resources[CreatureCYCLOPS] = re_cyclop();
    this.creatures_resources[CreatureARACHAS] = re_arachas();
    this.creatures_resources[CreatureBRUXA] = re_bruxacity();

    this.creatures_resources[CreatureSKELTROLL] = re_skeltroll();
    this.creatures_resources[CreatureSKELBEAR] = re_skelbear();
    this.creatures_resources[CreatureSKELWOLF] = re_skelwolf();

    // whh = re_whh();
    this.creatures_resources[CreatureWILDHUNT] = re_wildhunt();

    // this resource is almost never used.
    // there a functions to get random human resources
    // but it is used for its bestiary entry
    this.creatures_resources[CreatureHuman] = re_bandit();

    this.humans_resources[HT_BANDIT] = re_bandit();
    this.humans_resources[HT_NOVBANDIT] = re_novbandit();
    this.humans_resources[HT_SKELBANDIT] = re_skelbandit();
    this.humans_resources[HT_SKELBANDIT2] = re_skel2bandit();
    this.humans_resources[HT_CANNIBAL] = re_cannibal();
    this.humans_resources[HT_RENEGADE] = re_renegade();
    this.humans_resources[HT_PIRATE] = re_pirate();
    this.humans_resources[HT_SKELPIRATE] = re_skelpirate();
    this.humans_resources[HT_NILFGAARDIAN] = re_nilf();
    this.humans_resources[HT_WITCHHUNTER] = re_whunter();
  }

                  //////////////////////
                  // PUBLIC FUNCTIONS //
                  //////////////////////

  public latent function getBloodSplatsResources(): array<CEntityTemplate> {
    var i: int;
    var output: array<CEntityTemplate>;

    for (i = 0; i < this.blood_splats.Size(); i += 1) {
      output.PushBack(
        (CEntityTemplate)LoadResourceAsync(
          this.blood_splats[i],
          true
        )
      );
    }

    return output;
  }

  public latent function getPortalResource(): CEntityTemplate {
    var entity_template: CEntityTemplate;

    entity_template = (CEntityTemplate)LoadResourceAsync( "gameplay\interactive_objects\rift\rift.w2ent", true);
    
    return entity_template;
  }

  public function getCreatureTrophy(creature_type: CreatureType): name {
    switch (creature_type) {
      case CreatureHuman:
        return 'modrer_human_trophy';
        break;
      case CreatureARACHAS:
        return 'modrer_arachas_trophy';
        break;
      case CreatureKIKIMORE:
      case CreatureENDREGA:
      case CreatureECHINOPS:
      case CreatureSPIDER:
      case CreatureCENTIPEDE:
        return 'modrer_insectoid_trophy';
        break;
      case CreatureGHOUL:
      case CreatureALGHOUL:
      case CreatureDROWNER:
      case CreatureROTFIEND:
      case CreatureDROWNERDLC:
        return 'modrer_necrophage_trophy';
        break;
      
      case CreatureNEKKER:
        return 'modrer_nekker_trophy';

      case CreatureWRAITH:
        return 'modrer_wraith_trophy';
        break;
      case CreatureHARPY:
        return 'modrer_harpy_trophy';
        break;
      case CreatureBARGHEST:
      case CreatureSKELETON:
        return 'modrer_spirit_trophy';
        break;
      case CreatureWOLF:
      case CreatureBOAR:
      case CreatureBEAR:
      case CreaturePANTHER:
      case CreatureSKELWOLF:
      case CreatureSKELBEAR:
        return 'modrer_beast_trophy';
        break;
      case CreatureWILDHUNT:
        return 'modrer_wildhunt_trophy';
        break;
      case CreatureLESHEN:
        return 'modrer_leshen_trophy';
        break;
      case CreatureWEREWOLF:
        return 'modrer_werewolf_trophy';
        break;
      case CreatureFIEND:
        return 'modrer_fiend_trophy';
        break;
      case CreatureEKIMMARA:
        return 'modrer_ekimmara_trophy';
        break;
      case CreatureKATAKAN:
        return 'modrer_katakan_trophy';
        break;
      case CreatureGOLEM:
      case CreatureELEMENTAL:
        return 'modrer_elemental_trophy';
        break;
      case CreatureNIGHTWRAITH:
        return 'modrer_nightwraith_trophy';
        break;
      case CreatureNOONWRAITH:
        return 'modrer_noonwraith_trophy';
        break;
      case CreatureCHORT:
        return 'modrer_czart_trophy';
        break;
      case CreatureCYCLOPS:
        return 'modrer_cyclop_trophy';
        break;
      case CreatureTROLL:
        return 'modrer_troll_trophy';
        break;
      case CreatureHAG:
        return 'modrer_grave_hag_trophy';
        break;
      case CreatureFOGLET:
        return 'modrer_fogling_trophy';
        break;

      case CreatureFLEDER:
      case CreatureGARKAIN:
        return 'modrer_garkain_trophy';
        break;
      case CreatureBRUXA:
      case CreatureDETLAFF:
        return 'modrer_vampire_trophy';
        break;

      case CreatureGIANT:
        return 'modrer_giant_trophy';
        break;
      case CreatureSHARLEY:
        return 'modrer_sharley_trophy';
        break;
      case CreatureWIGHT:
        return 'modrer_wight_trophy';
        break;
      case CreatureGRYPHON:
        return 'modrer_griffin_trophy';
        break;
      case CreatureCOCKATRICE:
        return 'modrer_cockatrice_trophy';
        break;
      case CreatureBASILISK:
        return 'modrer_basilisk_trophy';
        break;
      case CreatureWYVERN:
        return 'modrer_wyvern_trophy';
        break;
      case CreatureFORKTAIL:
        return 'modrer_forktail_trophy';
        break;
      case CreatureSKELTROLL:
        return 'modrer_troll_trophy';
        break;
    }
  }
}

function isHeartOfStoneActive(): bool {
  return theGame.GetDLCManager().IsEP1Available() && theGame.GetDLCManager().IsEP1Enabled();
}

function isBloodAndWineActive(): bool {
  return theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled();
}

class RE_Settings {

  
  public var customDayMax, customDayMin, customNightMax, customNightMin  : int;
  public var all_monster_hunt_chance: int;
  public var all_monster_contract_chance: int;
  public var all_monster_ambush_chance: int;
  public var enableTrophies : bool;
  public var selectedDifficulty : int;

  // uses the enum `Creature` and its values for the index/key.
  // and the `int` for the value/chance.
  public var creatures_chances_day: array<int>;
  public var creatures_chances_night: array<int>;

  // use the enums `Creature` & `Creature` for the indices.
  // and the `bool` for the value.
  public var creatures_city_spawns: array<bool>;

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

  public var monster_trophies_chances: array<int>;

  public var minimum_spawn_distance: float;
  public var spawn_diameter: float;
  public var kill_threshold_distance: float;

  public var trophies_enabled_by_encounter: array<bool>;

  public var trophy_pickup_scene: bool;

  public var only_known_bestiary_creatures: bool;

  function loadXMLSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    if (this.shouldResetRERSettings(inGameConfigWrapper)) {
      LogChannel('modRandomEncounters', 'reset RER settings');
      this.resetRERSettings(inGameConfigWrapper);
    }

    this.loadMonsterHuntsChances(inGameConfigWrapper);
    this.loadMonsterContractsChances(inGameConfigWrapper);
    this.loadMonsterAmbushChances(inGameConfigWrapper);
    this.loadCustomFrequencies(inGameConfigWrapper);

    this.loadDifficultySettings(inGameConfigWrapper);
    this.loadCitySpawnSettings(inGameConfigWrapper);

    this.fillSettingsArrays();
    this.loadTrophiesSettings(inGameConfigWrapper);
    this.loadCreaturesSpawningChances(inGameConfigWrapper);
    this.loadGeraltCommentsSettings(inGameConfigWrapper);
    this.loadHideNextNotificationsSettings(inGameConfigWrapper);
    this.loadEnableEncountersLootSettings(inGameConfigWrapper);
    this.loadExternalFactorsCoefficientSettings(inGameConfigWrapper);
    this.loadMonsterTrophiesSettings(inGameConfigWrapper);
    this.loadAdvancedSettings(inGameConfigWrapper);
    this.loadTrophyPickupAnimationSettings(inGameConfigWrapper);
    this.loadOnlyKnownBestiaryCreaturesSettings(inGameConfigWrapper);
  }

  function loadXMLSettingsAndShowNotification() {
    this.loadXMLSettings();

    theGame
    .GetGuiManager()
    .ShowNotification("Random Encounters XML settings loaded");
  }

  private function loadDifficultySettings(inGameConfigWrapper: CInGameConfigWrapper) {
    selectedDifficulty = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'Difficulty'));
  }

  private function loadGeraltCommentsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.geralt_comments_enabled = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'geraltComments');
  }

  private function loadHideNextNotificationsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.hide_next_notifications = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'hideNextNotifications');
  }

  private function loadEnableEncountersLootSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.enable_encounters_loot = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableEncountersLoot');
  }

  private function loadExternalFactorsCoefficientSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.external_factors_coefficient = StringToFloat(
      inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'externalFactorsImpact')
    );
  }

  private function loadOnlyKnownBestiaryCreaturesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.only_known_bestiary_creatures = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERonlyKnownBestiaryCreatures');
  }

  private function loadTrophiesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.trophies_enabled_by_encounter[EncounterType_DEFAULT] = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERtrophiesAmbush');
    this.trophies_enabled_by_encounter[EncounterType_HUNT] = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERtrophiesHunt');
    this.trophies_enabled_by_encounter[EncounterType_CONTRACT] = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERtrophiesContract');
  }

  private function loadTrophyPickupAnimationSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.trophy_pickup_scene = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERtrophyPickupAnimation');
  }

  private function loadCustomFrequencies(inGameConfigWrapper: CInGameConfigWrapper) {
    customDayMax = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureFrequency', 'customdFrequencyHigh'));
    customDayMin = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureFrequency', 'customdFrequencyLow'));
    customNightMax = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureFrequency', 'customnFrequencyHigh'));
    customNightMin = StringToInt(inGameConfigWrapper.GetVarValue('RERcreatureFrequency', 'customnFrequencyLow'));  
  }

  private function loadMonsterHuntsChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_hunt_chance = StringToInt(inGameConfigWrapper.GetVarValue('RERencounterTypes', 'allMonsterHuntChance'));
  }

  private function loadMonsterContractsChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_contract_chance = StringToInt(
      inGameConfigWrapper.GetVarValue('RERencounterTypes', 'allMonsterContractChance')
    );
  }

  private function loadMonsterAmbushChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_ambush_chance = StringToInt(
      inGameConfigWrapper.GetVarValue('RERencounterTypes', 'allMonsterAmbushChance')
    );
  }

  private function shouldResetRERSettings(inGameConfigWrapper: CInGameConfigWrapper): bool {
    return !inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'RERmodInitialized');
  }

  private function resetRERSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    inGameConfigWrapper.ApplyGroupPreset('RandomEncountersMENU', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERencounterTypes', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERcreatureFrequency', 1); // medium frequency
    inGameConfigWrapper.ApplyGroupPreset('customGroundDay', 0);
    inGameConfigWrapper.ApplyGroupPreset('customGroundNight', 0);
    inGameConfigWrapper.ApplyGroupPreset('RER_CitySpawns', 0);
    inGameConfigWrapper.ApplyGroupPreset('RER_monsterTrophies', 0);
    inGameConfigWrapper.ApplyGroupPreset('RERadvanced', 0);
    
    inGameConfigWrapper.SetVarValue('RandomEncountersMENU', 'RERmodInitialized', 1);
    theGame.SaveUserSettings();
  }
  

  private function fillSettingsArrays() {
    var i: int;

    if (this.creatures_chances_day.Size() == 0) {
      for (i = 0; i < CreatureMAX; i += 1) {
        this.creatures_chances_day.PushBack(0);
        this.creatures_chances_night.PushBack(0);
        this.creatures_city_spawns.PushBack(false);
        this.monster_trophies_chances.PushBack(0);
      }

      for (i = 0; i < EncounterType_MAX; i += 1) {
        this.trophies_enabled_by_encounter.PushBack(false);
      }
    }
  }

  private function loadAdvancedSettings(out inGameConfigWrapper : CInGameConfigWrapper) {
    this.minimum_spawn_distance   = StringToFloat(inGameConfigWrapper.GetVarValue('RERadvanced', 'minSpawnDistance'));
    this.spawn_diameter           = StringToFloat(inGameConfigWrapper.GetVarValue('RERadvanced', 'spawnDiameter'));
    this.kill_threshold_distance  = StringToFloat(inGameConfigWrapper.GetVarValue('RERadvanced', 'killThresholdDistance'));

    if (this.minimum_spawn_distance < 20 || this.spawn_diameter < 10 || this.kill_threshold_distance < 100) {
      inGameConfigWrapper.ApplyGroupPreset('RERadvanced', 0);

      this.minimum_spawn_distance   = StringToInt(inGameConfigWrapper.GetVarValue('RERadvanced', 'minSpawnDistance'));
      this.spawn_diameter           = StringToInt(inGameConfigWrapper.GetVarValue('RERadvanced', 'spawnDiameter'));
      this.kill_threshold_distance  = StringToInt(inGameConfigWrapper.GetVarValue('RERadvanced', 'killThresholdDistance'));
      theGame.SaveUserSettings();
    }
  }
   
  private function loadCreaturesSpawningChances (out inGameConfigWrapper : CInGameConfigWrapper) {
    this.creatures_chances_day[CreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Harpies'));
    this.creatures_chances_day[CreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Endrega'));
    this.creatures_chances_day[CreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ghouls'));
    this.creatures_chances_day[CreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Alghouls'));
    this.creatures_chances_day[CreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Nekkers'));
    this.creatures_chances_day[CreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Drowners'));
    this.creatures_chances_day[CreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Rotfiends'));
    this.creatures_chances_day[CreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    this.creatures_chances_day[CreatureSKELWOLF]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    this.creatures_chances_day[CreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wraiths'));
    this.creatures_chances_day[CreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Spiders'));
    this.creatures_chances_day[CreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'WildHunt'));
    this.creatures_chances_day[CreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Humans'));
    this.creatures_chances_day[CreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Skeleton'));

    // Blood and Wine
    this.creatures_chances_day[CreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Barghest')); 
    this.creatures_chances_day[CreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Echinops')); 
    this.creatures_chances_day[CreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Centipede'));
    this.creatures_chances_day[CreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Kikimore'));
    this.creatures_chances_day[CreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'DrownerDLC'));
    this.creatures_chances_day[CreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Arachas'));
    this.creatures_chances_day[CreatureBEAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
    this.creatures_chances_day[CreatureSKELBEAR]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
    this.creatures_chances_day[CreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Panther'));
    this.creatures_chances_day[CreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Boars'));

    this.creatures_chances_day[CreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Leshens'));
    this.creatures_chances_day[CreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Werewolves'));
    this.creatures_chances_day[CreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fiends'));
    this.creatures_chances_day[CreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ekimmara'));
    this.creatures_chances_day[CreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Katakan'));
    this.creatures_chances_day[CreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Golems'));
    this.creatures_chances_day[CreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Elementals'));
    this.creatures_chances_day[CreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NightWraiths'));
    this.creatures_chances_day[CreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NoonWraiths'));
    this.creatures_chances_day[CreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Chorts'));
    this.creatures_chances_day[CreatureCYCLOPS]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cyclops'));
    this.creatures_chances_day[CreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    this.creatures_chances_day[CreatureSKELTROLL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    this.creatures_chances_day[CreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Hags'));
    this.creatures_chances_day[CreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fogling'));
    this.creatures_chances_day[CreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bruxa'));
    this.creatures_chances_day[CreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fleder'));
    this.creatures_chances_day[CreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Garkain'));
    this.creatures_chances_day[CreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'HigherVamp'));
    this.creatures_chances_day[CreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Giant'));
    this.creatures_chances_day[CreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Sharley'));
    this.creatures_chances_day[CreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wight'));
    this.creatures_chances_day[CreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Gryphons'));
    this.creatures_chances_day[CreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cockatrice'));
    this.creatures_chances_day[CreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Basilisk'));
    this.creatures_chances_day[CreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wyverns'));
    this.creatures_chances_day[CreatureFORKTAIL]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Forktails'));

    this.creatures_chances_night[CreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Harpies'));
    this.creatures_chances_night[CreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Endrega'));
    this.creatures_chances_night[CreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ghouls'));
    this.creatures_chances_night[CreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Alghouls'));
    this.creatures_chances_night[CreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Nekkers'));
    this.creatures_chances_night[CreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Drowners'));
    this.creatures_chances_night[CreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Rotfiends'));
    this.creatures_chances_night[CreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wolves'));
    this.creatures_chances_night[CreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wraiths'));
    this.creatures_chances_night[CreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Spiders'));
    this.creatures_chances_night[CreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'WildHunt'));
    this.creatures_chances_night[CreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Humans'));
    this.creatures_chances_night[CreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Skeleton'));


    // Blood and Wine
    this.creatures_chances_night[CreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Barghest')); 
    this.creatures_chances_night[CreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Echinops')); 
    this.creatures_chances_night[CreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Centipede'));
    this.creatures_chances_night[CreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Kikimore'));
    this.creatures_chances_night[CreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'DrownerDLC'));
    this.creatures_chances_night[CreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Arachas'));
    this.creatures_chances_night[CreatureBEAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bears'));
    this.creatures_chances_night[CreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Panther'));
    this.creatures_chances_night[CreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Boars'));

    this.creatures_chances_night[CreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Leshens'));
    this.creatures_chances_night[CreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Werewolves'));
    this.creatures_chances_night[CreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fiends'));
    this.creatures_chances_night[CreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ekimmara'));
    this.creatures_chances_night[CreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Katakan'));
    this.creatures_chances_night[CreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Golems'));
    this.creatures_chances_night[CreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Elementals'));
    this.creatures_chances_night[CreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NightWraiths'));
    this.creatures_chances_night[CreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NoonWraiths'));
    this.creatures_chances_night[CreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Chorts'));
    this.creatures_chances_night[CreatureCYCLOPS]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cyclops'));
    this.creatures_chances_night[CreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Troll'));
    this.creatures_chances_night[CreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Hags'));
    this.creatures_chances_night[CreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fogling'));
    this.creatures_chances_night[CreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bruxa'));
    this.creatures_chances_night[CreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fleder'));
    this.creatures_chances_night[CreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Garkain'));
    this.creatures_chances_night[CreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'HigherVamp'));
    this.creatures_chances_night[CreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Giant'));
    this.creatures_chances_night[CreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Sharley'));
    this.creatures_chances_night[CreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wight'));
    this.creatures_chances_night[CreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Gryphons'));
    this.creatures_chances_night[CreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cockatrice'));
    this.creatures_chances_night[CreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Basilisk'));
    this.creatures_chances_night[CreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wyverns'));
    this.creatures_chances_night[CreatureFORKTAIL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Forktails'));
  }

  private function loadCitySpawnSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.creatures_city_spawns[CreatureHARPY]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Harpies');
    this.creatures_city_spawns[CreatureENDREGA]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Endrega');
    this.creatures_city_spawns[CreatureGHOUL]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Ghouls');
    this.creatures_city_spawns[CreatureALGHOUL]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Alghouls');
    this.creatures_city_spawns[CreatureNEKKER]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Nekkers');
    this.creatures_city_spawns[CreatureDROWNER]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Drowners');
    this.creatures_city_spawns[CreatureROTFIEND]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Rotfiends');
    this.creatures_city_spawns[CreatureWOLF]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Wolves');
    this.creatures_city_spawns[CreatureWRAITH]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Wraiths');
    this.creatures_city_spawns[CreatureSPIDER]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Spiders');
    this.creatures_city_spawns[CreatureWILDHUNT]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'WildHunt');
    this.creatures_city_spawns[CreatureHuman]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Humans');
    this.creatures_city_spawns[CreatureSKELETON]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Skeleton');
    this.creatures_city_spawns[CreatureBARGHEST]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Barghest');
    this.creatures_city_spawns[CreatureECHINOPS]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Echinops');
    this.creatures_city_spawns[CreatureCENTIPEDE]  = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Centipede');
    this.creatures_city_spawns[CreatureKIKIMORE]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Kikimore');
    this.creatures_city_spawns[CreatureDROWNERDLC] = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'DrownerDLC');
    this.creatures_city_spawns[CreatureARACHAS]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Arachas');
    this.creatures_city_spawns[CreatureBEAR]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Bears');
    this.creatures_city_spawns[CreaturePANTHER]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Panther');
    this.creatures_city_spawns[CreatureBOAR]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Boars');

    this.creatures_city_spawns[CreatureLESHEN]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Leshens');
    this.creatures_city_spawns[CreatureWEREWOLF]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Werewolves');
    this.creatures_city_spawns[CreatureFIEND]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Fiends');
    this.creatures_city_spawns[CreatureEKIMMARA]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Ekimmara');
    this.creatures_city_spawns[CreatureKATAKAN]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Katakan');
    this.creatures_city_spawns[CreatureGOLEM]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Golems');
    this.creatures_city_spawns[CreatureELEMENTAL]    = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Elementals');
    this.creatures_city_spawns[CreatureNIGHTWRAITH]  = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'NightWraiths');
    this.creatures_city_spawns[CreatureNOONWRAITH]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'NoonWraiths');
    this.creatures_city_spawns[CreatureCHORT]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Chorts');
    this.creatures_city_spawns[CreatureCYCLOPS]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Cyclops');
    this.creatures_city_spawns[CreatureTROLL]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Troll');
    this.creatures_city_spawns[CreatureHAG]          = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Hags');
    this.creatures_city_spawns[CreatureFOGLET]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Fogling');
    this.creatures_city_spawns[CreatureBRUXA]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Bruxa');
    this.creatures_city_spawns[CreatureFLEDER]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Fleder');
    this.creatures_city_spawns[CreatureGARKAIN]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Garkain');
    this.creatures_city_spawns[CreatureDETLAFF]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'HigherVamp');
    this.creatures_city_spawns[CreatureGIANT]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Giant');
    this.creatures_city_spawns[CreatureSHARLEY]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Sharley');
    this.creatures_city_spawns[CreatureWIGHT]        = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Wight');
    this.creatures_city_spawns[CreatureGRYPHON]      = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Gryphons');
    this.creatures_city_spawns[CreatureCOCKATRICE]   = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Cockatrice');
    this.creatures_city_spawns[CreatureBASILISK]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Basilisk');
    this.creatures_city_spawns[CreatureWYVERN]       = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Wyverns');
    this.creatures_city_spawns[CreatureFORKTAIL]     = inGameConfigWrapper.GetVarValue('RER_CitySpawns', 'Forktails');
  }

  private function loadMonsterTrophiesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.monster_trophies_chances[CreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Harpies'));
    this.monster_trophies_chances[CreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Endrega'));
    this.monster_trophies_chances[CreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Ghouls'));
    this.monster_trophies_chances[CreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Alghouls'));
    this.monster_trophies_chances[CreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Nekkers'));
    this.monster_trophies_chances[CreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Drowners'));
    this.monster_trophies_chances[CreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Rotfiends'));
    this.monster_trophies_chances[CreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Wolves'));
    this.monster_trophies_chances[CreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Wraiths'));
    this.monster_trophies_chances[CreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Spiders'));
    this.monster_trophies_chances[CreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'WildHunt'));
    this.monster_trophies_chances[CreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Humans'));
    this.monster_trophies_chances[CreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Skeleton'));
    this.monster_trophies_chances[CreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Barghest'));
    this.monster_trophies_chances[CreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Echinops'));
    this.monster_trophies_chances[CreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Centipede'));
    this.monster_trophies_chances[CreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Kikimore'));
    this.monster_trophies_chances[CreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'DrownerDLC'));
    this.monster_trophies_chances[CreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Arachas'));
    this.monster_trophies_chances[CreatureBEAR]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Bears'));
    this.monster_trophies_chances[CreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Panther'));
    this.monster_trophies_chances[CreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Boars'));

    this.monster_trophies_chances[CreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Leshens'));
    this.monster_trophies_chances[CreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Werewolves'));
    this.monster_trophies_chances[CreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Fiends'));
    this.monster_trophies_chances[CreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Ekimmara'));
    this.monster_trophies_chances[CreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Katakan'));
    this.monster_trophies_chances[CreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Golems'));
    this.monster_trophies_chances[CreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Elementals'));
    this.monster_trophies_chances[CreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'NightWraiths'));
    this.monster_trophies_chances[CreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'NoonWraiths'));
    this.monster_trophies_chances[CreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Chorts'));
    this.monster_trophies_chances[CreatureCYCLOPS]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Cyclops'));
    this.monster_trophies_chances[CreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Troll'));
    this.monster_trophies_chances[CreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Hags'));
    this.monster_trophies_chances[CreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Fogling'));
    this.monster_trophies_chances[CreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Bruxa'));
    this.monster_trophies_chances[CreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Fleder'));
    this.monster_trophies_chances[CreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Garkain'));
    this.monster_trophies_chances[CreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'HigherVamp'));
    this.monster_trophies_chances[CreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Giant'));
    this.monster_trophies_chances[CreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Sharley'));
    this.monster_trophies_chances[CreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Wight'));
    this.monster_trophies_chances[CreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Gryphons'));
    this.monster_trophies_chances[CreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Cockatrice'));
    this.monster_trophies_chances[CreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Basilisk'));
    this.monster_trophies_chances[CreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Wyverns'));
    this.monster_trophies_chances[CreatureFORKTAIL]     = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', 'Forktails'));
  }

  public function doesAllowCitySpawns(): bool {
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      if (this.creatures_city_spawns[i]) {
        return true;
      }
    }

    return false;
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

  public function rollCreatures(): CreatureType {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      total += this.creatures_counters[i];
    }

    // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
    // added so the user can disable all CreatureType and it would
    // cancel the spawn. Useful when the user wants no spawn during the day.
    if (total <= 0) {
      return CreatureNONE;
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < CreatureMAX; i += 1) {
      // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
      // `this.creatures_counters[i] > 0` is add so the user can
      // disable a CreatureType completely.
      if (this.creatures_counters[i] > 0 && roll <= current_position + this.creatures_counters[i]) {
        return i;
      }

      current_position += this.creatures_counters[i];
    }

    // not supposed to get here but hey, who knows.
    return CreatureNONE;
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

function getMaximumCountBasedOnDifficulty(out factor: DifficultyFactor, difficulty: int, optional added_factor: float): int {
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

function getMinimumCountBasedOnDifficulty(out factor: DifficultyFactor, difficulty: int, optional added_factor: float): int {
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

function rollDifficultyFactor(out factor: DifficultyFactor, difficulty: int, optional added_factor: float): int {
  if (added_factor == 0) {
    added_factor = 1;
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

  LogChannel('modRandomEncounters', "bestiary can spawn enemy: " + enemy_template.bestiary_entry);

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
        return true;
      }
    }
    else {
      LogChannel('modRandomEncounters', "unknown bestiary entryBase for entry " + enemy_template.bestiary_entry);
    }
  }
  else {
    LogChannel('modRandomEncounters', "unknown bestiary resource: " + enemy_template.bestiary_entry);
  }

  return false;
}

function re_gryphon() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\gryphon_lvl1.w2ent",,,
      "gameplay\journal\bestiary\griffin.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\gryphon_lvl3__volcanic.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
    )
  ); 
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\gryphon_mh__volcanic.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\generic_quests\novigrad\quest_files\mh301_gryphon\characters\mh301_gryphon.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;

  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;

  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  
  return enemy_template_list;
}

function re_cockatrice() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;  

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\cockatrice_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarycockatrice.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_basilisk() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\basilisk_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarybasilisk.journal"
      )
    );
  
  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\basilisk_white.w2ent",,,
        "dlc\bob\journal\bestiary\mq7018basilisk.journal"
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_wyvern() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wyvern_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarywyvern.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wyvern_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarywyvern.journal"
    )
  );
  
  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\oszluzg_young.w2ent",,,
        "dlc\bob\journal\bestiary\dracolizard.journal" // TODO: confirm journal
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_forktail() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\forktail_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryforktail.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\forktail_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryforktail.journal"
    )
  );

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\generic_quests\skellige\quest_files\mh208_forktail\characters\mh208_forktail.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh208.journal"
    )
  );

  

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_novbandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_club.w2ent",,,
      "gameplay\journal\bestiary\humans.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_mace_t1.w2ent",,,
      "gameplay\journal\bestiary\humans.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_2h_hammer.w2ent",,,
      "gameplay\journal\bestiary\humans.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\characters\presets\novigrad\nov_1h_sword_t1.w2ent",,,
      "gameplay\journal\bestiary\humans.journal"
    )
  );
  
  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_pirate() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_axe_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_blunt.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_crossbow.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_pirates_sword_normal.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_skelpirate() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe1h_hard.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe1h_normal.w2ent"));      
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_axe2h.w2ent", 2));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_blunt_hard.w2ent"));     
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_blunt_normal.w2ent"));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_bow.w2ent", 2));    
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_crossbow.w2ent", 1));    
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_hammer2h.w2ent", 1));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_swordshield.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_easy.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_hard.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_pirate_sword_normal.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_bandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_axe_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nml_deserters_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\novigrad_bandit_shield_1haxe.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\novigrad_bandit_shield_1hclub.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_nilf() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_shield.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\nilfgaardian_deserter_sword_hard.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_cannibal() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_boss.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_melee.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_melee_spear.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\lw_giggler_ranged.w2ent", 3));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_renegade() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_2h_axe.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_axe.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_blunt.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_boss.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_crossbow.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_shield.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\baron_renegade_sword_normal.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_skelbandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_axe_t1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_club.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_bow.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_2h_spear.w2ent", 3));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_axe_t1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_club.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_axe_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_1h_sword.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_axe_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\skellige\ske_shield_sword.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_skel2bandit() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe1h_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_blunt_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_blunt_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_shield_axe1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_shield_mace1h_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_axe2h.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_easy.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_hard.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_sword_normal.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_hammer2h.w2ent", 1));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_bow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("living_world\enemy_templates\skellige_bandit_crossbow.w2ent", 1));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_whunter() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_1h_sword_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_1h_mace_t2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_crossbow.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\inquisition\inq_2h_sword.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_wildhunt() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_axe.w2ent", 2,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_halberd.w2ent", 2,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_hammer.w2ent", 1,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_spear.w2ent", 2,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_sword.w2ent", 1,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wildhunt_minion_lvl1.w2ent", 2,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );  // hound of the wild hunt   
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wildhunt_minion_lvl2.w2ent", 1,,
      "gameplay\journal\bestiary\whminion.journal"
    )
  );  // spikier hound

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 4;
  enemy_template_list.difficulty_factor.maximum_count_medium = 6;
  enemy_template_list.difficulty_factor.minimum_count_hard = 5;
  enemy_template_list.difficulty_factor.maximum_count_hard = 7;

  return enemy_template_list;
}


function re_arachas() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\arachas_lvl1.w2ent"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\arachas_lvl2__armored.w2ent", 2,,
      "gameplay\journal\bestiary\armoredarachas.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\arachas_lvl3__poison.w2ent", 2,,
      "gameplay\journal\bestiary\poisonousarachas.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_cyclop() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\cyclop_lvl1.w2ent",,,
      "gameplay\journal\bestiary\cyclops.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ice_giant.w2ent",,,
      "gameplay\journal\bestiary\icegiant.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_leshen() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\lessog_lvl1.w2ent",,,
      "gameplay\journal\bestiary\leshy.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\lessog_lvl2__ancient.w2ent",,,
      "gameplay\journal\bestiary\sq204ancientleszen.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\journal\bestiary\bestiarymonsterhuntmh302.journal",,,
      "quests\generic_quests\novigrad\quest_files\mh302_leshy\characters\mh302_leshy.w2ent"
    )
  );
  
  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\spriggan.w2ent",,,
        "dlc\bob\journal\bestiary\mq7002spriggan.journal"
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_werewolf() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl3__lycan.w2ent",,,
      "gameplay\journal\bestiary\lycanthrope.journal"
    )
  );  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl4__lycan.w2ent",,,
      "gameplay\journal\bestiary\lycanthrope.journal"
    )
  );  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\werewolf_lvl5__lycan.w2ent",,,
      "gameplay\journal\bestiary\lycanthrope.journal"
    )
  ); 
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__werewolf.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  ); 
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__werewolf_01.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  ); 
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__werewolf_02.w2ent",,,
      "gameplay\journal\bestiary\bestiarywerewolf.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_fiend() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate(
    "characters\npc_entities\monsters\bies_lvl1.w2ent",,,
    "gameplay\journal\bestiary\fiends.journal" // TODO: confirm journal
    )
  );  // fiends        
  enemy_template_list.templates.PushBack(makeEnemyTemplate(
    "characters\npc_entities\monsters\bies_lvl2.w2ent",,,
    "gameplay\journal\bestiary\fiends.journal" // TODO: confirm journal
    )
  );  // red fiend

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_chort() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\czart_lvl1.w2ent",,,
      "gameplay\journal\bestiary\czart.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_bear() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_lvl1__black.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );      // black, like it says :)      
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_lvl2__grizzly.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );      // light brown  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_lvl3__grizzly.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );      // light brown  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_berserker_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );    // red/brown

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_skelbear() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\bear_lvl3__white.w2ent",,,
      "gameplay\journal\bestiary\bear.journal"
    )
  );      // polarbear

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_golem() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );          // normal greenish golem        
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl2__ifryt.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );      // fire golem  
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\golem_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarygolem.journal"
    )
  );          // weird yellowish golem
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "gameplay\templates\monsters\gargoyle_lvl1_lvl25.w2ent",,,
      "gameplay\journal\bestiary\gargoyle.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_elemental() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );      // earth elemental        
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );      // stronger and cliffier elemental
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\elemental_dao_lvl3__ice.w2ent",,,
      "gameplay\journal\bestiary\bestiaryelemental.journal"
    )
  );

  if(theGame.GetDLCManager().IsEP2Available()  &&   theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\mq7007_item__golem_grafitti.w2ent",,,
        "gameplay\journal\bestiary\bestiaryelemental.journal"
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_ekimmara() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_ekima_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh104.journal"
    )
  );    // white vampire

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_katakan() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarykatakan.journal"
    )
  );  // cool blinky vampire     
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\vampire_katakan_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarykatakan.journal"
    )
  );  // cool blinky vamp
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\generic_quests\novigrad\quest_files\mh304_katakan\characters\mh304_katakan.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh304.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_nightwraith() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nightwraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarymoonwright.journal"
    )
  );

  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee.w2ent",,,
        "dlc\bob\journal\bestiary\beanshie.journal"
      )
    );
  }

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_noonwraith() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\noonwraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );       
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__noonwright_pesta.w2ent",,,
      "gameplay\journal\bestiary\bestiarynoonwright.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_troll() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl1.w2ent",,,
      "gameplay\journal\bestiary\trollcave.journal"
    )
  );    // grey

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 3;

  return enemy_template_list;
}

function re_skeltroll() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl3__ice.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );  // ice   
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_cave_lvl4__ice.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );  // ice
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\troll_ice_lvl13.w2ent",,,
      "gameplay\journal\bestiary\icetroll.journal"
    )
  );    // ice

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 3;

  return enemy_template_list;
}

function re_hag() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_grave_lvl1.w2ent",,,
      "gameplay\journal\bestiary\gravehag.journal"
    )
  );          // grave hag 1        
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_lvl1.w2ent",,,
      "gameplay\journal\bestiary\waterhag.journal"
    )
  );          // grey  water hag    
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\hag_water_lvl2.w2ent",,,
      "gameplay\journal\bestiary\waterhag.journal"
    )
  );          // greenish water hag

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\generic_quests\skellige\quest_files\mh203_water_hag\characters\mh203_water_hag.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh203.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_harpy() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl1.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );        // harpy
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl2.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );        // harpy
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\harpy.journal"
    )
  );    // harpy
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\harpy_lvl3__erynia.w2ent", 1,,
      "gameplay\journal\bestiary\erynia.journal"
    )
  );    // harpy
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl1.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl2__lamia.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\siren_lvl3.w2ent", 1,,
      "gameplay\journal\bestiary\siren.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 3;
  enemy_template_list.difficulty_factor.maximum_count_easy = 4;
  enemy_template_list.difficulty_factor.minimum_count_medium = 4;
  enemy_template_list.difficulty_factor.maximum_count_medium = 5;
  enemy_template_list.difficulty_factor.minimum_count_hard = 5;
  enemy_template_list.difficulty_factor.maximum_count_hard = 7;
  
  return enemy_template_list;
}

function re_endrega() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl1__worker.w2ent",,,
      "gameplay\journal\bestiary\bestiaryendriag.journal"
    )
  );      // small endrega
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent", 2,,
      "gameplay\journal\bestiary\endriagatruten.journal"
    )
  );      // bigger tailed endrega
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\endriaga_lvl3__spikey.w2ent", 1,,
      "gameplay\journal\bestiary\endriagaworker.journal"
    ),
  );      // big tailless endrega

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 5;

  return enemy_template_list;
}

function re_fogling() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl1.w2ent",,,
      "gameplay\journal\bestiary\fogling.journal"
    )
  );          // normal fogling
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl2.w2ent",,,
      "gameplay\journal\bestiary\fogling.journal"
    )
  );        // normal fogling
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\fogling_lvl3__willowisp.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal"
    )
  );  // green fogling

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\generic_quests\no_mans_land\quest_files\mh108_fogling\characters\mh108_ancient_fogling.w2ent",,,
      "gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_ghoul() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // normal ghoul   spawns from the ground
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl2.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );          // red ghoul   spawns from the ground
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\ghoul_lvl3.w2ent",,,
      "gameplay\journal\bestiary\bestiaryghoul.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 5;

  return enemy_template_list;
}

function re_alghoul() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // dark
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl2.w2ent", 3,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // dark reddish
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl3.w2ent", 2,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );        // greyish
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\alghoul_lvl4.w2ent", 1,,
      "gameplay\journal\bestiary\bestiaryalghoul.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\_quest__miscreant_greater.w2ent",,,
      "gameplay\journal\bestiary\bestiarymiscreant.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_nekker() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl1.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl2.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl3_customize.w2ent",,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\nekker_lvl3__warrior.w2ent", 2,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "quests\generic_quests\skellige\quest_files\mh202_nekker_warrior\characters\mh202_nekker_alpha.w2ent", 1,,
      "gameplay\journal\bestiary\nekker.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 4;
  enemy_template_list.difficulty_factor.maximum_count_easy = 5;
  enemy_template_list.difficulty_factor.minimum_count_medium = 4;
  enemy_template_list.difficulty_factor.maximum_count_medium = 6;
  enemy_template_list.difficulty_factor.minimum_count_hard = 5;
  enemy_template_list.difficulty_factor.maximum_count_hard = 7;

  return enemy_template_list;
}

function re_drowner() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl1.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // drowner
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl2.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // drowner
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl3.w2ent",,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );        // pink drowner
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\drowner_lvl4__dead.w2ent", 2,,
      "gameplay\journal\bestiary\drowner.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 5;

  return enemy_template_list;
}

function re_rotfiend() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\rotfiend_lvl1.w2ent",,,
      "gameplay\journal\bestiary\bestiarygreaterrotfiend.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\rotfiend_lvl2.w2ent", 1,,
      "gameplay\journal\bestiary\bestiarygreaterrotfiend.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_wolf() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );        // +4 lvls  grey/black wolf STEEL
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_lvl1__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // +4 lvls brown warg      STEEL

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_skelwolf() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_white_lvl2.w2ent",,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );    // lvl 51 white wolf    STEEL     
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wolf_white_lvl3__alpha.w2ent", 1,,
      "gameplay\journal\bestiary\wolf.journal"
    )
  );  // lvl 51 white wolf     STEEL  37

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_wraith() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl1.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl2.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl2_customize.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl3.w2ent",,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "characters\npc_entities\monsters\wraith_lvl4.w2ent", 2,,
      "gameplay\journal\bestiary\wraith.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_spider() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider.w2ent",,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\black_spider_large.w2ent",2,,
      "gameplay\journal\bestiary\bestiarycrabspider.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_boar() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\ep1\data\characters\npc_entities\monsters\wild_boar_ep1.w2ent",,,
      "dlc\bob\journal\bestiary\ep2boar.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_detlaff() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\dettlaff_vampire.w2ent", 1,,
      "dlc\bob\journal\bestiary\dettlaffmonster.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_skeleton() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon.w2ent",,,
      "dlc\bob\journal\bestiary\beanshie.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon_skeleton.w2ent",,,
      "dlc\bob\journal\bestiary\beanshie.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 3;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 4;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_barghest() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\barghest.w2ent",,,
      "dlc\bob\journal\bestiary\barghests.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 2;
  enemy_template_list.difficulty_factor.minimum_count_hard = 2;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_bruxa() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa.w2ent",,,
      "dlc\bob\journal\bestiary\bruxa.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_alp.w2ent",,,
      "dlc\bob\journal\bestiary\alp.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_echinops() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_hard.w2ent", 1,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_normal.w2ent",,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_normal_lw.w2ent",,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent", 1,,
      "dlc\bob\journal\bestiary\archespore.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 2;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_fleder() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\fleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\fleder.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\q704_protofleder.w2ent", 1,,
      "dlc\bob\journal\bestiary\protofleder.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_garkain() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\garkain.w2ent",,,
      "dlc\bob\journal\bestiary\garkain.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\garkain_mh.w2ent",,,
      "dlc\bob\journal\bestiary\q704alphagarkain.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_gravier() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\gravier.w2ent",,,
      "dlc\bob\journal\bestiary\parszywiec.journal"
    )
  ); // fancy drowner

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 3;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 4;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 6;

  return enemy_template_list;
}

function re_kikimore() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\kikimore.w2ent", 1,,
      "dlc\bob\journal\bestiary\kikimoraworker.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\kikimore_small.w2ent",,,
      "dlc\bob\journal\bestiary\kikimora.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 2;
  enemy_template_list.difficulty_factor.minimum_count_medium = 2;
  enemy_template_list.difficulty_factor.maximum_count_medium = 3;
  enemy_template_list.difficulty_factor.minimum_count_hard = 3;
  enemy_template_list.difficulty_factor.maximum_count_hard = 4;

  return enemy_template_list;
}

function re_panther() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_black.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_leopard.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\panther_mountain.w2ent",,,
      "dlc\bob\journal\bestiary\panther.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_giant() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\q701_dagonet_giant.w2ent",,,
      "dlc\bob\journal\bestiary\dagonet.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\q704_cloud_giant.w2ent",,,
      "dlc\bob\journal\bestiary\q704cloudgiant.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_centipede() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\scolopendromorph.w2ent",,,
      "dlc\bob\journal\bestiary\scolopedromorph.journal"
    )
  ); //worm
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\mq7023_albino_centipede.w2ent",,,
      "dlc\bob\journal\bestiary\scolopedromorph.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 2;
  enemy_template_list.difficulty_factor.minimum_count_hard = 2;
  enemy_template_list.difficulty_factor.maximum_count_hard = 3;

  return enemy_template_list;
}

function re_sharley() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );  // rock boss things
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_mh.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_q701.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\sharley_q701_normal_scale.w2ent",,,
      "dlc\bob\journal\bestiary\ep2sharley.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_wight() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\spooncollector.w2ent",1,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );  // spoon
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\wicht.w2ent",2,,
      "dlc\bob\journal\bestiary\wicht.journal"
    )
  );     // wight

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_bruxacity() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent",,,
      "dlc\bob\journal\bestiary\alp.journal"
    )
  );
  enemy_template_list.templates.PushBack(
    makeEnemyTemplate(
      "dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent",,,
      "dlc\bob\journal\bestiary\bruxa.journal"
    )
  );

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
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

  private function isNearNoticeboard(): bool {
    var entities: array<CGameplayEntity>;

     // 'W3NoticeBoard' for noticeboards, 'W3FastTravelEntity' for signpost
    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      50, // range, we'll have to check if 50 is too big/small
      1, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'W3NoticeBoard'
    );

    return entities.Size() > 0;
  }

  private function isPlayerNearSafeRoadsign(): bool {
    var entities: array<CGameplayEntity>;
    var i: int;

    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      50, // range, we'll have to check if 50 is too big/small
      1, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'W3FastTravelEntity'
    );

    for (i = 0; i < entities.Size(); i += 1) {
      if (this.isRoadsignSafe(entities[i])) {
        return true;
      }
    }

    return false;
  }

  private function isRoadsignSafe(roadsign: CGameplayEntity): bool {
    // TODO: maybe get the map pin corresponding to the roadsign
    // then check its `.type`
    // theGame.GetCommonMapManager().GetMappins()
    // with 
    // if (fastTravelEntity && fastTravelEntity.entityName == pin.Tag)

    // switch (roadsign.entityName) {
    //   case 'TODO':
    //     return true;
    //     break;
    // }

    return false;
  }

  private function isNearGuards(): bool {
    var entities: array<CGameplayEntity>;
    var i: int;

    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      50, // range, we'll have to check if 50 is too big/small
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

  public function isPlayerInSettlement(): bool {
    var current_area : EAreaName;
    var is_in_rer_cities: bool;

    current_area = theGame.GetCommonMapManager().GetCurrentArea();

    is_in_rer_cities = this
      .getCustomZone(thePlayer.GetWorldPosition()) == REZ_CITY;

    if (is_in_rer_cities) {
      return true;
    }

    // the .isInSettlement() method doesn't work when is skellige
    // it always returns true.
    if (current_area == AN_Skellige_ArdSkellig) {
      // HACK: it can be a great way to see if a settlement is nearby
      // by looking for a noticeboard. Though some settlements don't have
      // any noticeboard.
      // TODO: get the nearest signpost and read its tag then check
      // if it is a known settlement.
      return this.isNearNoticeboard()
          || this.isNearGuards();
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

  // TODO: create a better way to declare all this
  // I imagine a struct like this:
  //
  // struct CreatureSpawnFactor {
  //   var creature: CreatureType;
  //
  //   // if set only spawn in the region, and is affected
  //   // by the external coefficient if it is.
  //   var region: string; 
  //
  //   var only_forest: bool;
  //   var only_water: bool;
  //   var only_swamp: bool;
  //
  //   var like_forect: bool;
  //   var like_water: bool;
  //   var like_swamp: bool;
  //   
  //   var no_prolog: bool;
  // }
  // 
  // but filling such a struct for every creature
  // will result in longer but clearer code.
  public latent function getRandomCreatureByCurrentArea(out settings: RE_Settings, out spawn_roller: SpawnRoller, out resources: RE_Resources): CreatureType {
    var is_in_forest: bool;
    var is_near_water: bool;
    var is_in_swamp: bool;

    var i: int;
    var current_area: string;

    var manager : CWitcherJournalManager;
    var can_spawn_creature: bool;

    is_in_forest = this.IsPlayerInForest();
    is_near_water = this.IsPlayerNearWater();
    is_in_swamp = this.IsPlayerInSwamp();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    spawn_roller.reset();

    if (theGame.envMgr.IsNight()) {
      // first set all the counters to the settings value.
      for (i = 0; i < CreatureMAX; i += 1) {
        spawn_roller.setCreatureCounter(i, settings.creatures_chances_night[i]);
      }
    }
    else {
      for (i = 0; i < CreatureMAX; i += 1) {
        spawn_roller.setCreatureCounter(i, settings.creatures_chances_day[i]);
      }
    }

    // then handle special cases by hand

    if (current_area != "skellige") {
      spawn_roller.setCreatureCounter(CreatureSKELWOLF, 0);
      spawn_roller.setCreatureCounter(CreatureSKELBEAR, 0);
      spawn_roller.setCreatureCounter(CreatureSKELTROLL, 0);
    }
    else {
      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureSKELWOLF,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureSKELBEAR,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureSKELTROLL,
        settings
      );
    }

    // and now special cases depending on areas
    if (!is_near_water && !is_in_swamp) {
      // well, no water no drowners!
      spawn_roller.setCreatureCounter(CreatureDROWNER, 0);
      spawn_roller.setCreatureCounter(CreatureDROWNERDLC, 0);
    }

    if (!is_in_forest) {
      // no forest, no plants
      spawn_roller.setCreatureCounter(CreatureARACHAS, 0);
      spawn_roller.setCreatureCounter(CreatureENDREGA, 0);
      spawn_roller.setCreatureCounter(CreatureECHINOPS, 0);
      spawn_roller.setCreatureCounter(CreatureSPIDER, 0);

      spawn_roller.setCreatureCounter(CreatureLESHEN, 0);
    }
    else { // is_in_forest == true
      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureWEREWOLF,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureLESHEN,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureSPIDER,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureECHINOPS,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureENDREGA,
        settings
      );
      
      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureARACHAS,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureBEAR,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureWOLF,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureBOAR,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureSPIDER,
        settings
      );

      this.applyCoefficientToCreatureDivide(
        spawn_roller,
        CreatureCOCKATRICE,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureBASILISK,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureWYVERN,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureFORKTAIL,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureGRYPHON,
        settings
      );
    }

    if (is_near_water || is_in_swamp) {
      spawn_roller.setCreatureCounter(CreatureCENTIPEDE, 0);
      spawn_roller.setCreatureCounter(CreatureHARPY, 0);

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureHAG,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureFOGLET,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureDROWNER,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureDROWNERDLC,
        settings
      );
    }
    else {
      spawn_roller.setCreatureCounter(CreatureHAG, 0);
      spawn_roller.setCreatureCounter(CreatureFOGLET, 0);

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureHARPY,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureCENTIPEDE,
        settings
      );
    }

    if (is_in_swamp) {
      spawn_roller.setCreatureCounter(CreatureWEREWOLF, 0);
      spawn_roller.setCreatureCounter(CreatureELEMENTAL, 0);
      spawn_roller.setCreatureCounter(CreatureNOONWRAITH, 0);
      spawn_roller.setCreatureCounter(CreatureNIGHTWRAITH, 0);
    }
    else {
      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureWEREWOLF,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureELEMENTAL,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureNOONWRAITH,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureNIGHTWRAITH,
        settings
      );
    }

    if (!is_in_forest && !is_near_water && !is_in_swamp) {
      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureGRYPHON,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureCOCKATRICE,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureBASILISK,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureFORKTAIL,
        settings
      );

      this.applyCoefficientToCreature(
        spawn_roller,
        CreatureWYVERN,
        settings
      );
    }

    if (theGame.envMgr.IsNight()) {
      spawn_roller.setCreatureCounter(CreatureNOONWRAITH, 0);
    }
    else {
      spawn_roller.setCreatureCounter(CreatureNIGHTWRAITH, 0);
    }

    if (current_area == "prolog_village") {
      // we remove some creatures in the prolog area
      spawn_roller.setCreatureCounter(CreatureHARPY, 0);
      spawn_roller.setCreatureCounter(CreatureCENTIPEDE, 0);
      spawn_roller.setCreatureCounter(CreatureECHINOPS, 0);
      spawn_roller.setCreatureCounter(CreatureBARGHEST, 0);
      
      spawn_roller.setCreatureCounter(CreatureGIANT, 0);
      spawn_roller.setCreatureCounter(CreatureEKIMMARA, 0);
      spawn_roller.setCreatureCounter(CreatureKATAKAN, 0);
      spawn_roller.setCreatureCounter(CreatureGOLEM, 0);
      spawn_roller.setCreatureCounter(CreatureELEMENTAL, 0);
      spawn_roller.setCreatureCounter(CreatureCYCLOPS, 0);
      spawn_roller.setCreatureCounter(CreatureBRUXA, 0);
      spawn_roller.setCreatureCounter(CreatureFLEDER, 0);
      spawn_roller.setCreatureCounter(CreatureGARKAIN, 0);
      spawn_roller.setCreatureCounter(CreatureDETLAFF, 0);
      spawn_roller.setCreatureCounter(CreatureGIANT, 0);
      spawn_roller.setCreatureCounter(CreatureSHARLEY, 0);
    }

    // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/14
    // when a creature is set to NO in the city spawn menu, 
    // we remove it from the spawning pool.
    if (this.isPlayerInSettlement()) {
      LogChannel('modRandomEncounters', "player in settlement, removing city spawns");

      for (i = 0; i < CreatureMAX; i += 1) {
        if (!settings.creatures_city_spawns[i]) {
          spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    // when the option "Only known bestiary creatures" is ON
    // we remove every unknown creatures from the spawning pool
    if (settings.only_known_bestiary_creatures) {
      manager = theGame.GetJournalManager();

      for (i = 0; i < CreatureMAX; i += 1) {
        can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(resources.creatures_resources[i], manager);
        
        if (!can_spawn_creature) {
          spawn_roller.setCreatureCounter(i, 0);

          LogChannel('modRandomEncounters', "unknown bestiary creature, removed " + i + " from spawning pool");
        }
        else {
          LogChannel('modRandomEncounters', "known bestiary creature: " + i);
        }
      }
    }

    return spawn_roller.rollCreatures();
  }

  private function applyCoefficientToCreature(spawn_roller: SpawnRoller, creature: CreatureType, settings: RE_Settings) {
    if (theGame.envMgr.IsNight()) {
      spawn_roller.setCreatureCounter(
        creature,
        (int)(settings.creatures_chances_night[creature] * settings.external_factors_coefficient)
      );
    }
    else {
      spawn_roller.setCreatureCounter(
        creature,
        (int)(settings.creatures_chances_day[creature] * settings.external_factors_coefficient)
      );
    }
  }

  private function applyCoefficientToCreatureDivide(spawn_roller: SpawnRoller, creature: CreatureType, settings: RE_Settings) {
    if (theGame.envMgr.IsNight()) {
      spawn_roller.setCreatureCounter(
        creature,
        (int)(settings.creatures_chances_night[creature] / settings.external_factors_coefficient)
      );
    }
    else {
      spawn_roller.setCreatureCounter(
        creature,
        (int)(settings.creatures_chances_day[creature] / settings.external_factors_coefficient)
      );
    }
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

  public function IsPlayerInForest() : bool
  {
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
            return false;
          }
        }
      }
    }

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

latent function createRandomCreatureContract(master: CRandomEncounters, optional creature_type: CreatureType) {
  LogChannel('modRandomEncounters', "making create contract");

  if (creature_type == CreatureNONE) {
    creature_type = master.rExtra.getRandomCreatureByCurrentArea(
      master.settings,
      master.spawn_roller,
      master.resources
    );
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (creature_type == CreatureNONE) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }
  
  makeDefaultCreatureContract(master, creature_type);
}

latent function makeDefaultCreatureContract(master: CRandomEncounters, creature_type: CreatureType) {
  var composition: CreatureContractComposition;

  composition = new CreatureContractComposition in master;

  composition.init();
  composition.setCreatureType(creature_type)
    .spawn(master);
}

class CreatureContractComposition extends CompositionSpawner {
  public function init() {
    this
      .setRandomPositionMinRadius(190)
      .setRandomPositionMaxRadius(200);
  }

  protected latent function forEachEntity(entity: CEntity) {
    ((CNewNPC)entity).SetLevel(GetWitcherPlayer().GetLevel());
  }

  protected latent function afterSpawningEntities(): bool {
    var rer_contract_entity: RandomEncountersReworkedContractEntity;
    var i: int;

    rer_contract_entity = (RandomEncountersReworkedContractEntity)theGame.CreateEntity(
      (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\rer_monster_contract_entity.w2ent",
        true
      ),
      this.initial_position,
      thePlayer.GetWorldRotation()
    );

    if (!this.master.settings.enable_encounters_loot) {
      rer_contract_entity.removeAllLoot();
    }

    rer_contract_entity.start();

    return true;
  }
}

latent function createRandomCreatureHunt(master: CRandomEncounters, optional creature_type: CreatureType) {

  LogChannel('modRandomEncounters', "making create hunt");

  if (creature_type == CreatureNONE) {
    creature_type = master.rExtra.getRandomCreatureByCurrentArea(
      master.settings,
      master.spawn_roller,
      master.resources
    );
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (creature_type == CreatureNONE) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }

  if (creature_type == CreatureGRYPHON) {
    makeGryphonCreatureHunt(master);
  }
  else {
    makeDefaultCreatureHunt(master, creature_type);
  }
}


latent function makeGryphonCreatureHunt(master: CRandomEncounters) {
  var composition: CreatureHuntGryphonComposition;

  composition = new CreatureHuntGryphonComposition in master;

  composition.init(master.settings);
  composition.spawn(master);
}

class CreatureHuntGryphonComposition extends CompositionSpawner {
  public function init(settings: RE_Settings) {
    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance * 3)
      .setRandomPositionMaxRadius((settings.minimum_spawn_distance + settings.spawn_diameter) * 3)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance * 3)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_HUNT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene)
      .setCreatureType(CreatureGRYPHON)
      .setNumberOfCreatures(1);
  }

  var rer_entity_template: CEntityTemplate;
  var blood_splats_templates: array<CEntityTemplate>;

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

    current_rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
    
    if (!master.settings.enable_encounters_loot) {
      current_rer_entity.removeAllLoot();
    }

    current_rer_entity.startEncounter(this.blood_splats_templates);


    this.rer_entities.PushBack(current_rer_entity);
  }
}


latent function makeDefaultCreatureHunt(master: CRandomEncounters, creature_type: CreatureType) {
  var composition: CreatureHuntComposition;

  composition = new CreatureHuntComposition in master;

  composition.init(master.settings);
  composition.setCreatureType(creature_type)
    .spawn(master);
}

// CAUTION, it extends `CreatureAmbushWitcherComposition`
class CreatureHuntComposition extends CreatureAmbushWitcherComposition {
  public function init(settings: RE_Settings) {
    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance * 2)
      .setRandomPositionMaxRadius((settings.minimum_spawn_distance + settings.spawn_diameter) * 2)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance * 2)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_HUNT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene);
  }

  protected latent function afterSpawningEntities(): bool {
    var i: int;
    var current_rer_entity: RandomEncountersReworkedEntity;
    var bait: CEntity;

    bait = theGame.CreateEntity(
      (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
      this.initial_position,
      thePlayer.GetWorldRotation(),
      true,
      false,
      false,
      PM_DontPersist
    );

    for (i = 0; i < this.rer_entities.Size(); i += 1) {
      current_rer_entity = this.rer_entities[i];

      current_rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
      if (!master.settings.enable_encounters_loot) {
        current_rer_entity.removeAllLoot();
      }
      
      current_rer_entity.startWithBait(bait);
    }

    return true;
  }
}

enum CreatureComposition {
  CreatureComposition_AmbushWitcher = 1
}

latent function createRandomCreatureComposition(out master: CRandomEncounters, creature_type: CreatureType) {
  var creature_composition: CreatureComposition;

  creature_composition = CreatureComposition_AmbushWitcher;

  if (creature_type == CreatureNONE) {
    creature_type = master.rExtra.getRandomCreatureByCurrentArea(
      master.settings,
      master.spawn_roller,
      master.resources
    );
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (creature_type == CreatureNONE) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }

  LogChannel('modRandomEncounters', "spawning ambush - " + creature_type);

  if (creature_type == CreatureWILDHUNT) {
    makeCreatureWildHunt(master);
  }
  else {
    switch (creature_composition) {
      case CreatureComposition_AmbushWitcher:
        makeCreatureAmbushWitcher(creature_type, master);
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
  composition.setCreatureType(CreatureWILDHUNT)
    .spawn(master);
}

class WildHuntAmbushWitcherComposition extends CreatureAmbushWitcherComposition {
  var portal_template: CEntityTemplate;

  protected latent function forEachEntity(entity: CEntity) {
    super.forEachEntity(entity);

    ((CNewNPC)entity)
        .SetTemporaryAttitudeGroup('hostile_to_player', AGP_Default);
      
    ((CNewNPC)entity)
      .NoticeActor(thePlayer);
  }

  protected latent function afterSpawningEntities(): bool {
    var success: bool;
    var rift: CRiftEntity;
    var rifts: array<CRiftEntity>;
    var i: int;

    LogChannel('modRandomEncounters', "after spawning entities WILDHUNT");

    success = super.afterSpawningEntities();
    if (!success) {
      return false;
    }

    this.portal_template = master.resources.getPortalResource();
    for (i = 0; i < this.group_positions.Size(); i += 1) {
      rift = (CRiftEntity)theGame.CreateEntity(
        this.portal_template,
        this.group_positions[i],
        thePlayer.GetWorldRotation()
      );
      rift.ActivateRift();

      rifts.PushBack(rift);
    }

    return true;
  }
}


latent function makeCreatureAmbushWitcher(creature_type: CreatureType, out master: CRandomEncounters) {
  var composition: CreatureAmbushWitcherComposition;

  composition = new CreatureAmbushWitcherComposition in master;

  composition.init(master.settings);
  composition.setCreatureType(creature_type)
    .spawn(master);
}

class CreatureAmbushWitcherComposition extends CompositionSpawner {
  public function init(settings: RE_Settings) {
    LogChannel('modRandomEncounters', "CreatureAmbushWitcherComposition");

    this
      .setRandomPositionMinRadius(settings.minimum_spawn_distance)
      .setRandomPositionMaxRadius(settings.minimum_spawn_distance + settings.spawn_diameter)
      .setAutomaticKillThresholdDistance(settings.kill_threshold_distance)
      .setAllowTrophy(settings.trophies_enabled_by_encounter[EncounterType_DEFAULT])
      .setAllowTrophyPickupScene(settings.trophy_pickup_scene);
  }

  var rer_entity_template: CEntityTemplate;

  protected latent function beforeSpawningEntities(): bool {
    this.rer_entity_template =( CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_default_entity.w2ent",
      true
    );

    return true;
  }

  var rer_entities: array<RandomEncountersReworkedEntity>;

  protected latent function forEachEntity(entity: CEntity) {
    var current_rer_entity: RandomEncountersReworkedEntity;

    current_rer_entity = (RandomEncountersReworkedEntity)theGame.CreateEntity(
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

    this.rer_entities.PushBack(current_rer_entity);
  }

  protected latent function afterSpawningEntities(): bool {
    var i: int;
    var current_rer_entity: RandomEncountersReworkedEntity;

    for (i = 0; i < this.rer_entities.Size(); i += 1) {
      current_rer_entity = this.rer_entities[i];

      current_rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
      if (!master.settings.enable_encounters_loot) {
        current_rer_entity.removeAllLoot();
      }
      
      current_rer_entity.startWithoutBait();
    }

    return true;
  }
}

class RandomEncountersReworkedEntity extends CEntity {
  // an invisible entity used to bait the entity
  // do i really need a CEntity?
  // using ActionMoveTo i can force the creature to go
  // toward a vector.
  // Leaving the question here, but yes i tried for
  // a full week to make the functions ActionMoveTo work
  // but nothing worked as expected. So a bait is the best
  // thing. 
  var bait_entity: CEntity;

  // control whether the entity goes towards a bait
  // or the player
  var go_towards_bait: bool;
  default go_towards_bait = false;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  public var automatic_kill_threshold_distance: float;
  default automatic_kill_threshold_distance = 200;

  private var tracks_template: CEntityTemplate;
  private var tracks_entities: array<CEntity>;

  private var master: CRandomEncounters;

  public var pickup_animation_on_death: bool;
  default pickup_animation_on_death = false;

  event OnSpawned( spawnData : SEntitySpawnData ){
    super.OnSpawned(spawnData);

    LogChannel('modRandomEncounters', "RandomEncountersEntity spawned");
  }

  public function attach(actor: CActor, newnpc: CNewNPC, this_entity: CEntity, master: CRandomEncounters) {
    this.this_actor = actor;
    this.this_newnpc = newnpc;
    this.this_entity = this_entity;
    
    this.master = master;

    this.CreateAttachment( this_entity );
    this.AddTag('RandomEncountersReworked_Entity');
  }

  public function removeAllLoot() {
    var inventory: CInventoryComponent;

    inventory = this.this_actor.GetInventory();

    inventory.EnableLoot(false);
  }

  // entry point when creating an entity who will
  // follow a bait and leave tracks behind her.
  // more suited for: `EncounterType_HUNT`
  // NOTE: this functions calls `startWithoutBait`
  public latent function startWithBait(bait_entity: CEntity) {
    this.bait_entity = bait_entity;
    this.go_towards_bait = true;

    ((CNewNPC)this.bait_entity).SetGameplayVisibility(false);
    ((CNewNPC)this.bait_entity).SetVisibility(false);
    ((CActor)this.bait_entity).EnableCharacterCollisions(false);
    ((CActor)this.bait_entity).EnableDynamicCollisions(false);
    ((CActor)this.bait_entity).EnableStaticCollisions(false);
    ((CActor)this.bait_entity).SetImmortalityMode(AIM_Immortal, AIC_Default);

    this.tracks_template = getTracksTemplate(this.this_actor);  

    this.startWithoutBait();
  }

  // entry point when creating an entity who will
  // directly target the player.
  // more suited for: `EncounterType_DEFAULT`
  public function startWithoutBait() {
    LogChannel('modRandomEncounters', "starting - automatic death threshold = " + this.automatic_kill_threshold_distance);

    if (this.go_towards_bait) {
      AddTimer('intervalHuntFunction', 2, true);
      AddTimer('teleportBait', 10, true);
    }
    else {
      this.this_newnpc.NoticeActor(thePlayer);
      this.this_newnpc.SetAttitude(thePlayer, AIA_Hostile);

      AddTimer('intervalDefaultFunction', 2, true);

      this.this_actor
        .ActionMoveToNodeAsync(thePlayer);
    }
  }

  timer function intervalDefaultFunction(optional dt : float, optional id : Int32) {
    var distance_from_player: float;

    if (!this.this_actor.IsAlive()) {
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

    LogChannel('modRandomEncounters', "distance from player : " + distance_from_player);

    this.this_newnpc.NoticeActor(thePlayer);

    if (distance_from_player < 20) {
      // the creature is close enough to fight thePlayer,
      // we do not need this intervalFunction anymore.
      this.RemoveTimer('intervalDefaultFunction');

      // so it is also called almost instantly
      this.AddTimer('intervalLifecheckFunction', 0.1, false);
      this.AddTimer('intervalLifecheckFunction', 1, true);
    }
  }

  timer function intervalHuntFunction(optional dt : float, optional id : Int32) {
    var distance_from_player: float;
    var distance_from_bait: float;
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;

    if (!this.this_newnpc.IsAlive()) {
      this.clean();

      return;
    }

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    distance_from_bait = VecDistance(
      this.GetWorldPosition(),
      this.bait_entity.GetWorldPosition()
    );

    LogChannel('modRandomEncounters', "distance from player : " + distance_from_player);
    LogChannel('modRandomEncounters', "distance from bait : " + distance_from_bait);

    if (distance_from_player > this.automatic_kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
      this.clean();

      return;
    }

    if (distance_from_player < 20) {
      this.this_actor
        .ActionCancelAll();

      this.this_newnpc.NoticeActor(thePlayer);
      this.this_newnpc.SetAttitude(thePlayer, AIA_Hostile);

      // the creature is close enough to fight thePlayer,
      // we do not need this intervalFunction anymore.
      this.RemoveTimer('intervalHuntFunction');
      this.RemoveTimer('teleportBait');
      this.AddTimer('intervalLifecheckFunction', 1, true);

      // we also kill the bait
      this.bait_entity.Destroy();
    }
    else {
      // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/6:
      // when the bait_entity is no longer in the game, force the creatures
      // to target the player instead.
      if (this.bait_entity) {
        this.this_newnpc.NoticeActor((CActor)this.bait_entity);

        this.this_actor
        .ActionMoveToAsync(this.bait_entity.GetWorldPosition());

        if (distance_from_bait < 5) {
          new_bait_position = this.GetWorldPosition() + VecConeRand(this.GetHeading(), 90, 10, 20);
          new_bait_rotation = this.GetWorldRotation();
          
          this.bait_entity.TeleportWithRotation(
            new_bait_position,
            new_bait_rotation
          );
        }
      }
      else {
        // to avoid creatures who lost their bait (because it went too far)
        // aggroing the player. But instead they die too.
        if (distance_from_player > this.automatic_kill_threshold_distance * 0.8) {
          LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
          this.clean();

          return;
        }

        this.this_newnpc.NoticeActor(thePlayer);
      }

      this.createTracksOnGround();
    }  
  }

  private function createTracksOnGround() {
    var new_track: CEntity;
    var position: Vector;
    var rotation: EulerAngles;

    position = this.GetWorldPosition();
    rotation = this.GetWorldRotation();

    if (getGroundPosition(position)) {
      new_track = theGame.CreateEntity(
        this.tracks_template,
        position,
        rotation
      );

      this.tracks_entities.PushBack(new_track);

      if (this.tracks_entities.Size() > 200) {
        // TODO: clearly not great performance wise.
        // we could add an index variable going from 0 to 200
        // and once it has reached 200 goes back to 0 and we start
        // destroying the old track and replace it with the new one.
        // Or even better, only change the position of the old one.
        this.tracks_entities[0].Destroy();
        this.tracks_entities.Remove(this.tracks_entities[0]);
      }
    }
  }

  // simple interval function called every ten seconds or so to check if the creature is
  // still alive. Starts the cleaning process if not, and eventually triggers some events.
  timer function intervalLifecheckFunction(optional dt: float, optional id: Int32) {
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

  // a timer function called every few seconds o teleport the bait.
  // In case the bait is in a position the creature can't reach
  timer function teleportBait(optional dt : float, optional id : Int32) {
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;

    new_bait_position = this.GetWorldPosition() + VecConeRand(this.GetHeading(), 90, 10, 20);
    new_bait_rotation = this.GetWorldRotation();
    new_bait_rotation.Yaw += RandRange(-20,20);
    
    this.bait_entity.TeleportWithRotation(
      new_bait_position,
      new_bait_rotation
    );
  }

  private function clean() {
    var i: int;
    var distance_from_player: float;

    RemoveTimer('intervalDefaultFunction');
    RemoveTimer('intervalHuntFunction');
    RemoveTimer('teleportBait');
    RemoveTimer('intervalLifecheckFunction');

    LogChannel('modRandomEncounters', "RandomEncountersReworked_Entity destroyed");

    if (this.bait_entity) {
      this.bait_entity.Destroy();
    }

    for (i = 0; i < this.tracks_entities.Size(); i += 1) {
      this.tracks_entities[i].Destroy();
    }

    this.tracks_entities.Clear();

    this.this_actor.Kill('RandomEncountersReworked_Entity', true);

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    // 20 here because the cutscene picksup everything around geralt
    // so the distance doesn't have to be too high.
    if (this.pickup_animation_on_death && distance_from_player < 20) {
      this.master.requestOutOfCombatAction(OutOfCombatRequest_TROPHY_CUTSCENE);
    }
    
    this.Destroy();
  }
}

// This "Entity" is different from the others (gryphon/default) because
// It is not the entity itself but more of a manager who controls multiple
// entities.
statemachine class RandomEncountersReworkedContractEntity extends CEntity {
  var bait_entity: CEntity;
  
  // an array containing entities for the tracks when
  //  using the functions to add a  track on the ground
  // it adds one to the array, unless we reached the maximum
  // number of tracks. At this moment we come back to 0 and
  // start using the _tracks_index and set _tracks_looped  
  // to true to tell we have already reached the maximum once.
  // And now instead of creating a new track Entity we simply
  // move the old one at _tracks_index.
  var tracks_entities: array<CEntity>;
  var tracks_index: int;
  var tracks_looped: bool;
  default tracks_looped = false;
  var tracks_maximum: int;
  default tracks_maximum = 200;

  public var track_resource: CEntityTemplate;

  var monster_group_position: Vector;

  var entities: array<CEntity>;

  event OnSpawned( spawnData : SEntitySpawnData ){
    super.OnSpawned(spawnData);

    LogChannel(
      'modRandomEncounters',
      "RandomEncountersReworkedContractEntity spawned"
    );
  }

  public function attach(entities: array<CEntity>) {
    this.entities = entities;

    this.AddTag('RandomEncountersReworked_Entity');
  }

  public function removeAllLoot() {
    var inventory: CInventoryComponent;
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      inventory = ((CActor)this.entities[i]).GetInventory();

      inventory.EnableLoot(false);
    }
  }

  public latent function start() {
    this.AddTimer('intervalLifeCheck', 10.0, true);
  }

  private function areAllEntitiesDead(): bool {
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).IsAlive()) {
        return false;
      }
    }

    return true;
  }

  timer function intervalLifeCheck(optional dt : float, optional id : Int32) {
    if (this.areAllEntitiesDead()) {
      this.clean();
    }
  }

    public function addTrackHere(position: Vector, heading: EulerAngles) {
    var new_entity: CEntity;

    if (!this.tracks_looped) {
      new_entity = theGame.CreateEntity(
        this.track_resource,
        position,
        heading,
        true,
        false,
        false,
        PM_DontPersist
      );

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

  private function clean() {
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

    this.Destroy();
  }
}

state StartContract in RandomEncountersReworkedContractEntity {
  private var current_tracks_position: Vector;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State StartContract");

    this.StartContract_Main();
  }

  entry function StartContract_Main() {
    parent.AddTimer('StartContract_intervalDrawTracks', 0.25, true);
  }

  timer function StartContract_intervalDrawTracks(optional dt : float, optional id: Int32) {
    FixZAxis(this.current_tracks_position);

    parent.addTrackHere(
      current_tracks_position,
      VecToRotation(
        this.current_tracks_position - parent.monster_group_position
      )
    );

    if (VecDistanceSquared(this.current_tracks_position, parent.monster_group_position) < 5 * 5) {
      parent.RemoveTimer('StartContract_intervalDrawTracks');
    }

    // this.usePathFinding(this.current_tracks_position, parent.monster_group_position);
  }

  latent function usePathFinding(out current_position: Vector, target_position: Vector) : bool {
    var path : array<Vector>;	

    if(theGame
      .GetVolumePathManager()
      .IsPathfindingNeeded(current_position, target_position)) {

      path.Clear();
      
      if (theGame
         .GetVolumePathManager()
         .GetPath(current_position, target_position, path)) {

        current_position = path[1];

        return true;
      }

      return false;
    }

    return true;
  }

  event OnLeaveState(nextStateName : name) {
    parent.RemoveTimer('StartContract_intervalDrawTracks');

    super.OnLeaveState(nextStateName);
  }
}
// In this state the monsters aren't doing much.
state WaitingForPlayer in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State WaitingForPlayer");

    this.WaitingForPlayer_Main();
  }

  entry function WaitingForPlayer_Main() {
    parent.AddTimer('WaitingForPlayer_intervalMain', 1.0, true);
  }

  timer function WaitingForPlayer_intervalMain(optional dt : float, optional id: Int32) {
    var distance_from_player: float;

    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.monster_group_position
    );

    if (distance_from_player < 400) {
      parent.GotoState('FightingPlayer');

      return;
    }
  }

  event OnLeaveState(nextStateName : name) {
    parent.RemoveTimer('WaitingForPlayer_intervalMain');

    super.OnLeaveState(nextStateName);
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


  public var blood_resources: array<CEntityTemplate>;
  public var blood_resources_size: int;

  public var pickup_animation_on_death: bool;
  default pickup_animation_on_death = false;

  // an array containing entities for the blood tracks when
  //  using the functions to add a blood track on the ground
  // it adds one to the array, unless we reached the maximum
  // number of tracks. At this moment we come back to 0 and
  // start using the blood_tracks_index and set blood_tracks_looped  
  // to true to tell we have already reached the maximum once.
  // And now instead of creating a new track Entity we simply
  // move the old one at blood_tracks_index.
  var blood_tracks_entities: array<CEntity>;
  var blood_tracks_index: int;
  var blood_tracks_looped: bool;
  default blood_tracks_looped = false;
  var blood_tracks_maximum: int;
  default blood_tracks_maximum = 200;

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
  public function startEncounter(blood_resources: array<CEntityTemplate>) {
    LogChannel('modRandomEncounters', "RandomEncountersReworkedGryphonHuntEntity encounter started");

    this.blood_resources = blood_resources;
    this.blood_resources_size = blood_resources.Size();

    this.AddTimer('intervalLifecheckFunction', 1, true);
    
    if (RandRange(10) >= 5) {
      this.GotoState('WaitingForPlayer');
    }
    else {
      this.GotoState('FlyingAbovePlayer');
    }
  }

  public function getRandomBloodResource(): CEntityTemplate {
    return this.blood_resources[RandRange(this.blood_resources_size)];
  }

  public function addBloodTrackHere(position: Vector) {
    var new_entity: CEntity;

    if (!this.blood_tracks_looped) {
      new_entity = theGame.CreateEntity(
        this.getRandomBloodResource(),
        position,
        RotRand(0, 360),
        true,
        false,
        false,
        PM_DontPersist
      );

      // new_entity.UpdateInteraction("InteractiveClue");


      this.blood_tracks_entities.PushBack(new_entity);

      if (this.blood_tracks_entities.Size() == this.blood_tracks_maximum) {
        this.blood_tracks_looped = true;
      }

      return;
    }

    this.blood_tracks_entities[this.blood_tracks_index].TeleportWithRotation(position, RotRand(0, 360));

    this.blood_tracks_index = (this.blood_tracks_index + 1) % this.blood_tracks_maximum;
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

    for (i = 0; i < this.blood_tracks_entities.Size(); i += 1) {
      this.blood_tracks_entities[i].Destroy();
    }

    this.horse_corpse_near_geralt.Destroy();
    this.horse_corpse_near_gryphon.Destroy();

    this.blood_tracks_entities.Clear();

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
    parent.addBloodTrackHere(position);
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


    parent.addBloodTrackHere(this.bloodtrail_current_position);

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

function getGroundPosition(out input_position: Vector, optional personal_space: float, optional max_height_check: float): bool {
  var output_position: Vector;
  var point_z: float;
  var collision_normal: Vector;
  var result: bool;

  output_position = input_position;

  personal_space = MaxF(personal_space, 1.0);

  max_height_check = MaxF(max_height_check, 30.0);

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

latent function getTracksTemplate(actor : CActor): CEntityTemplate {
  var monsterCategory : EMonsterCategory;
  var soundMonsterName : CName;
  var isTeleporting : bool;
  var canBeTargeted : bool;
  var canBeHitByFists : bool;
  var entity_template: CEntityTemplate;

  theGame.GetMonsterParamsForActor(
    actor,
    monsterCategory,
    soundMonsterName,
    isTeleporting,
    canBeTargeted,canBeTargeted
  );

  switch(monsterCategory) {
    case MC_Specter :
    case MC_Magicals :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\generic_quests\skellige\quest_files\mh207_wraith\entities\mh207_area_fog.w2ent",
        true
      );

      return entity_template;
      break;
        
      break;
        
    case MC_Vampire :
    case MC_Human :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\minor_quests\no_mans_land\quest_files\mq1051_monster_hunt_nilfgaard1\entities\mq1051_mc_scout_footprint.w2ent",
        true
      );

      return entity_template;
      break;
        
    case MC_Insectoid :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\generic_quests\no_mans_land\quest_files\mh102_arachas\entities\mh102_arachas_tracks.w2ent",
        true
      );
    case MC_Cursed :
    case MC_Troll :
    case MC_Animal :
    case MC_Necrophage :
    case MC_Hybrid :
    case MC_Relic :
    case MC_Beast :
    case MC_Draconide :
    default :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\generic_quests\skellige\quest_files\mh202_nekker_warrior\entities\mh202_nekker_tracks.w2ent",
        true
      );

      return entity_template;
  }
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

state Spawning in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    parent.RemoveTimer('randomEncounterTick');

    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state SPAWNING");

    triggerCreaturesSpawn();
  }

  entry function triggerCreaturesSpawn() {
    var picked_encounter_type: EncounterType;

    LogChannel('modRandomEncounters', "creatures spawning triggered");

    picked_encounter_type = this.getRandomEncounterType();
    
    if (this.shouldAbortCreatureSpawn()) {
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

  function shouldAbortCreatureSpawn(): bool {
    var current_state: CName;
    var is_meditating: bool;
    var current_zone: EREZone;


    current_state = thePlayer.GetCurrentStateName();
    is_meditating = current_state == 'Meditation' && current_state == 'MeditationWaiting';
    current_zone = parent.rExtra.getCustomZone(thePlayer.GetWorldPosition());

    return is_meditating 
        || current_zone == REZ_NOSPAWN
        || thePlayer.IsInInterior()
        || thePlayer.IsInCombat()
        || thePlayer.IsUsingBoat()
        || thePlayer.IsInFistFightMiniGame()
        || thePlayer.IsSwimming()
        || thePlayer.IsInNonGameplayCutscene()
        || thePlayer.IsInGameplayScene()
        || theGame.IsDialogOrCutscenePlaying()
        || theGame.IsCurrentlyPlayingNonGameplayScene()
        || theGame.IsFading()
        || theGame.IsBlackscreen()

        || parent.rExtra.isPlayerInSettlement()
        && !parent.settings.doesAllowCitySpawns();
  }

  function getRandomEncounterType(): EncounterType {
    var max_roll: int;
    var roll: int;

    max_roll = parent.settings.all_monster_hunt_chance
            //  + parent.settings.all_monster_contract_chance
             + parent.settings.all_monster_ambush_chance;

    roll = RandRange(max_roll);
    if (roll < parent.settings.all_monster_hunt_chance) {
      return EncounterType_HUNT;
    }

    // roll -= parent.settings.all_monster_hunt_chance;
    // if (roll < parent.settings.all_monster_contract_chance) {
    //   return EncounterType_CONTRACT;
    // }

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
