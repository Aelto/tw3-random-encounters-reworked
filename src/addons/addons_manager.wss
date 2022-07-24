
statemachine class RER_AddonManager {
  var master: CRandomEncounters;

  /**
   * the queue of states to process, once a state is processed it
   * is removed from the queue. It goes from last item in the queue
   * to the first.
   */
  var states_to_process: array<name>;

  /**
   * the queue of states that were already processed. The first states
   * to be processed are first in the queue.
   */
  var processed_states: array<name>;

  /**
   * custom data officially supported by RER, it contains data we know may
   * potentially be injected into the mod and so we support it directly.
   */
  var addons_data: RER_AddonsData;

  public function init(master: CRandomEncounters) {
    this.master = master;
    this.GotoState('Loading');
  }
}

