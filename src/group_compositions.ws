
// Sometimes solo creatures can be accompanied by smaller creatures,
// this is what i call a group composition. Imagine a leshen and a few wolves
// or a giant fighting humans.

latent function makeGroupComposition(encounter_type: EEncounterType, random_encounters_class: CRandomEncounters) {
  switch (encounter_type) {
    case ET_GROUND:
      LogChannel('modRandomEncounters', "spawning type ET_GROUND ");
      createRandomGroundCreatureComposition(random_encounters_class);
      break;

    case ET_FLYING:
      LogChannel('modRandomEncounters', "spawning type ET_FLYING ");
      break;

    case ET_HUMAN:
      LogChannel('modRandomEncounters', "spawning type ET_HUMAN ");
      createRandomHumanComposition(random_encounters_class);
      break;

    case ET_GROUP:
      LogChannel('modRandomEncounters', "spawning type ET_GROUP ");
      createRandomGroupCreatureComposition(random_encounters_class);
      break;

    case ET_WILDHUNT:
      LogChannel('modRandomEncounters', "spawning type ET_WILDHUNT ");
      break;

    case ET_NONE:
        // do nothing when no EntityType was available
        // this is here for reminding me this case exists.
        break;
  }
}
