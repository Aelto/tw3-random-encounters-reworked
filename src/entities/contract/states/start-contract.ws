
state StartContract in RandomEncountersReworkedContractEntity {
  private var current_tracks_position: Vector;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State StartContract");

    this.StartContract_Main();
  }

  entry function StartContract_Main() {
    parent.AddTimer('StartContract_intervalDrawTracks', 0.25, true);
  }

  timer function StartContract_intervalDrawTracks(optional dt : float, optional id: Int32) {
    FixZAxis(this.current_tracks_position);

    parent.addTrackHere(
      current_tracks_position,
      VecToRotation(
        this.current_tracks_position - parent.monster_group_position
      )
    );

    if (VecDistanceSquared(this.current_tracks_position, parent.monster_group_position) < 5 * 5) {
      parent.RemoveTimer('StartContract_intervalDrawTracks');
    }

    this.usePathFinding(this.current_tracks_position, parent.monster_group_position);
  }

  latent function usePathFinding(out current_position: Vector, target_position: Vector) : bool {
    var path : array<Vector>;	

    if(theGame
      .GetVolumePathManager()
      .IsPathfindingNeeded(current_position, target_position)) {

      path.Clear();
      
      if (theGame
         .GetVolumePathManager()
         .GetPath(current_position, target_position, path)) {

        current_position = path[1];

        return true;
      }

      return false;
    }

    return true;
  }

  event OnLeaveState(nextStateName : name) {
    parent.RemoveTimer('StartContract_intervalDrawTracks');

    super.OnLeaveState(nextStateName);
  }
}