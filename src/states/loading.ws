
state Loading in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state LOADING");

    this.startLoading();
  }

  entry function startLoading() {
    this.registerStaticEncounters();

    // give time for other mods to register their static encounters
    Sleep(10);

    parent.static_encounter_manager.spawnStaticEncounters(parent);

    parent.GotoState('Waiting');
  }

  latent function registerStaticEncounters() {

    // A random swamp in velen
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(360, -375, 0),
      RER_RegionConstraint_ONLY_VELEN,
      50
    );

    // A burnt house near the water
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(620, -477, 0.9),
      RER_RegionConstraint_ONLY_VELEN,
      10
    );

    // A forest near water
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(730, -500, 11),
      RER_RegionConstraint_ONLY_VELEN,
      50
    );

    // A abandonned house with skeletons and hanged people in the forest
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(1060, -305, 6),
      RER_RegionConstraint_ONLY_VELEN,
      5
    );

    // var example_static_encounter: RER_StaticEncounter;

    // example_static_encounter = new RER_StaticEncounter in this;
    // example_static_encounter.bestiary_entry = parent.bestiary.entries[CreatureTROLL];
    // example_static_encounter.position = Vector(2444, 2344, 3);
    // example_static_encounter.region_constraint = RER_RegionConstraint_ONLY_VELEN;
    // example_static_encounter.radius = 5;

    // parent
    //   .static_encounter_manager
    //   .registerStaticEncounter(parent, example_static_encounter);
  }

  private latent function makeStaticEncounter(type: CreatureType, position: Vector, constraint: RER_RegionConstraint, radius: float) {
    var new_static_encounter: RER_StaticEncounter;

    new_static_encounter = new RER_StaticEncounter in parent;
    new_static_encounter.bestiary_entry = parent.bestiary.entries[type];
    new_static_encounter.position = position;
    new_static_encounter.region_constraint = constraint;
    new_static_encounter.radius = radius;

    parent
      .static_encounter_manager
      .registerStaticEncounter(parent, new_static_encounter);
  }
}
