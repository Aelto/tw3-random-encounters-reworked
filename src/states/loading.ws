
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
      50,
      StaticEncounterType_SMALL
    );

    // A burnt house near the water
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(620, -477, 0.9),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // A forest near water
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(730, -500, 11),
      RER_RegionConstraint_ONLY_VELEN,
      50,
      StaticEncounterType_SMALL
    );

    // A abandonned house with skeletons and hanged people in the forest
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(1060, -305, 6),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // a mountain near the swamp
    this.makeStaticEncounter(
      CreatureFORKTAIL,
      Vector(1310, -373, 22),
      RER_RegionConstraint_ONLY_VELEN,
      50,
      StaticEncounterType_LARGE
    );

    // a flat surface in the mountain near the swamp
    this.makeStaticEncounter(
      CreatureWYVERN,
      Vector(1329, -326, 43),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // abandonned human camp
    this.makeStaticEncounter(
      CreatureBEAR,
      Vector(990, -189, 15),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // a ruined castle near a swamp
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(1060, 1057, 7),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // mountains with lots of harpies
    this.makeStaticEncounter(
      CreatureHARPY,
      Vector(-200, 795, 31),
      RER_RegionConstraint_ONLY_VELEN,
      25,
      StaticEncounterType_SMALL
    );

    // castle with vanilla wyvern
    this.makeStaticEncounter(
      CreatureWYVERN,
      Vector(-286, 920, 14),
      RER_RegionConstraint_ONLY_VELEN,
      25,
      StaticEncounterType_LARGE
    );

    // castle basilisk from ciri scene
    this.makeStaticEncounter(
      CreatureBASILISK,
      Vector(-240, 565, 11),
      RER_RegionConstraint_ONLY_VELEN,
      50,
      StaticEncounterType_LARGE
    );

    // burning pyre full of human corpses
    this.makeStaticEncounter(
      CreatureROTFIEND,
      Vector(530, 956, 1),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // burning pyre full of human corpses
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(530, 956, 1),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // forest full of endregas
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(567, 1246, 9),
      RER_RegionConstraint_ONLY_VELEN,
      15,
      StaticEncounterType_SMALL
    );

    // forest full of endregas
    this.makeStaticEncounter(
      CreatureGRYPHON,
      Vector(604, 1200, 12),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // a beach in novigrad
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(375, 1963, 1),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // rotfiend nest
    this.makeStaticEncounter(
      CreatureROTFIEND,
      Vector(350, 980, 1.5),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // rotfiend nest
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(350, 980, 1.5),
      RER_RegionConstraint_ONLY_VELEN,
      20,
      StaticEncounterType_SMALL
    );

    // abandoned village near the swamp with blood everywhere
    this.makeStaticEncounter(
      CreatureWEREWOLF,
      Vector(638, -644, 2.5),
      RER_RegionConstraint_ONLY_VELEN,
      20,
      StaticEncounterType_LARGE
    );

    // White Orchard: ghouls in the cemetery
    this.makeStaticEncounter(
      CreatureGHOUL,
      Vector(-24, 284, 1.5),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      20,
      StaticEncounterType_SMALL
    );

    // White Orchard: Devil by the well
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(22, -264, 13),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // White Orchard: Devil by the well, lake nearby
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(117, -208, -0.7),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // White Orchard: An autel, somewhere in the forest
    this.makeStaticEncounter(
      CreatureBEAR,
      Vector(88, -136, 4.25),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      5,
      StaticEncounterType_SMALL
    );

    // White Orchard: Place where you kill the griffin
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(65, 230, 12.6),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // White Orchard: Wall with a gate, near the map limit
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(400, 208, 15),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
    );

    // White Orchard: Battle field, with lots of corpses
    this.makeStaticEncounter(
      CreatureGHOUL,
      Vector(552, 186, 20),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
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

  private latent function makeStaticEncounter(type: CreatureType, position: Vector, constraint: RER_RegionConstraint, radius: float, type: RER_StaticEncounterType) {
    var new_static_encounter: RER_StaticEncounter;

    new_static_encounter = new RER_StaticEncounter in parent;
    new_static_encounter.bestiary_entry = parent.bestiary.entries[type];
    new_static_encounter.position = position;
    new_static_encounter.region_constraint = constraint;
    new_static_encounter.radius = radius;
    new_static_encounter.type = RER_StaticEncounterType;

    parent
      .static_encounter_manager
      .registerStaticEncounter(parent, new_static_encounter);
  }
}
