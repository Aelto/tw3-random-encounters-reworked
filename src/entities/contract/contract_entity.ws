
struct ContractEntitySettings {
  var kill_threshold_distance: float;
  var allow_trophies: bool;
  var allow_trophy_pickup_scene: bool;
  var enable_loot: bool;
}

// This "Entity" is different from the others (gryphon/default) because
// it is not the entity itself but more of a manager who controls multiple
// entities.
//
// It has many states, so i'll explain what each state does and in which
// order it enters these states.
//
// - The first state called `CluesInvestigate` is where it all starts, Geralt find clues
//   on the ground and can choose to follow them.
//   A few tracks are created and if the player gets near them it goes to the
//   `CluesFollow` state.
//   
// - the`CluesFollow` state creates more tracks up to a point. When Geralt
//   reaches this point he can find another `CluesStart` or the next state.
//   During the `CluesStart` state Geralt can also be ambushes by either necrophages
//   or bandits.
//
// - The `Combat` state, it's just Geralt fighting the monsters until they die.
//   On death the monster drops a few crowns and also some items belonging
//   to the villagers Geralt found on `CluesStart`.
//   After this state it can either end here or loop to either `CluesFollow`
//   or the next state `CombatAmbush`
//
// - The `CombatAmbush` is a small state where it prepares an ambush after the initial
//   `Combat` state. This state simply creates an ambush and it goes back to `Combat`
statemachine class RandomEncountersReworkedContractEntity extends CEntity {
  var master: CRandomEncounters;

  var entities: array<CEntity>;

  var bestiary_entry: RER_BestiaryEntry;
  
  var number_of_creatures: int;

  var entity_settings: ContractEntitySettings;

  var trail_maker: RER_TrailMaker;

  var blood_maker: RER_TrailMaker;

  var corpse_maker: RER_TrailMaker;

  // this variable stores the last important position from the previous phase
  // It's useful when chaining many phases and when the next phase needs to know
  // where the previous phase ended
  var previous_phase_checkpoint: Vector;

  // everytime the entity goes into the PhasePick state, it stores the previous
  // phase that was played. It's useful when a state needs to know how many times
  // it's been played already, or if it needs to know if another state was played
  var played_phases: array<name>;

  public latent function startEncounter(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry) {
    this.master = master;
    this.bestiary_entry = bestiary_entry;
    this.number_of_creatures = rollDifficultyFactor(
      this.bestiary_entry.template_list.difficulty_factor,
      this.master.settings.selectedDifficulty,
      this.master.settings.enemy_count_multiplier
    );
    this.loadSettings(master);

    this.AddTimer('intervalLifeCheck', 10.0, true);
    this.GotoState('Loading');
  }

  private function loadSettings(master: CRandomEncounters) {
    this.entity_settings.kill_threshold_distance = master.settings.kill_threshold_distance;
    this.entity_settings.allow_trophy_pickup_scene = master.settings.trophy_pickup_scene;
    this.entity_settings.allow_trophies = master
      .settings
      .trophies_enabled_by_encounter[EncounterType_CONTRACT];
    this.entity_settings.enable_loot = master
      .settings
      .enable_encounters_loot
  }

  public latent function clean() {
    var i: int;

    LogChannel(
      'modRandomEncounters',
      "RandomEncountersReworkedContractEntity destroyed"
    );

    this.RemoveTimer('intervalLifeCheck');

    for (i = 0; i < this.entities.Size(); i += 1) {
      ((CActor)this.entities[i])
        .Kill('RandomEncountersReworkedContractEntity', true);
    }

    trail_maker.clean();
    blood_maker.clean();
    corpse_maker.clean();

    this.Destroy();
  }

  timer function intervalLifeCheck(optional dt : float, optional id : Int32) {
    var distance_from_player: float;

    if (this.GetCurrentStateName() == 'Ending') {
      return;
    }

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    if (distance_from_player > this.automatic_kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
      this.endContract();

      return;
    }
  }

  ///////////////////////////////////////////////////
  // below are helper functions used in the states //
  ///////////////////////////////////////////////////

  //
  // get the number of times the supplied phase was played
  public function playedPhaseCount(phase: name) {
    var i: int;
    var count: int;

    count = 0;

    for (i = 0; i < this.played_phases.Size(); i += 1) {
      if (phase == this.played_phases[i]) {
        count += 1;
      }
    }

    return count;
  }

  //
  // get the name of the previous phase (excluding the 'phase_pick' phase)
  public function getPreviousPhase(): name {
    var count: int;
    var phase: name;

    count = this.played_phases.Size();

    if (count == 0) {
      return '';
    }

    phase = this.played_phases[count - 1];

    // this function excludes the PhasePick phase, so if the previous phase was
    // PhasePick we try to go one phase lower.
    if (phase == 'PhasePick') {
      count -= 1;

      if (count == 0) {
        return '';
      }

      phase = this.played_phases[count - 1];
    }

    return phase;
  }

  //
  // removes the loot of all current entities
  public function removeAllLoot() {
    var inventory: CInventoryComponent;
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      inventory = ((CActor)this.entities[i]).GetInventory();

      inventory.EnableLoot(false);
    }
  }

  //
  // returns if all current entities are dead
  public function areAllEntitiesDead(): bool {
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).IsAlive()) {
        return false;
      }
    }

    return true;
  }

  //
  // returns if one of the current entities has geralt as a target
  public function hasOneOfTheEntitiesGeraltAsTarget(): bool {
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).HasAttitudeTowards(thePlayer) || ((CNewNPC)this.entities[i]).GetTarget() == thePlayer) {
        return true;
      }
    }

    return false;
  }

  //
  // ends the encounter by going into the Ending state
  public function endContract() {
    if (this.GetCurrentStateName() != 'Ending') {
      this.GotoState('Ending');
    }
  }

  event OnDestroyed() {
    LogChannel('modRandomEncounters', "Contract hit destroyed");
    // super.OnDestroyed();
  }
}
