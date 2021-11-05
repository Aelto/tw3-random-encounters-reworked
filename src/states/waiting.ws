
state Waiting in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state WAITING");

    parent.ticks_before_spawn = this.calculateRandomTicksBeforeSpawn();

    if (previous_state_name == 'SpawningCancelled') {
      parent.ticks_before_spawn = parent.ticks_before_spawn / 3;
    }

    if (parent.rExtra.isPlayerInSettlement()) {
      parent.ticks_before_spawn = (int)(parent.ticks_before_spawn * parent.settings.settlement_delay_multiplier);
    }

    LogChannel('modRandomEncounters', "waiting " + parent.ticks_before_spawn + " ticks");

    this.startWaiting();
  }

  entry function startWaiting() {
    var time_before_updating_frequency_multiplier: float;
    var ticks: float;

    parent.refreshEcosystemFrequencyMultiplier();

    time_before_updating_frequency_multiplier = 30;

    while (parent.ticks_before_spawn >= 0) {
      ticks = 1
            * parent.ecosystem_frequency_multiplier
            * parent.ecosystem_frequency_multiplier_multiplier;

      parent.ticks_before_spawn -= ticks;
      time_before_updating_frequency_multiplier -= ticks;

      // we refresh the ecosystem effects on frequencies every 30 seconds or so
      if (time_before_updating_frequency_multiplier <= 0) {
        parent.refreshEcosystemFrequencyMultiplier();
      }

      Sleep(5);
    }

    parent.GotoState('Spawning');
  }

  function calculateRandomTicksBeforeSpawn(): int {
    if (theGame.envMgr.IsNight()) {
      return RandRange(parent.settings.customNightMin, parent.settings.customNightMax)
           + parent.settings.additional_delay_per_player_level;
    }

    return RandRange(parent.settings.customDayMin, parent.settings.customDayMax)
         + parent.settings.additional_delay_per_player_level;
  }
}
