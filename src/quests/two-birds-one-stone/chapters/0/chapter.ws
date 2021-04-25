statemachine class RER_Q1_chapter0 extends SU_JournalQuestChapter {
  public function init(quest_entry: SU_JournalQuestEntry): RER_Q1_chapter0 {
    this.tag = "QuestTestChapterZero";
    this.setLocalizedDescriptionWhenActive("description_when_active");
    this.setLocalizedDescriptionWhenCompleted("description_when_completed");

    this.addObjective(
      (new SU_JournalQuestChapterObjective in thePlayer)
      .setTags('objective_one_tag')
      .setLabel("Look for a trail")
      .addPin((new SU_MapPin in thePlayer).init(
        "tag_one",
        ((RER_quest1)quest_entry).constants.chapter0_geralt_position_scene,
        "It is impossible to know where the brave man went without a trail",
        "Look for a trail",
        "MonsterQuest",
        5,
        "skellige"
      ))
    );

    return this;
  }
}