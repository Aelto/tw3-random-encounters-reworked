
statemachine class WildHuntRiftHandler extends CEntity {
  var rifts: array<CEntity>;
  var job_done: bool;

  public function start() {
    this.job_done = false;
    this.GotoState('WildHuntRift_OpenRifts');
  }
  
  public function finish_job() {
    var i: int;

    for (i = 0; i < this.rifts.Size(); i += 1) {
      this.rifts[i].Destroy();
    }

    this.rifts.Clear();

    this.job_done = true;
  }
}

state WildHuntRift_OpenRifts in WildHuntRiftHandler {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    this.WildHuntRift_OpenRifts_Main();
  }

  entry function WildHuntRift_OpenRifts_Main() {
    var i: int;

    for (i = 0; i < parent.rifts.Size(); i += 1) {
      parent.rifts[i].PlayEffect('rift_activate');
    }

    parent.AddTimer('WildHuntRift_OpenRifts_Leave', 5, false);
  }

  timer function WildHuntRift_OpenRifts_Leave(optional dt : float, optional id : Int32) {
    parent.GotoState('WildHuntRift_CloseRifts');
  }
}

state WildHuntRift_CloseRifts in WildHuntRiftHandler {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    this.WildHuntRift_CloseRifts_Main();
  }

  entry function WildHuntRift_CloseRifts_Main() {
    var i: int;

    for (i = 0; i < parent.rifts.Size(); i += 1) {
      parent.rifts[i].StopEffect('rift_activate');
    }

    parent.AddTimer('WildHuntRift_CloseRifts_Leave', 2, false);
  }

  timer function WildHuntRift_OpenRifts_Leave(optional dt : float, optional id : Int32) {
    parent.finish_job();
  }
}
