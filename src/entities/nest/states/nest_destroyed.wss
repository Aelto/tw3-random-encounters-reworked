
state NestDestroyed in RER_MonsterNest {
	event OnEnterState(prevStateName: name) {
		var commonMapManager: CCommonMapManager;
    NLOG("RER_MonsterNest - State NESTDESTROYED");

    commonMapManager = theGame.GetCommonMapManager();
		
		parent.StopAllEffects();
		parent.encounter.EnableEncounter( false );
		
		this.NestDestroyed_main();
	}

  entry function NestDestroyed_main() {
		parent.is_destroyed = true;

		RER_removePinsInAreaAndWithTag("RER_nest_contract_target", parent.pin_position, 50);
  }
}