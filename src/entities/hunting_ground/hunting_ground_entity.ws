
struct HuntEntitySettings {
  var kill_threshold_distance: float;
  var allow_trophy_pickup_scene: bool;
}

statemachine class RandomEncountersReworkedHuntingGroundEntity extends CEntity {
  var master: CRandomEncounters;
  
  var entities: array<CEntity>;

  var bestiary_entry: RER_BestiaryEntry;

  var entity_settings: HuntEntitySettings;

  var bait_entity: CEntity;

  public function startEncounter(master: CRandomEncounters, entities: array<CEntity>, bestiary_entry: RER_BestiaryEntry) {
    this.master = master;
    this.entities = entities;
    this.bestiary_entry = bestiary_entry;
    this.loadSettings(master);
    this.GotoState('Loading');
  }

  private function loadSettings(master: CRandomEncounters) {
    this.entity_settings.kill_threshold_distance = master.settings.kill_threshold_distance;
    this.entity_settings.allow_trophy_pickup_scene = master.settings.trophy_pickup_scene;
  }

  public latent function clean() {
    var i: int;

    LogChannel(
      'modRandomEncounters',
      "RandomEncountersReworkedHuntingGroundEntity destroyed"
    );

    for (i = 0; i < this.entities.Size(); i += 1) {
      this.killEntity(this.entities[i]);
    }

    this.Destroy();
  }

  ///////////////////////////////////////////////////
  // below are helper functions used in the states //
  ///////////////////////////////////////////////////

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

  public function areAllEntitiesFarFromPlayer(): bool {
    var player_position: Vector;
    var i: int;

    player_position = thePlayer.GetWorldPosition();

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (VecDistanceSquared(this.entities[i].GetWorldPosition(), player_position) < 20 * 20) {
        return false;
      }
    }

    return true;
  }

  public function killEntity(entity: CEntity): bool {
    ((CActor)entity).Kill('RandomEncountersReworked_Entity', true);

    return this.entities.Remove(entity);
  }

  public function getRandomEntity(): CEntity {
    var entity: CEntity;

    entity = this.entities[RandRange(this.entities.Size())];

    return entity;
  }
}
