
class RandomEncountersReworkedEntity extends CEntity {
  // an invisible entity used to bait the entity
  var bait_entity: CEntity;

  // control whether the entity goes towards a bait
  // or the player
  var go_towards_bait: bool;
  default go_towards_bait = false;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  private var tracks_template: CEntityTemplate;
  private var tracks_entities: array<CEntity>;

  event OnSpawned( spawnData : SEntitySpawnData ){
		super.OnSpawned(spawnData);

    LogChannel('modRandomEncounters', "RandomEncountersEntity spawned");
	}

  public function attach(actor: CActor, newnpc: CNewNPC, this_entity: CEntity) {
    this.this_actor = actor;
    this.this_newnpc = newnpc;
    this.this_entity = this_entity;

		this.CreateAttachment( this_entity );
    this.AddTag('RandomEncountersReworked_Entity');
  }

  // entry point when creating an entity who will
  // follow a bait and leave tracks behind her.
  // more suited for: `EncounterType_HUNT`
  // NOTE: this functions calls `startWithoutBait`
  public function startWithBait(bait_entity: CEntity) {
    this.bait_entity = bait_entity;
    this.go_towards_bait = true;

    ((CNewNPC)this.bait_entity).SetGameplayVisibility(false);
    ((CNewNPC)this.bait_entity).SetVisibility(false);		
    ((CActor)this.bait_entity).EnableCharacterCollisions(false);
    ((CActor)this.bait_entity).EnableDynamicCollisions(false);
    ((CActor)this.bait_entity).EnableStaticCollisions(false);
    ((CActor)this.bait_entity).SetImmortalityMode(AIM_Immortal, AIC_Default);  

    this.startWithoutBait();
  }

  // entry point when creating an entity who will
  // directly target the player.
  // more suited for: `EncounterType_DEFAULT`
  public function startWithoutBait() {
    // TODO: create a function getTracksTemplateByCreatureType
    this.tracks_template = (CEntityTemplate)LoadResource(
      "quests\generic_quests\skellige\quest_files\mh202_nekker_warrior\entities\mh202_nekker_tracks.w2ent",
      true
    );

    if (this.go_towards_bait) {
      AddTimer('intervalHuntFunction', 2, true);
    }
    else {
      AddTimer('intervalDefaultFunction', 2, true);
      AddTimer('teleportBait', 10, true);
    }
  }

  timer function intervalDefaultFunction(optional dt : float, optional id : Int32) {
    var distance_from_player: float;

    if (!this.this_actor.IsAlive()) {
      this.clean();

      return;
    }

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    if (distance_from_player > 100) {
      this.clean();

      return;
    }

    LogChannel('modRandomEncounters', "distance from player : " + distance_from_player);

    this.this_newnpc.NoticeActor(thePlayer);

    if (distance_from_player < 30) {
      // the creature is close enough to fight thePlayer,
      // we do not need this intervalFunction anymore.
      this.RemoveTimer('intervalDefaultFunction');

      this.AddTimer('intervalLifecheckFunction', 10, true);
    }
  }

  timer function intervalHuntFunction(optional dt : float, optional id : Int32) {
    var distance_from_player: float;
    var distance_from_bait: float;
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;

    if (!this.this_newnpc.IsAlive()) {
      this.clean();

      return;
    }

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    distance_from_bait = VecDistance(
      this.GetWorldPosition(),
      this.bait_entity.GetWorldPosition()
    );

    LogChannel('modRandomEncounters', "distance from player : " + distance_from_player);
    LogChannel('modRandomEncounters', "distance from bait : " + distance_from_bait);

    if (distance_from_player > 200) {
      this.clean();

      return;
    }

    if (distance_from_player < 20) {
      this.this_newnpc.NoticeActor(thePlayer);

      // the creature is close enough to fight thePlayer,
      // we do not need this intervalFunction anymore.
      this.RemoveTimer('intervalHuntFunction');
      this.RemoveTimer('teleportBait');
      this.AddTimer('intervalLifecheckFunction', 10, true);

      // we also kill the bait
      this.bait_entity.Destroy();

      this.this_actor
        .GetMovingAgentComponent()
        .SetGameplayRelativeMoveSpeed(-1);
    }
    else {
      this.this_actor
        .GetMovingAgentComponent()
        .SetGameplayRelativeMoveSpeed(1);

      this.this_newnpc.NoticeActor((CActor)this.bait_entity);

      if (distance_from_bait < 5) {
        new_bait_position = this.GetWorldPosition() + VecConeRand(this.GetHeading(), 90, 10, 20);
        new_bait_rotation = this.GetWorldRotation();
        new_bait_rotation.Yaw += RandRange(-20,20);
        
        this.bait_entity.TeleportWithRotation(
          new_bait_position,
          new_bait_rotation
        );
      }

      this.createTracksOnGround();
    }  
  }

  private function createTracksOnGround() {
    var new_track: CEntity;
    var position: Vector;
    var rotation: EulerAngles;

    position = this.GetWorldPosition();
    rotation = this.GetWorldRotation();

    if (getGroundPosition(position)) {
      new_track = theGame.CreateEntity(
        this.tracks_template,
        position,
        rotation
      );

      this.tracks_entities.PushBack(new_track);

      if (this.tracks_entities.Size() > 200) {
        // TODO: clearly not great performance wise.
        // we could add an index variable going from 0 to 200
        // and once it has reached 200 goes back to 0 and we start
        // destroying the old track and replace it with the new one.
        // Or even better, only change the position of the old one.
        this.tracks_entities[0].Destroy();
        this.tracks_entities.Remove(this.tracks_entities[0]);
      }
    }
  }

  // simple interval function call every ten seconds or so to check if the creature is
  // still alive. Starts the cleaning process if not, and eventually triggers some events.
  timer function intervalLifecheckFunction(optional dt: float, optional id: Int32) {
    var distance_from_player: float;

    if (!this.this_newnpc.IsAlive()) {
      this.clean();

      return;
    }

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    if (distance_from_player > 200) {
      this.clean();

      return;
    }
  }

  // a timer function called every few seconds o teleport the bait.
  // In case the bait is in a position the creature can't reach
  timer function teleportBait(optional dt : float, optional id : Int32) {
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;

    new_bait_position = this.GetWorldPosition() + VecConeRand(this.GetHeading(), 90, 10, 20);
    new_bait_rotation = this.GetWorldRotation();
    new_bait_rotation.Yaw += RandRange(-20,20);
    
    this.bait_entity.TeleportWithRotation(
      new_bait_position,
      new_bait_rotation
    );
  }

  private function clean() {
    var i: int;

    RemoveTimer('intervalDefaultFunction');
    RemoveTimer('intervalHuntFunction');
    RemoveTimer('teleportBait');

    LogChannel('modRandomEncounters', "RandomEncountersReworked_Entity destroyed");

    if (this.bait_entity) {
      this.bait_entity.Destroy();
    }

    for (i = 0; i < this.tracks_entities.Size(); i += 1) {
      this.tracks_entities[i].Destroy();
    }

    this.tracks_entities.Clear();

    this.this_actor.Kill('RandomEncountersReworked_Entity', true);
    this.Destroy();
  }
}
