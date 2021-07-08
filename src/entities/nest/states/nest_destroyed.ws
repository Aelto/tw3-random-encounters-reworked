
state NestDestroyed in RER_MonsterNest {
	event OnEnterState(prevStateName: name) {
		var commonMapManager: CCommonMapManager;
    NLOG("RER_MonsterNest - State NESTDESTROYED");

    commonMapManager = theGame.GetCommonMapManager();
		
		parent.StopAllEffects();
		parent.encounter.EnableEncounter( false );
		
		
	}

  entry function NestDestroyed_main() {
		parent.is_destroyed = true;
  }
}