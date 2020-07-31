
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

      this.settings.setHideNextNotificationsSettings(true);
    }
  }

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
