
state Loading in CRandomEncounters {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "Entering state LOADING");

    this.startLoading();
  }

  entry function startLoading() {
    if (theGame.GetInGameConfigWrapper().GetVarValue('RERoptionalFeatures', 'RERdelayLoadingStart')) {
      NLOG("Delaying RER loading start");

      Sleep(5);
    }

    this.removeAllRerMapPins();

    parent.bounty_manager.bounty_master_manager.init(parent.bounty_manager);
    this.registerStaticEncounters();

    // give time for other mods to register their static encounters
    Sleep(10);

    // it's super important the mod takes control of the creatures BEFORE spawning
    // the static encounters, or else RER will considered creatures from static encounters
    // like HuntingGround encounters and because of the death threshold distance
    // it will kill them instantly. We don't want them to be killed.
    this.takeControlOfEntities();

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

    // White Orchard: Endregas near a tree behind the mill
    this.makeStaticEncounter(
      CreatureKIKIMORE,
      Vector(138, 348, 14),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      20,
      StaticEncounterType_LARGE
    );

    // skellige, wraiths on a house near a lake
    this.makeStaticEncounter(
      CreatureNIGHTWRAITH,
      Vector(378, 173, 22),
      RER_RegionConstraint_ONLY_SKELLIGE,
      15,
      StaticEncounterType_LARGE
    );

    // a random, lost village
    this.makeStaticEncounter(
      CreatureFIEND,
      Vector(1995, -643, 0),
      RER_RegionConstraint_ONLY_VELEN,
      25,
      StaticEncounterType_SMALL
    );

    // people hanged on a tree
    this.makeStaticEncounter(
      CreatureWRAITH,
      Vector(-447, -77, 10),
      RER_RegionConstraint_ONLY_VELEN,
      15,
      StaticEncounterType_SMALL
    );

    // people hanged on a tree
    this.makeStaticEncounter(
      CreatureCOCKATRICE,
      Vector(-90, -848, 6),
      RER_RegionConstraint_ONLY_VELEN,
      40,
      StaticEncounterType_LARGE
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

    // this.test();
  }

  // the mod loses control of the previously spawned entities when the player
  // reloads. So when the mod is initialized it loops through all the RER entities
  // (thanks to a tag) and then finds groups of creatures and links them to a
  // HuntEntity manager that will control them again.
  private latent function takeControlOfEntities() {
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var rer_entity_template: CEntityTemplate;
    var surrounding_entities: array<CGameplayEntity>;
    var entity_group: array<CEntity>;
    var entities: array<CEntity>;
    var entity: CEntity;
    var i, k: int;

    LogChannel('RER', "takeControlOfEntities()");


    theGame.GetEntitiesByTag('RandomEncountersReworked_Entity', entities);

    for (i = 0; i < entities.Size(); i += 1) {
      entity = entities[i];

      entity.SetLevel(getRandomLevelBasedOnSettings(parent.settings));
      entity.RemoveTag('RER_controlled');
    }

    // this function adds the `RER_controlled` tag to the creatures who have the
    // `RER_BountyEntity` tag. Hence the if case below that checks for the tag.
    parent.bounty_manager.retrieveBountyGroups();

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    for (i = 0; i < entities.Size(); i += 1) {
      entity = entities[i];
      
      // RER has already taken control of this creature so we ignore it.
      if (entity.HasTag('RER_controlled')) {
        continue;
      }

      surrounding_entities.Clear();

      FindGameplayEntitiesInRange(
        surrounding_entities,
        entity,
        20, // radius
        20, // max number of entities
        'RandomEncountersReworked_Entity', // tag
        FLAG_ExcludePlayer,
        thePlayer, // target
        'CNewNPC'
      );

      entity_group.Clear();

      // the goal here is to create a list of entities in the surrounding areas
      // that RER will take control of.
      for (k = 0; k < surrounding_entities.Size(); k += 1) {
        // RER has already taken control of this creature so we ignore it.
        if (entity.HasTag('RER_controlled')) {
          continue;
        }

        entity_group.PushBack(surrounding_entities[k]);

        surrounding_entities[k].AddTag('RER_controlled');
      }

      if (entity_group.Size() > 0) {
        rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, entity.GetWorldPosition(), entity.GetWorldRotation());
        rer_entity.startEncounter(parent, entity_group, parent.bestiary.entries[parent.bestiary.getCreatureTypeFromEntity(entity)]);
        LogChannel('modRandomEncounters', "created a HuntingGround with " + entity_group.Size() + " RER entities");
      }
    }

    for (i = 0; i < entities.Size(); i += 1) {
      entities[i].RemoveTag('RER_controlled');
    }

    LogChannel('modRandomEncounters', "found " + entities.Size() + " RER entities");
  }

  private latent function makeStaticEncounter(type: CreatureType, position: Vector, constraint: RER_RegionConstraint, radius: float, encounter_type: RER_StaticEncounterType) {
    var new_static_encounter: RER_StaticEncounter;

    new_static_encounter = new RER_StaticEncounter in parent;
    new_static_encounter.bestiary_entry = parent.bestiary.entries[type];
    new_static_encounter.position = position;
    new_static_encounter.region_constraint = constraint;
    new_static_encounter.radius = radius;
    new_static_encounter.type = encounter_type;

    parent
      .static_encounter_manager
      .registerStaticEncounter(parent, new_static_encounter);
  }

  private function removeAllRerMapPins() {
    SU_removeCustomPinByPredicate(new SU_CustomPinRemoverPredicateFromRER in parent);
  }
}

class SU_CustomPinRemoverPredicateFromRER extends SU_PredicateInterfaceRemovePin {
  function predicate(pin: SU_MapPin): bool {
    return StrStartsWith(pin.tag, "RER_");
  }
}