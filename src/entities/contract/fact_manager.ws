enum RER_ContractFact {
	ContractFact_PHASE_KNEEL_PLAYED = 0,
	ContractFact_MAX = 	1,
	ContractFact_NONE = 2,
}

class RER_ContractFactManager {

	/**
	 * the enum `RER_ContractFact` for the index.
	 */
	var facts: array<int>;

  function init() {
    var i: int;

    if (ContractFact_MAX > 0) {
      this.facts.Resize(ContractFact_MAX + 1);
    }

    for (i = 0; i < ContractFact_MAX; i += 1) {
      this.set(i, 0);
    }
  }

	function get(fact: RER_ContractFact): int {
		return this.facts[fact];
	}

	function set(fact: RER_ContractFact, value: int) {
		this.facts[fact] = value;
	}

	function add(fact: RER_ContractFact) {
		this.facts[fact] = this.facts[fact] + 1;
	}

}