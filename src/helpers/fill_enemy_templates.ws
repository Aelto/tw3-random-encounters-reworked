
/**
 * NOTE: it makes a copy of the list
 **/
function fillEnemyTemplates(enemy_templates: array<SEnemyTemplate>, total_number_of_enemies: int): array<SEnemyTemplate> {
  var template_list: array<SEnemyTemplate>;
  var selected_template_to_increment: int;

  template_list = copyTemplateList(enemy_templates);

  while (total_number_of_enemies > 0) {
    selected_template_to_increment = RandRange(template_list.Size());

    LogChannel('modRandomEncounters', "selected template: " + selected_template_to_increment);

    if (template_list[selected_template_to_increment].max > -1
      && template_list[selected_template_to_increment].count >= template_list[selected_template_to_increment].max) {
      continue;
    }

    template_list[selected_template_to_increment].count += 1;

    total_number_of_enemies -= 1;
  }

  return template_list;
}