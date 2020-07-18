
// Sometimes solo creatures can be accompanied by smaller creatures,
// this is what i call a group composition. Imagine a leshen and a few wolves
// or a giant fighting humans.

latent function makeGroupComposition(creature_type: CreatureType, random_encounters_class: CRandomEncounters) {
  switch (creature_type) {
    case SMALL_CREATURE:
      LogChannel('modRandomEncounters', "spawning type SMALL_CREATURE");
      createRandomSmallCreatureComposition(random_encounters_class);
      break;

    case LARGE_CREATURE:
      LogChannel('modRandomEncounters', "spawning type LARGE_CREATURE");
      createRandomLargeCreatureComposition(random_encounters_class);
      break;
  }
}
