
state Talking in RER_MonsterNest {
  event OnEnterState(prevStateName: name) {
    NLOG("RER_MonsterNest - State TALKING");
		super.OnEnterState(prevStateName);

    this.Talking_main();
	}

  entry function Talking_main() {
    (new RER_RandomDialogBuilder in thePlayer).start()
      .either(new REROL_more_will_spawn in this, true, 1)
      .either(new REROL_here_is_the_nest in this, true, 1)
      .either(new REROL_finally_the_main_nest in this, true, 1)
      .either(new REROL_good_place_for_their_nest in this, true, 1)
      .either(new REROL_monster_nest_best_destroyed in this, true, 1)
      .play();

    parent.GotoState('Spawning');
  }
}
