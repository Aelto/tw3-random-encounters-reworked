
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

  public var automatic_kill_threshold_distance: float;
  default automatic_kill_threshold_distance = 200;

  public var allow_trophy: bool;

  var entities: array<CEntity>;

  //#region shared variables between states

  public var trail_maker: RER_TrailMaker;
  public var blood_maker: RER_TrailMaker;
  public var corpse_maker: RER_TrailMaker;

  public var track_resource: CEntityTemplate;

  // it contains a list of corpse resources, useful when creating clues
  var corpse_reources: array<CEntityTemplate>;

  public function getRandomCorpseResource(): CEntityTemplate {
    return this.corpse_reources[RandRange(this.corpse_reources.Size())];
  }

  var chosen_bestiary_entry: RER_BestiaryEntry;
  
  var number_of_creatures: int;

  //#endregion shared variables between states

  //#region variables made in `CluesInvestigate`
  var investigation_center_position: Vector;
  var investigation_last_clues_position: Vector;

  // set to true if the position was forced by external code.
  var forced_investigation_center_position: bool;
  
  //#endregion variables made in `CluesInvestigate`

  //#region variables used in `CluesFollow`

  // this is the position where the last combat took place
  var last_clues_follow_final_position: Vector;

  // this is position where the next combat will take place
  var final_point_position: Vector;

  //#endregion variables used in `CluesFollow`

  //#region variables used in `CombatLoop`

  // chances used to determine if the phase should loop, expressed in %
  var looping_chances: float;
  default looping_chances = 60;

  // everytime it loops the looping_chances are decreased by this value
  var looping_chances_decrease: float;
  default looping_chances_decrease = 15;

  // indicates if the combat looped.
  // It changes a few things in the `CluesFollow` state when set to true
  var has_combat_looped: bool;
  default has_combat_looped = false;
  //#endregion variables used in `CombatLoop`

  event OnSpawned( spawnData : SEntitySpawnData ){
    super.OnSpawned(spawnData);

    LogChannel(
      'modRandomEncounters',
      "RandomEncountersReworkedContractEntity spawned"
    );
  }


  public function removeAllLoot() {
    var inventory: CInventoryComponent;
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      inventory = ((CActor)this.entities[i]).GetInventory();

      inventory.EnableLoot(false);
    }
  }

  public function forcePosition(position: Vector) {
    this.forced_investigation_center_position = true;
    this.investigation_center_position = position;
  }


  public latent function startContract(master: CRandomEncounters) {
    this.master = master;

    this.automatic_kill_threshold_distance = master.settings.kill_threshold_distance * 3;

    this.allow_trophy = master.settings
    .trophies_enabled_by_encounter[EncounterType_CONTRACT];

    this.pickRandomBestiaryEntry();

    this.AddTimer('intervalLifeCheck', 10.0, true);

    this.GotoState('CluesInvestigate');
  }

  public latent function pickRandomBestiaryEntry() {
    this.chosen_bestiary_entry = this
      .master
      .bestiary
      .getRandomEntryFromBestiary(this.master, EncounterType_CONTRACT);

    this.number_of_creatures = rollDifficultyFactor(
      this.chosen_bestiary_entry.template_list.difficulty_factor,
      this.master.settings.selectedDifficulty,
      this.master.settings.enemy_count_multiplier
    );

    LogChannel('modrandomencounters', "chosen bestiary entry" + this.chosen_bestiary_entry.type);
  }


  public function areAllEntitiesDead(): bool {
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).IsAlive()) {
        return false;
      }
    }

    return true;
  }

  public function hasOneOfTheEntitiesGeraltAsTarget(): bool {
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).HasAttitudeTowards(thePlayer)) {
        return true;
      }
    }

    return false;
  }


  timer function intervalLifeCheck(optional dt : float, optional id : Int32) {
    var distance_from_player: float;

    if (this.GetCurrentStateName() == 'Ending') {
      return;
    }

    if (this.GetCurrentStateName() == 'CluesInvestigate'
    && VecDistanceSquared(this.investigation_center_position, thePlayer.GetWorldPosition())
     > this.master.settings.kill_threshold_distance * this.master.settings.kill_threshold_distance) {
      this.endContract();
    }

    if (this.GetCurrentStateName() == 'CluesFollow') {
      distance_from_player = VecDistance(
        this.final_point_position,
        thePlayer.GetWorldPosition()
      );
    }
    else {
      distance_from_player = VecDistance(
        this.GetWorldPosition(),
        thePlayer.GetWorldPosition()
      );
    }

    if (distance_from_player > this.automatic_kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
      this.endContract();

      return;
    }
  }

  public function endContract() {
    if (this.GetCurrentStateName() != 'Ending') {
      this.GotoState('Ending');
    }
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

  event OnDestroyed() {
    LogChannel('modRandomEncounters', "Contract hit destroyed");
    // super.OnDestroyed();
  }
}
