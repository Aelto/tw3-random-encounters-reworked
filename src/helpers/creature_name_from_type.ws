
function getCreatureNameFromCreatureType(bestiary: RER_Bestiary, type: CreatureType): string {
  if (type >= CreatureMAX) {
    return GetLocStringByKey("rer_unknown");
  }

  return GetLocStringByKey(bestiary.entries[type].localized_name);
}