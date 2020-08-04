
latent function flyStartFromLand(npc: CNewNPC) {
	var animation_slot : CAIPlayAnimationSlotAction;
  var ticket 				: SMovementAdjustmentRequestTicket;
  var movementAdjustor	: CMovementAdjustor;
  var slidePos 			: Vector;
  var i: float;
  var duration_in_seconds: float;
  var time_per_step: float;
  var translation_per_step: Vector;

  animation_slot = new CAIPlayAnimationSlotAction in npc;
  animation_slot.OnCreated();
  animation_slot.animName = 'monster_gryphon_fly_start_from_ground';			
  animation_slot.blendInTime = 1.0f;
  animation_slot.blendOutTime = 1.0f;	
  animation_slot.slotName = 'NPC_ANIM_SLOT';
  
  // movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();
  // movementAdjustor.CancelAll();
  
  // ticket = movementAdjustor.CreateNewRequest( 'FlyStartFromLand' );
  // slidePos = Vector(0, 0, 15);
  
  // movementAdjustor.Continuous( ticket );
  // movementAdjustor.AdjustmentDuration( ticket, 2 );
  // movementAdjustor.AdjustLocationVertically( ticket, true );
  // movementAdjustor.BlendIn( ticket, 1 );
  // movementAdjustor.SlideBy( ticket, slidePos );
  // movementAdjustor.RotateTowards( ticket, thePlayer );

  npc.ForceAIBehavior(animation_slot, BTAP_Emergency);
  
  duration_in_seconds = 2.0f;
  time_per_step = 0.02f;
  translation_per_step = Vector(0, 0, 10 / (duration_in_seconds / time_per_step));


  i = 0;
  while (i < duration_in_seconds) {
    npc.Teleport(npc.GetWorldPosition() + translation_per_step);
    // npc.SetBehaviorVariable( 'GroundContact', 0.0 );
    // npc.SetBehaviorVariable( 'DistanceFromGround', 100 );
    
    i += time_per_step;
    Sleep(time_per_step);
  }

  // npc.SetBehaviorVariable( 'GroundContact', 0.0 );
  // npc.SetBehaviorVariable( 'DistanceFromGround', 10 );
}
