state Bootstrap in RER_Q1_chapter5 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Bootstrap_main();
  }

  entry function Bootstrap_main() {
    var entity: CEntity;

    entity = theGame.GetEntityByTag('RER_Q1_chapter4_troll');

    if (!entity) {
      this.spawnTroll();
    }

    parent.nextState();
  }

  latent function spawnTroll() {
    var template: CEntityTemplate;
    var tags_array: array<name>;
    var template_path: string;
    var position: Vector;
    
    tags_array.PushBack('RER_Q1_chapter4_troll');
    template_path = "characters\npc_entities\monsters\troll_ice_lvl13.w2ent";
    template = (CEntityTemplate)LoadResourceAsync(template_path, true);

    position = ((RER_quest1)parent.quest_entry).constants.chapter_4_troll_position;
    
    theGame.CreateEntity(
      template,
      position,
      EulerAngles(0, -80, 0),,,,
      PM_Persist,
      tags_array
    );
  }
}