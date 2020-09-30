
latent function createRandomCreatureContract(master: CRandomEncounters, optional creature_type: CreatureType) {
  var bestiary_entry: RER_BestiaryEntry;

  LogChannel('modRandomEncounters', "making create contract");

  if (creature_type == CreatureNONE) {
    bestiary_entry = master
      .bestiary
      .getRandomEntryFromBestiary(master);
  }
  else {
    bestiary_entry = master
      .bestiary
      .entries[creature_type];
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (bestiary_entry.isNull()) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }
  
  makeDefaultCreatureContract(master, bestiary_entry);
}

latent function makeDefaultCreatureContract(master: CRandomEncounters, bestiary_entry: RER_BestiaryEntry) {
  var composition: CreatureContractComposition;

  composition = new CreatureContractComposition in master;

  composition.init();
  composition.setBestiaryEntry(bestiary_entry)
    .spawn(master);
}

class CreatureContractComposition extends CompositionSpawner {
  public function init() {
    this
      .setRandomPositionMinRadius(190)
      .setRandomPositionMaxRadius(200);
  }

  protected latent function forEachEntity(entity: CEntity) {
    ((CNewNPC)entity).SetLevel(GetWitcherPlayer().GetLevel());
  }

  protected latent function afterSpawningEntities(): bool {
    var rer_contract_entity: RandomEncountersReworkedContractEntity;
    var i: int;

    rer_contract_entity = (RandomEncountersReworkedContractEntity)theGame.CreateEntity(
      (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\rer_monster_contract_entity.w2ent",
        true
      ),
      this.initial_position,
      thePlayer.GetWorldRotation()
    );

    if (!this.master.settings.enable_encounters_loot) {
      rer_contract_entity.removeAllLoot();
    }

    rer_contract_entity.start();

    return true;
  }
}
