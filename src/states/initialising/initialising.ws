
state Initialising in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("Entering state Initialising");

    this.startInitialising();
  }

  entry function startInitialising() {
    parent.spawn_roller.fill_arrays();

    parent.bestiary.init();
    parent.bestiary.loadSettings();

    if (parent.settings.shouldResetRERSettings(theGame.GetInGameConfigWrapper())) {
      this.displayPresetChoiceDialogeMenu();
    }

    parent.settings.loadXMLSettings();
    parent.resources.load_resources();

    parent.events_manager.init(parent);
    parent.events_manager.start();

    parent.ecosystem_manager.init(parent);
    parent.bounty_manager.init(parent);
    parent.horde_manager.init(parent);
    parent.contract_manager.init(parent);

    parent.storages = RER_loadStorageCollection();

    RER_tutorialTryShowStarted();
    
    LogChannel('RER', "ecosystem areas storage count = " + parent.storages
      .ecosystem
      .ecosystem_areas.Size());

    parent.GotoState('Loading');
  }

  latent function displayPresetChoiceDialogeMenu() {
    var choices: array<SSceneChoice>;
    var manager: RER_PresetManager;
    var response: SSceneChoice;

    manager = new RER_PresetManager in this;
    manager.master = parent;

    choices = manager.getChoiceList();

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

    theGame.GetInGameConfigWrapper().SetVarValue('RERmain', 'RERmodInitialized', 1);
    theGame.SaveUserSettings();

  }

}

