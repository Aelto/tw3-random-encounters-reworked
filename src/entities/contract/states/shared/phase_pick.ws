
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
      parent.played_phases.PushBack(previous_state_name);

      this.PhasePick_pickNextPhase(previous_state_name);
    }
    else {
      parent.endContract();
    }
  }

  entry function PhasePick_pickNextPhase(previous_phase: name) {
    // represents the n-1 phase.
    var n1_phase: name;
    var registered_phases: array<RER_PhasePickRegisteredPhase>;
    var picked_phase: RER_PhasePickRegisteredPhase;

    n1_phase = parent.getPreviousPhase(previous_phase);

    LogChannel('modRandomEncounters', "Contract - State, previous phase " + previous_phase + ", n-1 phase " + n1_phase);

    switch (previous_phase) {
      case 'Loading':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'CluesInvestigate',
          10,
          1
        ));

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'KneelInteraction',
          10,
          1
        ));
        break;

      case 'Ambush':
      case 'Combat':
        // we do this to avoid aving too many trails in the same place
        parent.trail_maker.hidePreviousTracks();

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'TrailChoice',
          10,
          1
        ));

        if (n1_phase != 'Ambush') {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase(
            'Ambush',
            5,
            1
          ));
        }

        if (n1_phase != 'TrailCombat') {
          registered_phases.PushBack(RER_PhasePickRegisteredPhase(
            'TrailCombat',
            10,
            1
          ));
        }

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'TrailBreakoff',
          10,
          1
        ));

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'KneelInteraction',
          10,
          1
        ));
        
        break;

      case 'TrailChoice':
      case 'TrailSplit':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'TrailCombat',
          10,
          1
        ));

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'TrailBreakoff',
          10,
          0.5
        ));

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'KneelInteraction',
          5,
          1
        ));

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'Ambush',
          1,
          2
        ));
        break;

      case 'KneelInteraction':
      case 'CluesInvestigate':
      case 'TrailBreakoff':
        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'TrailBreakoff',
          10,
          1
        ));

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'TrailCombat',
          5,
          1
        ));

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'Ambush',
          5,
          2
        ));

        registered_phases.PushBack(RER_PhasePickRegisteredPhase(
          'TrailChoice',
          10,
          1
        ));
        break;
    }

    picked_phase = this.rollRegisteredPhases(registered_phases);

    if (picked_phase.phase_name != '__unknown__') {
      parent.longevity -= picked_phase.longevity_cost;
      parent.GotoState(picked_phase.phase_name);
    }
    else {
      NDEBUG("RER encountered an error, contract ending");
      LogChannel('modRandomEncounters', "Contract - State PhasePick: could not find the next phase");
      parent.endContract();
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
}
