
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
  var events_manager: RER_EventsManager;
  var bestiary: RER_Bestiary;

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

      this.GotoState('Waiting');
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
    this.GotoState('Waiting');
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
        REROL_someone_pay_for_trophy();
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

