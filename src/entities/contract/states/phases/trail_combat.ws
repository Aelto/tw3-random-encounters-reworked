
// A trail is created is created from the previous checkpoint to a random position
// where creatures will be waiting
state TrailCombat in RandomEncountersReworkedContractEntity extends TrailPhase {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State TrailCombat");

    this.TrailCombat_main();
  }

  var destination: Vector;

  entry function TrailCombat_main() {
    this.TrailCombat_start();
  }

  latent function TrailCombat_start() {
    if (!this.getNewTrailDestination(this.destination, 0.5)) {
      LogChannel('modRandomEncounters', "Contract - State TrailCombat, could not find trail destination");
      parent.endContract();

      return;
    }

    parent.updatePhaseTransitionHeading(
      parent.previous_phase_checkpoint,
      this.destination
    );

    this.drawTrailsToWithCorpseDetailsMaker(
      this.destination,
      parent.number_of_creatures
    );

    this.play_oneliner_begin();

    this.spawnRandomMonster();

    this.waitForPlayerToReachPoint(this.destination, 15);

    REROL_there_you_are(true);

    parent.previous_phase_checkpoint = parent.trail_maker.getLastPlacedTrack().GetWorldPosition();

    parent.GotoState('Combat');
  }

  latent function play_oneliner_begin() {
    var previous_phase: name;

    previous_phase = parent.getPreviousPhase('Ambush');

    if (previous_phase == 'TrailBreakoff') {
      REROL_trail_goes_on(true);
    }
  }

  latent function spawnRandomMonster() {
    var bestiary_entry: RER_BestiaryEntry;

    bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary(
        parent.master,
        EncounterType_CONTRACT,
        , // for bounty
        (new RER_SpawnRollerFilter in parent)
          .init()
          .setOffsets(CreatureDRACOLIZARD, CreatureMAX)
      );

    parent.entities = bestiary_entry.spawn(
      parent.master,
      this.destination,
      ,,
      EncounterType_CONTRACT
    );
  }

  latent function waitForPlayerToReachPoint_action(): bool {
    SUH_keepCreaturesOnPoint(
      this.destination,
      20,
      parent.entities,
    );

    // tell it to stop waiting if one creature targets Geralt
    return parent.hasOneOfTheEntitiesGeraltAsTarget();
  }

}
