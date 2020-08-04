
statemachine class RandomEncountersReworkedGryphonHuntEntity extends CEntity {
  public var bait_position: Vector;

  // ticks variable used in some states. 
  // often used to run a timer for set period.
  public var ticks: int;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  public var animation_slot: CAIPlayAnimationSlotAction;
	public var animation_slot_idle : CAIPlayAnimationSlotAction;


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

    this.animation_slot_idle = new CAIPlayAnimationSlotAction in this;
		this.animation_slot_idle.OnCreated();
		this.animation_slot_idle.animName = 'monster_gryphon_idle';	
		this.animation_slot_idle.blendInTime = 1.0f;
		this.animation_slot_idle.blendOutTime = 1.0f;	
		this.animation_slot_idle.slotName = 'NPC_ANIM_SLOT';

    // this.animation_slot_idle = new CAIPlayAnimationSlotAction in this;
		// this.animation_slot_idle.OnCreated();
		// this.animation_slot_idle.animName = 'monster_gryphon_fly_start_from_ground';	
		// this.animation_slot_idle.blendInTime = 1.0f;
		// this.animation_slot_idle.blendOutTime = 1.0f;	
		// this.animation_slot_idle.slotName = 'NPC_ANIM_SLOT';

    // this.animation_slot_idle = new CAIPlayAnimationSlotAction in this;
		// this.animation_slot_idle.OnCreated();
		// this.animation_slot_idle.animName = 'monster_gryphon_fly_f_land';	
		// this.animation_slot_idle.blendInTime = 1.0f;
		// this.animation_slot_idle.blendOutTime = 1.0f;	
		// this.animation_slot_idle.slotName = 'NPC_ANIM_SLOT';

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

    this.AddTimer('intervalLifecheckFunction', 1, true);
    
    if (RandRange(10) >= 5) {
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

    this.GotoState('ExitEncounter');

    theSound.SoundEvent("stop_music");
		theSound.InitializeAreaMusic( theGame.GetCommonMapManager().GetCurrentArea() );

    this.this_actor.Kill('RandomEncountersReworked_Entity', true);
    this.Destroy();
  }
}

state ExitEncounter in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
  }
}



// state Test in RandomEncountersReworkedGryphonHuntEntity {
//   event OnEnterState(previous_state_name: name) {
//     super.OnEnterState(previous_state_name);

//     this.TestMain4();
//   }

//   entry function TestMain4() {
//     flyTo((CNewNPC)parent.this_entity, thePlayer.GetWorldPosition(), 10.0f);
//   }

  // entry function TestMain() {
	// 	var ticket 				: SMovementAdjustmentRequestTicket;
	// 	var movementAdjustor	: CMovementAdjustor;
	// 	var slidePos 			: Vector;
	// 	var slideDuration		: float;

  //   LogChannel('modRandomEncounters', "Test main");

		
	// 	movementAdjustor = parent.this_newnpc.GetMovingAgentComponent().GetMovementAdjustor();
	// 	movementAdjustor.CancelAll();

	// 	// movementAdjustor.CancelByName( 'SlideAway' );
		
	// 	ticket = movementAdjustor.CreateNewRequest( 'SlideTowards' );
	// 	// slidePos = GetWorldPosition() + ( VecNormalize2D( GetWorldPosition() - thePlayer.GetWorldPosition() ) * 0.75 );
  //   slidePos = thePlayer.GetWorldPosition() + Vector(0, 0, 100);
		
	// 	// if( theGame.GetWorld().NavigationLineTest( parent.this_newnpc.GetWorldPosition(), slidePos, parent.this_newnpc.GetRadius(), false, true ) ) 
	// 	// {
	// 		slideDuration = VecDistance2D( parent.this_newnpc.GetWorldPosition(), slidePos ) / 4;
			
	// 		movementAdjustor.Continuous( ticket );
	// 		movementAdjustor.AdjustmentDuration( ticket, slideDuration );
	// 		movementAdjustor.AdjustLocationVertically( ticket, true );
	// 		movementAdjustor.BlendIn( ticket, 0.25 );
	// 		movementAdjustor.SlideTo( ticket, slidePos );
	// 		movementAdjustor.RotateTowards( ticket, thePlayer );
	// 	// }

	// 	// return true;	
  // }

  // // doesn't work
  // entry function TestMain2() {
    
  //   l_aiTree = new CAIMoveToPoint in parent.this_actor;
  //   l_aiTree.OnCreated();
    
  //   l_aiTree.params.destinationPosition = thePlayer.GetWorldPosition();
  //   l_aiTree.params.destinationHeading = VecHeading(
  //       thePlayer.GetWorldPosition() - parent.this_entity.GetWorldPosition()
  //   );

  //   l_aiTree.params.moveSpeed = 4;
  //   l_aiTree.params.maxIterationsNumber 	= 100;
  //   l_aiTree.params.maxDistance 	= 10000.0;
  //   l_aiTree.params.useTimeout				= false;
  //   l_aiTree.params.timeoutValue 			= 3.f;
  //   // l_aiTree.params.rotateAfterwards = false;
    
  //   // if( speed > 1 )
  //   // {
  //     l_aiTree.params.moveType = MT_Sprint;
  //   // }

  //   parent.AddTimer('forceBehavior', 0.01, true);
  // }

  // timer function forceBehavior(optional dt : float, optional id : Int32) {
  //   // parent.this_actor.ActionCancelAll();
  //   parent.this_actor.ForceAIBehavior( l_aiTree, BTAP_Emergency);
  // }

  // // doesn't work
  // entry function TestMain3() {
  //   var res: bool; 
  //   LogChannel('modRandomEncounters', "test main 3");

  //   ((CNewNPC)parent.this_entity).ActionCancelAll();


  //   res = ((CNewNPC)parent.this_entity).ActionMoveToWithHeading( thePlayer.GetWorldPosition(), VecHeading(
  //       thePlayer.GetWorldPosition() - parent.this_entity.GetWorldPosition()
  //   ), MT_Sprint);

  //   if (res) {
  //     LogChannel('modRandomEncounters', "test main 3 good");
  //   }
  //   else {
  //   LogChannel('modRandomEncounters', "test main 3 not good");

  //   }
  // }

  // // doesn't work
  // entry function TextMain4() {
  //   parent.AddTimer('moveTimer', 0.01, true);
  // }

  // timer function moveTimer(optional dt : float, optional id : Int32) {
  //   this.MoveNpcFwd(parent.this_actor, 4, MT_Sprint);
  // }

  // function MoveNpcFwd( actor : CActor, distance : float, moveType : EMoveType )
  // {
  //   var l_actor 			: CActor;
  //   var l_aiTree			: CAIMoveToPoint;
    
  //   l_actor = actor;
    
  //   l_aiTree = new CAIMoveToPoint in l_actor;
  //   l_aiTree.OnCreated();
    
  //   l_aiTree.enterExplorationOnStart 		= false;
  //   l_aiTree.params.destinationHeading 		= VecHeading(l_actor.GetHeadingVector());
  //   l_aiTree.params.destinationPosition 	= l_actor.GetWorldPosition() + distance*l_actor.GetHeadingVector();
  //   l_aiTree.params.maxIterationsNumber 	= 0;
    
  //   l_aiTree.params.moveType = moveType;
      
  //   l_actor.ForceAIBehavior( l_aiTree, BTAP_Emergency);
  // }
// }





