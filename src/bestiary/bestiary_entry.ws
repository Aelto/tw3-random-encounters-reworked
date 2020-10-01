
abstract class RER_BestiaryEntry {
  var type: CreatureType;

  var template_list: EnemyTemplateList;

  // names for this entity trophies
  // uses the enum TrophyVariant as index
  var trophy_names: array<name>;

  // the name used in the mod menus
  var menu_name: name;

  // both use the enum EncounterType as index
  var chances_day: array<int>;
  var chances_night: array<int>;

  var trophy_chance: float;

  var region_constraint: RER_RegionConstraint;

  var city_spawn: bool;

  public function init() {}

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences {
    LogChannel('modRandomEncounters', "setCreaturePreference called");

    return preferences
      .setCreatureType(this.type)
      .setChances(this.chances_day[encounter_type], this.chances_night[encounter_type])
      .setCitySpawnAllowed(this.city_spawn)
      .setRegionConstraint(this.region_constraint);
  }

  public function loadSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    var i: int;

    this.city_spawn = inGameConfigWrapper.GetVarValue('RER_CitySpawns', this.menu_name);
    this.trophy_chance = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', this.menu_name));
    this.region_constraint = StringToInt(inGameConfigWrapper.GetVarValue('RER_RegionConstraints', this.menu_name));

    this.chances_day.Clear();
    this.chances_night.Clear();

    for (i = 0; i < EncounterType_MAX; i += 1) {
      this.chances_day.PushBack(0);
      this.chances_night.PushBack(0);
    }

    this.chances_day[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('RERcreaturesRatiosAmbushDay', this.menu_name));
    this.chance_night[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('RERcreaturesRatiosAmbushNight', this.menu_name));
    this.chances_day[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('RERcreaturesRatiosHuntDay', this.menu_name));
    this.chance_night[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('RERcreaturesRatiosHuntNight', this.menu_name));


    // LogChannel('modRandomEncounters', "settings " + this.menu_name + " = " + this.city_spawn + " - " + this.trophy_chance + " " + this.chance_day + " " + this.region_constraint + " " );
  }

  public function isNull(): bool {
    return this.type == CreatureNONE;
  }
}

class RER_BestiaryEntryNull extends RER_BestiaryEntry {
  default type = CreatureNONE;

  public function isNull(): bool {
    return true;
  }
}