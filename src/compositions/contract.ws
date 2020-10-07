
// This composition is different, it is not really a composition because it
// doesn't use the CompositionSpawner.
// Because this class isn't a class of type "one instance per entity" but
// instead a single class handling the whole encounter.
latent function createRandomCreatureContract(master: CRandomEncounters) {
  var rer_entity_template: CEntityTemplate;
  var contract_entity: RandomEncountersReworkedContractEntity;

  rer_entity_template = (CEntityTemplate)LoadResourceAsync(
    "dlc\modtemplates\randomencounterreworkeddlc\data\rer_contract_entity.w2ent",
    true
  );

  contract_entity = (RandomEncountersReworkedContractEntity)theGame.CreateEntity(
    rer_entity_template,
    thePlayer.GetWorldPosition(),
    thePlayer.GetWorldRotation()
  );

  contract_entity.startContract(master);
}