
struct RER_PhasePickRegisteredPhase {
  var phase_name: name;
  var phase_chance: int;
  var longevity_cost: float;
}

state PhasePick in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State PhasePick");

    if (parent.longevity > 0) {
      this.PhasePick_pickNextPhase();
    }
    else {
      parent.endContract();
    }
  }

  entry function PhasePick_pickNextPhase() {
    var previous_phase: name;
    // represents the n-1 phase.
    var n1_phase: name;
    var registered_phases: array<RER_PhasePickRegisteredPhase>;
    var picked_phase: RER_PhasePickRegisteredPhase;

    delayIncomingEncounters();

    previous_phase = parent.getPreviousPhase();
    n1_phase = parent.getPreviousPhase(previous_phase);

    // When the longevity is this low, force the end of the contract with
    // the picked creature type. 
    if (parent.longevity <= 2) {
      // And it's always a trailcombat to give the player the time to prepare
      // for the fight in case it's a large creature.
      registered_phases.PushBack(RER_PhasePickRegisteredPhase(
        'FinalTrailCombat',
        50,
        2
      ));

      picked_phase = this.rollRegisteredPhases(registered_phases);
      
      parent.longevity = -1;
      parent.GotoState(picked_phase.phase_name);

      return;
    }

    switch (previous_phase) {
      case 'Loading':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('CluesInvestigate', 10, 1));
        if (!thePlayer.IsUsingHorse()) {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase('KneelInteraction', 10, 1));
        }
        break;

      case 'CluesInvestigate':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailChoice', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        break;

      case 'KneelInteraction':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailChoice', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 10, 2));
        break;

      case 'TrailCombat':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 10, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailChoice', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        if (n1_phase != 'KneelInteraction') {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase('KneelInteraction', 10, 1));
        }
        break;
      
      case 'TrailSplit':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 4, 2));
        break;

      case 'TrailChoice':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 4, 2));
        break;

      case 'TrailBreakoff':
        if (n1_phase != 'KneelInteraction') {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase('KneelInteraction', 5, 0.5));
        }
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('Ambush', 5, 2));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailSplit', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 10, 2));
        break;

      case 'Ambush':
        if (n1_phase != 'KneelInteraction') {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase('KneelInteraction', 10, 0.5));
        }
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailBreakoff', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailChoice', 10, 1));
        registered_phases.PushBack(RER_PhasePickRegisteredPhase('TrailCombat', 5, 2));
        break;
    }

    picked_phase = this.rollRegisteredPhases(registered_phases);

    this.printContractPhasesTree(picked_phase);

    switch (picked_phase.phase_name) {
      case 'TrailChoice':
      case 'KneelAnimation':
      case 'Ambush':
      case 'TrailBreakoff':
        if (previous_phase != 'KneelAnimation') {
          parent.trail_maker.hidePreviousTracks();
        }
        break;
    }
    
    if (picked_phase.phase_name != '__unknown__') {
      parent.longevity -= picked_phase.longevity_cost;
      parent.played_phases.PushBack(picked_phase.phase_name);
      parent.GotoState(picked_phase.phase_name);
    }
    else {
      NDEBUG("RER encountered an error, contract ending");
      LogChannel('modRandomEncounters', "Contract - State PhasePick: could not find the next phase");
      parent.endContract();
    }
  }

  // During my tests i could not finish a single contracts not because of the
  // difficulty of the contract, but because there were hunts and ambushes
  // that interrupted the gameplay and made everything harder.
  // This function was created so that whenever a phase is finished and the contract
  // goes in this state, if an encounter is supposed to be created in the new few
  // minutes, it will be delayed.
  function delayIncomingEncounters() {
    //                                     5 minutes
    if (parent.master.ticks_before_spawn < 60 * 5) {
      parent.master.GotoState('SpawningDelayed');
    }
  }

  function rollRegisteredPhases(phases: array<RER_PhasePickRegisteredPhase>): RER_PhasePickRegisteredPhase {
    var i: int;
    var max: int;
    var roll: int;

    max = 0;
    for (i = 0; i < phases.Size(); i += 1) {
      max += phases[i].phase_chance;
    }

    roll = RandRange(max);

    for (i = 0; i < phases.Size(); i += 1) {
      if (roll < phases[i].phase_chance) {
        return phases[i];
      }

      roll -= phases[i].phase_chance;
    }

    // return the last one if the list is not empty
    i = phases.Size();
    if (i > 0) {
      return phases[i - 1];
    }

    return RER_PhasePickRegisteredPhase('__unknown__', 0, 0);
  }

  public function printContractPhasesTree(next_phase: RER_PhasePickRegisteredPhase) {
    var i: int;
    var message: string;

    message = "Loading";

    for (i = 0; i < parent.played_phases.Size(); i += 1) {
      message += " -> " + NameToString(parent.played_phases[i]);
    }

    message += " -> [" + NameToString(next_phase.phase_name) + "]";
    

    LogChannel('modRandomEncounters', "Contract - State PhasePick, phases tree BEGIN");
    LogChannel('modRandomEncounters', message);
    LogChannel('modRandomEncounters', "Contract - State PhasePick, current longevity = " + parent.longevity + ", next phase cost = " + next_phase.longevity_cost);
    LogChannel('modRandomEncounters', "Contract - State PhasePick, phases tree END.");
  }
}
