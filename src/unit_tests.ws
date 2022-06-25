exec function rerut_getImpactPointsForDifficulty() {
  var rer_entity : CRandomEncounters;
  var i: int;

  if (!getRandomEncounters(rer_entity)) {
    NDEBUG("No entity found with tag <RandomEncounterTag>");
    
    return;
  }

  for (i = 0; i < 100; i += 1) {
    NLOG(
      "rerut_getImpactPointsForDifficulty for " + i + " = "
      + rer_entity.contract_manager.getImpactPointsForDifficulty(RER_ContractDifficultyLevel(i))
    );
  }
}