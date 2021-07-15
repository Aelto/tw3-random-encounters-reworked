
statemachine class RER_MonsterNest extends CMonsterNestEntity {
  var master: CRandomEncounters;
  var entities: array<CEntity>;

  var entity_settings: ContractEntitySettings;

  var is_destroyed: bool;

  var bestiary_entry: RER_BestiaryEntry;

  /**
   * counts how many monsters were spawned by this nest
   */
  var monsters_spawned_count: int;

  /**
   * defines when newly spawned monsters should no longer drop loot.
   * The number set corresponds to the number of monsters that were spawned
   * before.
   */
  var disable_monsters_loot_threshold: int;
  default disable_monsters_loot_threshold = 10;

  /**
   * controls how many monsters the nest can spawn in total.
   */
  var monsters_spawned_limit: int;
  default monsters_spawned_limit = 15;

  var pin_position: Vector;

  function startEncounter(master: CRandomEncounters) {
    this.master = master;
    this.loadSettings(master);

    this.GotoState('Loading');

    this.AddTimer('intervalLifeCheck', 10.0, true);
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

    this.disable_monsters_loot_threshold = 5;

    if (master.settings.selectedDifficulty == RER_Difficulty_RANDOM) {
      this.monsters_spawned_limit = RandRange(
        ((int)RER_Difficulty_HARD + 1) * 4,
        ((int)RER_Difficulty_EASY + 1) * 4
      );
    }
    else {
      this.monsters_spawned_limit = RandRange(
        ((int)master.settings.selectedDifficulty + 1) * 4,
        ((int)master.settings.selectedDifficulty + 1) * 3,
      );
    }
  }

  event OnSpawned(spawnData: SEntitySpawnData) {}

  event OnAreaEnter(area: CTriggerAreaComponent, activator: CComponent) {
    if (area != (CTriggerAreaComponent)this.GetComponent("VoiceSetTrigger")
     || !this.CanPlayVoiceSet()
     || this.voicesetPlayed) {
       return false;
    }

    this.l_enginetime = theGame.GetEngineTimeAsSeconds();

    // the player did not talk in the last 60 seconds
    if (l_enginetime > this.voicesetTime + 60.0f) {
      this.voicesetTime = this.l_enginetime;
      this.voicesetPlayed = true;
      this.GotoState('Talking');
    }
    // he did, so we directly go to the spawning state
    else if (GetCurrentStateName() != 'Spawning') {
      this.GotoState('Spawning');
    }

    SUH_makeEntitiesTargetPlayer(this.entities);
  }

  event OnFireHit(source: CGameplayEntity) {}
  event OnAardHit(sign: W3AardProjectile) {}
	
  event OnInteraction(actionName: string, activator: CEntity) {
    if (activator != thePlayer || !thePlayer.CanPerformPlayerAction()) {
			return false;
		}
	
		if(interactionComponent && wasExploded && interactionComponent.IsEnabled()) {
			interactionComponent.SetEnabled(false);
		}

    if (!PlayerHasBombActivator()) {
      GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt( "panel_hud_message_destroy_nest_bomb_lacking" ) );
			messageTimestamp = theGame.GetEngineTimeAsSeconds();

      return false;
    }

    if(interactionComponent && interactionComponent.IsEnabled()) {
      theGame.CreateNoSaveLock( 'nestSettingExplosives', saveLockIdx );
      wasExploded = true;
      GetEncounter();
      interactionComponent.SetEnabled(false);
      
      GotoState('SettingExplosives');
    }

    return true;
  }

  private latent function getRandomNestCreatureType(master: CRandomEncounters): CreatureType {
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
      .setIsInCity(master.rExtra.isPlayerInSettlement() || master.rExtra.getCustomZone(thePlayer.GetWorldPosition()) == REZ_CITY)
      .setCurrentRegion(AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea()));

    creatures_preferences
      .reset();
      
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
    
    master.bestiary.entries[CreatureARACHAS]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureENDREGA]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureNEKKER]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureHARPY]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureSPIDER]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureCENTIPEDE]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureECHINOPS]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureKIKIMORE]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

    master.bestiary.entries[CreatureSIREN]
      .setCreaturePreferences(creatures_preferences, EncounterType_DEFAULT)
      .fillSpawnRoller(spawn_roller);

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

    roll = spawn_roller.rollCreatures(master.ecosystem_manager);
    return roll.roll;
  }

  timer function intervalLifeCheck(optional dt : float, optional id : Int32) {
    var distance_from_player: float;

    if (this.GetCurrentStateName() == 'Ending') {
      return;
    }

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    if (distance_from_player > this.entity_settings.kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.entity_settings.kill_threshold_distance);
      this.endEncounter();

      return;
    }
  }

  public function endEncounter() {
    if (this.GetCurrentStateName() != 'Ending') {
      this.GotoState('Ending');
    }
  }

  public latent function clean() {
    var i: int;

    NLOG("RER_MonsterNest destroyed");

    this.RemoveTimer('intervalLifeCheck');

    for (i = 0; i < this.entities.Size(); i += 1) {
      ((CActor)this.entities[i])
        .Kill('RandomEncountersReworkedContractEntity', true);
    }

    this.Destroy();
  }
}
