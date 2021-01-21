
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