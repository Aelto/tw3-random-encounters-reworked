statemachine class RER_Q1_chapter2 extends SU_JournalQuestChapter {
  public function init(quest_entry: SU_JournalQuestEntry): RER_Q1_chapter2 {
    this.tag = "QuestTestChapterTwo";
    this.setLocalizedDescriptionWhenActive("description_when_active");
    this.setLocalizedDescriptionWhenCompleted("description_when_completed");

    this.addObjective(
      (new SU_JournalQuestChapterObjective in thePlayer)
      .setTags('objective_one_tag')
      .setLabel("Kill the harpies")
      .addPin((new SU_MapPin in thePlayer).init(
        "tag_one",
        Vector(1438.7, -1906, 0),
        "Kill the harpies",
        "",
        "MonsterQuest",
        5,
        "skellige"
      ))
    );

    return this;
  }
}