
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

  var bait_entity: CEntity;

  var entities: array<CEntity>;

  //#region shared variables between states

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
  
  // those clues were created during the Investigate state
  // and removing as soon as the state ends would be too soon.
  // And leaving them in the world woulb be worse, so these
  // entities will be cleared when the contract ends.
  var investigation_clues: array<CEntity>;

  var investigation_center_position: Vector;
  var investigation_last_clues_position: Vector;
  
  //#endregion variables made in `CluesInvestigate`

  //#region variables used in `CluesFollow`

  // this is the position the 
  var last_clues_follow_final_position: Vector;

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


  public latent function startContract(master: CRandomEncounters) {
    this.master = master;

    this.AddTimer('intervalLifeCheck', 10.0, true);

    this.GotoState('CluesInvestigate');
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
    if (this.GetCurrentStateName() == 'Ending') {
      this.clean();
    }

    if (this.GetCurrentStateName() == 'CluesInvestigate'
    && VecDistanceSquared(this.investigation_center_position, thePlayer.GetWorldPosition())
     > this.master.settings.kill_threshold_distance * this.master.settings.kill_threshold_distance) {
       this.clean();
    }
  }

  // an array containing entities for the tracks when
  // using the functions to add a  track on the ground
  // it adds one to the array, unless we reached the maximum
  // number of tracks. At this moment we come back to 0 and
  // start using the _tracks_index and set _tracks_looped  
  // to true to tell we have already reached the maximum once.
  // And now instead of creating a new track Entity we simply
  // move the old one at _tracks_index.
  var tracks_entities: array<CEntity>;
  var tracks_index: int;
  var tracks_looped: bool;
  default tracks_looped = false;
  var tracks_maximum: int;
  default tracks_maximum = 600;

  public function addTrackHere(position: Vector, heading: EulerAngles) {
    var new_entity: CEntity;

    if (!this.tracks_looped) {
      new_entity = theGame.CreateEntity(
        this.track_resource,
        position,
        heading
      );

      this.tracks_entities.PushBack(new_entity);

      if (this.tracks_entities.Size() == this.tracks_maximum) {
        this.tracks_looped = true;
      }

      return;
    }

    this.tracks_entities[this.tracks_index]
      .TeleportWithRotation(position, RotRand(0, 360));

    this.tracks_index = (this.tracks_index + 1) % this.tracks_maximum;
  }

  public var blood_resources: array<CEntityTemplate>;
  public var blood_resources_size: int;

  // an array containing entities for the blood tracks when
  //  using the functions to add a blood track on the ground
  // it adds one to the array, unless we reached the maximum
  // number of tracks. At this moment we come back to 0 and
  // start using the blood_tracks_index and set blood_tracks_looped  
  // to true to tell we have already reached the maximum once.
  // And now instead of creating a new track Entity we simply
  // move the old one at blood_tracks_index.
  var blood_tracks_entities: array<CEntity>;
  var blood_tracks_index: int;
  var blood_tracks_looped: bool;
  default blood_tracks_looped = false;
  var blood_tracks_maximum: int;
  default blood_tracks_maximum = 200;

  public function getRandomBloodResource(): CEntityTemplate {
    return this.blood_resources[RandRange(this.blood_resources_size)];
  }

  public function addBloodTrackHere(position: Vector) {
    var new_entity: CEntity;

    if (!this.blood_tracks_looped) {
      new_entity = theGame.CreateEntity(
        this.getRandomBloodResource(),
        position,
        RotRand(0, 360),
        true,
        false,
        false,
        PM_DontPersist
      );

      this.blood_tracks_entities.PushBack(new_entity);

      if (this.blood_tracks_entities.Size() == this.blood_tracks_maximum) {
        this.blood_tracks_looped = true;
      }

      return;
    }

    this.blood_tracks_entities[this.blood_tracks_index].TeleportWithRotation(position, RotRand(0, 360));

    this.blood_tracks_index = (this.blood_tracks_index + 1) % this.blood_tracks_maximum;
  }


  private function clean() {
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

    // clearing any clues created during the investigation state
    for (i = 0; i < this.investigation_clues.Size(); i += 1) {
      ((CActor)this.investigation_clues[i])
        .Destroy();
    }

    this.investigation_clues.Clear();

    this.Destroy();
  }

  event OnDestroyed() {
    LogChannel('modRandomEncounters', "Contract hit destroyed");
    // super.OnDestroyed();
  }
}
