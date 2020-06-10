
function copyTemplateList(list_to_copy: array<SEnemyTemplate>): array<SEnemyTemplate> {
  var copy: array<SEnemyTemplate>;
  var i: int;

  for (i = 0; i < list_to_copy.Size(); i += 1) {
    copy.PushBack(
      makeEnemyTemplate(
        list_to_copy[i].template,
        list_to_copy[i].max,
        list_to_copy[i].count
      )
    );
  }

  return copy;
}