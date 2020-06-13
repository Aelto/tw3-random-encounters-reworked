
latent function spawnTemplateList(entities_templates: array<SEnemyTemplate>, position: Vector, optional density: float): array<CEntity> {
  var returned_entities: array<CEntity>;
  var current_iteration_entities: array<CEntity>;

  var current_entity_template: SEnemyTemplate;
  var current_template: CEntityTemplate;

  var i: int;
  var j: int;

  for (i = 0; i < entities_templates.Size(); i += 1) {
    current_entity_template = entities_templates[i];

    if (current_entity_template.count > 0) {
      current_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);

      current_iteration_entities = spawnEntities(
        current_template,
        position,
        current_entity_template.count,
        density
      );

      for (j = 0; j < current_iteration_entities.Size(); j += 1) {
        returned_entities.PushBack(current_iteration_entities[j]);
      }
    }
  }

  return returned_entities;
}