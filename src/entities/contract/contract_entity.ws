
// This "Entity" is different from the others (gryphon/default) because
// It is not the entity itself but more of a manager who controls multiple
// entities.
statemachine class RandomEncountersReworkedContractEntity extends CEntity {
  var bait_entity: CEntity;
  
  // an array containing entities for the tracks when
  //  using the functions to add a  track on the ground
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
  default tracks_maximum = 200;

  public var track_resource: CEntityTemplate;

  var monster_group_position: Vector;

  event OnSpawned( spawnData : SEntitySpawnData ){
    super.OnSpawned(spawnData);

    LogChannel(
      'modRandomEncounters',
      "RandomEncountersReworkedContractEntity spawned"
    );
  }

  public function attach(entities: array<CEntity>) {
    this.entities = entities;

    this.AddTag('RandomEncountersReworked_Entity');
  }

  public function removeAllLoot() {
    var inventory: CInventoryComponent;
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      inventory = ((CActor)this.entities[i]).GetInventory();

      inventory.EnableLoot(false);
    }
  }

  public latent function start() {
    this.AddTimer('intervalLifeCheck', 10.0, true);
  }

  private function areAllEntitiesDead(): bool {
    var i: int;

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (this.entities[i]).IsAlive()) {
        return false;
      }
    }

    return true;
  }

  timer function intervalLifeCheck(optional dt : float, optional id : Int32) {
    if (this.areAllEntitiesDead()) {
      this.clean();
    }
  }

    public function addTrackHere(position: Vector, heading: EulerAngles) {
    var new_entity: CEntity;

    if (!this.tracks_looped) {
      new_entity = theGame.CreateEntity(
        this.track_resource,
        position,
        heading,
        true,
        false,
        false,
        PM_DontPersist
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

    this.Destroy();
  }
}
