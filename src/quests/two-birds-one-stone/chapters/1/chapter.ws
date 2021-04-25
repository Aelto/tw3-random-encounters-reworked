statemachine class RER_Q1_chapter1 extends SU_JournalQuestChapter {
  public function init(quest_entry: SU_JournalQuestEntry): RER_Q1_chapter1 {
    this.tag = "QuestTestChapterOne";
    this.setLocalizedDescriptionWhenActive("description_when_active");
    this.setLocalizedDescriptionWhenCompleted("description_when_completed");

    this.addObjective(
      (new SU_JournalQuestChapterObjective in thePlayer)
      .setTags('objective_one_tag')
      .setLabel("Follow the trail to find the hunter")
      .addPin((new SU_MapPin in thePlayer).init(
        "tag_one",
        ((RER_quest1)quest_entry).constants.chapter1_geralt_position_scene,
        "",
        "Follow the trail",
        "MonsterQuest",
        10,
        "skellige"
      ))
    );

    return this;
  }
}