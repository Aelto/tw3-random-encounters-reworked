
statemachine class RandomEncountersReworkedGryphonHuntEntity extends CEntity {
  public var bait_position: Vector;

  // ticks variable used in some states. 
  // often used to run a timer for set period.
  public var ticks: int;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  public var animation_slot: CAIPlayAnimationSlotAction;

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
  }

  // ENTRY-POINT for the gryphon fight
  public function start() {
    if (/*RandRange(10) >= 5*/false) {
      this.GotoState('WaitingForPlayer');
    }
    else {
      this.GotoState('FlyingAbovePlayer');
    }
  }
}

// When the gryphon is on the ground waiting for the player to attack it
// The gryphon is feeding on a dead beast on the ground. You have to find
// it with tracks and blood spills on the ground.
// ENTRY-POINT state.
state WaitingForPlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State WaitingForPlayer");

    parent.AddTimer('WaitingForPlayer_intervalDefaultFunction', 0.5, true);

    parent.this_newnpc.ChangeStance( NS_Normal );
    parent.this_newnpc.SetBehaviorVariable( '2high', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 1 );
  }

  timer function WaitingForPlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    if (parent.this_actor.IsInCombat()
    // the distance here is squared for performances reasons, so 400 = 20*20
    // the squareroot is a costly operation. So it's better to multiply the other
    // side and compare it to the squared value (distance).
     || VecDistanceSquared(thePlayer.GetWorldPosition(), parent.this_actor.GetWorldPosition()) < 400
     || parent.this_actor.GetDistanceFromGround(1000) > 3
    ) {
      this.leaveState();

      parent.GotoState('GryphonFleeingPlayer');

      return;
    }

    parent.this_newnpc.ChangeStance( NS_Normal );
    parent.this_newnpc.SetBehaviorVariable( '2high', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 1 );

    parent.this_actor.ForceAIBehavior(parent.animation_slot, BTAP_Emergency);
  }

  function leaveState() {
    var i: int;

    parent.RemoveTimer('WaitingForPlayer_intervalDefaultFunction');

    // copied from regular RE, not sure about it.
    for(i=0; i<100; i+=1) {
      parent.this_actor.CancelAIBehavior(i);
    }
  }
}

// When the gryphon flies over the player, then comes back to attack it
// Imagine it flying at high-speed above you, he sees you and screems
// then he does a complete turn and starts attacking you
// ENTRY-POINT state.
state FlyingAbovePlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State FlyingAbovePlayer");

    parent.bait_position = this.get_flight_destination();

    parent.this_newnpc.ChangeStance( NS_Retreat );
    parent.this_newnpc.SetBehaviorVariable( '2high', 1 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 0 );

    this.moveToFlightDestination();

    // parent.AddTimer('FlyingAbovePlayer_intervalDefaultFunction', 0.5, true);
  }

  entry function moveToFlightDestination() {
    parent.this_actor.SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );

    parent.this_actor
      .ActionMoveTo(this.get_flight_destination(), MT_Sprint, 4, 10);
    // parent.this_actor
    //   .ActionMoveTo(parent.bait_position, MT_Sprint);
  }

  private function get_flight_destination(): Vector {
    var this_position: Vector;

    this_position = parent.this_entity.GetWorldPosition();

    return thePlayer.GetWorldPosition();

    // Okay so, here we get the distance between the player and the gryphon.
    // then multiply this distance by a factor of 2
    // then add it to the current gryphon position.
    return this_position + VecInterpolate(
      this_position,
      thePlayer.GetWorldPosition(),
      2
    );
  }

  timer function FlyingAbovePlayer_intervalDefaultFunction(optional dt : float, optional id : Int32) {
    parent.this_actor
        .ActionMoveToAsync(parent.bait_position, MT_Sprint);

    parent.this_newnpc.ChangeStance( NS_Retreat );
    parent.this_newnpc.SetBehaviorVariable( '2high', 1 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 0 );

    // 10 * 10 = 100
    if (VecDistanceSquared(parent.bait_position, parent.this_actor.GetWorldPosition()) < 100) {

      // once it has reached the first flight destination it comes back to 
      // the player at full speed.
      parent.bait_position = thePlayer.GetWorldPosition();

      parent.RemoveTimer('FlyingAbovePlayer_intervalDefaultFunction');
      parent.AddTimer('FlyingAbovePlayer_intervalComingToPlayer', 0.5, true);
    }
  }

  timer function FlyingAbovePlayer_intervalComingToPlayer(optional dt : float, optional id : Int32) {
    parent.this_actor
      .ActionMoveToAsync(thePlayer.GetWorldPosition(), MT_Sprint);

    parent.this_newnpc.ChangeStance( NS_Retreat );
    parent.this_newnpc.SetBehaviorVariable( '2high', 1 );
    parent.this_newnpc.SetBehaviorVariable( '2low', 0 );
    parent.this_newnpc.SetBehaviorVariable( '2ground', 0 );

    // 20 * 20 = 400
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), parent.this_actor.GetWorldPosition()) < 400) {
      parent.GotoState('GryphonFightingPlayer');
    }
  }

  function leaveState() {
    parent.RemoveTimer('FlyingAbovePlayer_intervalDefaultFunction');
    parent.RemoveTimer('FlyingAbovePlayer_intervalComingToPlayer');
  }
}

// When the gryphon is fighting with the player. 
// The gryphon is fighting with you until a health threshold. Where he
// will start fleeing
// MULTIPLE state. Can be used multiple times in the encounter
state GryphonFightingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFightingPlayer");
  }
}

// The gryphon is fleeing far from the player.
// The gryphon is hurt, he's bleeding and start flying far from the
// player at low speed. So the player can catch him with or without
// Roach. It ends when the gryphon is exhausted and goes on the ground
// SINGLE state. Used once in the encounter (more would be annoying)
state GryphonFleeingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFleeingPlayer");
  }
}

// The gryphon is tauting the player.
// The gryphon flies at low altitude above the player in circles
// The player cannot interrupt it.
// SINGLE state. Used once in the encounter (more would be annoying)
state GryphonTauntingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State GryphonTauntingPlayer");
  }
}