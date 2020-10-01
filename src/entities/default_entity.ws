
class RandomEncountersReworkedEntity extends CEntity {
  // an invisible entity used to bait the entity
  // do i really need a CEntity?
  // using ActionMoveTo i can force the creature to go
  // toward a vector.
  // Leaving the question here, but yes i tried for
  // a full week to make the functions ActionMoveTo work
  // but nothing worked as expected. So a bait is the best
  // thing. 
  var bait_entity: CEntity;

  // control whether the entity goes towards a bait
  // or the player
  var go_towards_bait: bool;
  default go_towards_bait = false;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  public var automatic_kill_threshold_distance: float;
  default automatic_kill_threshold_distance = 200;

  private var tracks_template: CEntityTemplate;
  private var tracks_entities: array<CEntity>;

  private var master: CRandomEncounters;

  public var pickup_animation_on_death: bool;
  default pickup_animation_on_death = false;

  event OnSpawned( spawnData : SEntitySpawnData ){
    super.OnSpawned(spawnData);

    LogChannel('modRandomEncounters', "RandomEncountersEntity spawned");
  }

  public function attach(actor: CActor, newnpc: CNewNPC, this_entity: CEntity, master: CRandomEncounters) {
    this.this_actor = actor;
    this.this_newnpc = newnpc;
    this.this_entity = this_entity;
    
    this.master = master;

    this.CreateAttachment( this_entity );
    this.AddTag('RandomEncountersReworked_Entity');
  }

  public function removeAllLoot() {
    var inventory: CInventoryComponent;

    inventory = this.this_actor.GetInventory();

    inventory.EnableLoot(false);
  }

  // entry point when creating an entity who will
  // follow a bait and leave tracks behind her.
  // more suited for: `EncounterType_HUNT`
  // NOTE: this functions calls `startWithoutBait`
  public latent function startWithBait(bait_entity: CEntity) {
    this.bait_entity = bait_entity;
    this.go_towards_bait = true;

    ((CNewNPC)this.bait_entity).SetGameplayVisibility(false);
    ((CNewNPC)this.bait_entity).SetVisibility(false);
    ((CActor)this.bait_entity).EnableCharacterCollisions(false);
    ((CActor)this.bait_entity).EnableDynamicCollisions(false);
    ((CActor)this.bait_entity).EnableStaticCollisions(false);
    ((CActor)this.bait_entity).SetImmortalityMode(AIM_Immortal, AIC_Default);

    this.tracks_template = getTracksTemplate(this.this_actor);

    // it's a slow function because there is a sleep inside,
    // without the sleep the game crashes because it creates
    // a huge amount of entities.
    this.drawInitialFootTracks();

    this.startWithoutBait();
  }

  // entry point when creating an entity who will
  // directly target the player.
  // more suited for: `EncounterType_DEFAULT`
  public function startWithoutBait() {
    LogChannel('modRandomEncounters', "starting - automatic death threshold = " + this.automatic_kill_threshold_distance);

    if (this.go_towards_bait) {
      AddTimer('intervalHuntFunction', 2, true);
      AddTimer('teleportBait', 10, true);
    }
    else {
      this.this_newnpc.NoticeActor(thePlayer);
      this.this_newnpc.SetAttitude(thePlayer, AIA_Hostile);

      AddTimer('intervalDefaultFunction', 2, true);

      this.this_actor
        .ActionMoveToNodeAsync(thePlayer);
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

    if (distance_from_player > this.automatic_kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
      this.clean();

      return;
    }

    LogChannel('modRandomEncounters', "distance from player : " + distance_from_player);

    this.this_newnpc.NoticeActor(thePlayer);

    if (distance_from_player < 20) {
      // the creature is close enough to fight thePlayer,
      // we do not need this intervalFunction anymore.
      this.RemoveTimer('intervalDefaultFunction');

      // so it is also called almost instantly
      this.AddTimer('intervalLifecheckFunction', 0.1, false);
      this.AddTimer('intervalLifecheckFunction', 1, true);
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

    if (distance_from_player > this.automatic_kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
      this.clean();

      return;
    }

    if (distance_from_player < 20) {
      this.this_actor
        .ActionCancelAll();

      this.this_newnpc.NoticeActor(thePlayer);
      this.this_newnpc.SetAttitude(thePlayer, AIA_Hostile);

      // the creature is close enough to fight thePlayer,
      // we do not need this intervalFunction anymore.
      this.RemoveTimer('intervalHuntFunction');
      this.RemoveTimer('teleportBait');
      this.AddTimer('intervalLifecheckFunction', 1, true);

      // we also kill the bait
      this.bait_entity.Destroy();
    }
    else {
      // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/6:
      // when the bait_entity is no longer in the game, force the creatures
      // to target the player instead.
      if (this.bait_entity) {
        this.this_newnpc.NoticeActor((CActor)this.bait_entity);

        this.this_actor
        .ActionMoveToAsync(this.bait_entity.GetWorldPosition());

        if (distance_from_bait < 5) {
          new_bait_position = this.GetWorldPosition() + VecConeRand(this.GetHeading(), 90, 10, 20);
          new_bait_rotation = this.GetWorldRotation();
          
          this.bait_entity.TeleportWithRotation(
            new_bait_position,
            new_bait_rotation
          );
        }
      }
      else {
        // to avoid creatures who lost their bait (because it went too far)
        // aggroing the player. But instead they die too.
        if (distance_from_player > this.automatic_kill_threshold_distance * 0.8) {
          LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
          this.clean();

          return;
        }

        this.this_newnpc.NoticeActor(thePlayer);
      }

      this.addFootTrackHere(this.GetWorldPosition(), this.GetWorldRotation());
    }  
  }

  // when using the functions to add a foot track on the ground
  // it adds one to the array, unless we reached the maximum
  // number of tracks. At this moment we come back to 0 and
  // start using the foot_tracks_index and set foot_tracks_looped  
  // to true to tell we have already reached the maximum once.
  // And now instead of creating a new track Entity we simply
  // move the old one at foot_tracks_index.
  var foot_tracks_entities: array<CEntity>;
  var foot_tracks_index: int;
  var foot_tracks_looped: bool;
  var foot_tracks_maximum: int;
  default foot_tracks_looped = false;
  default foot_tracks_maximum = 200;

  public function addFootTrackHere(position: Vector, rotation: EulerAngles) {
    var new_track: CEntity;
    var position: Vector;
    var rotation: EulerAngles;

    if (!this.foot_tracks_looped) {
      new_entity = theGame.CreateEntity(
        this.tracks_template,
        position,
        rotation
      );

      this.foot_tracks_entities.PushBack(new_entity);

      if (this.foot_tracks_entities.Size() == this.foot_tracks_maximum) {
        this.foot_tracks_looped = true;
      }

      return;
    }

    this.foot_tracks_entities[this.foot_tracks_index]
      .TeleportWithRotation(position, RotRand(0, 360));

    this.foot_tracks_index = (this.foot_tracks_index + 1) % this.foot_tracks_maximum;
  }

  latent function drawInitialFootTracks() {
    var tracks_heading: float;
    var current_position: Vector;
    var distance_from_monster: float;

    // heading going from this to ThePlayer,
    // so we know where to go to reach the creatures.
    tracks_heading = VecHeading(
        thePlayer.GetWorldPosition() - this.GetWorldPosition()
    );

    // to calculate the initial position we go from the
    // monsters position and use the inverse tracks_heading to
    // cross ThePlayer's path.
    current_position = 
      // starting from the monster
      this.GetWorldPosition()
      // then we translate by the distance between the player and
      // the monster, this multiplied by 1.3.
      - VecConeRand(
          -tracks_heading
          (thePlayer.GetWorldPosition() - this.GetWorldPosition()) * 1.3,

          // we give it a ten degrees randomness
          10, 10
        );

    distance_from_monster = VecDistanceSquared(
      this.GetWorldPosition(),
      current_position
    );

    // we continue until we're 20 meters away from the monster
    while (distance_from_monster > 20 * 20) {
      tracks_heading = VecHeading(this.bloodtrail_target_position - this.bloodtrail_current_position);

      current_position += VecConeRand(
        tracks_heading,
        80, // 80 degrees randomness
        1,
        2
      );

      FixZAxis(current_position);

      // TODO: convert heading to EulerAngles
      // instead of using the monster rotation.
      this.addFootTrackHere(current_position, this.GetWorldRotation());

      Sleep(0.2f);
    }
    
  }

  // simple interval function called every ten seconds or so to check if the creature is
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

    if (distance_from_player > this.automatic_kill_threshold_distance) {
      LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + this.automatic_kill_threshold_distance);
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
    var distance_from_player: float;

    RemoveTimer('intervalDefaultFunction');
    RemoveTimer('intervalHuntFunction');
    RemoveTimer('teleportBait');
    RemoveTimer('intervalLifecheckFunction');

    LogChannel('modRandomEncounters', "RandomEncountersReworked_Entity destroyed");

    if (this.bait_entity) {
      this.bait_entity.Destroy();
    }

    for (i = 0; i < this.tracks_entities.Size(); i += 1) {
      this.tracks_entities[i].Destroy();
    }

    this.tracks_entities.Clear();

    this.this_actor.Kill('RandomEncountersReworked_Entity', true);

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    // 20 here because the cutscene picksup everything around geralt
    // so the distance doesn't have to be too high.
    if (this.pickup_animation_on_death && distance_from_player < 20) {
      this.master.requestOutOfCombatAction(OutOfCombatRequest_TROPHY_CUTSCENE);
    }
    
    this.Destroy();
  }
}
