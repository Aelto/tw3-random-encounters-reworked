
// enum HumanComposition {
//   HumanComposition_FightingCyclop = 1,
//   HumanComposition_FightingGiant = 2,
//   HumanComposition_FightingWolves = 3,
//   HumanComposition_FightingDrowners = 4,
//   HumanComposition_FightingNekkers = 5,
//   HumanComposition_AmbushWitcher = 6
// }

// latent function createRandomHumanComposition(random_encounters_class: CRandomEncounters) {
//   var human_composition: HumanComposition;

//   human_composition = getRandomHumanComposition();

//   switch (human_composition) {
//     case HumanComposition_FightingCyclop:
//       makeHumanCompositionAgainstCyclop(random_encounters_class);
//       break;

//     case HumanComposition_FightingGiant:
//       makeHumanCompositionAgainstGiant(random_encounters_class);
//       break;

//     case HumanComposition_FightingWolves:
//     makeHumanCompositionAgainstWolves(random_encounters_class);
//       break;

//     case HumanComposition_FightingDrowners:
//       makeHumanCompositionAgainstDrowners(random_encounters_class);
//       break;

//     case HumanComposition_FightingNekkers:
//       makeHumanCompositionAgainstNekkers(random_encounters_class);
//       break;

//     case HumanComposition_AmbushWitcher:
//       makeHumanCompositionAmbushWitcher(random_encounters_class);
//       break;
//   }
// }

// function getRandomHumanComposition(): HumanComposition {
//   var roll: int;

//   roll = RandRange(100);

//   if (roll < 5) {
//     return HumanComposition_FightingCyclop;
//   }
//   else if (roll < 10) {
//     return HumanComposition_FightingGiant;
//   }
//   else if (roll < 20) {
//     return HumanComposition_FightingWolves;
//   }
//   else if (roll < 35) {
//     return HumanComposition_FightingDrowners;
//   }
//   else if (roll < 50) {
//     return HumanComposition_FightingNekkers;
//   }
//   else {
//     return HumanComposition_AmbushWitcher;
//   }
// }


//           //////////////////////////////////////
//           // maker functions for compositions //
//           //////////////////////////////////////


// latent function makeHumanCompositionAgainstCyclop(master: CRandomEncounters) {
//   var cyclop_templates: array<SEnemyTemplate>;
//   var humans_templates: array<SEnemyTemplate>;
//   var number_of_humans: int;

//   var cyclop_entities: array<CEntity>;
//   var humans_entities: array<CEntity>;

//   var i: int;
//   var summon: CNewNPC;
//   var initial_position: Vector;

//   LogChannel('modRandomEncounters', "making human composition against cyclop");

//   getRandomPositionBehindCamera(initial_position);

//   number_of_humans = RandRange(
//     3 + master.settings.selectedDifficulty,
//     6 + master.settings.selectedDifficulty
//   );

//   cyclop_templates = master.resources.cyclop;
//   humans_templates = master.resources.copy_template_list(
//     master.resources.getHumanResourcesByHumanType(
//       master.rExtra.getRandomHumanTypeByCurrentArea()
//     )
//   );

//   cyclop_templates = fillEnemyTemplates(cyclop_templates, 1);
//   humans_templates = fillEnemyTemplates(humans_templates, number_of_humans);

//   cyclop_entities = spawnTemplateList(cyclop_templates, initial_position);
//   humans_entities = spawnTemplateList(humans_templates, initial_position, 0.01);

//   if (cyclop_entities.Size() > 0) {
//     for (i = 0; i < humans_entities.Size(); i += 1) {
//       summon = (CNewNPC) humans_entities[i];

//       summon.SetLevel(GetWitcherPlayer().GetLevel());
//       summon.SignalGameplayEventParamObject( 'ForceTarget', (CNewNPC) cyclop_entities[0] );
//     }
//   }
// }




// latent function makeHumanCompositionAgainstGiant(master: CRandomEncounters) {
//   var giant_templates: array<SEnemyTemplate>;
//   var humans_templates: array<SEnemyTemplate>;
//   var number_of_humans: int;

//   var giant_entities: array<CEntity>;
//   var humans_entities: array<CEntity>;

//   var i: int;
//   var summon: CNewNPC;
//   var initial_position: Vector;

//   LogChannel('modRandomEncounters', "making human composition against giant");

//   getRandomPositionBehindCamera(initial_position);

//   number_of_humans = RandRange(
//     3 + master.settings.selectedDifficulty,
//     6 + master.settings.selectedDifficulty
//   );

//   giant_templates = master.resources.giant;
//   humans_templates = master.resources.copy_template_list(
//     master.resources.getHumanResourcesByHumanType(
//       master.rExtra.getRandomHumanTypeByCurrentArea()
//     )
//   );

//   giant_templates = fillEnemyTemplates(giant_templates, 1);
//   humans_templates = fillEnemyTemplates(humans_templates, number_of_humans);

//   giant_entities = spawnTemplateList(giant_templates, initial_position);
//   humans_entities = spawnTemplateList(humans_templates, initial_position, 0.01);

//   if (giant_entities.Size() > 0) {
//     for (i = 0; i < humans_entities.Size(); i += 1) {
//       summon = (CNewNPC) humans_entities[i];

//       summon.SetLevel(GetWitcherPlayer().GetLevel());
//       summon.SignalGameplayEventParamObject( 'ForceTarget', (CNewNPC) giant_entities[0] );
//     }
//   }
// }




// latent function makeHumanCompositionAgainstWolves(master: CRandomEncounters) {
//   var wolves_templates: array<SEnemyTemplate>;
//   var humans_templates: array<SEnemyTemplate>;
//   var number_of_humans: int;
//   var number_of_wolves: int;

//   var wolves_entities: array<CEntity>;
//   var humans_entities: array<CEntity>;

//   var i: int;
//   var summon: CNewNPC;
//   var initial_position: Vector;

//   LogChannel('modRandomEncounters', "making human composition against wolves");

//   getRandomPositionBehindCamera(initial_position);

//   // few number of humans
//   number_of_humans = RandRange(
//     0 + master.settings.selectedDifficulty,
//     1 + master.settings.selectedDifficulty
//   );

//   // moderate/high amount of wolves.
//   // notice it's multiplied by the difficulty
//   number_of_wolves = RandRange(
//     1 * master.settings.selectedDifficulty,
//     2 * master.settings.selectedDifficulty
//   );

//   if (theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig) {
//     wolves_templates = master.resources.skelwolf;
//   }
//   else {
//     wolves_templates = master.resources.wolf;
//   }

//   humans_templates = master.resources.copy_template_list(
//     master.resources.getHumanResourcesByHumanType(
//       master.rExtra.getRandomHumanTypeByCurrentArea()
//     )
//   );

//   wolves_templates = fillEnemyTemplates(wolves_templates, number_of_wolves);
//   humans_templates = fillEnemyTemplates(humans_templates, number_of_humans);

//   wolves_entities = spawnTemplateList(wolves_templates, initial_position);
//   humans_entities = spawnTemplateList(humans_templates, initial_position, 0.01);

//   if (wolves_entities.Size() > 0) {
//     for (i = 0; i < humans_entities.Size(); i += 1) {
//       summon = (CNewNPC) humans_entities[i];

//       summon.SetLevel(GetWitcherPlayer().GetLevel());
//       summon.SignalGameplayEventParamObject( 'ForceTarget', (CNewNPC) wolves_entities[0] );
//     }
//   }
// }




// latent function makeHumanCompositionAgainstDrowners(master: CRandomEncounters) {
//   var drowners_templates: array<SEnemyTemplate>;
//   var humans_templates: array<SEnemyTemplate>;
//   var number_of_humans: int;
//   var number_of_drowners: int;

//   var drowners_entities: array<CEntity>;
//   var humans_entities: array<CEntity>;

//   var i: int;
//   var summon: CNewNPC;
//   var initial_position: Vector;

//   LogChannel('modRandomEncounters', "making human composition against drowners");

//   getRandomPositionBehindCamera(initial_position);

//   // few number of humans
//   number_of_humans = RandRange(
//     0 + master.settings.selectedDifficulty,
//     1 + master.settings.selectedDifficulty
//   );

//   // moderate/high amount of drowners.
//   // notice it's multiplied by the difficulty
//   number_of_drowners = RandRange(
//     1 * master.settings.selectedDifficulty,
//     2 * master.settings.selectedDifficulty + 1
//   );

//   drowners_templates = master.resources.drowner;

//   humans_templates = master.resources.copy_template_list(
//     master.resources.getHumanResourcesByHumanType(
//       master.rExtra.getRandomHumanTypeByCurrentArea()
//     )
//   );

//   drowners_templates = fillEnemyTemplates(drowners_templates, number_of_drowners);
//   humans_templates = fillEnemyTemplates(humans_templates, number_of_humans);

//   drowners_entities = spawnTemplateList(drowners_templates, initial_position);
//   humans_entities = spawnTemplateList(humans_templates, initial_position, 0.01);

//   if (drowners_entities.Size() > 0) {
//     for (i = 0; i < humans_entities.Size(); i += 1) {
//       summon = (CNewNPC) humans_entities[i];

//       summon.SetLevel(GetWitcherPlayer().GetLevel());
//       summon.SignalGameplayEventParamObject( 'ForceTarget', (CNewNPC) drowners_entities[0] );
//     }
//   }
// }




// latent function makeHumanCompositionAgainstNekkers(master: CRandomEncounters) {
//   var nekkers_templates: array<SEnemyTemplate>;
//   var humans_templates: array<SEnemyTemplate>;
//   var number_of_humans: int;
//   var number_of_nekkers: int;

//   var nekkers_entities: array<CEntity>;
//   var humans_entities: array<CEntity>;

//   var i: int;
//   var summon: CNewNPC;
//   var initial_position: Vector;

//   LogChannel('modRandomEncounters', "making human composition against nekkers");

//   getRandomPositionBehindCamera(initial_position);

//   // few number of humans
//   number_of_humans = RandRange(
//     0 + master.settings.selectedDifficulty,
//     1 + master.settings.selectedDifficulty
//   );

//   // moderate/high amount of nekkers.
//   // notice it's multiplied by the difficulty
//   number_of_nekkers = RandRange(
//     1 * master.settings.selectedDifficulty,
//     2 * master.settings.selectedDifficulty + 1
//   );

//   nekkers_templates = master.resources.nekker;

//   humans_templates = master.resources.copy_template_list(
//     master.resources.getHumanResourcesByHumanType(
//       master.rExtra.getRandomHumanTypeByCurrentArea()
//     )
//   );

//   nekkers_templates = fillEnemyTemplates(nekkers_templates, number_of_nekkers);
//   humans_templates = fillEnemyTemplates(humans_templates, number_of_humans);

//   nekkers_entities = spawnTemplateList(nekkers_templates, initial_position);
//   humans_entities = spawnTemplateList(humans_templates, initial_position, 0.01);

//   if (nekkers_entities.Size() > 0) {
//     for (i = 0; i < humans_entities.Size(); i += 1) {
//       summon = (CNewNPC) humans_entities[i];

//       summon.SetLevel(GetWitcherPlayer().GetLevel());
//       summon.SignalGameplayEventParamObject( 'ForceTarget', (CNewNPC) nekkers_entities[0] );
//     }
//   }
// }




// latent function makeHumanCompositionAmbushWitcher(master: CRandomEncounters) {
//   var humans_templates: array<SEnemyTemplate>;
//   var number_of_humans: int;
//   var number_of_groups: int;

//   var humans_entities: array<CEntity>;

//   var i: int;
//   var summon: CNewNPC;
//   var initial_position: Vector;

//   LogChannel('modRandomEncounters', "making human composition ambush witcher");

//   getRandomPositionBehindCamera(initial_position);

//   number_of_humans = RandRange(
//     2 + master.settings.selectedDifficulty,
//     5 + master.settings.selectedDifficulty
//   );

//   humans_templates = master.resources.copy_template_list(
//     master.resources.getHumanResourcesByHumanType(
//       master.rExtra.getRandomHumanTypeByCurrentArea()
//     )
//   );

//   humans_templates = fillEnemyTemplates(humans_templates, number_of_humans);

//   humans_entities = spawnTemplateList(humans_templates, initial_position, 0.01);

//   for (i = 0; i < humans_entities.Size(); i += 1) {
//     summon = (CNewNPC) humans_entities[i];

//     summon.SetLevel(GetWitcherPlayer().GetLevel());
//     summon.NoticeActor(thePlayer);
//     summon.SignalGameplayEventParamObject('ForceTarget', thePlayer);
//   }
// }