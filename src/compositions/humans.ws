
enum HumanComposition {
  HumanComposition_FightingCyclop = 1,
  HumanComposition_FightingGiant = 2,
  HumanComposition_FightingWolves = 3,
  HumanComposition_FightingDrowners = 4,
  HumanComposition_FightingNekkers = 5,
  HumanComposition_AmbushWitcher = 6
}

latent function createRandomHumanComposition(random_encounters_class: CRandomEncounters) {
  var human_composition: HumanComposition;

  human_composition = HumanComposition_FightingCyclop;//getRandomHumanComposition();

  switch (human_composition) {
    case HumanComposition_FightingCyclop:
      makeHumanCompositionAgainstCyclop(random_encounters_class);
      break;

    case HumanComposition_FightingGiant:
      break;

    case HumanComposition_FightingWolves:
      break;

    case HumanComposition_FightingDrowners:
      break;

    case HumanComposition_FightingNekkers:
      break;

    case HumanComposition_AmbushWitcher:
      break;
  }
}

function getChoicesOfHumanCompositions(): array<HumanComposition> {
  var choices: array<HumanComposition>;

  choices.PushBack(HumanComposition_FightingCyclop);
  choices.PushBack(HumanComposition_FightingGiant);
  choices.PushBack(HumanComposition_FightingWolves);
  choices.PushBack(HumanComposition_FightingDrowners);
  choices.PushBack(HumanComposition_FightingNekkers);
  choices.PushBack(HumanComposition_AmbushWitcher);

  return choices;
}

function getRandomHumanComposition(): HumanComposition {
  // var choices: array<HumanComposition> = getChoicesOfHumanCompositions();

  // return choices[RandRange(choices.Size())];

  // could use the code above when i want to disable one
  // HumanComposition in particular.
  // but simply returning a random number is more performant.

  return RandRange(HumanComposition_AmbushWitcher);
}


          //////////////////////////////////////
          // maker functions for compositions //
          //////////////////////////////////////


latent function makeHumanCompositionAgainstCyclop(master: CRandomEncounters) {
  var cyclop_templates: array<SEnemyTemplate>;
  var humans_templates: array<SEnemyTemplate>;
  var number_of_humans: int;

  var cyclop_entities: array<CEntity>;
  var humans_entities: array<CEntity>;

  var i: int;
  var summon: CNewNPC;
  var initial_position: Vector;

  getRandomPositionBehindCamera(initial_position, 30);

  number_of_humans = RandRange(
    3 + master.settings.selectedDifficulty,
    6 + master.settings.selectedDifficulty
  );

  cyclop_templates = master.resources.cyclop;
  humans_templates = master.resources.copy_template_list(
    master.resources.getHumanResourcesByHumanType(
      master.rExtra.getRandomHumanTypeByCurrentArea()
    )
  );

  cyclop_templates = fillEnemyTemplates(cyclop_templates, 1);
  humans_templates = fillEnemyTemplates(humans_templates, number_of_humans);

  cyclop_entities = spawnTemplateList(cyclop_templates, initial_position);
  humans_entities = spawnTemplateList(humans_templates, initial_position, 0.01);

  if (cyclop_entities.Size() > 0) {
    for (i = 0; i < humans_entities.Size(); i += 1) {
      summon = (CNewNPC) humans_entities[i];

      summon.SetLevel(GetWitcherPlayer().GetLevel());
      // summon.NoticeActor((CNewNPC) cyclop_entities[0]);
      summon.SignalGameplayEventParamObject( 'ForceTarget', (CNewNPC) cyclop_entities[0] );
      // summon.SetTemporaryAttitudeGroup('hostile_to_player', AGP_Default);
    }
  }
}






