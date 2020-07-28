
class RandomEncountersReworkedEntity extends CEntity {
  // an invisible entity used to bait the entity
  var bait_entity: CEntity;

  // control whether the entity goes towards a bait
  // or the player
  var go_towards_bait: bool;
  default go_towards_bait = false;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  private var tracks_template: CEntityTemplate;
  private var tracks_entities: array<CEntity>;

  event OnSpawned( spawnData : SEntitySpawnData ){
		super.OnSpawned(spawnData);

    LogChannel('modRandomEncounters', "RandomEncountersEntity spawned");
	}

  public function attach(actor: CActor, newnpc: CNewNPC, this_entity: CEntity) {
    this.this_actor = actor;
    this.this_newnpc = newnpc;
    this.this_entity = this_entity;

		this.CreateAttachment( this_entity );
    this.AddTag('RandomEncountersReworked_Entity');
  }

  // entry point when creating an entity who will
  // follow a bait and leave tracks behind her.
  // more suited for: `EncounterType_HUNT`
  // NOTE: this functions calls `startWithoutBait`
  public function startWithBait(bait_entity: CEntity) {
    this.bait_entity = bait_entity;
    this.go_towards_bait = true;

    ((CNewNPC)this.bait_entity).SetGameplayVisibility(false);
    ((CNewNPC)this.bait_entity).SetVisibility(false);		
    ((CActor)this.bait_entity).EnableCharacterCollisions(false);
    ((CActor)this.bait_entity).EnableDynamicCollisions(false);
    ((CActor)this.bait_entity).EnableStaticCollisions(false);
    ((CActor)this.bait_entity).SetImmortalityMode(AIM_Immortal, AIC_Default);  

    this.startWithoutBait();
  }

  // entry point when creating an entity who will
  // directly target the player.
  // more suited for: `EncounterType_DEFAULT`
  public function startWithoutBait() {
    // TODO: create a function getTracksTemplateByCreatureType
    this.tracks_template = (CEntityTemplate)LoadResource(
      "quests\generic_quests\skellige\quest_files\mh202_nekker_warrior\entities\mh202_nekker_tracks.w2ent",
      true
    );

    if (this.go_towards_bait) {
      AddTimer('intervalHuntFunction', 2, true);
    }
    else {
      AddTimer('intervalDefaultFunction', 2, true);
      AddTimer('teleportBait', 10, true);
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

    if (distance_from_player > 100) {
      this.clean();

      return;
    }

    LogChannel('modRandomEncounters', "distance from player : " + distance_from_player);

    this.this_newnpc.NoticeActor(thePlayer);

    if (distance_from_player < 30) {
      // the creature is close enough to fight thePlayer,
      // we do not need this intervalFunction anymore.
      this.RemoveTimer('intervalDefaultFunction');

      this.AddTimer('intervalLifecheckFunction', 10, true);
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

    if (distance_from_player > 200) {
      this.clean();

      return;
    }

    if (distance_from_player < 20) {
      this.this_newnpc.NoticeActor(thePlayer);

      // the creature is close enough to fight thePlayer,
      // we do not need this intervalFunction anymore.
      this.RemoveTimer('intervalHuntFunction');
      this.RemoveTimer('teleportBait');
      this.AddTimer('intervalLifecheckFunction', 10, true);

      // we also kill the bait
      this.bait_entity.Destroy();

      this.this_actor
        .GetMovingAgentComponent()
        .SetGameplayRelativeMoveSpeed(-1);
    }
    else {
      this.this_actor
        .GetMovingAgentComponent()
        .SetGameplayRelativeMoveSpeed(1);

      this.this_newnpc.NoticeActor((CActor)this.bait_entity);

      if (distance_from_bait < 5) {
        new_bait_position = this.GetWorldPosition() + VecConeRand(this.GetHeading(), 90, 10, 20);
        new_bait_rotation = this.GetWorldRotation();
        new_bait_rotation.Yaw += RandRange(-20,20);
        
        this.bait_entity.TeleportWithRotation(
          new_bait_position,
          new_bait_rotation
        );
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

  // simple interval function call every ten seconds or so to check if the creature is
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

    if (distance_from_player > 200) {
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

    RemoveTimer('intervalDefaultFunction');
    RemoveTimer('intervalHuntFunction');
    RemoveTimer('teleportBait');

    LogChannel('modRandomEncounters', "RandomEncountersReworked_Entity destroyed");

    if (this.bait_entity) {
      this.bait_entity.Destroy();
    }

    for (i = 0; i < this.tracks_entities.Size(); i += 1) {
      this.tracks_entities[i].Destroy();
    }

    this.tracks_entities.Clear();

    this.this_actor.Kill('RandomEncountersReworked_Entity', true);
    this.Destroy();
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
  SMALL_CREATURE,
  LARGE_CREATURE
}

enum SmallCreatureType {
  SmallCreatureHuman        = 0,
  SmallCreatureARACHAS      = 1,
  SmallCreatureENDREGA      = 2,
  SmallCreatureGHOUL        = 3,
  SmallCreatureALGHOUL      = 4,
  SmallCreatureNEKKER       = 5,
  SmallCreatureDROWNER      = 6,
  SmallCreatureROTFIEND     = 7,
  SmallCreatureWOLF         = 8,
  SmallCreatureWRAITH       = 9,
  SmallCreatureHARPY        = 10,
  SmallCreatureSPIDER       = 11,
  SmallCreatureCENTIPEDE    = 12,
  SmallCreatureDROWNERDLC   = 13,  
  SmallCreatureBOAR         = 14,  
  SmallCreatureBEAR         = 15,
  SmallCreaturePANTHER      = 16,  
  SmallCreatureSKELETON     = 17,
  SmallCreatureECHINOPS     = 18,
  SmallCreatureKIKIMORE     = 19,
  SmallCreatureBARGHEST     = 20,
  SmallCreatureSKELWOLF     = 21,
  SmallCreatureSKELBEAR     = 22,
  SmallCreatureWILDHUNT     = 23,

  // It is important to keep the numbers continuous.
  // The `SpawnRoller` classes uses these numbers to
  // to fill its arrays.
  // (so that i dont have to write 40 lines by hand)
  SmallCreatureMAX          = 24,
  SmallCreatureNONE         = 25,
}

enum LargeCreatureType {
  LargeCreatureLESHEN       = 0,
  LargeCreatureWEREWOLF     = 1,
  LargeCreatureFIEND        = 2,
  LargeCreatureEKIMMARA     = 3,
  LargeCreatureKATAKAN      = 4,
  LargeCreatureGOLEM        = 5,
  LargeCreatureELEMENTAL    = 6,
  LargeCreatureNIGHTWRAITH  = 7,
  LargeCreatureNOONWRAITH   = 8,
  LargeCreatureCHORT        = 9,
  LargeCreatureCYCLOPS      = 10,
  LargeCreatureTROLL        = 11,
  LargeCreatureHAG          = 12,
  LargeCreatureFOGLET       = 13,
  LargeCreatureBRUXA        = 14,
  LargeCreatureFLEDER       = 15,
  LargeCreatureGARKAIN      = 16,
  LargeCreatureDETLAFF      = 17,
  LargeCreatureGIANT        = 18,  
  LargeCreatureSHARLEY      = 19,
  LargeCreatureWIGHT        = 20,
  LargeCreatureVAMPIRE      = 21,
  LargeCreatureGRYPHON      = 22,
  LargeCreatureCOCKATRICE   = 23,
  LargeCreatureBASILISK     = 24,
  LargeCreatureWYVERN       = 25,
  LargeCreatureFORKTAIL     = 26,
  LargeCreatureSKELTROLL    = 27,


  // It is important to keep the numbers continuous.
  // The `SpawnRoller` classes uses these numbers to
  // to fill its arrays.
  // (so that i dont have to write 40 lines by hand)
  LargeCreatureMAX          = 28,
  LargeCreatureNONE         = 29
}

enum EncounterType {
  EncounterType_DEFAULT = 0,
  EncounterType_HUNT    = 1
}

// Sometimes solo creatures can be accompanied by smaller creatures,
// this is what i call a group composition. Imagine a leshen and a few wolves
// or a giant fighting humans.

latent function makeGroupComposition(encounter_type: EncounterType, creature_type: CreatureType, random_encounters_class: CRandomEncounters) {
  if (encounter_type == EncounterType_HUNT) {
    switch (creature_type) {
      case SMALL_CREATURE:
        LogChannel('modRandomEncounters', "spawning type SMALL_CREATURE - HUNT");
        createRandomSmallCreatureHunt(random_encounters_class);
        break;

      case LARGE_CREATURE:
        LogChannel('modRandomEncounters', "spawning type LARGE_CREATURE - HUNT");
        createRandomLargeCreatureHunt(random_encounters_class);
        break;
    }

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "MiscFreshTracks" );
    }
  }
  else {
    switch (creature_type) {
      case SMALL_CREATURE:
        LogChannel('modRandomEncounters', "spawning type SMALL_CREATURE");
        createRandomSmallCreatureComposition(random_encounters_class);
        break;

      case LARGE_CREATURE:
        LogChannel('modRandomEncounters', "spawning type LARGE_CREATURE");
        createRandomLargeCreatureComposition(random_encounters_class);
        break;
    }

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "BattleCryBadSituation" );
    }
  }
}

class CRandomEncounterInitializer extends CEntityMod {
  default modName = 'Random Encounters Reworked';
  default modAuthor = "erxv";
  default modUrl = "http://www.nexusmods.com/witcher3/mods/785?";
  default modVersion = '1.31';

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
  
    this.GotoState('Spawning');
  }

  private function initiateRandomEncounters() {
    this.settings.loadXMLSettings();
    this.resources.load_resources();

    AddTimer('onceReady', 3.0, false);
    this.GotoState('Waiting');
  }

  timer function onceReady(optional delta: float, optional id: Int32) {
    displayRandomEncounterEnabledNotification();
  }
}

function displayRandomEncounterEnabledNotification() {
  theGame
  .GetGuiManager()
  .ShowNotification(
    GetLocStringByKey("option_rer_enabled")
  );
}

class RE_Resources {
  public var novbandit, pirate, skelpirate, bandit, nilf, cannibal, renegade, skelbandit, skel2bandit, whunter: EnemyTemplateList;
  public var gryphon, gryphonf, forktail, wyvern, cockatrice, cockatricef, basilisk, basiliskf, wight, sharley  : EnemyTemplateList;
  public var fiend, chort, wildHunt, endrega, fogling, ghoul, alghoul, bear, skelbear, golem, elemental, hag, nekker : EnemyTemplateList;
  public var ekimmara, katakan, whh, drowner, rotfiend, nightwraith, noonwraith, troll, skeltroll, wolf, skelwolf, wraith : EnemyTemplateList;
  public var spider, harpy, leshen, werewolf, cyclop, arachas, vampire, skelelemental, bruxacity : EnemyTemplateList;
  public var centipede, giant, panther, kikimore, gravier, garkain, fleder, echinops, bruxa, barghest, skeleton, detlaff, boar : EnemyTemplateList;

  public var blood_splats : array<string>;

  public var small_creatures_resources: array<EnemyTemplateList>;
  public var large_creatures_resources: array<EnemyTemplateList>;
  public var humans_resources: array<EnemyTemplateList>;


  function load_resources() {
    var i: int;
    var empty_enemy_template_list: EnemyTemplateList;

    if (this.small_creatures_resources.Size() == 0) {
      for (i = 0; i < SmallCreatureMAX; i += 1) {
        this.small_creatures_resources.PushBack(empty_enemy_template_list);
      }
    }

    if (this.large_creatures_resources.Size() == 0) {
      for (i = 0; i < LargeCreatureMAX; i += 1) {
        this.large_creatures_resources.PushBack(empty_enemy_template_list);
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

  public function getCreatureResourceBySmallCreatureType(creature_type: SmallCreatureType, out rExtra: CModRExtra): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get creature resource by small creature type: " + creature_type);

    if (creature_type == SmallCreatureHuman) {
      return this.getHumanResourcesByHumanType(
        rExtra.getRandomHumanTypeByCurrentArea()
      );
    }

    return this.small_creatures_resources[creature_type];
  }

  public function getCreatureResourceByLargeCreatureType(creature_type: LargeCreatureType): EnemyTemplateList {
    LogChannel('modRandomEncounters', "get creature resource by large creature type: " + creature_type);

    return this.large_creatures_resources[creature_type];
  }

  private function load_blood_splats() {
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_big.w2ent");  
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium.w2ent");    
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium_2.w2ent");  
    blood_splats.PushBack("living_world\treasure_hunting\th1003_lynx\entities\generic_clue_blood_splat.w2ent");
  }

  private function loadBloodAndWineResources() {
    this.large_creatures_resources[LargeCreatureWIGHT] = re_wight();
    this.large_creatures_resources[LargeCreatureSHARLEY] = re_sharley();
    this.small_creatures_resources[SmallCreatureCENTIPEDE] = re_centipede();
    this.large_creatures_resources[LargeCreatureGIANT] = re_giant();
    this.small_creatures_resources[SmallCreaturePANTHER] = re_panther();
    this.small_creatures_resources[SmallCreatureKIKIMORE] = re_kikimore();
    this.small_creatures_resources[SmallCreatureDROWNERDLC] = re_gravier();
    this.large_creatures_resources[LargeCreatureGARKAIN] = re_garkain();
    this.large_creatures_resources[LargeCreatureFLEDER] = re_fleder();
    this.small_creatures_resources[SmallCreatureECHINOPS] = re_echinops();
    this.large_creatures_resources[LargeCreatureBRUXA] = re_bruxa();
    this.small_creatures_resources[SmallCreatureBARGHEST] = re_barghest();
    this.small_creatures_resources[SmallCreatureSKELETON] = re_skeleton();
    this.large_creatures_resources[LargeCreatureDETLAFF] = re_detlaff();
  }

  private function loadHearOfStoneResources() {
    this.small_creatures_resources[SmallCreatureSPIDER] = re_spider();
    this.small_creatures_resources[SmallCreatureBOAR] = re_boar();
  }

  private function load_default_entities() {
    this.large_creatures_resources[LargeCreatureGRYPHON] = re_gryphon();
    this.large_creatures_resources[LargeCreatureFORKTAIL] = re_forktail();
    this.large_creatures_resources[LargeCreatureWYVERN] = re_wyvern();
    this.large_creatures_resources[LargeCreatureCOCKATRICE] = re_cockatrice();
    //cockatricef = re_cockatricef();
    this.large_creatures_resources[LargeCreatureBASILISK] = re_basilisk();
    //basiliskf = re_basiliskf();
    this.small_creatures_resources[LargeCreatureFIEND] = re_fiend();
    this.large_creatures_resources[LargeCreatureCHORT] = re_chort();
    this.small_creatures_resources[SmallCreatureENDREGA] = re_endrega();
    this.large_creatures_resources[LargeCreatureFOGLET] = re_fogling();
    this.small_creatures_resources[SmallCreatureGHOUL] = re_ghoul();
    this.small_creatures_resources[SmallCreatureALGHOUL] = re_alghoul();
    this.small_creatures_resources[SmallCreatureBEAR] = re_bear();
    
    
    this.large_creatures_resources[LargeCreatureGOLEM] = re_golem();
    this.large_creatures_resources[LargeCreatureELEMENTAL] = re_elemental();
    this.large_creatures_resources[LargeCreatureHAG] = re_hag();
    this.small_creatures_resources[SmallCreatureNEKKER] = re_nekker();
    this.large_creatures_resources[LargeCreatureEKIMMARA] = re_ekimmara();
    this.large_creatures_resources[LargeCreatureKATAKAN] = re_katakan();
    
    
    this.small_creatures_resources[SmallCreatureDROWNER] = re_drowner();
    this.small_creatures_resources[SmallCreatureROTFIEND] = re_rotfiend();
    this.large_creatures_resources[LargeCreatureNIGHTWRAITH] = re_nightwraith();
    this.large_creatures_resources[LargeCreatureNOONWRAITH] = re_noonwraith();
    this.large_creatures_resources[LargeCreatureTROLL] = re_troll();
    
    this.small_creatures_resources[SmallCreatureWOLF] = re_wolf();
    
    this.small_creatures_resources[SmallCreatureWRAITH] = re_wraith();    
    this.small_creatures_resources[SmallCreatureHARPY] = re_harpy();
    this.large_creatures_resources[LargeCreatureLESHEN] = re_leshen();
    this.large_creatures_resources[LargeCreatureWEREWOLF] = re_werewolf();
    this.large_creatures_resources[LargeCreatureCYCLOPS] = re_cyclop();
    this.small_creatures_resources[SmallCreatureARACHAS] = re_arachas();
    this.large_creatures_resources[LargeCreatureBRUXA] = re_bruxacity();

    this.large_creatures_resources[LargeCreatureSKELTROLL] = re_skeltroll();
    this.small_creatures_resources[SmallCreatureSKELBEAR] = re_skelbear();
    this.small_creatures_resources[SmallCreatureSKELWOLF] = re_skelwolf();

    // whh = re_whh();
    this.small_creatures_resources[SmallCreatureWILDHUNT] = re_wildhunt();

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
}

function isHeartOfStoneActive(): bool {
  return theGame.GetDLCManager().IsEP1Available() && theGame.GetDLCManager().IsEP1Enabled();
}

function isBloodAndWineActive(): bool {
  return theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled();
}

class RE_Settings {

	
	public var customDayMax, customDayMin, customNightMax, customNightMin	: int;
	public var all_monster_hunt_chance: int;
	public var enableTrophies : bool;
  public var cityBruxa, citySpawn : int;
  public var selectedDifficulty	: int;

  // uses the enum `SmallCreature` and its values for the index/key.
  // and the `int` for the value/chance.
  public var small_creatures_chances_day: array<int>;
  public var small_creatures_chances_night: array<int>;

  // uses the enum `LargeCreature` and its values for the index/key.
  // and the `int` for the value/chance.
  public var large_creatures_chances_day: array<int>;
  public var large_creatures_chances_night: array<int>;

  // used when picking the EncounterType Large/Small
  public var large_creature_chance: int;

  // controls whether or not geralt will comment
  // when an encounter appears
  public var geralt_comments_enabled: bool;

  function loadXMLSettings() {
    var inGameConfigWrapper : CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();


    this.loadMonsterHuntsChances(inGameConfigWrapper);
    this.loadLargeCreatureChance(inGameConfigWrapper);
    this.loadCustomFrequencies(inGameConfigWrapper);

    this.loadTrophiesSettings(inGameConfigWrapper);
    this.loadDifficultySettings(inGameConfigWrapper);
    this.loadCitySpawnSettings(inGameConfigWrapper);

    this.fillSettingsArrays();
		this.loadCreaturesSpawningChances(inGameConfigWrapper);
    this.loadGeraltCommentsSettings(inGameConfigWrapper);
  }

  function loadXMLSettingsAndShowNotification() {
    this.loadXMLSettings();

    theGame
    .GetGuiManager()
    .ShowNotification("Random Encounters XML settings loaded");
  }

  private function loadCitySpawnSettings(inGameConfigWrapper: CInGameConfigWrapper) {
		citySpawn = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'citySpawn'));
		cityBruxa = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'cityBruxa'));
  }

  private function loadDifficultySettings(inGameConfigWrapper: CInGameConfigWrapper) {
    selectedDifficulty = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'Difficulty'));
  }

  private function loadGeraltCommentsSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.geralt_comments_enabled = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'geraltComments');
  }

  private function loadTrophiesSettings(inGameConfigWrapper: CInGameConfigWrapper) {
		enableTrophies = inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'enableTrophies');
  }

  private function loadCustomFrequencies(inGameConfigWrapper: CInGameConfigWrapper) {
    customDayMax = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customdFrequencyHigh'));
		customDayMin = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customdFrequencyLow'));
		customNightMax = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customnFrequencyHigh'));
		customNightMin = StringToInt(inGameConfigWrapper.GetVarValue('custom', 'customnFrequencyLow'));	
  }

  private function loadMonsterHuntsChances(inGameConfigWrapper: CInGameConfigWrapper) {
    this.all_monster_hunt_chance = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'allMonsterHuntChance'));
  }

  private function loadLargeCreatureChance(inGameConfigWrapper: CInGameConfigWrapper) {
    this.large_creature_chance = StringToInt(inGameConfigWrapper.GetVarValue('RandomEncountersMENU', 'largeCreatureChance'));
  }
  

	private function fillSettingsArrays() {
    var i: int;

    if (this.small_creatures_chances_day.Size() == 0) {
      for (i = 0; i < SmallCreatureMAX; i += 1) {
        this.small_creatures_chances_day.PushBack(0);
        this.small_creatures_chances_night.PushBack(0);
      }
    }

    if (this.large_creatures_chances_night.Size() == 0) {
      for (i = 0; i < LargeCreatureMAX; i += 1) {
        this.large_creatures_chances_day.PushBack(0);
        this.large_creatures_chances_night.PushBack(0);
      }
    }
  }

   
  private function loadCreaturesSpawningChances (out inGameConfigWrapper : CInGameConfigWrapper) {
    this.small_creatures_chances_day[SmallCreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Harpies'));
    this.small_creatures_chances_day[SmallCreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Endrega'));
    this.small_creatures_chances_day[SmallCreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ghouls'));
    this.small_creatures_chances_day[SmallCreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Alghouls'));
    this.small_creatures_chances_day[SmallCreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Nekkers'));
    this.small_creatures_chances_day[SmallCreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Drowners'));
    this.small_creatures_chances_day[SmallCreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Rotfiends'));
    this.small_creatures_chances_day[SmallCreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    this.small_creatures_chances_day[SmallCreatureSKELWOLF]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wolves'));
    this.small_creatures_chances_day[SmallCreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wraiths'));
    this.small_creatures_chances_day[SmallCreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Spiders'));
    this.small_creatures_chances_day[SmallCreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'WildHunt'));
    this.small_creatures_chances_day[SmallCreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Humans'));
    this.small_creatures_chances_day[SmallCreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Skeleton'));


    

    // Blood and Wine
    this.small_creatures_chances_day[SmallCreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Barghest')); 
    this.small_creatures_chances_day[SmallCreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Echinops')); 
    this.small_creatures_chances_day[SmallCreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Centipede'));
    this.small_creatures_chances_day[SmallCreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Kikimore'));
    this.small_creatures_chances_day[SmallCreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'DrownerDLC'));
    this.small_creatures_chances_day[SmallCreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Arachas'));
    this.small_creatures_chances_day[SmallCreatureBEAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
    this.small_creatures_chances_day[SmallCreatureSKELBEAR]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bears'));
		this.small_creatures_chances_day[SmallCreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Panther'));
		this.small_creatures_chances_day[SmallCreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Boars'));

		this.large_creatures_chances_day[LargeCreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Leshens'));
    this.large_creatures_chances_day[LargeCreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Werewolves'));
    this.large_creatures_chances_day[LargeCreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fiends'));
    this.large_creatures_chances_day[LargeCreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Ekimmara'));
    this.large_creatures_chances_day[LargeCreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Katakan'));
    this.large_creatures_chances_day[LargeCreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Golems'));
    this.large_creatures_chances_day[LargeCreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Elementals'));
    this.large_creatures_chances_day[LargeCreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NightWraiths'));
    this.large_creatures_chances_day[LargeCreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'NoonWraiths'));
    this.large_creatures_chances_day[LargeCreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Chorts'));
    this.large_creatures_chances_day[LargeCreatureCYCLOPS]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cyclops'));
    this.large_creatures_chances_day[LargeCreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    this.large_creatures_chances_day[LargeCreatureSKELTROLL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Troll'));
    this.large_creatures_chances_day[LargeCreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Hags'));
    this.large_creatures_chances_day[LargeCreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fogling'));
		this.large_creatures_chances_day[LargeCreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Bruxa'));
		this.large_creatures_chances_day[LargeCreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Fleder'));
		this.large_creatures_chances_day[LargeCreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Garkain'));
		this.large_creatures_chances_day[LargeCreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'HigherVamp'));
		this.large_creatures_chances_day[LargeCreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Giant'));
		this.large_creatures_chances_day[LargeCreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Sharley'));
    this.large_creatures_chances_day[LargeCreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wight'));
    this.large_creatures_chances_day[LargeCreatureVAMPIRE]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Vampires'));
    this.large_creatures_chances_day[LargeCreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Gryphons'));
    this.large_creatures_chances_day[LargeCreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Cockatrice'));
    this.large_creatures_chances_day[LargeCreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Basilisk'));
    this.large_creatures_chances_day[LargeCreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Wyverns'));
    this.large_creatures_chances_day[LargeCreatureFORKTAIL]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', 'Forktails'));

    this.small_creatures_chances_night[SmallCreatureHARPY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Harpies'));
    this.small_creatures_chances_night[SmallCreatureENDREGA]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Endrega'));
    this.small_creatures_chances_night[SmallCreatureGHOUL]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ghouls'));
    this.small_creatures_chances_night[SmallCreatureALGHOUL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Alghouls'));
    this.small_creatures_chances_night[SmallCreatureNEKKER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Nekkers'));
    this.small_creatures_chances_night[SmallCreatureDROWNER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Drowners'));
    this.small_creatures_chances_night[SmallCreatureROTFIEND]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Rotfiends'));
    this.small_creatures_chances_night[SmallCreatureWOLF]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wolves'));
    this.small_creatures_chances_night[SmallCreatureWRAITH]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wraiths'));
    this.small_creatures_chances_night[SmallCreatureSPIDER]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Spiders'));
    this.small_creatures_chances_night[SmallCreatureWILDHUNT]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'WildHunt'));
    this.small_creatures_chances_night[SmallCreatureHuman]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Humans'));
    this.small_creatures_chances_night[SmallCreatureSKELETON]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Skeleton'));


    // Blood and Wine
    this.small_creatures_chances_night[SmallCreatureBARGHEST]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Barghest')); 
    this.small_creatures_chances_night[SmallCreatureECHINOPS]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Echinops')); 
    this.small_creatures_chances_night[SmallCreatureCENTIPEDE]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Centipede'));
    this.small_creatures_chances_night[SmallCreatureKIKIMORE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Kikimore'));
    this.small_creatures_chances_night[SmallCreatureDROWNERDLC] = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'DrownerDLC'));
    this.small_creatures_chances_night[SmallCreatureARACHAS]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Arachas'));
    this.small_creatures_chances_night[SmallCreatureBEAR]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bears'));
		this.small_creatures_chances_night[SmallCreaturePANTHER]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Panther'));
		this.small_creatures_chances_night[SmallCreatureBOAR]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Boars'));

		this.large_creatures_chances_night[LargeCreatureLESHEN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Leshens'));
    this.large_creatures_chances_night[LargeCreatureWEREWOLF]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Werewolves'));
    this.large_creatures_chances_night[LargeCreatureFIEND]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fiends'));
    this.large_creatures_chances_night[LargeCreatureEKIMMARA]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Ekimmara'));
    this.large_creatures_chances_night[LargeCreatureKATAKAN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Katakan'));
    this.large_creatures_chances_night[LargeCreatureGOLEM]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Golems'));
    this.large_creatures_chances_night[LargeCreatureELEMENTAL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Elementals'));
    this.large_creatures_chances_night[LargeCreatureNIGHTWRAITH]  = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NightWraiths'));
    this.large_creatures_chances_night[LargeCreatureNOONWRAITH]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'NoonWraiths'));
    this.large_creatures_chances_night[LargeCreatureCHORT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Chorts'));
    this.large_creatures_chances_night[LargeCreatureCYCLOPS]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cyclops'));
    this.large_creatures_chances_night[LargeCreatureTROLL]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Troll'));
    this.large_creatures_chances_night[LargeCreatureHAG]          = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Hags'));
    this.large_creatures_chances_night[LargeCreatureFOGLET]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fogling'));
		this.large_creatures_chances_night[LargeCreatureBRUXA]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Bruxa'));
		this.large_creatures_chances_night[LargeCreatureFLEDER]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Fleder'));
		this.large_creatures_chances_night[LargeCreatureGARKAIN]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Garkain'));
		this.large_creatures_chances_night[LargeCreatureDETLAFF]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'HigherVamp'));
		this.large_creatures_chances_night[LargeCreatureGIANT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Giant'));
		this.large_creatures_chances_night[LargeCreatureSHARLEY]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Sharley'));
    this.large_creatures_chances_night[LargeCreatureWIGHT]        = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wight'));
    this.large_creatures_chances_night[LargeCreatureVAMPIRE]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Vampires'));
    this.large_creatures_chances_night[LargeCreatureGRYPHON]      = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Gryphons'));
    this.large_creatures_chances_night[LargeCreatureCOCKATRICE]   = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Cockatrice'));
    this.large_creatures_chances_night[LargeCreatureBASILISK]     = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Basilisk'));
    this.large_creatures_chances_night[LargeCreatureWYVERN]       = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Wyverns'));
    this.large_creatures_chances_night[LargeCreatureFORKTAIL]    = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', 'Forktails'));
  }
}

struct LargeCreatureCounter {
  var type: LargeCreatureType;
  var counter: int;
}

struct SmallCreatureCounter {
  var type: SmallCreatureType;
  var counter: int;
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

  // It uses the enums LargeCreatureType & SmallCreatureType as the index
  // and the value as the counter.
  private var large_creatures_counters: array<int>;
  private var small_creatures_counters: array<int>;

  public function fill_arrays() {
    var i: int;

    for (i = 0; i < SmallCreatureMAX; i += 1) {
      this.small_creatures_counters.PushBack(0);
    }

    for (i = 0; i < LargeCreatureMAX; i += 1) {
      this.large_creatures_counters.PushBack(0);
    }
  }

  // To use before rolling,
  // set all the counters to 0.
  public function reset() {
    var i: int;
    
    for (i = 0; i < SmallCreatureMAX; i += 1) {
      small_creatures_counters[i] = 0;
    }

    for (i = 0; i < LargeCreatureMAX; i += 1) {
      large_creatures_counters[i] = 0;
    }
  }

  public function setLargeCreatureCounter(type: LargeCreatureType, count: int) {
    this.large_creatures_counters[type] = count;
  }

  public function setSmallCreatureCounter(type: SmallCreatureType, count: int) {
    LogChannel('modRandomEncounter', "set small creature: " + type + " counter to " + count);
    
    this.small_creatures_counters[type] = count;
  }

  public function rollSmallCreatures(): SmallCreatureType {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;

    for (i = 0; i < SmallCreatureMAX; i += 1) {
      total += this.small_creatures_counters[i];
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < SmallCreatureMAX; i += 1) {
      if (roll <= current_position + this.small_creatures_counters[i]) {
        return i;
      }

      current_position += this.small_creatures_counters[i];
    }

    // not supposed to get here but hey, who knows.
    return SmallCreatureNONE;
  }

  public function rollLargeCreatures(): LargeCreatureType {
    var current_position: int;
    var total: int;
    var roll: int;
    var i: int;

    for (i = 0; i < LargeCreatureMAX; i += 1) {
      total += this.large_creatures_counters[i];
    }

    roll = RandRange(total);

    current_position = 0;

    for (i = 0; i < LargeCreatureMAX; i += 1) {
      if (roll <= current_position + this.large_creatures_counters[i]) {
        return i;
      }

      current_position += this.large_creatures_counters[i];
    }

    // not supposed to get here but hey, who knows.
    return LargeCreatureNONE;
  }

  
}

struct SEnemyTemplate {
  var template : string;
  var max      : int;
  var count    : int;
}

function makeEnemyTemplate(template: string, optional max: int, optional count: int): SEnemyTemplate {
  var enemy_template: SEnemyTemplate;

  enemy_template.template = template;
  enemy_template.max = max;
  enemy_template.count = count;

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

function re_gryphon() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\gryphon_lvl1.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\gryphon_lvl3__volcanic.w2ent")); 
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\gryphon_mh__volcanic.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\cockatrice_lvl1.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\basilisk_lvl1.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wyvern_lvl1.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wyvern_lvl2.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\forktail_lvl1.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\forktail_lvl2.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\novigrad\nov_1h_club.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\novigrad\nov_1h_mace_t1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\novigrad\nov_2h_hammer.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("gameplay\templates\characters\presets\novigrad\nov_1h_sword_t1.w2ent"));
  
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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_axe.w2ent", 2));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_halberd.w2ent", 2));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_hammer.w2ent", 1));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_spear.w2ent", 2));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("quests\part_2\quest_files\q403_battle\characters\q403_wild_hunt_2h_sword.w2ent", 1));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wildhunt_minion_lvl1.w2ent", 2));  // hound of the wild hunt   
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wildhunt_minion_lvl2.w2ent", 1));  // spikier hound

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\arachas_lvl1.w2ent"));       
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\arachas_lvl2__armored.w2ent", 2));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\arachas_lvl3__poison.w2ent", 2));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\cyclop_lvl1.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\lessog_lvl1.w2ent"));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\lessog_lvl2__ancient.w2ent"));
  
  if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\spriggan.w2ent"));
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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\werewolf_lvl1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\werewolf_lvl3__lycan.w2ent"));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\werewolf_lvl4__lycan.w2ent"));  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\werewolf_lvl5__lycan.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\bies_lvl1.w2ent"));  // fiends        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\bies_lvl2.w2ent"));  // red fiend

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\czart_lvl1.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\bear_lvl1__black.w2ent"));      // black, like it says :)      
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\bear_lvl2__grizzly.w2ent"));      // light brown  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\bear_lvl3__grizzly.w2ent"));      // light brown  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\bear_berserker_lvl1.w2ent"));    // red/brown

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\bear_lvl3__white.w2ent"));      // polarbear

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\golem_lvl1.w2ent"));          // normal greenish golem        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\golem_lvl2__ifryt.w2ent"));      // fire golem  
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\golem_lvl3.w2ent"));          // weird yellowish golem

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\elemental_dao_lvl1.w2ent"));      // earth elemental        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\elemental_dao_lvl2.w2ent"));      // stronger and cliffier elemental
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\elemental_dao_lvl3__ice.w2ent"));

  if(theGame.GetDLCManager().IsEP2Available()  &&   theGame.GetDLCManager().IsEP2Enabled()){
    enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\mq7007_item__golem_grafitti.w2ent"));
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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\vampire_ekima_lvl1.w2ent"));    // white vampire

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\vampire_katakan_lvl1.w2ent"));  // cool blinky vampire     
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\vampire_katakan_lvl3.w2ent"));  // cool blinky vamp

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\nightwraith_lvl1.w2ent"));       
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\nightwraith_lvl2.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\nightwraith_lvl3.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\noonwraith_lvl1.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\noonwraith_lvl2.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\noonwraith_lvl3.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\troll_cave_lvl1.w2ent"));    // grey

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_skeltroll() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\troll_cave_lvl3__ice.w2ent"));  // ice   
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\troll_cave_lvl4__ice.w2ent"));  // ice
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\troll_ice_lvl13.w2ent"));    // ice

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 2;

  return enemy_template_list;
}

function re_hag() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\hag_grave_lvl1.w2ent"));          // grave hag 1        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\hag_water_lvl1.w2ent"));          // grey  water hag    
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\hag_water_lvl2.w2ent"));          // greenish water hag

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\harpy_lvl1.w2ent"));        // harpy
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\harpy_lvl2.w2ent"));        // harpy
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\harpy_lvl2_customize.w2ent"));    // harpy
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\harpy_lvl3__erynia.w2ent", 1));    // harpy

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\endriaga_lvl1__worker.w2ent"));      // small endrega
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent", 2));      // bigger tailed endrega
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\endriaga_lvl3__spikey.w2ent", 1));      // big tailless endrega

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\fogling_lvl1.w2ent"));          // normal fogling
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\fogling_lvl2.w2ent"));        // normal fogling
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\fogling_lvl3__willowisp.w2ent"));  // green fogling

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\ghoul_lvl1.w2ent"));          // normal ghoul   spawns from the ground
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\ghoul_lvl2.w2ent"));          // red ghoul   spawns from the ground
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\ghoul_lvl3.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\alghoul_lvl1.w2ent"));        // dark
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\alghoul_lvl2.w2ent", 3));        // dark reddish
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\alghoul_lvl3.w2ent", 2));        // greyish
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\alghoul_lvl4.w2ent", 1));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\nekker_lvl1.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\nekker_lvl2.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\nekker_lvl2_customize.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\nekker_lvl3_customize.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\nekker_lvl3__warrior.w2ent", 2));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\drowner_lvl1.w2ent"));        // drowner
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\drowner_lvl2.w2ent"));        // drowner
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\drowner_lvl3.w2ent"));        // pink drowner
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\drowner_lvl4__dead.w2ent", 2));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\rotfiend_lvl1.w2ent"));        
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\rotfiend_lvl2.w2ent", 1));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wolf_lvl1.w2ent"));        // +4 lvls  grey/black wolf STEEL
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wolf_lvl1__alpha.w2ent", 1));    // +4 lvls brown warg      STEEL

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wolf_white_lvl2.w2ent"));    // lvl 51 white wolf    STEEL     
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wolf_white_lvl3__alpha.w2ent", 1));  // lvl 51 white wolf     STEEL  37

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wraith_lvl1.w2ent"));      // all look the bloody same....
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wraith_lvl2.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wraith_lvl2_customize.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wraith_lvl3.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("characters\npc_entities\monsters\wraith_lvl4.w2ent", 2));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\ep1\data\characters\npc_entities\monsters\black_spider.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\ep1\data\characters\npc_entities\monsters\black_spider_large.w2ent",2));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\ep1\data\characters\npc_entities\monsters\wild_boar_ep1.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\dettlaff_vampire.w2ent", 1));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\nightwraith_banshee_summon_skeleton.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\barghest.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\bruxa.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\bruxa_alp.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\echinops_hard.w2ent", 1));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\echinops_normal.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\echinops_normal_lw.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent", 1));

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_fleder() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\fleder.w2ent", 1));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\garkain.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\garkain_mh.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\gravier.w2ent")); // fancy drowner

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\kikimore.w2ent", 1));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\kikimore_small.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\panther_black.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\panther_leopard.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\panther_mountain.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\q701_dagonet_giant.w2ent"));
  // enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\q704_cloud_giant.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\scolopendromorph.w2ent")); //worm
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\mq7023_albino_centipede.w2ent"));

  enemy_template_list.difficulty_factor.minimum_count_easy = 1;
  enemy_template_list.difficulty_factor.maximum_count_easy = 1;
  enemy_template_list.difficulty_factor.minimum_count_medium = 1;
  enemy_template_list.difficulty_factor.maximum_count_medium = 1;
  enemy_template_list.difficulty_factor.minimum_count_hard = 1;
  enemy_template_list.difficulty_factor.maximum_count_hard = 1;

  return enemy_template_list;
}

function re_sharley() : EnemyTemplateList {
  var enemy_template_list: EnemyTemplateList;

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\sharley.w2ent"));  // rock boss things
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\sharley_mh.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\sharley_q701.w2ent"));
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\sharley_q701_normal_scale.w2ent"));

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\spooncollector.w2ent",1));  // spoon
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\wicht.w2ent",2));     // wight

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

  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"));  // spoon
  enemy_template_list.templates.PushBack(makeEnemyTemplate("dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent"));     // wight

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

  public function getRandomHumanTypeByCurrentArea(): EHumanType {
    var choice: array<EHumanType>;
    var current_area: string;
    var i: int;

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    if (current_area == "prolog_village") {
      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_BANDIT);
      }
      
      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }
      
      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }
    }
    else if (current_area == "skellige") {
      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_SKELBANDIT);
      }
      
      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_SKELBANDIT2);
      }
  
      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_SKELPIRATE);
      }
    }
    else if (current_area == "kaer_morhen") {
      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_BANDIT);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }
    }
    else if (current_area == "novigrad" || current_area == "no_mans_land") {
      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_NOVBANDIT);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_PIRATE);
      }

      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_BANDIT);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NILFGAARDIAN);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_WITCHHUNTER);
      }
    }
    else if (current_area == "bob") {
      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NOVBANDIT);
      }

      for (i=0; i<4; i+=1) {
        choice.PushBack(HT_BANDIT);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NILFGAARDIAN);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }
    }
    else {
      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NOVBANDIT);
      }

      for (i=0; i<4; i+=1) {
        choice.PushBack(HT_BANDIT);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NILFGAARDIAN);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }
    }

    return choice[RandRange(choice.Size())];
  }

  public function getRandomSmallCreatureByCurrentArea(out settings: RE_Settings, out spawn_roller: SpawnRoller): SmallCreatureType {
    var is_in_forest: bool;
    var is_near_water: bool;
    var is_in_swamp: bool;

    var i: int;
    var current_area: string;

    is_in_forest = this.IsPlayerInForest();
    is_near_water = this.IsPlayerNearWater();
    is_in_swamp = this.IsPlayerInSwamp();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    spawn_roller.reset();

    if (theGame.envMgr.IsNight()) {
      // first set all the counters to the settings value.
      for (i = 0; i < SmallCreatureMAX; i += 1) {
        spawn_roller.setSmallCreatureCounter(i, settings.small_creatures_chances_night[i]);
      }
    }
    else {
      for (i = 0; i < SmallCreatureMAX; i += 1) {
        spawn_roller.setSmallCreatureCounter(i, settings.small_creatures_chances_day[i]);
      }
    }

    // then handle special cases by hand
    
    if (current_area == "prolog_village") {
      // we remove some creatures in the prolog area
      spawn_roller.setSmallCreatureCounter(SmallCreatureHARPY, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureCENTIPEDE, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureECHINOPS, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureBARGHEST, 0);
    }

    if (current_area != "skellige") {
      spawn_roller.setSmallCreatureCounter(SmallCreatureSKELWOLF, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureSKELBEAR, 0);
    }

    // and now special cases depending on areas
    if (!is_near_water && !is_in_swamp) {
      // well, no water no drowners!
      spawn_roller.setSmallCreatureCounter(SmallCreatureDROWNER, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureDROWNERDLC, 0);
    }

    if (!is_in_forest) {
      // no forest, no plants
      spawn_roller.setSmallCreatureCounter(SmallCreatureARACHAS, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureENDREGA, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureECHINOPS, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureSPIDER, 0);
    }

    if (is_near_water || is_in_swamp) {
      spawn_roller.setSmallCreatureCounter(SmallCreatureCENTIPEDE, 0);
      spawn_roller.setSmallCreatureCounter(SmallCreatureHARPY, 0);
    }

    return spawn_roller.rollSmallCreatures();
  }

  public function getRandomLargeCreatureByCurrentArea(settings: RE_Settings, out spawn_roller: SpawnRoller): LargeCreatureType {
    var i: int;
    var current_area: string;
    var is_in_forest: bool;
    var is_near_water: bool;
    var is_in_swamp: bool;

    is_in_forest = this.IsPlayerInForest();
    is_near_water = this.IsPlayerNearWater();
    is_in_swamp = this.IsPlayerInSwamp();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    spawn_roller.reset();

    if (theGame.envMgr.IsNight()) {
      // first set all the counters to the settings value.
      for (i = 0; i < LargeCreatureMAX; i += 1) {
        spawn_roller.setLargeCreatureCounter(i, settings.large_creatures_chances_night[i]);
      }
    }
    else {
      for (i = 0; i < LargeCreatureMAX; i += 1) {
        spawn_roller.setLargeCreatureCounter(i, settings.large_creatures_chances_day[i]);
      }
    }

    // then handle special cases by hand
    
    if (current_area == "prolog_village") {
      // we remove some creatures in the prolog area
      spawn_roller.setLargeCreatureCounter(LargeCreatureGIANT, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureEKIMMARA, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureKATAKAN, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureGOLEM, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureELEMENTAL, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureCYCLOPS, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureBRUXA, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureFLEDER, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureGARKAIN, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureDETLAFF, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureGIANT, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureSHARLEY, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureVAMPIRE, 0);
    }

    if (current_area != "skellige") {
      spawn_roller.setLargeCreatureCounter(LargeCreatureSKELTROLL, 0);
    }

    // and now special cases depending on areas
    if (is_in_forest) {
      if (theGame.envMgr.IsNight()) {
        spawn_roller.setLargeCreatureCounter(LargeCreatureCOCKATRICE, settings.large_creatures_chances_night[LargeCreatureCOCKATRICE] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureBASILISK, settings.large_creatures_chances_night[LargeCreatureBASILISK] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureWYVERN, settings.large_creatures_chances_night[LargeCreatureWYVERN] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureFORKTAIL, settings.large_creatures_chances_night[LargeCreatureFORKTAIL] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureGRYPHON, settings.large_creatures_chances_night[LargeCreatureGRYPHON] / 2);
      }
      else {
        spawn_roller.setLargeCreatureCounter(LargeCreatureCOCKATRICE, settings.large_creatures_chances_day[LargeCreatureCOCKATRICE] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureBASILISK, settings.large_creatures_chances_day[LargeCreatureBASILISK] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureWYVERN, settings.large_creatures_chances_day[LargeCreatureWYVERN] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureFORKTAIL, settings.large_creatures_chances_day[LargeCreatureFORKTAIL] / 2);
        spawn_roller.setLargeCreatureCounter(LargeCreatureGRYPHON, settings.large_creatures_chances_day[LargeCreatureGRYPHON] / 2);
      }
    }
    else {
      spawn_roller.setLargeCreatureCounter(LargeCreatureLESHEN, 0);
    }

    if (is_in_swamp) {
      spawn_roller.setLargeCreatureCounter(LargeCreatureWEREWOLF, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureELEMENTAL, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureNOONWRAITH, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureNIGHTWRAITH, 0);
    }
    else {
      spawn_roller.setLargeCreatureCounter(LargeCreatureHAG, 0);
      spawn_roller.setLargeCreatureCounter(LargeCreatureFOGLET, 0);
    }

    if (theGame.envMgr.IsNight()) {
      spawn_roller.setLargeCreatureCounter(LargeCreatureNOONWRAITH, 0);
    }
    else {
      spawn_roller.setLargeCreatureCounter(LargeCreatureNIGHTWRAITH, 0);
    }

    return spawn_roller.rollLargeCreatures();
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

function VecArc(angleStart : int, angleEnd : int, angleStep : int, radius : float) : array<Vector>
{
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

function VecSphere(angleStep : int, radius : float) : array<Vector>
{
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

enum LargeCreatureComposition {
  LargeCreatureComposition_AmbushWitcher = 1
}

latent function createRandomLargeCreatureComposition(out random_encounters_class: CRandomEncounters) {
  var large_creature_composition: LargeCreatureComposition;

  large_creature_composition = LargeCreatureComposition_AmbushWitcher;

  switch (large_creature_composition) {
    case LargeCreatureComposition_AmbushWitcher:
      makeLargeCreatureAmbushWitcher(random_encounters_class);
      break;
  }
}


          //////////////////////////////////////
          // maker functions for compositions //
          //////////////////////////////////////


latent function makeLargeCreatureAmbushWitcher(out master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;

  var creatures_entities: array<RandomEncountersReworkedEntity>;
  var rer_entity: RandomEncountersReworkedEntity;

  var i: int;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making large creatures composition ambush witcher");

  creatures_templates = master.resources.getCreatureResourceByLargeCreatureType(
    master.rExtra.getRandomLargeCreatureByCurrentArea(
      master.settings,
      master.spawn_roller
    )
  );

  if (!getRandomPositionBehindCamera(initial_position)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures");

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    rer_entity = creatures_entities[i];
    rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
    rer_entity.startWithoutBait();
  }
}

latent function createRandomLargeCreatureHunt(master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;
  var bait: CEntity;

  var creatures_entities: array<RandomEncountersReworkedEntity>;
  var createEntityHelper: CCreateEntityHelper;

  var current_entity_template: SEnemyTemplate;
  var current_template: CEntityTemplate;

  var i: int;
  var j: int;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making create hunt");

  creatures_templates = master.resources.getCreatureResourceByLargeCreatureType(
    master.rExtra.getRandomLargeCreatureByCurrentArea(
      master.settings,
      master.spawn_roller
    )
  );

  if (!getRandomPositionBehindCamera(initial_position, 60, 40)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  number_of_creatures = number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );;

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures");

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);

  // creating the bait now
  createEntityHelper = new CCreateEntityHelper;
  createEntityHelper.Reset();
  theGame.CreateEntityAsync(
    createEntityHelper,
    (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
    initial_position,
    thePlayer.GetWorldRotation(),
    true,
    false,
    false,
    PM_DontPersist
  );

  while(createEntityHelper.IsCreating()) {            
    SleepOneFrame();
  }

  bait = createEntityHelper.GetCreatedEntity();
 
  LogChannel('modRandomEncounters', "bait entity spawned");

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    LogChannel('modRandomEncounters', "adding bait to: " + i);
    creatures_entities[i].startWithBait(bait);
  }
}

enum SmallCreatureComposition {
  SmallCreatureComposition_AmbushWitcher = 1
}

latent function createRandomSmallCreatureComposition(out random_encounters_class: CRandomEncounters) {
  var small_creature_composition: SmallCreatureComposition;

  small_creature_composition = SmallCreatureComposition_AmbushWitcher;

  switch (small_creature_composition) {
    case SmallCreatureComposition_AmbushWitcher:
      makeSmallCreatureAmbushWitcher(random_encounters_class);
      break;
  }
}


          //////////////////////////////////////
          // maker functions for compositions //
          //////////////////////////////////////


latent function makeSmallCreatureAmbushWitcher(out master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;

  var creatures_entities: array<RandomEncountersReworkedEntity>;
  var rer_entity: RandomEncountersReworkedEntity;

  var i: int;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making small creatures composition ambush witcher");

  creatures_templates = master.resources.getCreatureResourceBySmallCreatureType(
    master.rExtra.getRandomSmallCreatureByCurrentArea(master.settings, master.spawn_roller),
    master.rExtra
  );

  if (!getRandomPositionBehindCamera(initial_position)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  LogChannel('modRandomEncounters', "spawning position found : " + initial_position.X + " " + initial_position.Y + " " + initial_position.Z);


  number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures, difficulty: " + master.settings.selectedDifficulty);

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    rer_entity = creatures_entities[i];
    rer_entity.this_newnpc.SetLevel(GetWitcherPlayer().GetLevel());
    rer_entity.startWithoutBait();
  }
}

latent function createRandomSmallCreatureHunt(master: CRandomEncounters) {
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;
  var bait: CEntity;

  var creatures_entities: array<RandomEncountersReworkedEntity>;
  var createEntityHelper: CCreateEntityHelper;

  var current_entity_template: SEnemyTemplate;
  var current_template: CEntityTemplate;

  var i: int;
  var j: int;
  var initial_position: Vector;

  LogChannel('modRandomEncounters', "making create hunt");

  creatures_templates = master.resources.getCreatureResourceBySmallCreatureType(
    master.rExtra.getRandomSmallCreatureByCurrentArea(master.settings, master.spawn_roller),
    master.rExtra
  );

  if (!getRandomPositionBehindCamera(initial_position, 60, 40)) {
    LogChannel('modRandomEncounters', "could not find proper spawning position");

    return;
  }

  number_of_creatures = number_of_creatures = rollDifficultyFactor(
    creatures_templates.difficulty_factor,
    master.settings.selectedDifficulty
  );;

  LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures");

  creatures_templates = fillEnemyTemplateList(creatures_templates, number_of_creatures);
  creatures_entities = spawnTemplateList(creatures_templates.templates, initial_position, 0.01);

  // creating the bait now
  createEntityHelper = new CCreateEntityHelper;
  createEntityHelper.Reset();
  theGame.CreateEntityAsync(
    createEntityHelper,
    (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
    initial_position,
    thePlayer.GetWorldRotation(),
    true,
    false,
    false,
    PM_DontPersist
  );

  while(createEntityHelper.IsCreating()) {            
    SleepOneFrame();
  }

  bait = createEntityHelper.GetCreatedEntity();
 
  LogChannel('modRandomEncounters', "bait entity spawned");

  for (i = 0; i < creatures_entities.Size(); i += 1) {
    LogChannel('modRandomEncounters', "adding bait to: " + i);
    creatures_entities[i].startWithBait(bait);
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
        list_to_copy.templates[i].count
      )
    );
  }

  return copy;
}

/**
 * NOTE: it makes a copy of the list
 **/
function fillEnemyTemplateList(enemy_template_list: EnemyTemplateList, total_number_of_enemies: int): EnemyTemplateList {
  var template_list: EnemyTemplateList;
  var selected_template_to_increment: int;
  var max_tries: int;
  var i: int;

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


  while (total_number_of_enemies > 0 && max_tries > 0) {
    max_tries -= 1;

    selected_template_to_increment = RandRange(template_list.templates.Size());

    LogChannel('modRandomEncounters', "selected template: " + selected_template_to_increment);

    if (template_list.templates[selected_template_to_increment].max > 0
      && template_list.templates[selected_template_to_increment].count >= template_list.templates[selected_template_to_increment].max) {
      continue;
    }

    template_list.templates[selected_template_to_increment].count += 1;

    total_number_of_enemies -= 1;
  }

  return template_list;
}

function getGroundPosition(out input_position: Vector): bool {
  var output_position: Vector;
  var point_z: float;
  var collision_normal: Vector;

  output_position = input_position;

  // first search for ground based on navigation data.
  theGame
  .GetWorld()
  .NavigationComputeZ( output_position, output_position.Z - 30.0, output_position.Z + 30.0, point_z );

	output_position.Z = point_z;

  // then do a static trace to find the position on ground
  theGame
  .GetWorld()
  .StaticTrace(
    output_position + Vector(0,0,1.5),// + 5,// Vector(0,0,5),
    output_position - Vector(0,0,1.5),// - 5,//Vector(0,0,5),
    output_position,
    collision_normal
  );
  
  // finally, return if the position is above water level
  if (output_position.Z >= theGame.GetWorld().GetWaterLevel(output_position, true)) {
    input_position = output_position;

    return true;
  }

  return false;

  
}

function getRandomPositionBehindCamera(out initial_pos: Vector, optional distance: float, optional minimum_distance: float): bool {  // var camera_direction: Vector;
  var player_position: Vector;
  var point_z: float;

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
  initial_pos = player_position + VecConeRand(theCamera.GetCameraHeading(), 270, -minimum_distance, -distance);

  return getGroundPosition(initial_pos);
}

latent function spawnEntities(entity_template: CEntityTemplate, initial_position: Vector, optional quantity: int, optional density: float): array<RandomEncountersReworkedEntity> {
  var ent: CEntity;
  var player, pos_fin, normal: Vector;
  var rot: EulerAngles;
  var i, sign: int;
  var s, r, x, y: float;
  var createEntityHelper: CCreateEntityHelper;
  var created_entities: array<RandomEncountersReworkedEntity>;
  var current_rer_entity: RandomEncountersReworkedEntity;
  var rer_entity_template: CEntityTemplate;
  var created_entity: CEntity;
  
  quantity = Max(quantity, 1);

  if (density == 0) {
    density = 0.2;
  }

  LogChannel('modRandomEncounters', "spawning " + quantity + " entities");

  rot = thePlayer.GetWorldRotation();  

  //const values used in the loop
  pos_fin.Z = initial_position.Z;
  s = quantity / density; // maintain a constant density of 0.2 unit per m2
  r = SqrtF(s/Pi());

  createEntityHelper = new CCreateEntityHelper;
  // createEntityHelper.SetPostAttachedCallback(this, 'onEntitySpawned');

  rer_entity_template = (CEntityTemplate)LoadResourceAsync("dlc\modtemplates\randomencounterreworkeddlc\data\rer_default_entity.w2ent", true);

  for (i = 0; i < quantity; i += 1) {
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

    createEntityHelper.Reset();
    theGame.CreateEntityAsync(createEntityHelper, entity_template, pos_fin, rot, true, false, false, PM_DontPersist);

    LogChannel('modRandomEncounters', "spawning entity at " + pos_fin.X + " " + pos_fin.Y + " " + pos_fin.Z);

    while(createEntityHelper.IsCreating()) {            
      SleepOneFrame();
    }

    current_rer_entity = (RandomEncountersReworkedEntity)theGame.CreateEntity(
      rer_entity_template,
      initial_position,
      thePlayer.GetWorldRotation()
    );

    created_entity = createEntityHelper.GetCreatedEntity();

    current_rer_entity.attach(
      (CActor)created_entity,
      (CNewNPC)created_entity,
      created_entity
    );

    created_entities.PushBack(current_rer_entity);
  }

  return created_entities;
}

latent function spawnTemplateList(entities_templates: array<SEnemyTemplate>, position: Vector, optional density: float): array<RandomEncountersReworkedEntity> {
  var returned_entities: array<RandomEncountersReworkedEntity>;
  var current_iteration_entities: array<RandomEncountersReworkedEntity>;

  var current_entity_template: SEnemyTemplate;
  var current_template: CEntityTemplate;

  var i: int;
  var j: int;

  for (i = 0; i < entities_templates.Size(); i += 1) {
    current_entity_template = entities_templates[i];

    if (current_entity_template.count > 0) {
      current_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);

      current_iteration_entities = spawnEntities(
        current_template,
        position,
        current_entity_template.count,
        density
      );

      for (j = 0; j < current_iteration_entities.Size(); j += 1) {
        returned_entities.PushBack(current_iteration_entities[j]);
      }
    }
  }

  return returned_entities;
}

state Spawning in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    parent.RemoveTimer('randomEncounterTick');

    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state SPAWNING");

    triggerCreaturesSpawn();
  }

  entry function triggerCreaturesSpawn() {
    var picked_entity_type: CreatureType;
    var picked_encounter_type: EncounterType;

    LogChannel('modRandomEncounters', "creatures spawning triggered");
    
    if (this.shouldAbortCreatureSpawn()) {
      parent.GotoState('SpawningCancelled');

      return;
    }

    picked_entity_type = this.getRandomEntityTypeWithSettings();
    picked_encounter_type = this.getRandomEncounterType();

    LogChannel('modRandomEncounters', "picked entity type: " + picked_entity_type + ", picked encounter type: " + picked_encounter_type);

    makeGroupComposition(
      picked_encounter_type,
      picked_entity_type,
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
        || current_zone == REZ_CITY 
        && !parent.settings.cityBruxa 
        && !parent.settings.citySpawn;
  }

  function getRandomEntityTypeWithSettings(): CreatureType {
    if (theGame.envMgr.IsNight()) {
      if (RandRange(100) < parent.settings.large_creature_chance) {
        return LARGE_CREATURE;
      }

      return SMALL_CREATURE;
    }
    else {
      if (RandRange(100) < parent.settings.large_creature_chance * 2) {
        return LARGE_CREATURE;
      }

      return SMALL_CREATURE;
    }
  }

  function getRandomEncounterType(): EncounterType {
    if (RandRange(100) < parent.settings.all_monster_hunt_chance) {
      return EncounterType_HUNT;
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
