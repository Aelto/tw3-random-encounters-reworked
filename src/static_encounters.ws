
class RER_StaticEncounterManager {

  var encounters: array<RER_StaticEncounter>;

  var already_spawned_registered_encounters: bool;
  default already_spawned_registered_encounters = false;

  public latent function registerStaticEncounter(master: CRandomEncounters, encounter: RER_StaticEncounter) {
    this.encounters.PushBack(encounter);

    // instantly spawn the encounter if the RER already spawned the registered
    // static encounters
    if (this.already_spawned_registered_encounters) {
      this.trySpawnStaticEncounter(master, encounter);
    }
  }

  /**
   * Returns the amount of encounters spawned
   */
  public latent function spawnStaticEncounters(master: CRandomEncounters): int {
    var encounters_spawn_count: int;
    var has_spawned: bool;
    var i: int;

    encounters_spawn_count = 0;

    for (i = 0; i < this.encounters.Size(); i += 1) {
      has_spawned = this.trySpawnStaticEncounter(master, this.encounters[i]);

      // NDEBUG("has spawned: " + has_spawned);

      if (has_spawned) {
        encounters_spawn_count += 1;
      }
    }

    this.already_spawned_registered_encounters = true;

    return encounters_spawn_count;
  }

  private latent function trySpawnStaticEncounter(master: CRandomEncounters, encounter: RER_StaticEncounter): bool {

    LogChannel('modRandomEncounters', "can spawn?" + encounter.canSpawn());
    if (!encounter.canSpawn()) {
      LogChannel('modRandomEncounters', "can spawn: NO");
      return false;
    }

    LogChannel('modRandomEncounters', "can spawn: YES");

    encounter.bestiary_entry.spawn(
      master,
      encounter.getSpawningPosition(),
      , // count
      , // density
      true, // allow_trophies
    );

    return true;
  }

}

class RER_StaticEncounter {

  var bestiary_entry: RER_BestiaryEntry;

  var position: Vector;

  var region_constraint: RER_RegionConstraint;

  // used to fetch the spawning chance from the menu.
  var type: RER_StaticEncounterType;
  default type = StaticEncounterType_SMALL;

  var radius: float;
  default radius = 0.01;

  public function canSpawn(): bool {
    var entities: array<CGameplayEntity>;
    var current_region: string;
    var i: int;

    current_region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    if (this.region_constraint == RER_RegionConstraint_NO_VELEN && (current_region == "no_mans_land" || current_region == "novigrad")
    ||  this.region_constraint == RER_RegionConstraint_NO_SKELLIGE && (current_region == "skellige" || current_region == "kaer_morhen")
    ||  this.region_constraint == RER_RegionConstraint_NO_TOUSSAINT && current_region == "bob"
    ||  this.region_constraint == RER_RegionConstraint_NO_WHITEORCHARD && current_region == "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_TOUSSAINT && current_region != "bob"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_WHITEORCHARD && current_region != "prolog_village"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_SKELLIGE && current_region != "skellige" && current_region != "kaer_morhen"
    ||  this.region_constraint == RER_RegionConstraint_ONLY_VELEN && current_region != "no_mans_land" && current_region != "novigrad") {
      return false;
    }

    if (!this.rollSpawningChance()) {
      return false;
    }

    // check if the player is nearby, cancel spawn.
    if (VecDistanceSquared(thePlayer.GetWorldPosition(), this.position) < this.radius * this.radius) {
      LogChannel('modRandomEncounters', "StaticEncounter player too close");
      return false;
    }

    // check if an enemy from the `bestiary_entry` is nearby, cancel spawn.
    FindGameplayEntitiesCloseToPoint(
      entities,
      this.position,
      this.radius + 10, // the +10 is to still catch monster on small radius in case they move
      1 * (int)this.radius,
      , // tags
      , // queryflags
      , // target
      'CNewNPC'
    );

    for (i = 0; i < entities.Size(); i += 1) {
      // we found a nearby enemy that is from the same template
      if (this.isTemplateInEntry(entities[i])) {
        LogChannel('modRandomEncounters', "StaticEncounter already spawned");

        return false;
      }
    }

    LogChannel('modRandomEncounters', "StaticEncounter can spawn");

    return true;
  }

  private function isTemplateInEntry(template: string): bool {
    var i: int;

    for (i = 0; i < this.bestiary_entry.template_list.templates.Size(); i += 1) {
      if (this.bestiary_entry.template_list.templates[i].template == template) {
        return true;
      }
    }

    return false;
  }

  public function getSpawningPosition(): Vector {
    var max_attempt_count: int;
    var current_spawn_position: Vector;
    var i: int;

    max_attempt_count = 10;

    for (i = 0; i < max_attempt_count; i += 1) {
      current_spawn_position = this.position
        + VecRingRand(0, this.radius);

      if (getGroundPosition(current_spawn_position, , this.radius)) {
        return current_spawn_position;
      }
    }

    return this.position;
  }

  //
  // return `true` if the roll succeeded, and false if it didn't.
  private function rollSpawningChance(): bool {
    var spawn_chance: float;

    spawn_chance = this.getSpawnChance();

    if (RandRangeF(100) < spawn_chance) {
      return true;
    }

    return false;
  }

  //
  // fetch the spawning chance from the mod menu based on the static encounter type
  private function getSpawnChance(): float {
    var config_wrapper: CInGameConfigWrapper;

    config_wrapper = theGame.GetInGameConfigWrapper();

    if (this.type == StaticEncounterType_LARGE) {
      return StringToFloat(
        config_wrapper
        .GetVarValue('RERencountersGeneral', 'RERstaticEncounterLargeSpawnChance')
      );
    }
    else {
      return StringToFloat(
        config_wrapper
        .GetVarValue('RERencountersGeneral', 'RERstaticEncounterSmallSpawnChance')
      );
    }
  }

}

enum RER_StaticEncounterType {
  StaticEncounterType_SMALL = 0,
  StaticEncounterType_LARGE = 1,
}