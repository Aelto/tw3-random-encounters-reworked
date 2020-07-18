
function copyEnemyTemplateList(list_to_copy: EnemyTemplateList): EnemyTemplateList {
  var copy: EnemyTemplateList;
  var i: int;

  copy.difficulty_factor = list_to_copy.difficulty_factor;

  for (i = 0; i < list_to_copy.templates.Size(); i += 1) {
    copy.templates.PushBack(
      makeEnemyTemplate(
        list_to_copy.templates[i].template,
        list_to_copy.templates[i].max,
        list_to_copy.templates[i].count
      )
    );
  }

  return copy;
}