
statemachine class RandomEncountersReworkedGryphonHuntEntity extends CEntity {
  public var bait_position: Vector;

  // ticks variable used in some states. 
  // often used to run a timer for set period.
  public var ticks: int;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  public var animation_slot: CAIPlayAnimationSlotAction;

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

  event OnSpawned( spawnData : SEntitySpawnData ){
    super.OnSpawned(spawnData);

    animation_slot = new CAIPlayAnimationSlotAction in this;
    this.animation_slot.OnCreated();
    this.animation_slot.animName = 'monster_gryphon_special_attack_tearing_up_loop';
    this.animation_slot.blendInTime = 1.0f;
    this.animation_slot.blendOutTime = 1.0f;  
    this.animation_slot.slotName = 'NPC_ANIM_SLOT';

    this.this_actor.SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

    LogChannel('modRandomEncounters', "RandomEncountersReworkedGryphonHuntEntity spawned");
  }

  public function attach(actor: CActor, newnpc: CNewNPC, this_entity: CEntity) {
    this.this_actor = actor;
    this.this_newnpc = newnpc;
    this.this_entity = this_entity;

    this.CreateAttachment( this_entity );
    this.AddTag('RandomEncountersReworked_Entity');
    newnpc.AddTag('RandomEncountersReworked_Entity');
  }

  // ENTRY-POINT for the gryphon fight
  public function startEncounter(blood_resources: array<CEntityTemplate>) {
    LogChannel('modRandomEncounters', "RandomEncountersReworkedGryphonHuntEntity encounter started");

    this.blood_resources = blood_resources;
    this.blood_resources_size = blood_resources.Size();

    this.AddTimer('intervalLifecheckFunction', 1);
    
    if (/*RandRange(10) >= 5*/false) {
      this.GotoState('WaitingForPlayer');
    }
    else {
      this.GotoState('FlyingAbovePlayer');
    }
  }

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

      // new_entity.UpdateInteraction("InteractiveClue");


      this.blood_tracks_entities.PushBack(new_entity);

      if (this.blood_tracks_entities.Size() == this.blood_tracks_maximum) {
        this.blood_tracks_looped = true;
      }

      return;
    }

    this.blood_tracks_entities[this.blood_tracks_index].TeleportWithRotation(position, RotRand(0, 360));

    this.blood_tracks_index = (this.blood_tracks_index + 1) % this.blood_tracks_maximum;
  }

  public function killNearbyEntities(center: CNode) {
    var entities_in_range : array<CGameplayEntity>;
    var i: int;

    FindGameplayEntitiesInRange(entities_in_range , center, 20, 50, /*NOP*/, /*NOP*/, /*NOP*/, 'CNewNPC');

    for(i=0;i<entities_in_range.Size();i+=1) {
      if ((CActor)entities_in_range[i] != this.this_actor
      &&  (CActor)entities_in_range[i] != this
      &&  (CNode)entities_in_range[i] != center
      &&  !((CNewNPC)entities_in_range[i]).HasTag('RandomEncountersReworked_Entity')
      &&  (
            ((CNewNPC)entities_in_range[i]).HasTag('animal')
        ||  ((CActor)entities_in_range[i]).IsMonster()
        ||  ((CActor)entities_in_range[i]).GetAttitude( thePlayer ) == AIA_Hostile
      )) {

        ((CActor)entities_in_range[i]).Kill('RandomEncounters',true);

      }
    }
  }

  event OnDestroyed() {
    this.clean();
  }

  timer function intervalLifecheckFunction(optional dt : float, optional id : Int32) {
    var distance_from_player: float;

    if (!this.this_newnpc.IsAlive()) {
      this.clean();

      return;
    }

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    if (distance_from_player > 600) {
      this.clean();

      return;
    }
  }

  private function clean() {
    var i: int;

    LogChannel('modRandomEncounters', "RandomEncountersReworkedGryphonHuntEntity destroyed");
    
    RemoveTimer('intervalDefaultFunction');

    for (i = 0; i < this.blood_tracks_entities.Size(); i += 1) {
      this.blood_tracks_entities[i].Destroy();
    }

    this.blood_tracks_entities.Clear();

    this.this_actor.Kill('RandomEncountersReworked_Entity', true);
    this.Destroy();
  }
}

// When the gryphon is on the ground waiting for the player to attack it
// The gryphon is feeding on a dead beast on the ground. You have to find
// it with tracks and blood spills on the ground.
// ENTRY-POINT state.
state WaitingForPlayer in RandomEncountersReworkedGryphonHuntEntity {
  var bloodtrail_current_position: Vector;
  var bloodtrail_target_position: Vector;
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State WaitingForPlayer");

    this.WaitingForPlayer_Main();
  }

  entry function WaitingForPlayer_Main() {
    this.bloodtrail_target_position = parent.this_actor.GetWorldPosition();
    this.bloodtrail_current_position = thePlayer.GetWorldPosition() + VecRingRand(2, 4);

    parent.AddTimer('WaitingForPlayer_drawLineOfBloodToGryphon', 0.25, true);
    parent.AddTimer('WaitingForPlayer_intervalDefaultFunction', 0.5, true);

    parent.this_newnpc.ChangeStance( NS_Normal );
    parent.this_newnpc.SetBehaviorVariable( '2high', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 1 );
  }

  timer function WaitingForPlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    parent.killNearbyEntities(parent.this_actor);

    if (parent.this_actor.IsInCombat() && parent.this_actor.GetTarget() == thePlayer
    // the distance here is squared for performances reasons, so 400 = 20*20
    // the squareroot is a costly operation. So it's better to multiply the other
    // side and compare it to the squared value (distance).
     || VecDistanceSquared(thePlayer.GetWorldPosition(), parent.this_actor.GetWorldPosition()) < 400
     || parent.this_actor.GetDistanceFromGround(1000) > 3
    ) {
      parent.GotoState('GryphonFleeingPlayer');

      return;
    }

    parent.this_newnpc.ChangeStance( NS_Normal );
    parent.this_newnpc.SetBehaviorVariable( '2high', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 1 );

    parent.this_actor.ForceAIBehavior(parent.animation_slot, BTAP_Emergency);
  }

  // I'm making it a timer because spawning too many entities
  // in one go did not go well for the game. It crashed sometimes.
  // It's a way to drop blood splats smoothly over time.
  timer function WaitingForPlayer_drawLineOfBloodToGryphon(optional dt : float, optional id : Int32) {
    var heading_to_target: float;

    heading_to_target = VecHeading(this.bloodtrail_target_position - this.bloodtrail_current_position);

    this.bloodtrail_current_position += VecConeRand(
      heading_to_target,
      80, // 80 degrees randomness
      1,
      2
    );

    FixZAxis(this.bloodtrail_current_position);

    LogChannel('modRandomEncounters', "line of blood to gryphon, current position: " + VecToString(this.bloodtrail_current_position) + " target position: " + VecToString(this.bloodtrail_target_position));


    parent.addBloodTrackHere(this.bloodtrail_current_position);

    if (VecDistanceSquared(this.bloodtrail_current_position, this.bloodtrail_target_position) < 5 * 5) {
      parent.RemoveTimer('WaitingForPlayer_drawLineOfBloodToGryphon');
    }
  }

  event OnLeaveState( nextStateName : name ) {
    var i: int;

    parent.RemoveTimer('WaitingForPlayer_intervalDefaultFunction');
    parent.RemoveTimer('WaitingForPlayer_drawLineOfBloodToGryphon');

    // copied from regular RE, not sure about it.
    for(i=0; i<100; i+=1) {
      parent.this_actor.CancelAIBehavior(i);
    }

    super.OnLeaveState(nextStateName);
  }
}

// When the gryphon flies over the player, then comes back to attack it
// Imagine it flying at high-speed above you, he sees you and screems
// then he does a complete turn and starts attacking you
// ENTRY-POINT state.
state FlyingAbovePlayer in RandomEncountersReworkedGryphonHuntEntity {
  var bait: CEntity;
  var ai_behavior_flight: CAIFlightIdleFreeRoam;
  var bait_distance_from_player: float;
  var flight_heading: float;
  var distance_threshold: float;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State FlyingAbovePlayer, from " + previous_state_name);

    parent.this_actor.SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

    this.FlyingAbovePlayer_main();
  }

  entry function FlyingAbovePlayer_main() {
    var i: int;

    parent.this_entity.Teleport(parent.this_entity.GetWorldPosition() + Vector(0, 0, 80));

    bait = theGame.CreateEntity(
      (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
      parent.this_entity.GetWorldPosition(),
      thePlayer.GetWorldRotation(),
      true,
      false,
      false,
      PM_DontPersist
    );

    for(i=0;i<100;i+=1)
    {
      parent.this_newnpc.CancelAIBehavior(i);
    }

    ((CNewNPC)this.bait).SetGameplayVisibility(false);
    ((CNewNPC)this.bait).SetVisibility(false);    
    ((CActor)this.bait).EnableCharacterCollisions(false);
    ((CActor)this.bait).EnableDynamicCollisions(false);
    ((CActor)this.bait).EnableStaticCollisions(false);
    ((CActor)this.bait).SetImmortalityMode(AIM_Immortal, AIC_Default);

    this.ai_behavior_flight = new CAIFlightIdleFreeRoam in this;

    this.flight_heading = VecHeading(
        thePlayer.GetWorldPosition() - parent.this_entity.GetWorldPosition()
    );
    
    parent.this_actor.ForceAIBehavior( this.ai_behavior_flight, BTAP_Emergency );
    parent.this_actor.SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );

    this.distance_threshold = VecDistanceSquared(
      parent.this_entity.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    ) + 100;

    // The two seconds here is important, the gryphon doesn't fly without it
    parent.AddTimer('FlyingAbovePlayer_intervalDefaultFunction', 2, true);
  }

  timer function FlyingAbovePlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    var bait_position: Vector;

    parent.this_actor.SetTemporaryAttitudeGroup( 'monsters', AGP_Default );

    bait_position = parent.this_entity.GetWorldPosition();
    bait_position += VecConeRand(this.flight_heading, 1, 100, 100);
    
    this.bait.Teleport(bait_position);

    if (((CActor)bait).GetDistanceFromGround(500) < 100) {
      bait_position.Z += 30;
    }
    else {
      bait_position.Z -= 10;
    }

    this.bait.Teleport(bait_position);
    
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    // distance_threshold is already squared
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.this_actor.GetWorldPosition()) > distance_threshold) {
      parent.RemoveTimer('FlyingAbovePlayer_intervalDefaultFunction');
      parent.AddTimer('FlyingAbovePlayer_intervalComingToPlayer', 0.5, true);
    }
  }

  timer function FlyingAbovePlayer_intervalComingToPlayer(optional dt : float, optional id : Int32) {
    this.bait.Teleport(thePlayer.GetWorldPosition());

    parent.this_newnpc.NoticeActor((CActor)this.bait);

    // 20 * 20 = 400
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.this_actor.GetWorldPosition()) < 400) {
      parent.GotoState('GryphonFightingPlayer');
    }
  }

  event OnLeaveState( nextStateName : name ) {
    parent.RemoveTimer('FlyingAbovePlayer_intervalDefaultFunction');
    parent.RemoveTimer('FlyingAbovePlayer_intervalComingToPlayer');

    this.bait.Destroy();

    super.OnLeaveState(nextStateName);
  }
}

// When the gryphon is fighting with the player. 
// The gryphon is fighting with you until a health threshold. Where he
// will start fleeing
// MULTIPLE state. Can be used multiple times in the encounter
state GryphonFightingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  var can_flee_fight: bool;
  var starting_health: float;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    if (previous_state_name == 'FlyingAbovePlayer') {
      this.can_flee_fight = true;
    }
    else {
      this.can_flee_fight = false;
    }

    this.starting_health = parent.this_actor.GetHealthPercents();

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFightingPlayer");

    parent.AddTimer('GryphonFightingPlayer_intervalDefaultFunction', 0.5, true);
  }

  timer function GryphonFightingPlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    LogChannel('modRandomEncounters', "health loss: " + (this.starting_health - parent.this_actor.GetHealthPercents()));

    if (this.can_flee_fight && this.starting_health - parent.this_actor.GetHealthPercents() > 0.45) {
      parent.GotoState('GryphonFleeingPlayer');
    }
  }

  event OnLeaveState( nextStateName : name ) {
    parent.RemoveTimer('GryphonFightingPlayer_intervalDefaultFunction');

    super.OnLeaveState(nextStateName);
  }
}

// The gryphon is fleeing far from the player.
// The gryphon is hurt, he's bleeding and start flying far from the
// player at low speed. So the player can catch him with or without
// Roach. It ends when the gryphon is exhausted and goes on the ground
// SINGLE state. Used once in the encounter (more would be annoying)
state GryphonFleeingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  var is_bleeding: bool;
  var bait: CEntity;
  var ai_behavior_flight: CAIFlightIdleFreeRoam;
  var ai_behavior_combat: CAIFlyingMonsterCombat;
  var flight_heading: float;
  var distance_threshold: float;
  var starting_position: Vector;
  
  // if found_landing_position is set to true,
  // The gryphon will go to the landing position
  var found_landing_position: bool;
  var landing_position: Vector;



  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    // the gryphon bleeds only if a fight happened before.
    if (previous_state_name == 'GryphonFightingPlayer') {
      this.is_bleeding = true;
    }
    else {
      this.is_bleeding = false;
    }

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFleeingPlayer");

    this.GryphonFleeingPlayer_main();
  }


  entry function GryphonFleeingPlayer_main() {
    var i: int;

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFleeingPlayer - main");

    (parent.this_actor).SetImmortalityMode(AIM_Invulnerable, AIC_Default);
    (parent.this_actor).EnableCharacterCollisions(false);
    (parent.this_actor).EnableDynamicCollisions(false);
    // (parent.this_actor).EnableStaticCollisions(false);

    bait = theGame.CreateEntity(
      (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true),
      parent.this_entity.GetWorldPosition(),
      thePlayer.GetWorldRotation(),
      true,
      false,
      false,
      PM_DontPersist
    );

    for(i=0;i<100;i+=1) {
      parent.this_newnpc.CancelAIBehavior(i);
    }

    ((CNewNPC)this.bait).SetGameplayVisibility(false);
    ((CNewNPC)this.bait).SetVisibility(false);    
    ((CActor)this.bait).EnableCharacterCollisions(false);
    ((CActor)this.bait).EnableDynamicCollisions(false);
    ((CActor)this.bait).EnableStaticCollisions(false);
    ((CActor)this.bait).SetImmortalityMode(AIM_Immortal, AIC_Default);

    this.GryphonFleeingPlayer_startFlying();
    this.GryphonFleeingPlayer_forgetPlayer();

    parent.AddTimer('GryphonFleeingPlayer_startFlying', 1, false);
    parent.AddTimer('GryphonFleeingPlayer_forgetPlayerTargetBait', 0.2, true);
  }

  timer function GryphonFleeingPlayer_forgetPlayer(optional dt : float, optional id : Int32) {
    parent.this_newnpc.ForgetActor(thePlayer);
  }

  timer function GryphonFleeingPlayer_startFlying(optional dt : float, optional id : Int32) {
    this.ai_behavior_flight = new CAIFlightIdleFreeRoam in this;

    this.flight_heading = VecHeading(
        parent.this_entity.GetWorldPosition() - thePlayer.GetWorldPosition()
    );

    // parent.this_actor.ForceAIBehavior( this.ai_behavior_flight, BTAP_Emergency );
    parent.this_actor.SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );
    parent.this_newnpc.ForgetActor(thePlayer);
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    this.distance_threshold = 150 * 150; // squared value for performances
    this.starting_position = thePlayer.GetWorldPosition();

    // if (parent.this_actor.IsInCombat()) {
      // parent.AddTimer('GryphonFleeingPlayer_intervalDefaultFunction', 0.1, true);
    // }

    parent.AddTimer('GryphonFleeingPlayer_intervalDefaultFunction', 2, true);

    if (this.is_bleeding) {
      parent.AddTimer('GryphonFleeingPlayer_intervalDropBloodFunction', 0.3, true);
    }
  }


  timer function GryphonFleeingPlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    var bait_position: Vector;

    LogChannel('modRandomEncounters', "gryphon fleeing");

    parent.this_actor.SetTemporaryAttitudeGroup( 'monsters', AGP_Default );

    bait_position = parent.this_entity.GetWorldPosition();
    bait_position += VecConeRand(this.flight_heading, 1, 100, 100);

    FixZAxis(bait_position);

    bait_position.Z += 100;
    
    // if (((CActor)bait).GetDistanceFromGround(500) < 70) {
    //   bait_position.Z += 20;
    // }
    // else {
    //   bait_position.Z -= 10;
    // }

    this.bait.Teleport(bait_position);
    
    parent.this_newnpc.ForgetActor(thePlayer);
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    parent.this_actor.SetHealthPerc(parent.this_actor.GetHealthPercents() + 0.01);

    // attempt at forcing the gryphon to fly
    parent.this_entity.Teleport(parent.this_entity.GetWorldPosition() + Vector(0, 0, 0.1));


    // distance_threshold is already squared
    if (VecDistanceSquared(this.starting_position, parent.this_actor.GetWorldPosition()) > distance_threshold) {
      LogChannel('modRandomEncounters', "Gryphon looking for ground position");

      parent.RemoveTimer('GryphonFleeingPlayer_intervalDefaultFunction');
      parent.AddTimer('GryphonFightingPlayer_intervalLookingForGroundPositionFunction', 1, true);
    }
  }

  timer function GryphonFightingPlayer_intervalLookingForGroundPositionFunction(optional dt: float, optional id: Int32) {
    var bait_position: Vector;

    bait_position = VecRingRand(1, 20) + parent.this_entity.GetWorldPosition();
    bait_position.Z -= 20;

    // the bait is close enough for the ground.
    // we look for a safe landing position
    if (!this.found_landing_position && ((CActor)bait).GetDistanceFromGround(500) <= 20) {
      this.landing_position = bait_position;
      
      if (getGroundPosition(this.landing_position, 3.0)) {
      LogChannel('modRandomEncounters', "found landing position");
        this.found_landing_position = true;
        bait_position = this.landing_position;
      }
    }

    if (this.found_landing_position) {
      bait_position = this.landing_position;
    }

    this.bait.Teleport(bait_position);
    parent.this_actor.SetTemporaryAttitudeGroup( 'monsters', AGP_Default );
    parent.this_newnpc.ForgetActor(thePlayer);
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    // attempt at making the gryphon land gracefully
    parent.this_entity.Teleport(parent.this_entity.GetWorldPosition() - Vector(0, 0, 0.05));
    

    parent.this_actor.SetHealthPerc(parent.this_actor.GetHealthPercents() + 0.01);

    if (this.found_landing_position) {
      parent.killNearbyEntities(this.bait);
    }

    if (this.found_landing_position && parent.this_actor.GetDistanceFromGround(500) < 5) {
      LogChannel('modRandomEncounters', "Gryphon landed");

      parent.RemoveTimer('GryphonFightingPlayer_intervalLookingForGroundPositionFunction');
      this.cancelAIBehavior();

      this.ai_behavior_combat = new CAIFlyingMonsterCombat in this;
      parent.this_actor.ForceAIBehavior( this.ai_behavior_combat, BTAP_Emergency );
      
      parent.AddTimer('GryphonFleeingPlayer_intervalWaitPlayerFunction', 0.5, true);
    }
  }

  function cancelAIBehavior() {
    var i: int;
    
    for(i=0;i<100;i+=1)
    {
      parent.this_newnpc.CancelAIBehavior(i);
    }
  }

  timer function GryphonFleeingPlayer_intervalWaitPlayerFunction(optional dt : float, optional id : Int32) {
    var gryphon_position: Vector;

    this.bait.Teleport(this.landing_position);

    parent.this_newnpc.ForgetActor(thePlayer);
    parent.this_newnpc.NoticeActor((CActor)this.bait);

    parent.this_newnpc.ChangeStance( NS_Normal );
    parent.this_newnpc.SetBehaviorVariable( '2high', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 1 );

    gryphon_position = parent.this_entity.GetWorldPosition();
    FixZAxis(gryphon_position);

    parent.this_entity.Teleport(gryphon_position);

    parent.this_actor.SetHealthPerc(parent.this_actor.GetHealthPercents() + 0.005);

    


    if (VecDistanceSquared(parent.this_actor.GetWorldPosition(), thePlayer.GetWorldPosition()) < 625) {
      parent.GotoState('GryphonFightingPlayer');
    }
  }

  timer function GryphonFleeingPlayer_intervalDropBloodFunction(optional dt : float, optional id: Int32) {
    var position: Vector;

    position = parent.this_actor.GetWorldPosition();

    FixZAxis(position);
    parent.addBloodTrackHere(position);
  }

  event OnLeaveState( nextStateName : name ) {
    this.bait.Destroy();
    parent.RemoveTimer('GryphonFleeingPlayer_intervalDefaultFunction');
    parent.RemoveTimer('GryphonFleeingPlayer_intervalWaitPlayerFunction');
    parent.RemoveTimer('GryphonFleeingPlayer_intervalDropBloodFunction');
    parent.RemoveTimer('GryphonFleeingPlayer_forgetPlayer');

    (parent.this_actor).SetImmortalityMode(AIM_None, AIC_Default);
    (parent.this_actor).EnableCharacterCollisions(false);
    (parent.this_actor).EnableDynamicCollisions(false);
    (parent.this_actor).EnableStaticCollisions(false);


    super.OnLeaveState(nextStateName);
  }
}
