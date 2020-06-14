state Spawning in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    parent.RemoveTimer('randomEncounterTick');

    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state SPAWNING");

    triggerCreaturesSpawn();
  }

  entry function triggerCreaturesSpawn() {
    var picked_entity_type: EEncounterType;

    LogChannel('modRandomEncounters', "creatures spawning triggered");
    
    if (this.shouldAbortCreatureSpawn()) {
      parent.GotoState('SpawningCancelled');

      return;
    }

    picked_entity_type = this.getRandomEntityTypeWithSettings();

    LogChannel('modRandomEncounters', "picked entity type: " + picked_entity_type);

    makeGroupComposition(picked_entity_type, parent);

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

  function getRandomEntityTypeWithSettings(): EEncounterType {
    var choice : array<EEncounterType>;

    if (theGame.envMgr.IsNight()) {
      choice = this.getRandomEntityTypeForNight();
    }
    else {
      choice = this.getRandomEntityTypeForDay();
    }

    if (choice.Size() < 1) {
      return ET_NONE;
    }

    return choice[RandRange(choice.Size())];
  }

  function getRandomEntityTypeForNight(): array<EEncounterType> {
    var choice: array<EEncounterType>;
    var i: int;

    // for (i = 0; i < parent.settings.isGroundActiveN; i += 1) {
    //   choice.PushBack(ET_GROUND);
    // }

    // TODO: add inForest factor, maybe 0.5?
    // for (i = 0; i < parent.settings.isFlyingActiveN; i += 1) {
    //   choice.PushBack(ET_FLYING);
    // }

    for (i = 0; i < parent.settings.isHumanActiveN; i += 1) {
      choice.PushBack(ET_HUMAN);
    }

    for (i = 0; i < parent.settings.isGroupActiveN; i += 1) {
      choice.PushBack(ET_GROUP);
    }

    // for (i = 0; i < parent.settings.isWildHuntActiveN; i += 1) {
    //   choice.PushBack(ET_WILDHUNT);
    // }

    return choice;
  }

  function getRandomEntityTypeForDay(): array<EEncounterType> {
    var choice: array<EEncounterType>;
    var i: int;

    // for (i = 0; i < parent.settings.isGroundActiveD; i += 1) {
    //   choice.PushBack(ET_GROUND);
    // }

    // TODO: add inForest factor, maybe 0.5?
    // for (i = 0; i < parent.settings.isFlyingActiveD; i += 1) {
    //   choice.PushBack(ET_FLYING);
    // }

    for (i = 0; i < parent.settings.isHumanActiveD; i += 1) {
      choice.PushBack(ET_HUMAN);
    }

    for (i = 0; i < parent.settings.isGroupActiveD; i += 1) {
      choice.PushBack(ET_GROUP);
    }

    // for (i = 0; i < parent.settings.isWildHuntActiveD; i += 1) {
    //   choice.PushBack(ET_WILDHUNT);
    // }

    return choice;
  }
}
