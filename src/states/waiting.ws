
state Waiting in CRandomEncounters {
  var ecosystem_frequency_multiplier: float;
  
  // a second multiplier that multiplies the multiplier...
  // this value is obtained from the menu.
  var ecosystem_frequency_multiplier_multiplier: float;

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
    var ticks: float;

    this.ecosystem_frequency_multiplier = this.getNewEcosystemFrequencyMultiplier();

    // we update the value from the menu every time we start waiting.
    this.ecosystem_frequency_multiplier_multiplier = StringToFloat(
      theGame.GetInGameConfigWrapper()
      .GetVarValue('RERencountersGeneral', 'RERecosystemFrequencyMultiplier')
    ) * 0.01;

    NLOG("RERecosystemFrequencyMultiplier = " + this.ecosystem_frequency_multiplier);
    NLOG("RERecosystemFrequencyMultiplier [menu] = " + this.ecosystem_frequency_multiplier_multiplier);

    while (parent.ticks_before_spawn >= 0) {
      if (this.ecosystem_frequency_multiplier > 0) {
        parent.ticks_before_spawn -= 1 / (
            1
            + this.ecosystem_frequency_multiplier
            * this.ecosystem_frequency_multiplier_multiplier
          );
      }
      else if (this.ecosystem_frequency_multiplier < 0) {
        parent.ticks_before_spawn -= 1 * (
            1
            + this.ecosystem_frequency_multiplier
            * this.ecosystem_frequency_multiplier_multiplier
          );
      }

      NLOG("parent.ticks_before_spawn = " + parent.ticks_before_spawn);

      parent.ticks_before_spawn -= 1 *
        MaxF(
          0, // cannot go below 0 obvsiouly

          this.ecosystem_frequency_multiplier
          * this.ecosystem_frequency_multiplier_multiplier
          * -1 // we invert the number in the end as a positive
        );

      // we refresh the ecosystem effects on frequencies every 30 seconds
      if (ModF(parent.ticks_before_spawn, 30.0) == 0) {
        this.ecosystem_frequency_multiplier = this.getNewEcosystemFrequencyMultiplier();
      }

      Sleep(1);
    }
  }

  function calculateRandomTicksBeforeSpawn(): int {
    if (theGame.envMgr.IsNight()) {
      return RandRange(parent.settings.customNightMin, parent.settings.customNightMax)
           + parent.settings.additional_delay_per_player_level;
    }

    return RandRange(parent.settings.customDayMin, parent.settings.customDayMax)
         + parent.settings.additional_delay_per_player_level;
  }

  function getNewEcosystemFrequencyMultiplier(): float {
    return parent.ecosystem_manager
      .getEcosystemAreasFrequencyMultiplier(parent.ecosystem_manager.getCurrentEcosystemAreas());
  }
}
