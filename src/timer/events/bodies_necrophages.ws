
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
      .GetVarValue('RERadvancedEvents', 'eventBodiesNecrophages')
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

    return spawn_roller.rollCreatures();
  }
}