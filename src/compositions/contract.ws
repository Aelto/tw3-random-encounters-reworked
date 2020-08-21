
latent function createRandomCreatureContract(master: CRandomEncounters, optional creature_type: CreatureType) {
  LogChannel('modRandomEncounters', "making create contract");

  if (!creature_type || creature_type == CreatureNONE) {
    creature_type = master.rExtra.getRandomCreatureByCurrentArea(
      master.settings,
      master.spawn_roller
    );
  }

  // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/5:
  // added the NONE check because the SpawnRoller can return
  // the NONE value if the user set all values to 0.
  if (creature_type == CreatureNONE) {
    LogChannel('modRandomEncounters', "creature_type is NONE, cancelling spawn");

    return;
  }
  
  makeDefaultCreatureHunt(master, creature_type);
}

latent function makeDefaultCreatureHunt(master: CRandomEncounters, creature_type: CreatureType) {
  var composition: CreatureContractComposition;

  composition = new CreatureContractComposition in this;

  composition.init();
  composition.setCreatureType(creature_type)
    .spawn(master);
}

class CreatureContractComposition extends CompositionSpawner {
  public function init() {
    this
      .setRandomPositionMinRadius(190)
      .setRandomPositionMaxRadius(200);
  }

  protected function forEachEntity(entity: CEntity) {
    ((CNewNPC)entity).SetLevel(GetWitcherPlayer().GetLevel());
  }

  protected latent function AfterSpawningEntities(): bool {
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
