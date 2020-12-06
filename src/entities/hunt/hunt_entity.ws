
struct HuntEntitySettings {
  var kill_threshold_distance: float;
  var allow_trophy_pickup_scene: bool;
}

statemachine class RandomEncountersReworkedHuntEntity extends CEntity {
  var master: CRandomEncounters;
  
  var entities: array<CEntity>;

  var bestiary_entry: RER_BestiaryEntry;

  var entity_settings: HuntEntitySettings;

  var bait_entity: CEntity;

  var trail_maker: RER_TrailMaker;

  var bait_moves_towards_player: bool;

  public function startEncounter(master: CRandomEncounters, entities: array<CEntity>, bestiary_entry: RER_BestiaryEntry, optional bait_moves_towards_player: bool) {
    this.master = master;
    this.entities = entities;
    this.bestiary_entry = bestiary_entry;
    this.bait_moves_towards_player = bait_moves_towards_player;
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
      "RandomEncountersReworkedHuntEntity destroyed"
    );

    this.RemoveTimer('randomEncounterTick');

    for (i = 0; i < this.entities.Size(); i += 1) {
      this.killEntity(this.entities[i]);
    }

    trail_maker.clean();

    this.Destroy();
  }

  ///////////////////////////////////////////////////
  // below are helper functions used in the states //
  ///////////////////////////////////////////////////

  public function areAllEntitiesDead(): bool {
    var i: int;

    // LogChannel('RER', "HuntEntity - areAllEntitiesDead, entity size = " + this.entities.Size());

    for (i = 0; i < this.entities.Size(); i += 1) {
      if (((CActor)this.entities[i]).IsAlive()) {
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

  // It's a timer that is called during the `clues_follow` state. The goal
  // is to increase the amount of ambushes and hunts while the player is following
  // the clues to the final point.
  timer function randomEncounterTick(optional delta: float, optional id: Int32) {
    this.master.ticks_before_spawn -= 1;
  }
}
