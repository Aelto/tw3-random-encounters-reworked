
// this manager class doesn't do much actually, it's more of a namespace for functions
// about the ecosystem feature.
class RER_EcosystemManager {
  var master: CRandomEncounters;

  var impact_list: array<EcosystemCreatureImpact>;

  public function init(master: CRandomEncounters) {
    this.master = master;

    this.impact_list = getEcosystemImpactList();
  }

  // returns the EcosystemAreas the player is currently in.
  // EcosystemAreas can overlap and so it returns an array
  public function getCurrentEcosystemAreas(): array<EcosystemArea> {
    var player_position: Vector;
    var current_area: EcosystemArea;
    var output: array<EcosystemArea>;
    var i: int;

    player_position = thePlayer.GetWorldPosition();
    for (i = 0; i < this.master.storages.ecosystem.ecosystem_areas; i += 1) {
      current_area = this.master.storages.ecosystem.ecosystem_areas[i];

      // check if the player in is the radius
      if (VecDistanceSquared(player_position, current_area.position) < current_area.radius * current_area.radius) {
        output.PushBack(current_area);
      }
    }

    return output;
  }

  public function getCreatureModifiersForEcosystemAreas(areas: array<EcosystemArea>): array<float> {
    var output: array<float>;
    var current_area: EcosystemArea;
    var current_power: int;
    var current_impact: EcosystemCreatureImpact;
    var i, j, k: int;

    // first we fill the array with 0 for each creature type
    for (i = 0; i < CreatureMAX; i += 1) {
      output.PushBack(0);
    }

    // now for each area
    for (i = 0; i < areas.Size(); i += 1) {
      current_area = areas[i];

      for (j = 0; j < current_area.impacts_power_by_creature_type.Size(); j += 1) {
        current_power = current_area.impacts_power_by_creature_type[j];

        // when power is at 0 we can skip it as it won't change anything
        if (current_power == 0) {
          continue;
        }

        // note that here, J is also an int that can be used as a CreatureType
        current_impact = this.impact_list[j];

        // now we loop through each influence and add them to the output
        // the influence is multiplied by the power of the current CreatureType
        for (k = 0; k < current_impact.influences.Size(); k += 1) {
          output[j] += current_power * current_impact.influences[k];
        }
      }
    }

    // here we now have a list of the influenced spawn rates for each CreatureType.
    // the influenced spawn rate is a float value that tells by how much the creature's
    // spawn rate should be multiplied. It can be positive or negative.
    return output;
  }

  public function udpateCountersWithCreatureModifiers(out counters: array<int>, modifiers: array<float>) {
    var i: int;

    if (counters.Size() != modifiers.Size()) {
      LogChannel('RER', "attempt at updating counters with creature modifiers, but counters and modifiers are not of the same size");

      return;
    }

    for (i = 0; i < counters.Size(); i += 1) {
      // here, it's an added value `+=` and not a `=` so if the modifiers is at
      // 0 it won't change the value rather than setting it at 0.
      // See modifiers as an % increase/decrease.
      //
      // TODO: ecosystem, add a menu option to control how much the modifier change
      // the values. It would result in `counters[i] * modifiers[i] * menu_modifier`
      // so the user can control how much the ecosystem feature affects the
      // spawn rates.
      counters[i] += counters[i] * modifiers[i];
    }
  }

  // this function fetches the current ecosystem areas the player is in, then
  // updates the power for the supplied creature by additioning the supplied
  // `power_change` value to the current `power` value of the creature in the
  // current areas.
  //
  // If there are no EcosystemArea around the player this function creates a new
  // one at the exact position of the player.
  //
  // If there are multiple EcosystemAreas around the player this function updates
  // the power values based on the distances.
  //
  // No matter the count of EcosystemAreas around the player it updates the power
  // value by calculating the % distance from the center of the area to its extremity.
  //
  // NOTE: the function saves the ecosystem storage after the operation.
  public function updatePowerForCreatureInCurrentEcosystemAreas(creature: CreatureType, power_change: float) {
    var ecosystem_areas: array<EcosystemArea>;
    var current_ecosystem_area: EcosystemArea;
    var distance_from_center: float;
    var player_position: Vector;
    var i: int;

    player_position = thePlayer.GetWorldPosition();
    ecosystem_areas = this.getCurrentEcosystemAreas();

    if (ecosystem_areas.Size() == 0) {
      current_ecosystem_area = getNewEcosystemArea(
        player_position,
        50 // default ecosystem area radius is 50 meters
      );

      ecosystem_areas.PushBack(current_ecosystem_area);
    }

    for (i = 0; i < ecosystem_areas.Size(); i += 1) {
      current_ecosystem_area = ecosystem_areas[i];
      
      // at the moment it's just the raw squared distance
      distance_from_center = VecDistanceSquared(
        current_ecosystem_area.position,
        player_position
      );

      // now it's a percentage value going from 0 to 1
      distance_from_center = distance_from_center / (current_ecosystem_area.radius * current_ecosystem_area);

      current_ecosystem_area.impacts_power_by_creature_type[creature] += power_change * distance_from_center;
    }

    // we now save the storage to store the power change.
    this.master
      .storages
      .ecosystem
      .save();
  }

  // returns a new empty ecosystem area with all default values initiliased
  public function getNewEcosystemArea(position: Vector, radius: Vector): EcosystemArea {
    var area: EcosystemArea;
    var i: int;

    for (i = 0; i < CreatureMAX; i += 1) {
      area.impacts_power_by_creature_type.PushBack(0);
    }

    return area;
  }

}