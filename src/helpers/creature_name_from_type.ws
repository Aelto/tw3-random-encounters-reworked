
function getCreatureNameFromCreatureType(bestiary: RER_Bestiary, type: CreatureType): string {
  if (type >= CreatureMAX) {
    return "Unknown";
  }

  return StrReplace(bestiary.entries[type].menu_name, "_", " ");
}