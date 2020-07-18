
/**
 * NOTE: it makes a copy of the list
 **/
function fillEnemyTemplateList(enemy_template_list: EnemyTemplateList, total_number_of_enemies: int): EnemyTemplateList {
  var template_list: EnemyTemplateList;
  var selected_template_to_increment: int;
  var max_tries: int;
  var i: int;

  template_list = copyEnemyTemplateList(enemy_template_list);

  max_tries = 0;

  for (i = 0; i < template_list.templates.Size(); i += 1) {
    if (template_list.templates[i].max == 0) {
      max_tries = total_number_of_enemies * 2;

      break;
    }

    max_tries += template_list.templates[i].max;
  }

  LogChannel('modRandomEncounters', "maximum number of tries: " + max_tries);


  while (total_number_of_enemies > 0 && max_tries > 0) {
    max_tries -= 1;

    selected_template_to_increment = RandRange(template_list.templates.Size());

    LogChannel('modRandomEncounters', "selected template: " + selected_template_to_increment);

    if (template_list.templates[selected_template_to_increment].max > 0
      && template_list.templates[selected_template_to_increment].count >= template_list.templates[selected_template_to_increment].max) {
      continue;
    }

    template_list.templates[selected_template_to_increment].count += 1;

    total_number_of_enemies -= 1;
  }

  return template_list;
}