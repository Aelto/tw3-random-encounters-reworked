
struct HuntingGroundEntitySettings {
  var kill_threshold_distance: float;
  var allow_trophy_pickup_scene: bool;
}

statemachine class RandomEncountersReworkedHuntingGroundEntity extends CEntity {
  var master: CRandomEncounters;
  
  var entities: array<CEntity>;

  var bestiary_entry: RER_BestiaryEntry;

  var entity_settings: HuntingGroundEntitySettings;

  var bait_entity: CEntity;

  public function startEncounter(master: CRandomEncounters, entities: array<CEntity>, bestiary_entry: RER_BestiaryEntry) {
    this.master = master;
    this.entities = entities;
    this.bestiary_entry = bestiary_entry;
    this.loadSettings(master);

    LogChannel('RER', "starting RandomEncountersReworkedHuntingGroundEntity with " + entities.Size() + " " + bestiary_entry.type);

    this.GotoState('Loading');
  }

  private function loadSettings(master: CRandomEncounters) {
    this.entity_settings.kill_threshold_distance = master.settings.kill_threshold_distance;
    this.entity_settings.allow_trophy_pickup_scene = master.settings.trophy_pickup_scene;
  }

  public var bounty_manager: RER_BountyManager;
  public var is_bounty: bool;
  public var bounty_group_index: int;

  // Once activated as a bounty mode it will place a marker on the group and will
  public function activateBountyMode(bounty_manager: RER_BountyManager, group_index: int) {
    this.bounty_manager = bounty_manager;
    this.is_bounty = true;
    this.bounty_group_index = group_index;

    NLOG("activateBountyMode - " + group_index);
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
      if (((CActor)this.entities[i]).GetHealthPercents() >= 0.01) {
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
      if (VecDistanceSquared(this.entities[i].GetWorldPosition(), player_position) < 20 * 20 * ((int)((CNewNPC)this.entities[i]).IsFlying() + 1)) {
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
