
abstract class RER_BestiaryEntry {
  var type: CreatureType;

  var template_list: EnemyTemplateList;

  // stores a hash of the templates the bestiary entry has for a faster lookup.
  // Used by the function `isCreatureHashedNameFromEntry()`
  var template_hashes: array<int>;

  // names for this entity trophies
  // uses the enum TrophyVariant as index
  var trophy_names: array<name>;

  // the name used in the mod menus
  var menu_name: name;

  var ecosystem_impact: EcosystemCreatureImpact;

  // both use the enum EncounterType as index
  var chances_day: array<int>;
  var chances_night: array<int>;

  // the custom multiplier the user set for this specific creature type. By default
  // it's set at 1.
  var creature_type_multiplier: float;
  default creature_type_multiplier = 1;

  var trophy_chance: float;

  var crowns_percentage: float;

  var region_constraint: RER_RegionConstraint;

  var city_spawn: bool;

  public function init() {}

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences {
    return preferences
      .setCreatureType(this.type)
      .setChances(this.chances_day[encounter_type], this.chances_night[encounter_type])
      .setCitySpawnAllowed(this.city_spawn)
      .setRegionConstraint(this.region_constraint);
  }

  public function loadSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    var i: int;

    this.city_spawn = inGameConfigWrapper.GetVarValue('RERencountersSettlement', this.menu_name);
    this.trophy_chance = StringToInt(inGameConfigWrapper.GetVarValue('RERmonsterTrophies', this.menu_name));
    this.region_constraint = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersConstraints', this.menu_name));

    this.chances_day.Clear();
    this.chances_night.Clear();

    for (i = 0; i < EncounterType_MAX; i += 1) {
      this.chances_day.PushBack(0);
      this.chances_night.PushBack(0);
    }

    this.chances_day[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersAmbushDay', this.menu_name));
    this.chances_night[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersAmbushNight', this.menu_name));
    this.chances_day[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersHuntDay', this.menu_name));
    this.chances_night[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersHuntNight', this.menu_name));
    this.chances_day[EncounterType_CONTRACT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersContractDay', this.menu_name));
    this.chances_night[EncounterType_CONTRACT] = StringToInt(inGameConfigWrapper.GetVarValue('RERencountersContractNight', this.menu_name));
    this.creature_type_multiplier = StringToFloat(inGameConfigWrapper.GetVarValue('RERcreatureTypeMultiplier', this.menu_name));
    this.crowns_percentage = StringToFloat(inGameConfigWrapper.GetVarValue('RERmonsterCrowns', this.menu_name)) / 100.0f;

    for (i = 0; i < this.template_list.templates.Size(); i += 1) {
      this.template_hashes.PushBack(
        rer_hash_string(this.template_list.templates[i].template)
      );
    }

    // LogChannel('modRandomEncounters', "settings " + this.menu_name + " = " + this.city_spawn + " - " + this.trophy_chance + " " + this.chance_day + " " + this.region_constraint + " " );
  }

  public function isNull(): bool {
    return this.type == CreatureNONE;
  }

  public latent function spawn(master: CRandomEncounters, position: Vector, optional count: int, optional density: float, optional allow_trophies: bool, optional encounter_type: EncounterType): array<CEntity> {
    var creatures_templates: EnemyTemplateList;
    var group_positions: array<Vector>;
    var current_template: CEntityTemplate;
    var current_entity_template: SEnemyTemplate;
    var current_rotation: EulerAngles;
    var created_entity: CEntity;
    var created_entities: array<CEntity>;
    var group_positions_index: int;
    var i: int;
    var j: int;

    if (count == 0) {
      count = rollDifficultyFactor(
        this.template_list.difficulty_factor,
        master.settings.selectedDifficulty,
        master.settings.enemy_count_multiplier * this.creature_type_multiplier
      );
    }

    if (density <= 0) {
      density = 0.01;
    }

    LogChannel('RER', "BestiaryEntry, spawn() count = " + count);

    creatures_templates = fillEnemyTemplateList(
      this.template_list,
      count,
      master.settings.only_known_bestiary_creatures
    );

    group_positions = getGroupPositions(
      position,
      count,
      density
    );

    group_positions_index = 0;

    for (i = 0; i < creatures_templates.templates.Size(); i += 1) {
      current_entity_template = creatures_templates.templates[i];

      if (current_entity_template.count > 0) {
        current_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);
        current_rotation = VecToRotation(VecRingRand(1, 2));

        FixZAxis(group_positions[group_positions_index]);

        for (j = 0; j < current_entity_template.count; j += 1) {
          created_entity = theGame.CreateEntity(
            current_template,
            group_positions[group_positions_index],
            current_rotation
          );

          ((CNewNPC)created_entity).SetLevel(
            getRandomLevelBasedOnSettings(master.settings)
          );

          if (allow_trophies && RandRange(100) < this.trophy_chance) {
            LogChannel('modRandomEncounters', "adding 1 trophy " + this.type);
            
            ((CActor)created_entity)
              .GetInventory()
              .AddAnItem(
                this.trophy_names[master.settings.trophy_price],
                1
              );
          }

          // add crowns to the entity, based on the settings
          ((CActor)created_entity)
          .GetInventory()
          .AddMoney(
            (int)(
              master.settings.crowns_amounts_by_encounter[encounter_type]
              * this.crowns_percentage
              * RandRangeF(1.2, 0.8) // a random value between 80% and 120%
            )
          );

          if (!master.settings.enable_encounters_loot) {
            ((CActor)created_entity)
              .GetInventory()
              .EnableLoot(false);
          }

          created_entities.PushBack(created_entity);

          group_positions_index += 1;
        }
      }
    }

    return created_entities;
  }

  // checks if the hashed creature name is from this bestiary entry. To get a hashed
  // creature name, use CEntity::GetReadableName() and then use rer_hash_string()
  public function isCreatureHashedNameFromEntry(hashed_name: int): bool {
    var i: int;

    for (i = 0; i < this.template_hashes.Size(); i += 1) {
      if (this.template_hashes[i] == hashed_name) {
        return true;
      }
    }

    return false;
  }
}

class RER_BestiaryEntryNull extends RER_BestiaryEntry {
  default type = CreatureNONE;

  public function isNull(): bool {
    return true;
  }
}