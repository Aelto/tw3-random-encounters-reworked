statemachine class RER_quest1 extends SU_JournalQuestEntry {
  var constants: RER_quest1Constants;

  function init(): RER_quest1 {
    this.tag = "RER_questTwoBirdsOneStone";
    this.unique_tag = 'RER_questTwoBirdsOneStone';
    this.is_tracked = false;
    this.type = Side;
    this.status = JS_Active;
    this.difficulty = SU_JournalQuestEntryDifficulty_EASY;
    this.area = AN_Velen;
    this.title = "Two birds one stone";
    this.episode = SU_JournalQuestEntryEpisodeCORE;
    this.constants = (new RER_quest1Constants in this).init();

    this.addChapter((new RER_Q1_chapter0 in thePlayer).init(this));
    this.addChapter((new RER_Q1_chapter1 in thePlayer).init(this));
    this.addChapter((new RER_Q1_chapter2 in thePlayer).init(this));
    this.addChapter((new RER_Q1_chapter3 in thePlayer).init(this));
    this.addChapter((new RER_Q1_chapter4 in thePlayer).init(this));
    this.addChapter((new RER_Q1_chapter5 in thePlayer).init(this));

    return this;
  }
}

class RER_quest1Constants {
  var chapter0_geralt_position_scene: Vector;
  var chapter0_camera_position_scene_start: Vector;
  var chapter0_camera_position_scene_end: Vector;

  var chapter1_geralt_position_scene: Vector;
  var chapter1_camera_position_scene_start: Vector;
  var chapter1_camera_position_scene_end: Vector;
  var chapter1_corpse_position: Vector;

  var chapter2_harpy_spawn_position: Vector;

  var chapter_4_trail_position_end: Vector;
  var chapter_4_troll_position: Vector;

  function init(): RER_quest1Constants {
    this.chapter0_geralt_position_scene = Vector(1585.5, -1942, 29.3);
    this.chapter0_camera_position_scene_start = Vector(1588, -1928.4, 33);
    this.chapter0_camera_position_scene_end = Vector(1582.8, -1928.4, 34);

    this.chapter1_geralt_position_scene = Vector(1494.98, -1931.72, 27.35);
    this.chapter1_camera_position_scene_start = Vector(1505.8, -1934.32, 30.5);
    this.chapter1_camera_position_scene_end = chapter1_geralt_position_scene + Vector(0, 0, 3);
    this.chapter1_corpse_position = Vector(1438.7, -1906, 0);

    this.chapter2_harpy_spawn_position = Vector(1443, -1909.5, 0.65);

    this.chapter_4_trail_position_end = Vector(1506, -1984, 22.3);
    this.chapter_4_troll_position = Vector(1568.2, -2033.5, 0.3);

    return this;
  }
}