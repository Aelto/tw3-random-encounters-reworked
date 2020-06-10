
// Sometimes solo creatures can be accompanied by smaller creatures,
// this is what i call a group composition. Imagine a leshen and a few wolves
// or a giant fighting humans.

latent function makeGroupComposition(encounter_type: EEncounterType, random_encounters_class: CRandomEncounters) {
  switch (encounter_type) {
    case ET_GROUND:
      LogChannel('modRandomEncounters', "spawning type ET_GROUND ");
      break;

    case ET_FLYING:
      LogChannel('modRandomEncounters', "spawning type ET_FLYING ");
      break;

    case ET_HUMAN:
      makeGroupCompositionForHumans(random_encounters_class);
      LogChannel('modRandomEncounters', "spawning type ET_HUMAN ");
      break;

    case ET_GROUP:
      LogChannel('modRandomEncounters', "spawning type ET_GROUP ");
      break;

    case ET_WILDHUNT:
      LogChannel('modRandomEncounters', "spawning type ET_WILDHUNT ");
      break;
  }
}

latent function makeGroupCompositionForHumans(random_encounters_class: CRandomEncounters) {
  var picked_human_type: EHumanType;
  var template_human_array: array<SEnemyTemplate>;

  LogChannel('modRandomEncounters', "making group composition for humans");

  picked_human_type = random_encounters_class.rExtra.getRandomHumanTypeByCurrentArea();
  template_human_array = random_encounters_class.resources.copy_template_list(
    random_encounters_class.resources.getHumanResourcesByHumanType(picked_human_type)
  );

  createRandomHumanComposition(random_encounters_class);
}

function makeGroupCompositionForCreature(random_encounters_class: CRandomEncounters) {
  // TODO
}