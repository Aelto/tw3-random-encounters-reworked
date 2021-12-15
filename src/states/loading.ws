
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
    RER_addNoticeboardInjectors();

    parent.refreshEcosystemFrequencyMultiplier();

    // give time for other mods to register their static encounters
    Sleep(10);

    // it's super important the mod takes control of the creatures BEFORE spawning
    // the static encounters, or else RER will considered creatures from static encounters
    // like HuntingGround encounters and because of the death threshold distance
    // it will kill them instantly. We don't want them to be killed.
    this.takeControlOfEntities();

    parent.static_encounter_manager.spawnStaticEncounters(parent);

    SU_updateMinimapPins();

    parent.GotoState('Waiting');
  }

  latent function registerStaticEncounters() {
    var version: StaticEncountersVariant;

    version = StringToInt(
      theGame.GetInGameConfigWrapper()
      .GetVarValue('RERencountersGeneral', 'RERstaticEncounterVersion')
    );

    if (version == StaticEncountersVariant_LUCOLIVIER) {
      this.registerStaticEncountersLucOliver();
    }
    else {
      this.registerStaticEncountersAeltoth();
    }
  }

  latent function registerStaticEncountersLucOliver() {
    // White Orchard swamp
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(-417, 246, -0.1),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      20,
      StaticEncounterType_LARGE
     );

    // White Orchard Burned house
    this.makeStaticEncounter(
      CreatureNOONWRAITH,
      Vector(-165, -104, 6.6),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      5,
      StaticEncounterType_LARGE
     );

    // White Orchard Ghoul near power
    this.makeStaticEncounter(
      CreatureGHOUL,
      Vector(-92, -330, 32),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
     );

    // White Orchard By Well
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(32, -269, 13.3),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      5,
      StaticEncounterType_SMALL
     );

    // White Orchard near pond
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(120, -220, 0.5),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      20,
      StaticEncounterType_SMALL
     );

    // White Orchard near stones in forest
    this.makeStaticEncounter(
      CreatureBEAR,
      Vector(92, -138, 4.2),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
     );

    // White Orchard near fields
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(137, 38, 1.1),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      5,
      StaticEncounterType_SMALL
     );

    // White Orchard Near thy graveyard
    this.makeStaticEncounter(
      CreatureWRAITH,
      Vector(-78, 295, 4),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      10,
      StaticEncounterType_SMALL
     );

    // White Orchard horpse corpse
    this.makeStaticEncounter(
      CreatureGHOUL,
      Vector(73, 285, 8.3),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      20,
      StaticEncounterType_SMALL
     );

    // White Orchard field with nothing
    this.makeStaticEncounter(
      CreatureBARGHEST,
      Vector(142, 326, 14.4),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      20,
      StaticEncounterType_SMALL
     );

    // White Orchard GATE
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(406, 211, 15.2),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      5,
      StaticEncounterType_SMALL
     );

    // White Orchard Waterfall
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(421, 191, -0.3),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      5,
      StaticEncounterType_LARGE
     );

    // White Orchard Bonus
    this.makeStaticEncounter(
      CreatureCHORT,
      Vector(311, 49, 0.2),
      RER_RegionConstraint_ONLY_WHITEORCHARD,
      5,
      StaticEncounterType_LARGE
     );

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

    // Abandonned field
    this.makeStaticEncounter(
      CreatureALGHOUL,
      Vector(796, 490, 13.4),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_LARGE
    );

    // entrace to wyvern cave
    this.makeStaticEncounter(
      CreatureTROLL,
      Vector(1889, 47, 41.8),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_LARGE
    );

    // Troll's swamp
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(1487, 1132, -0.3),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_LARGE
    );

    // Haunted forest
    this.makeStaticEncounter(
      CreatureLESHEN,
      Vector(235, 1509, 19),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_LARGE
    );

    // Beach, near good troll
    this.makeStaticEncounter(
      CreatureFORKTAIL,
      Vector(103, 892, 7.7),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_LARGE
    );

    // Basilisk place
    this.makeStaticEncounter(
      CreatureBASILISK,
      Vector(-90, 1487, 9.3),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_LARGE
    );

    // A abandonned house with skeletons 
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(1060, -305, 6),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // Harpy location
    this.makeStaticEncounter(
      CreatureHARPY,
      Vector(-98, 603, 11.1),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // a flat surface in the mountain near the swamp
    this.makeStaticEncounter(
      CreatureWYVERN,
      Vector(1329, -326, 50),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

   // Near Graveyard, 
    this.makeStaticEncounter(
      CreatureGHOUL,
      Vector(-218, 380, 15.4),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // a beach in novigrad
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(375, 1963, 1),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // a random lost village
    this.makeStaticEncounter(
      CreatureFIEND,
      Vector(1995, -643, 0),
      RER_RegionConstraint_ONLY_VELEN,
      25,
      StaticEncounterType_LARGE
    );

    // people hanged on a tree
    this.makeStaticEncounter(
      CreatureWRAITH,
      Vector(-447, -77, 10),
      RER_RegionConstraint_ONLY_VELEN,
      15,
      StaticEncounterType_SMALL
    );

    // Forest with insects
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(512, 1232, 11.3),
      RER_RegionConstraint_ONLY_VELEN,
      25,
      StaticEncounterType_SMALL
    );

    // A pond near boat
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(-450, -440, 0),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // NORTH near endregas
    this.makeStaticEncounter(
      CreatureARACHAS,
      Vector(797, 2318, 7),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // Abandonned ilse
    this.makeStaticEncounter(
      CreatureFOGLET,
      Vector(529, -117, -7.9),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // South of crow's perch
    this.makeStaticEncounter(
      CreatureNEKKER,
      Vector(161, -108, 5.4),
      RER_RegionConstraint_ONLY_VELEN,
      20,
      StaticEncounterType_LARGE
    );

    // Middle of nowhere
    this.makeStaticEncounter(
      CreatureBARGHEST,
      Vector(667, 150, 4.5),
      RER_RegionConstraint_ONLY_VELEN,
      20,
      StaticEncounterType_SMALL
    );

    // Unused Pong
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(1335, 524, 5.3),
      RER_RegionConstraint_ONLY_VELEN,
      20,
      StaticEncounterType_LARGE
    );

    // rotfiend nest
    this.makeStaticEncounter(
      CreatureROTFIEND,
      Vector(350, 980, 1.5),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // Mage House
    this.makeStaticEncounter(
      CreatureELEMENTAL,
      Vector(2430, 977, 39.4),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // Road to Lurtch
    this.makeStaticEncounter(
      CreatureALGHOUL,
      Vector(1055, -1, 48.2),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // Contract mine
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(748, 902, 2.4),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // Near Toderas
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(1627, -11, 13.2),
      RER_RegionConstraint_ONLY_VELEN,
      15,
      StaticEncounterType_SMALL
    );

    // Near horse cadavar
    this.makeStaticEncounter(
      CreatureGHOUL,
      Vector(1462, -850, 29.5),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_SMALL
    );

    // in forest
    this.makeStaticEncounter(
      CreatureARACHAS,
      Vector(-92, 31, 10.3),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_LARGE
    );

    // Field with people
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(625, 1403, 1.8),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // Near Wyvern castle
    this.makeStaticEncounter(
      CreatureWYVERN,
      Vector(-255, 863, 30.8),
      RER_RegionConstraint_ONLY_VELEN,
      15,
      StaticEncounterType_LARGE
    );

    // Near thy swamp
    this.makeStaticEncounter(
      CreatureARACHAS,
      Vector(1070, -638, 0.4),
      RER_RegionConstraint_ONLY_VELEN,
      10,
      StaticEncounterType_LARGE
    );

    // Leshen Forest
    this.makeStaticEncounter(
      CreatureLESHEN,
      Vector(1268, -166, 58.4),
      RER_RegionConstraint_ONLY_VELEN,
      30,
      StaticEncounterType_LARGE
    );

    // South Velen
    this.makeStaticEncounter(
      CreatureGRYPHON,
      Vector(-162, -1117, 16.4),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // Haunted treasure
    this.makeStaticEncounter(
      CreatureWRAITH,
      Vector(-213, -971, 7.8),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_SMALL
    );

    // Very lost treasure
    this.makeStaticEncounter(
      CreatureBARGHEST,
      Vector(634, -909, 9.1),
      RER_RegionConstraint_ONLY_VELEN,
      15,
      StaticEncounterType_SMALL
    );

    // Near a Grave
    this.makeStaticEncounter(
      CreatureGARGOYLE,
      Vector(191, -1271, 3.3),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // Near the city with ghouls
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(1570, 1375, 3.3),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // Near forest near city
    this.makeStaticEncounter(
      CreatureWEREWOLF,
      Vector(1178, 2117, 1.7),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // empty field
    this.makeStaticEncounter(
      CreatureNOONWRAITH,
      Vector(1529, 1928, 5.7),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // empty field
    this.makeStaticEncounter(
      CreatureNIGHTWRAITH,
      Vector(2070, 925, 0.1),
      RER_RegionConstraint_ONLY_VELEN,
      5,
      StaticEncounterType_LARGE
    );

    // a grotto in the middle of skellige
    this.makeStaticEncounter(
      CreatureBEAR,
      Vector(671, 689, 81),
      RER_RegionConstraint_ONLY_SKELLIGE,
      40,
      StaticEncounterType_SMALL
    );

    // a tomb in the middle of skellige
    this.makeStaticEncounter(
      CreatureNIGHTWRAITH,
      Vector(589, 127, 40.1),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Road west of blandare
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(436, 67, 37.7),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_SMALL
    );

    // Cyclops road
    this.makeStaticEncounter(
      CreatureCYCLOP,
      Vector(517, 429, 55.4),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_LARGE
    );

    // Near Troll cave
    this.makeStaticEncounter(
      CreatureTROLL,
      Vector(430, 361, 44.6),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_LARGE
    );

    // House with skeleton
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(751, -149, 31.2),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_SMALL
    );

    // in Forest sawmill
    this.makeStaticEncounter(
      CreatureEKIMMARA,
      Vector(866, 168, 66),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Elemental place
    this.makeStaticEncounter(
      CreatureELEMENTAL,
      Vector(1171, 187, 89.1),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Forest exist
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(901, 328, 86.7),
      RER_RegionConstraint_ONLY_SKELLIGE,
      15,
      StaticEncounterType_SMALL
    );

    // Vamp lair
    this.makeStaticEncounter(
      CreatureKATAKAN,
      Vector(713, 482, 146.2),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Bridge to Eldberg
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(-791, 210, 10.2),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_SMALL
    );

    // Forest Between Cities
    this.makeStaticEncounter(
      CreatureNEKKER,
      Vector(-415, -244, 42.3),
      RER_RegionConstraint_ONLY_SKELLIGE,
      20,
      StaticEncounterType_SMALL
    );

    // Leshen Forest
    this.makeStaticEncounter(
      CreatureLESHEN,
      Vector(-107, -223, 49),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_LARGE
    );

    // Near Crypt
    this.makeStaticEncounter(
      CreatureALGHOUL,
      Vector(93, 373, 18.4),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Open Field
    this.makeStaticEncounter(
      CreatureCYCLOP,
      Vector(313, -467, 10.2),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // North Castle
    this.makeStaticEncounter(
      CreatureEKIMMARA,
      Vector(390, 738, 106.6),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Whale graves
    this.makeStaticEncounter(
      CreatureCYCLOP,
      Vector(1024, 712, 1.6),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_LARGE
    );

    // Abandonned Village
    this.makeStaticEncounter(
      CreatureKATAKAN,
      Vector(1231, 27, 2),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Road to dream Cave
    this.makeStaticEncounter(
      CreatureNOONWRAITH,
      Vector(-56, -1228, 5.2),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Left of Urialla
    this.makeStaticEncounter(
      CreatureBERSERKER,
      Vector(1278, 1980, 29.50),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_SMALL
    );

    // Right of Urialla
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(1600, 1873, 5.7),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Ulfedinn place
    this.makeStaticEncounter(
      CreatureWEREWOLF,
      Vector(-12, -514, 66),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Cyclop place
    this.makeStaticEncounter(
      CreatureCYCLOP,
      Vector(-608, -617, 5.2),
      RER_RegionConstraint_ONLY_SKELLIGE,
      20,
      StaticEncounterType_LARGE
    );

    // Mountain
    this.makeStaticEncounter(
      CreatureHARPY,
      Vector(107, -686, 90.6),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_SMALL
    );

    // destroyed forest
    this.makeStaticEncounter(
      CreatureFOGLET,
      Vector(995, -146, 18.4),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_SMALL
    );

    // destroyed forest beach
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(1116, -283, 1),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_SMALL
    );


    // destroyed house on spikeroog
    this.makeStaticEncounter(
      CreatureBERSERKER,
      Vector(-1416, 1510, 24.3),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_SMALL
    );

    // spikeroog south beah
    this.makeStaticEncounter(
      CreatureCOCKATRICE,
      Vector(-1925, 1045, 7.7),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // spikeroog Neach near treasure
    this.makeStaticEncounter(
      CreatureDRACOLIZARD,
      Vector(-1534, 1176, 7.6),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Faroe Left
    this.makeStaticEncounter(
      CreatureBERSERKER,
      Vector(1679, -1805, 8.8),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_SMALL
    );

    // Faroe near wolves
    this.makeStaticEncounter(
      CreatureFIEND,
      Vector(1998, -1990, 12.9),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // Hindarsal carrefour
    this.makeStaticEncounter(
      CreatureNEKKER,
      Vector(2509, 154, 21.3),
      RER_RegionConstraint_ONLY_SKELLIGE,
     10,
      StaticEncounterType_SMALL
    );

    // Hindarsal carrefour
    this.makeStaticEncounter(
      CreatureSKELTROLL,
      Vector(2238, 85, 48.3),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_LARGE
    );

   // Hindarsal Beach
    this.makeStaticEncounter(
      CreatureSIREN,
      Vector(2603,-196, 8.1),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_SMALL
    );

   // Hindarsal Road
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(2711,-26, 30.6),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_SMALL
    );

   // Hindarsal carrefour
    this.makeStaticEncounter(
      CreatureSKELTROLL,
      Vector(2853, 50, 40.1),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_LARGE
    );

   // Anti-Religion island
    this.makeStaticEncounter(
      CreatureFORKTAIL,
      Vector(353, 1559, 8.5),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_LARGE
    );

   // Island of sirens
    this.makeStaticEncounter(
      CreatureCOCKATRICE,
      Vector(148, 2097, 7.2),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_LARGE
    );

   // Island with corpses
    this.makeStaticEncounter(
      CreatureHARPY,
      Vector(-508, 2115, 6.6),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_SMALL
    );

   // Island with Bags
    this.makeStaticEncounter(
      CreatureGRYPHON,
      Vector(-954, 1967, 7.2),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_LARGE
    );

   // Island with Chest
    this.makeStaticEncounter(
      CreatureARACHAS,
      Vector(-833, 2049, 1.3),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_LARGE
    );

   // Island south
    this.makeStaticEncounter(
      CreatureGRYPHON,
      Vector(-218, -1962, 7.5),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_LARGE
    );

    // Island  with bear corpse
    this.makeStaticEncounter(
      CreatureTROLL,
      Vector(-1770, -1898, 35.5),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_LARGE
    );

    // Island  with bear corpse Beach
    this.makeStaticEncounter(
      CreatureNEKKER,
      Vector(-1781, -1998, 1.4),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_SMALL
    );

    // Island  with Cyclop
    this.makeStaticEncounter(
      CreatureBERSERKER,
      Vector(-2603, 1599, 25.1),
      RER_RegionConstraint_ONLY_SKELLIGE,
     5,
      StaticEncounterType_SMALL
    );

    // Golem place
    this.makeStaticEncounter(
      CreatureGOLEM,
      Vector(1664, 2560, 40.5),
      RER_RegionConstraint_ONLY_VELEN,
     5,
      StaticEncounterType_LARGE
    );

    // Corpse 
    this.makeStaticEncounter(
      CreatureALGHOUL,
      Vector(1536, 2612, 27.4),
      RER_RegionConstraint_ONLY_VELEN,
     5,
      StaticEncounterType_SMALL
    );

    // Jade small deport
    this.makeStaticEncounter(
      CreatureWEREWOLF,
      Vector(1249, 2534, 11,6),
      RER_RegionConstraint_ONLY_VELEN,
     5,
      StaticEncounterType_LARGE
    );

    // Haunted forest
    this.makeStaticEncounter(
      CreatureLESHEN,
      Vector(2716, 1725, 30.5),
      RER_RegionConstraint_ONLY_VELEN,
     5,
      StaticEncounterType_LARGE
    );

    // Gryphon feeding
    this.makeStaticEncounter(
      CreatureGRYPHON,
      Vector(2570, 1585, 53.7),
      RER_RegionConstraint_ONLY_VELEN,
     5,
      StaticEncounterType_LARGE
    );

    // Road to Brunwich
    this.makeStaticEncounter(
      CreatureSPIDER,
      Vector(2055, 2331, 20.2),
      RER_RegionConstraint_ONLY_VELEN,
     5,
      StaticEncounterType_SMALL
    );

    // River of house
    this.makeStaticEncounter(
      CreatureSPIDER,
      Vector(2305, 1996, 25.3),
      RER_RegionConstraint_ONLY_VELEN,
     5,
      StaticEncounterType_SMALL
    );

    // Slyzard nest
    this.makeStaticEncounter(
      CreatureDRACOLIZARD,
      Vector(1087, -853, 45),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     15,
      StaticEncounterType_LARGE
    );

    // Ruin near Hanse
    this.makeStaticEncounter(
      CreatureBRUXA,
      Vector(777, -681, 41.8),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Empty road north
    this.makeStaticEncounter(
      CreatureSPIDER,
      Vector(-829, 4, 4.4),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     10,
      StaticEncounterType_SMALL
    );

    // Echinops nest
    this.makeStaticEncounter(
      CreatureECHINOPS,
      Vector(-180, -816, 18.3),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Slyzard and chest
    this.makeStaticEncounter(
      CreatureDRACOLIZARD,
      Vector(1055, -601, 80),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Echinops nest
    this.makeStaticEncounter(
      CreatureECHINOPS,
      Vector(127, -1492, 5.7),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Haunted House
    this.makeStaticEncounter(
      CreatureBARGHEST,
      Vector(525, -1833, 71.4),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Empty Pound
    this.makeStaticEncounter(
      CreatureDROWNERDLC,
      Vector(-228, -1788, 43.4),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // mountain near Goylat
    this.makeStaticEncounter(
      CreatureGRYPHON,
      Vector(-10, -363, 31.7),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Wraith Beach
    this.makeStaticEncounter(
      CreatureNOONWRAITH,
      Vector(-446, -279, 1),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Wraith Beach
    this.makeStaticEncounter(
      CreatureNIGHTWRAITH,
      Vector(-446, -269, 1),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Near Emerald Lake
    this.makeStaticEncounter(
      CreatureDROWNERDLC,
      Vector(-853, -739, 61.1),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Forest between village
    this.makeStaticEncounter(
      CreatureWEREWOLF,
      Vector(-1206, -938, 116.6),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Ruin of prison
    this.makeStaticEncounter(
      CreatureBRUXA,
      Vector(-1195, -841, 117.2),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Clear Field
    this.makeStaticEncounter(
      CreatureDRACOLIZARD,
      Vector(-868, -466, 57),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Near Town
    this.makeStaticEncounter(
      CreatureBARGHEST,
      Vector(-1000, -266, 14.1),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // House with rotfiend
    this.makeStaticEncounter(
      CreatureSKELTROLL,
      Vector(-746, -74, 0),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Cavern
    this.makeStaticEncounter(
      CreatureLESHEN,
      Vector(-780, -228, 6.7),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Pond Near Carrefour
    this.makeStaticEncounter(
      CreatureDROWNERDLC,
      Vector(-853, -739, 61.1),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Horse corpse
    this.makeStaticEncounter(
      CreatureWIGHT,
      Vector(-229, 375, 8.3),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // North of Plegmund bridge
    this.makeStaticEncounter(
      CreatureCENTIPEDE,
      Vector(-472, 5, 1.6),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Pond Near shealmar
    this.makeStaticEncounter(
      CreatureDROWNERDLC,
      Vector(-380, 192, 0),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // South of occupied Town
    this.makeStaticEncounter(
      CreatureFIEND,
      Vector(-339, 480, 1.5),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Carrefour in north of map
    this.makeStaticEncounter(
      CreatureCYCLOP,
      Vector(-57, 481, 13.8),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // North of Plegmund bridge
    this.makeStaticEncounter(
      CreatureCENTIPEDE,
      Vector(164, 224, 1.5),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Abandonned storage
    this.makeStaticEncounter(
      CreatureWIGHT,
      Vector(-106, -184, 23.4),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Basilisk Place
    this.makeStaticEncounter(
      CreatureBASILISK,
      Vector(-69, -65, 10),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Trolls
    this.makeStaticEncounter(
      CreatureTROLL,
      Vector(281, -13, 0.5),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Respawn Barghest
    this.makeStaticEncounter(
      CreatureBARGHEST,
      Vector(49, -817, 6.3),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Centipede love shaelmars
    this.makeStaticEncounter(
      CreatureCENTIPEDE,
      Vector(200, -742, 0.3),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Pond Near graves
    this.makeStaticEncounter(
      CreatureDROWNERDLC,
      Vector(531, -264, 12.1),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Grave with Alp
    this.makeStaticEncounter(
      CreatureBRUXA,
      Vector(439, -215, 1.1),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Echinops nest
    this.makeStaticEncounter(
      CreatureECHINOPS,
      Vector(273, -2136, 63.3),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_SMALL
    );

    // Near Werewolf Cave
    this.makeStaticEncounter(
      CreatureWEREWOLF,
      Vector(678, -69, 7.1),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Centipede Nest
    this.makeStaticEncounter(
      CreatureCENTIPEDE,
      Vector(-1, -1989, 78.8),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     10,
      StaticEncounterType_SMALL
    );

    // Super Random
    this.makeStaticEncounter(
      CreatureWEREWOLF,
      Vector(473, -1559, 26.4),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Vampires place
    this.makeStaticEncounter(
      CreatureFLEDER,
      Vector(732, -1603, 14.3),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Vampires place
    this.makeStaticEncounter(
      CreatureKATAKAN,
      Vector(736, -1601, 13.9),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Vampires place
    this.makeStaticEncounter(
      CreatureEKIMMARA,
      Vector(736, -1393, 13),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );

    // Vampires place
    this.makeStaticEncounter(
      CreatureGARKAIN,
      Vector(728, -1596, 13.9),
      RER_RegionConstraint_ONLY_TOUSSAINT,
     5,
      StaticEncounterType_LARGE
    );
  }

  latent function registerStaticEncountersAeltoth() {

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

    // near a water body where a cockatrice is in vanilla
    this.makeStaticEncounter(
      CreatureCOCKATRICE,
      Vector(-90, -848, 6),
      RER_RegionConstraint_ONLY_VELEN,
      40,
      StaticEncounterType_LARGE
    );

    // a big gcave
    this.makeStaticEncounter(
      CreatureKATAKAN,
      Vector(1956, 32, 43),
      RER_RegionConstraint_ONLY_VELEN,
      20,
      StaticEncounterType_LARGE
    );

    // cave where the two ladies want to cut the nails of the dead
    this.makeStaticEncounter(
      CreatureKATAKAN,
      Vector(58, 487, 10.45),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // entrance of the cave where the two ladies want to cut the nails of
    // the dead
    this.makeStaticEncounter(
      CreatureTROLL,
      Vector(140, 393, 23),
      RER_RegionConstraint_ONLY_SKELLIGE,
      5,
      StaticEncounterType_LARGE
    );

    // a guarded treasure with a forktail
    this.makeStaticEncounter(
      CreatureFORKTAIL,
      Vector(11, 237, 39),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_LARGE
    );

    // a big stone where there is sometimes a cyclop in vanilla
    this.makeStaticEncounter(
      CreatureCYCLOP,
      Vector(420, 188, 64),
      RER_RegionConstraint_ONLY_SKELLIGE,
      20,
      StaticEncounterType_LARGE
    );

    // a beach near kaer trolde
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(88, 167, 0),
      RER_RegionConstraint_ONLY_SKELLIGE,
      20,
      StaticEncounterType_LARGE
    );

    // a mountain with lots of harpies
    this.makeStaticEncounter(
      CreatureHARPY,
      Vector(645, 320, 87),
      RER_RegionConstraint_ONLY_SKELLIGE,
      50,
      StaticEncounterType_SMALL
    );

    // a mountain peak
    this.makeStaticEncounter(
      CreatureFIEND,
      Vector(737, 560, 155),
      RER_RegionConstraint_ONLY_SKELLIGE,
      30,
      StaticEncounterType_LARGE
    );

    // a beach with broken boats
    this.makeStaticEncounter(
      CreatureCYCLOP,
      Vector(1064, 570, 1),
      RER_RegionConstraint_ONLY_SKELLIGE,
      50,
      StaticEncounterType_LARGE
    );

    // a beach with broken boats
    this.makeStaticEncounter(
      CreatureARACHAS,
      Vector(978, 720, 18),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_SMALL
    );

    // a grotto in the middle of skellige
    this.makeStaticEncounter(
      CreatureBEAR,
      Vector(671, 689, 81),
      RER_RegionConstraint_ONLY_SKELLIGE,
      40,
      StaticEncounterType_SMALL
    );

    // a forest north east of skellige
    this.makeStaticEncounter(
      CreatureLESHEN,
      Vector(546, 591, 63),
      RER_RegionConstraint_ONLY_SKELLIGE,
      55,
      StaticEncounterType_LARGE
    );

    // a small lake near a forest
    this.makeStaticEncounter(
      CreatureTROLL,
      Vector(426, 377, 44),
      RER_RegionConstraint_ONLY_SKELLIGE,
      20,
      StaticEncounterType_LARGE
    );

    // lake south of skellige
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(-99, -525, 63),
      RER_RegionConstraint_ONLY_SKELLIGE,
      40,
      StaticEncounterType_LARGE
    );

    // lake south of skellige
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(-99, -525, 63),
      RER_RegionConstraint_ONLY_SKELLIGE,
      40,
      StaticEncounterType_SMALL
    );

    // lake south of skellige
    this.makeStaticEncounter(
      CreatureNEKKER,
      Vector(-99, -525, 63),
      RER_RegionConstraint_ONLY_SKELLIGE,
      60,
      StaticEncounterType_SMALL
    );

    // ruins south of skellige, near a lage
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(-10, -517, 66),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_SMALL
    );

    // a forest south of skellige
    this.makeStaticEncounter(
      CreatureENDREGA,
      Vector(-450, -512, 38),
      RER_RegionConstraint_ONLY_SKELLIGE,
      60,
      StaticEncounterType_SMALL
    );

    // a tomb in the middle of skellige
    this.makeStaticEncounter(
      CreatureNIGHTWRAITH,
      Vector(588, 142, 35),
      RER_RegionConstraint_ONLY_SKELLIGE,
      10,
      StaticEncounterType_LARGE
    );

    // abandoned house with skeleton
    this.makeStaticEncounter(
      CreatureDROWNER,
      Vector(750, -149, 31),
      RER_RegionConstraint_ONLY_SKELLIGE,
      4,
      StaticEncounterType_SMALL
    );

    // abandoned house with skeleton
    this.makeStaticEncounter(
      CreatureCHORT,
      Vector(792, -529, 78),
      RER_RegionConstraint_ONLY_SKELLIGE,
      4,
      StaticEncounterType_LARGE
    );

    // siren nest
    this.makeStaticEncounter(
      CreatureSIREN,
      Vector(387, -1161, 0),
      RER_RegionConstraint_ONLY_SKELLIGE,
      20,
      StaticEncounterType_SMALL
    );

    // random road
    this.makeStaticEncounter(
      CreatureHUMAN,
      Vector(432, -3, 34),
      RER_RegionConstraint_ONLY_SKELLIGE,
      100,
      StaticEncounterType_SMALL
    );

    // a place where this is already a cyclop
    this.makeStaticEncounter(
      CreatureCYCLOP,
      Vector(-624, -617, 5),
      RER_RegionConstraint_ONLY_SKELLIGE,
      100,
      StaticEncounterType_LARGE
    );

    // a treasure near the water
    this.makeStaticEncounter(
      CreatureHAG,
      Vector(-1489, 1248, 0),
      RER_RegionConstraint_ONLY_SKELLIGE,
      30,
      StaticEncounterType_SMALL
    );

    // an isolated beach
    this.makeStaticEncounter(
      CreatureWYVERN,
      Vector(-1536, 1175, 0),
      RER_RegionConstraint_ONLY_SKELLIGE,
      30,
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

      ((CNewNPC)entity).SetLevel(getRandomLevelBasedOnSettings(parent.settings));
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
    new_static_encounter.bestiary_entry = parent.bestiary.getEntry(parent, type);
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

class SU_CustomPinRemovePredicateFromRERAndRegion extends SU_PredicateInterfaceRemovePin {
  var starts_with: string;
  default starts_with = "RER_";

  var position: Vector;

  var radius: float;
  default radius = 50;

  function predicate(pin: SU_MapPin): bool {
    return StrStartsWith(pin.tag, this.starts_with)
        && VecDistanceSquared2D(this.position, pin.position) < this.radius * this.radius;
  }
}

function RER_removePinsInAreaAndWithTag(tag_start: string, center: Vector, radius: float) {
  var predicate: SU_CustomPinRemovePredicateFromRERAndRegion;

  predicate = new SU_CustomPinRemovePredicateFromRERAndRegion in thePlayer;
  predicate.position = center;
  predicate.radius = radius;
  predicate.starts_with = tag_start;

  SU_removeCustomPinByPredicate(predicate);
}