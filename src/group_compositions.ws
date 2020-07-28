
// Sometimes solo creatures can be accompanied by smaller creatures,
// this is what i call a group composition. Imagine a leshen and a few wolves
// or a giant fighting humans.

latent function makeGroupComposition(encounter_type: EncounterType, creature_type: CreatureType, random_encounters_class: CRandomEncounters) {
  if (encounter_type == EncounterType_HUNT) {
    switch (creature_type) {
      case SMALL_CREATURE:
        LogChannel('modRandomEncounters', "spawning type SMALL_CREATURE - HUNT");
        createRandomSmallCreatureHunt(random_encounters_class);
        break;

      case LARGE_CREATURE:
        LogChannel('modRandomEncounters', "spawning type LARGE_CREATURE - HUNT");
        createRandomLargeCreatureHunt(random_encounters_class);
        break;
    }

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "MiscFreshTracks" );
    }
  }
  else {
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

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "BattleCryBadSituation" );
    }
  }
}
