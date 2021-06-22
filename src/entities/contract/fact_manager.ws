enum RER_ContractFact {
	ContractFact_PHASE_KNEEL_PLAYED = 0,
	ContractFact_PHASE_NPC_RESCUE_PLAYED = 1,
	ContractFact_MAX = 	2,
	ContractFact_NONE = 3,
}

class RER_ContractFactManager {

	/**
	 * the enum `RER_ContractFact` for the index.
	 */
	var facts: array<int>;

  function init() {
    var i: int;

    for (i = 0; i < ContractFact_MAX; i += 1) {
			this.facts.PushBack(0);
    }
  }

	function get(fact: RER_ContractFact): int {
		return this.facts[fact];
	}

	function set(fact: RER_ContractFact, value: int) {
		NLOG("Contract::FactMananer - " + fact + " set to " + value);

		this.facts[fact] = value;
	}

	function add(fact: RER_ContractFact) {
		this.set(fact, this.get(fact) + 1);
	}

}