state Bootstrap in RER_Q1_chapter3 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Bootstrap_main();
  }

  entry function Bootstrap_main() {
    var entity: CEntity;

    entity = theGame.GetEntityByTag('RER_Q1_chapter1_corpse_tag');

    if (!entity) {
      entity = this.spawnCorpse();
    }

    parent.nextState();
  }

  latent function spawnCorpse(): CEntity {
    var template: CEntityTemplate;
    var tags_array: array<name>;
    var template_path: string;
    var position: Vector;
    
    tags_array.PushBack('RER_Q1_chapter1_corpse_tag');
    template_path = "environment\decorations\corpses\human_corpses\merchant\merchant_corpses_03.w2ent";
    template = (CEntityTemplate)LoadResourceAsync(template_path, true);

    position = ((RER_quest1)parent.quest_entry).constants.chapter1_corpse_position;
    
    return theGame.CreateEntity(
      template,
      position,
      thePlayer.GetWorldRotation(),,,,
      PM_Persist,
      tags_array
    );
  }
}