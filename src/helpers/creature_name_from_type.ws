
function getCreatureNameFromCreatureType(bestiary: RER_Bestiary, type: CreatureType): string {
  if (type >= CreatureMAX) {
    return GetLocStringByKey("rer_unknown");
  }

  NLOG("name from type " + GetLocStringByKey(bestiary.entries[type].localized_name) + " for " + type);

  return GetLocStringByKey(bestiary.entries[type].localized_name);
}