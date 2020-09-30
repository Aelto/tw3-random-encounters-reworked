
abstract class RER_BestiaryEntry {
  var type: CreatureType;

  var template_list: EnemyTemplateList;

  // names for this entity trophies
  // uses the enum TrophyVariant as index
  var trophy_names: array<name>;

  // the name used in the mod menus
  var menu_name: name;

  var chance_day: int;

  var chance_night: int;

  var trophy_chance: float;

  var region_constraint: RER_RegionConstraint;

  var city_spawn: bool;

  public function init() {}

  public function setCreaturePreferences(preferences: RER_CreaturePreferences): RER_CreaturePreferences {
    LogChannel('modRandomEncounters', "setCreaturePreference called");

    return preferences
      .setCreatureType(this.type)
      .setChances(this.chance_day, this.chance_night)
      .setCitySpawnAllowed(this.city_spawn)
      .setRegionConstraint(this.region_constraint);
  }

  public function loadSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    this.city_spawn = inGameConfigWrapper.GetVarValue('RER_CitySpawns', this.menu_name);
    this.trophy_chance = StringToInt(inGameConfigWrapper.GetVarValue('RER_monsterTrophies', this.menu_name));
    this.chance_day = StringToInt(inGameConfigWrapper.GetVarValue('customGroundDay', this.menu_name));
    this.chance_night = StringToInt(inGameConfigWrapper.GetVarValue('customGroundNight', this.menu_name));
    this.region_constraint = StringToInt(inGameConfigWrapper.GetVarValue('RER_RegionConstraints', this.menu_name));

    LogChannel('modRandomEncounters', "settings " + this.menu_name + " = " + this.city_spawn + " - " + this.trophy_chance + " " + this.chance_day + " " + this.region_constraint + " " );
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