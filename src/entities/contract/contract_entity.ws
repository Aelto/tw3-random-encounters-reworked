
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

  // this boolean is mainly used in the starting phases, to know if a camera scene
  // should be played or not, or if a series of oneliners should run.
  var started_from_noticeboard: bool;

  // this variable stores the last important position from the previous phase
  // It's useful when chaining many phases and when the next phase needs to know
  // where the previous phase ended
  var previous_phase_checkpoint: Vector;

  // everytime the entity goes into the PhasePick state, it stores the previous
  // phase that was played. It's useful when a state needs to know how many times
  // it's been played already, or if it needs to know if another state was played
  var played_phases: array<name>;

  // this variables stores the longevity of the encounter. Once the float value
  // reaches 0, it means the encounter cannot create any more phases and it should
  // stop after the current phase. It is a float an not a int because some phases
  // will cost more than some others. And some may have a 0.5 cost while other could
  // go up to 2 or 3.
  var longevity: float;

  // a normalized heading that represent the direction the contract should
  // head to whenever a new position has to be picked.
  // This allows the contract to progress
  var phase_transition_heading: float;

  // this an internal variable to know if a custom heading was set.
  private var use_phase_transitation_heading: bool;

  public latent function startEncounter(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry) {
    this.master = master;
    this.bestiary_entry = bestiary_entry;
    this.number_of_creatures = rollDifficultyFactor(
      this.bestiary_entry.template_list.difficulty_factor,
      this.master.settings.selectedDifficulty,
      this.master.settings.enemy_count_multiplier
    );
    this.loadSettings(master);
    this.previous_phase_checkpoint = thePlayer.GetWorldPosition();

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
      .enable_encounters_loot;

    this.longevity = master
      .settings
      .monster_contract_longevity;

    if (!this.use_phase_transitation_heading) {
      this.phase_transition_heading = RandRange(360);
    }
  }

  public function setPhaseTransitionHeading(heading: float) {
    this.use_phase_transitation_heading = true;
    this.phase_transition_heading = heading;
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
      this.previous_phase_checkpoint,
      thePlayer.GetWorldPosition()
    );

    if (distance_from_player > this.entity_settings.kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.entity_settings.kill_threshold_distance);
      this.endContract();

      return;
    }
  }

  ///////////////////////////////////////////////////
  // below are helper functions used in the states //
  ///////////////////////////////////////////////////

  //
  // get the number of times the supplied phase was played
  public function playedPhaseCount(phase: name): int {
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
  public function getPreviousPhase(optional ignore_phase: name): name {
    var count: int;
    var phase: name;

    count = this.played_phases.Size();

    if (count == 0) {
      return 'Loading';
    }

    phase = this.played_phases[count - 1];

    // this function excludes the PhasePick phase, so if the previous phase was
    // PhasePick we try to go one phase lower.
    if (phase == 'PhasePick' || phase == ignore_phase) {
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
  // remove the dead entities from the list of entities
  public function removeDeadEntities() {
     var i: int;
     var max: int;

     max = this.entities.Size();

     for (i = 0; i < max; i += 1) {
       if (!((CActor)this.entities[i]).IsAlive()) {
         this.entities.Remove(this.entities[i]);

         max -= 1;
         i -= 1;
       }
     }
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
  // returns true if none of the contract entities is nearby
  // can also be used to know if at least one creature is nearby
  function areAllEntitiesFarFromPlayer(): bool {
    var player_position: Vector;
    var i: int;

    player_position = thePlayer.GetWorldPosition();

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (VecDistanceSquared(this.entities[i].GetWorldPosition(), player_position) < 30 * 30 * ((int)((CNewNPC)this.entities[i]).IsFlying() + 1)) {
        return false;
      }
    }

    return true;
  }

  //
  // play a camera scene that will show the supplied position. Mainly used in the
  // starting phases if the contract was started from a noticeboard, to show
  // the player where the contract is.
  public latent function playContractEncounterCameraScene(position: Vector) {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;

    if(this.master.settings.disable_camera_scenes) {
      return;
    }

    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(0.3, 0, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    scene.look_at_target_static = position;

    // scene.velocity_type = RER_CameraVelocityType_FORWARD;
    // scene.velocity = Vector(0.005, 0.005, 0.02);

    scene.duration = 3;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();
    camera.playCameraScene(scene, true);
  }

  //
  // updates the phase transition heading based on the new position that is
  // going to be picked. Note that it updates it just slightly, it tries to keep
  // the old heading and pick a mean value between the two.
  public function updatePhaseTransitionHeading(old_position: Vector, new_position: Vector) {
    var new_heading: float;

    new_heading = VecHeading(new_position - old_position);

    // the current phase_transition_heading has more weight so the transition
    // isn't too abrupt.
    this.phase_transition_heading =
      (this.phase_transition_heading * 2 + new_heading) / 3;
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
