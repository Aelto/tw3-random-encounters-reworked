state Bootstrap in RER_Q1_chapter0 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Bootstrap_main();
  }

  entry function Bootstrap_main() {
    this.createClues();
    parent.nextState();
  }

  latent function createClues() {
    var template_path: string;
    var center_position: Vector;
    var radius: float;
    var max_count: int;
    var min_count: int;

    center_position = ((RER_quest1)parent.quest_entry)
      .constants
      .chapter0_geralt_position_scene;

    template_path = "characters\models\monsters\harpy\w_01__harpy_cut_wing.w2ent";
    min_count = 3;
    max_count = 6;
    radius = 5;
    this.randomlySpawnEntityInArea(template_path, center_position, radius, max_count, min_count);
    
    template_path = "characters\models\monsters\harpy\w_04__harpy_cut_torso.w2ent";
    min_count = 3;
    max_count = 1;
    radius = 5;
    this.randomlySpawnEntityInArea(template_path, center_position, radius, max_count, min_count);

    template_path = "fx\cutscenes\skellige\sq204_huldra\feathers_huldra.w2ent";
    min_count = 20;
    max_count = 10;
    radius = 5;
    this.randomlySpawnEntityInArea(template_path, center_position, radius, max_count, min_count);

    // blood
    template_path = "quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_big.w2ent";
    min_count = 12;
    max_count = 3;
    radius = 10;
    this.randomlySpawnEntityInArea(template_path, center_position, radius, max_count, min_count);
    template_path = "quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium.w2ent";
    min_count = 12;
    max_count = 3;
    radius = 10;
    this.randomlySpawnEntityInArea(template_path, center_position, radius, max_count, min_count);
    template_path = "quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium_2.w2ent";
    min_count = 12;
    max_count = 3;
    radius = 10;
    this.randomlySpawnEntityInArea(template_path, center_position, radius, max_count, min_count);
    template_path = "living_world\treasure_hunting\th1003_lynx\entities\generic_clue_blood_splat.w2ent";
    min_count = 12;
    max_count = 3;
    radius = 10;
    this.randomlySpawnEntityInArea(template_path, center_position, radius, max_count, min_count);
  }
}