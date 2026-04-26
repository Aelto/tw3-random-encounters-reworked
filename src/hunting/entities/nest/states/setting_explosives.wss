
state SettingExplosives in RER_MonsterNest {
	event OnEnterState(prevStateName : name) {
    NLOG("RER_MonsterNest - State SETTINGEXPLOSIVES");
		if(ShouldProcessTutorial('TutorialMonsterNest')) {
			FactsAdd("tut_nest_blown");
    }
		
		PlayAnimationAndSetExplosives();
	}
	
	entry function PlayAnimationAndSetExplosives() {	
		var movementAdjustor: CMovementAdjustor;
		var ticket: SMovementAdjustmentRequestTicket;

    movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
    ticket = movementAdjustor.CreateNewRequest('InteractionEntity');
		
		thePlayer.OnHolsterLeftHandItem();		
		thePlayer.AddAnimEventChildCallback(parent,'AttachBomb','OnAnimEvent_AttachBomb');
		thePlayer.AddAnimEventChildCallback(parent,'DetachBomb','OnAnimEvent_DetachBomb');
		
		movementAdjustor.AdjustmentDuration(ticket, 0.5);
		
		if (parent.matchPlayerHeadingWithHeadingOfTheEntity) {
			movementAdjustor.RotateTowards( ticket, parent );
    }

		if (parent.desiredPlayerToEntityDistance >= 0) {
			movementAdjustor.SlideTowards( ticket, parent, parent.desiredPlayerToEntityDistance );
    }
		
		thePlayer.PlayerStartAction(PEA_SetBomb);
		
		// blocking interaction with other objects and fast travel
		parent.BlockPlayerNestInteraction();
			
		Sleep(parent.settingExplosivesTime);
		
		parent.playerInventory.SingletonItemRemoveAmmo(parent.usedBomb, 1);
		
		Sleep(parent.explodeAfter);
		
		parent.GotoState('Explosion');
	}
}
