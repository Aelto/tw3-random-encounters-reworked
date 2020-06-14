
/**
 * NOTE: it makes a copy of the list
 **/
function fillEnemyTemplates(enemy_templates: array<SEnemyTemplate>, total_number_of_enemies: int): array<SEnemyTemplate> {
  var template_list: array<SEnemyTemplate>;
  var selected_template_to_increment: int;
  var max_tries: int;
  var i: int;

  template_list = copyTemplateList(enemy_templates);

  // first try to calculate the maximum number rolls
  // for when we will increment the count of a template
  // it is to avoid a long looping function
  max_tries = 0;

  LogChannel('modRandomEncounters', "template_list.Size()" + template_list.Size());

  for (i = 0; i < template_list.Size(); i += 1) {
    if (template_list[i].max < 0) {
      max_tries = total_number_of_enemies * 2;

      break;
    }

    max_tries += template_list[i].max;
  }

  LogChannel('modRandomEncounters', "maximum number of tries: " + max_tries);


  while (total_number_of_enemies > 0 && max_tries > 0) {
    max_tries -= 1;

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