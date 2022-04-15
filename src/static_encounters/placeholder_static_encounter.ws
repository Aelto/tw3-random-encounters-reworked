
enum RER_PlaceholderStaticEncounterType {
  /**
   * When set with this the SE will use the ecosystem data to pick a random creature
   * at every trigger.
   */
  RER_PSET_LearnFromEcosystem = 0,

  /**
   * When set with this the SE will search for a nearby creature and will then spawn
   * it again at every future trigger.
   *
   * If no creatures were found and a trigger happens, it will search for a copy again
   * and if still no creature was found then it defaults to `LearnFromEcosystem`.
   */
  RER_PSET_CopyNearbyCreature = 1
}

class RER_PlaceholderStaticEncounter extends RER_StaticEncounter {
  public var placeholder_type: RER_PlaceholderStaticEncounterType;

  public var picked_creature_type: CreatureType;
  default picked_creature_type = CreatureNONE;

  /**
   * Controls whether this static encounter can spawn its creatures even if
   * there are other creatures in the area.
   * true: can spawn
   * false: cannot spawn
   */
  private var ignore_creature_check: bool;

  public function init(ignore_creature_check: bool, position: Vector, radius: float, type: RER_StaticEncounterType, placeholder_type: RER_PlaceholderStaticEncounterType): RER_PlaceholderStaticEncounter {
    this.ignore_creature_check = ignore_creature_check;
    this.position = position;
    this.type = type;
    this.radius = radius;
    this.region_constraint = RER_RegionConstraint_NONE;
    this.placeholder_type = placeholder_type;

    return this;
  }

  /**
   * override the function to return true whenever it finds a monster instead of
   * a specific bestiary entry.
   */
  private function areThereEntitiesWithSameTemplate(entities: array<CGameplayEntity>): bool {
    var hashed_name: string;
    var actor: CActor;
    var i: int;

    if (this.ignore_creature_check) {
      return false;
    }

    for (i = 0; i < entities.Size(); i += 1) {
      actor = (CActor)entities[i];

      if (actor) {
        if (actor.IsMonster()) {
          return true;
        }
      }
    }
    
    return false;
  }

  /**
   * override the function to return a random entry based on the surrounding
   * ecosystem.
   *
   * warning: side effect, depending on the RER_PlaceholderStaticEncounterType
   * it may run some additional functions.
   */
  public latent function getBestiaryEntry(master: CRandomEncounters): RER_BestiaryEntry {
    var filter: RER_SpawnRollerFilter;

    filter = (new RER_SpawnRollerFilter in this)
      .init();

    if (this.placeholder_type == StaticEncounterType_SMALL) {
      filter
        .setOffsets(
          constants.large_creature_begin,
          constants.large_creature_max,
          0 // creature outside the offset have 0% chance to appear
        );
    }
    else {
      filter
        .setOffsets(
          constants.large_creature_begin,
          constants.large_creature_max,
          0 // creature outside the offset have 0% chance to appear
        );
    }

    if (this.placeholder_type == RER_PSET_LearnFromEcosystem) {
      return master.bestiary.getRandomEntryFromBestiary(
        master,
        EncounterType_HUNTINGGROUND,
        RER_flag(RER_BREF_IGNORE_SETTLEMENT, true),
        filter
      );
    }
    else if (this.placeholder_type == RER_PSET_CopyNearbyCreature) {
      // this placeholder static encounter has not yet found an entity to copy 
      if (this.picked_creature_type == CreatureNONE) {
        this.picked_creature_type = this.findRandomNearbyHostileCreatureType(master);
      }

      // if it's still none then we default back to
      // the LearnFromEcosystem behavior
      if (this.picked_creature_type == CreatureNONE) {
        return master.bestiary.getRandomEntryFromBestiary(
          master,
          EncounterType_HUNTINGGROUND,
          RER_flag(RER_BREF_IGNORE_SETTLEMENT, true),
          filter
        );
      }

      return master.bestiary.getEntry(this.picked_creature_type);
    }

    NDEBUG("RER warning: RER_PlaceholderStaticEncounter::getBestiaryEntry(), returning RER_BestiaryEntryNull.");

    return new RER_BestiaryEntryNull in master;
  }

  private function findRandomNearbyHostileCreatureType(master: CRandomEncounters): CreatureType {
    var possible_types: array<CreatureType>;
    var entities: array<CGameplayEntity>;
    var current_type: CreatureType;
    var current_entity: CEntity;
    var i: int;

    FindGameplayEntitiesCloseToPoint(
      entities,
      this.position,
      this.radius + 20, // the +20 is to still catch monster on small radius in case they move
      1 * (int)this.radius,
      , // tags
      FLAG_ExcludePlayer | FLAG_OnlyAliveActors | FLAG_Attitude_Hostile, // queryflags
      thePlayer, // target
      'CNewNPC'
    );

    for (i = 0; i < entities.Size(); i += 1) {
      current_entity = (CEntity)entities[i];

      if (current_entity) {
        current_type = master.bestiary.getCreatureTypeFromReadableName(current_entity.GetReadableName());

        if (current_type == CreatureNONE) {
          continue;
        }

        possible_types.PushBack(current_type);
      }
    }

    // note: we re-use i here instead of making a new variable for the array size
    i = possible_types.Size();
    if (i <= 0) {
      return CreatureNONE;
    }

    // note: we re-use i here for the random index now
    i = RandRange(i, 0);

    return possible_types[i];
  }
}

function RER_placeholderStaticEncounterCanSpawnAtPosition(position: Vector, rng: RandomNumberGenerator, playthrough_seed: int): bool {
  var seed: int;

  rng
    .useSeed(true)
    .setSeed(playthrough_seed + position.X + position.Y + position.Z);

  return rng.nextRange(100, 0) > 50;
}
