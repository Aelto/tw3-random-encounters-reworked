state Bootstrap in RER_Q1_chapter4 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Bootstrap_main();
  }

  entry function Bootstrap_main() {
    var entity: CEntity;

    entity = theGame.GetEntityByTag('RER_Q1_chapter1_corpse_tag');

    if (!entity) {
      entity = this.spawnCorpse();
    }

    this.spawnTroll();

    this.createTrails();
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

  

  latent function createTrails() {
    var tracks_templates: array<RER_TrailMakerTrack>;
    var trail_maker: RER_TrailMaker;
    var from: Vector;
    var to: Vector;

    tracks_templates.PushBack(getTracksTemplateByCreatureType(CreatureHUMAN));

    trail_maker = new RER_TrailMaker in parent;
    trail_maker.init(
      3,
      500,
      tracks_templates
    );
    trail_maker.dont_clean_on_destroy = true;

    NLOG("start drawing trails");

    from = ((RER_quest1)parent.quest_entry).constants.chapter1_corpse_position;
    to = Vector(1461.55, -1911.50, 2);
    trail_maker.drawTrail(from, to, 3,,, true, true);

    NLOG("trail 1 drawn");

    from = to;
    to = ((RER_quest1)parent.quest_entry).constants.chapter_4_trail_position_end;
    trail_maker.drawTrail(from, to, 3,,, true, true);

    NLOG("trail 2 drawn");
  }
}