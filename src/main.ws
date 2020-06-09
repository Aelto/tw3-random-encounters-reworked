class CRandomEncounterInitializer extends CEntityMod {
  default modName = 'Random Encounters';
  default modAuthor = "erxv";
  default modUrl = "http://www.nexusmods.com/witcher3/mods/785?";
  default modVersion = '1.31';

  default logLevel = MLOG_DEBUG;

  default template = "dlc\modtemplates\randomencounterdlc\data\re_initializer.w2ent";
}


function modCreate_RandomEncounters() : CMod {
  return new CRandomEncounterInitializer in thePlayer;
}

statemachine class CRandomEncounters extends CEntity {
  var rExtra: CModRExtra;
  var settings: RE_Settings;
  var resources: RE_Resources;

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

      theInput.RegisterListener(this, 'OnRefreshSettings', 'RefreshRESetting');
      theInput.RegisterListener(this, 'OnSpawnMonster', 'RandomEncounter');

      super.OnSpawned(spawn_data);

      rExtra = new CModRExtra in this;
      settings = new RE_Settings in this;
      resources = new RE_Resources in this;

      this.initiateRandomEncounters();
    }
  }

  event OnRefreshSettings(action: SInputAction) {
    if (IsPressed(action)) {
      this.settings.loadXMLSettingsAndShowNotification();
    }
  }

  event OnSpawnMonster(action: SInputAction) {
    LogChannel('modRandomEncounters', "on spawn event");
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


  // function trySpawnGroundCreatures() {
  //   var entity_template: CEntityTemplate;
  //   var number_of_creatures: int;
  //   var picked_creature_type: EGroundMonsterType;
  // }
}



