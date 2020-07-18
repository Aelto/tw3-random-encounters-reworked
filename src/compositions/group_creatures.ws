
// enum GroupCreatureComposition {
//   GroupCreature_AmbushWitcher = 1
// }

// latent function createRandomGroupCreatureComposition(random_encounters_class: CRandomEncounters) {
//   var group_creature_composition: GroupCreatureComposition;

//   group_creature_composition = GroupCreature_AmbushWitcher;

//   switch (group_creature_composition) {
//     case GroupCreature_AmbushWitcher:
//       makeGroupCreatureAmbushWitcher(random_encounters_class);
//       break;
//   }
// }


//           //////////////////////////////////////
//           // maker functions for compositions //
//           //////////////////////////////////////


// latent function makeGroupCreatureAmbushWitcher(master: CRandomEncounters) {
//   var creatures_templates: array<SEnemyTemplate>;
//   var number_of_creatures: int;

//   var creatures_entities: array<CEntity>;

//   var i: int;
//   var summon: CNewNPC;
//   var initial_position: Vector;

//   LogChannel('modRandomEncounters', "making group creatures composition ambush witcher");

//   getRandomPositionBehindCamera(initial_position);

//   number_of_creatures = RandRange(
//     2 + master.settings.selectedDifficulty,
//     4 + master.settings.selectedDifficulty
//   );

//   LogChannel('modRandomEncounters', "preparing to spawn " + number_of_creatures + " creatures");

//   creatures_templates = master.resources.copy_template_list(
//     master.resources.getCreatureResourceByGroundMonsterType(
//       master.rExtra.getRandomGroupCreatureByCurrentArea(master.settings)
//     )
//   );

//   creatures_templates = fillEnemyTemplates(creatures_templates, number_of_creatures);
//   creatures_entities = spawnTemplateList(creatures_templates, initial_position, 0.01);

//   for (i = 0; i < creatures_entities.Size(); i += 1) {
//     summon = (CNewNPC) creatures_entities[i];

//     summon.SetLevel(GetWitcherPlayer().GetLevel());
//     summon.NoticeActor(thePlayer);
//     summon.SignalGameplayEventParamObject('ForceTarget', thePlayer);
//   }
// }