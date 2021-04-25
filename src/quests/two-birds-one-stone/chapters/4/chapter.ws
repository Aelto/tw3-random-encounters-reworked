statemachine class RER_Q1_chapter4 extends SU_JournalQuestChapter {
  public function init(quest_entry: SU_JournalQuestEntry): RER_Q1_chapter4 {
    this.tag = "QuestTestChapterFour";
    this.setLocalizedDescriptionWhenActive("description_when_active");
    this.setLocalizedDescriptionWhenCompleted("description_when_completed");

    this.addObjective(
      (new SU_JournalQuestChapterObjective in thePlayer)
      .setTags('objective_one_tag')
      .setLabel("Follow the tracks left by the troll")
      .addPin((new SU_MapPin in thePlayer).init(
        "tag_one",
        ((RER_quest1)quest_entry).constants.chapter_4_trail_position_end,
        "",
        "Follow the trail",
        "MonsterQuest",
        5,
        "skellige"
      ))
    );

    return this;
  }
}