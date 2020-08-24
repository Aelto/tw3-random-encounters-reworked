
// In this state the monsters aren't doing much.
state WaitingForPlayer in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State WaitingForPlayer");

    this.WaitingForPlayer_Main();
  }

  entry function WaitingForPlayer_Main() {
    parent.AddTimer('WaitingForPlayer_intervalMain', 1.0, true);
  }

  timer function WaitingForPlayer_intervalMain(optional dt : float, optional id: Int32) {
    var distance_from_player: float;

    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.monster_group_position
    );

    if (distance_from_player < 400) {
      parent.GotoState('FightingPlayer');

      return;
    }
  }

  event OnLeaveState(nextStateName : name) {
    parent.RemoveTimer('WaitingForPlayer_intervalMain');

    super.OnLeaveState(nextStateName);
  }
}

