
statemachine class RER_HordeManager {
  var master: CRandomEncounters;
  var requests: array<RER_HordeRequest>;

  public function init(master: CRandomEncounters) {
    this.master = master;
    this.GotoState('Waiting');
  }

  public function sendRequest(request: RER_HordeRequest) {
    this.requests.PushBack(request);

    if (this.GetCurrentStateName() != 'Processing') {
      this.GotoState('Processing');
    }
  }

  public function clearRequests() {
    this.requests.Clear();
  }
}

