
function getCreatureNameFromCreatureType(bestiary: RER_Bestiary, type: CreatureType): string {
  if (type >= CreatureMAX) {
    return "Unknown";
  }

  return bestiary.entries[type].menu_name;
}