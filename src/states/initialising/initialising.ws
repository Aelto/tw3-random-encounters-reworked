
state Initialising in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("Entering state Initialising");

    this.startInitialising();
  }

  entry function startInitialising() {
    if (parent.settings.shouldResetRERSettings(theGame.GetInGameConfigWrapper())) {
      this.displayPresetChoiceDialogeMenu();
    }

    this.removeAllRerMapPins();
    this.updateSettings();

    parent.spawn_roller.fill_arrays();

    parent.bestiary.init();
    parent.bestiary.loadSettings();

    parent.settings.loadXMLSettings();
    parent.resources.load_resources();

    parent.events_manager.init(parent);
    parent.events_manager.start();

    parent.storages = RER_loadStorageCollection();

    parent.ecosystem_manager.init(parent);
    parent.bounty_manager.init(parent);
    parent.horde_manager.init(parent);
    parent.contract_manager.init(parent);

    RER_tutorialTryShowStarted();
    
    LogChannel('RER', "ecosystem areas storage count = " + parent.storages
      .ecosystem
      .ecosystem_areas.Size());

    parent.GotoState('Loading');
  }

  function updateSettings() {
    var config: CInGameConfigWrapper;
    var constants: RER_Constants;
    var current_version: float;

    config = theGame.GetInGameConfigWrapper();
    constants = RER_Constants();
    current_version = StringToFloat(config.GetVarValue('RERmain', 'RERmodVersion'));

    if (current_version < 2.07) {
      config.ApplyGroupPreset('RERcontracts', 0);

      current_version = 2.07;
    }

    // if (current_version < 2.08) {
    //   NDEBUG("[RER] The mod was updated to v2.8: the Contract System settings were reset to support the new reputation system");

    //   // reset the contract tutorial value so it displays again
    //   // config.SetVarValue('RERtutorials', 'RERtutorialMonsterContract', 1);
    //   config.ApplyGroupPreset('RERcontracts', 0);

    //   current_version = 2.08;
    // }

    config.SetVarValue('RERmain', 'RERmodVersion', constants.version);
    theGame.SaveUserSettings();
  }

  latent function displayPresetChoiceDialogeMenu() {
    var choices: array<SSceneChoice>;
    var manager: RER_PresetManager;
    var response: SSceneChoice;

    manager = new RER_PresetManager in this;
    manager.master = parent;

    choices = manager.getChoiceList();

    while (isPlayerBusy()) {
      Sleep(5);
    }

    Sleep(5);

    (new RER_RandomDialogBuilder in thePlayer).start()
      .dialog(new REROL_whoa_in_for_one_helluva_ride in thePlayer, true)
      .play();

    response = SU_setDialogChoicesAndWaitForResponse(choices);
    SU_closeDialogChoiceInterface();
    manager.GotoState(response.playGoChunk);

    while (!manager.done) {
      SleepOneFrame();
    }

    (new RER_RandomDialogBuilder in thePlayer).start()
      .dialog(new REROL_ready_to_go_now in thePlayer, true)
      .play();

    theGame.SaveUserSettings();
  }

  private function removeAllRerMapPins() {
    SU_removeCustomPinByPredicate(new SU_CustomPinRemoverPredicateFromRER in parent);
  }
}

