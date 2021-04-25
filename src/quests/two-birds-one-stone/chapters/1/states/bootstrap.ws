state Bootstrap in RER_Q1_chapter1 extends BaseChapter {
  event OnEnterState(previous_state_name: name) {
    this.Bootstrap_main();
  }

  entry function Bootstrap_main() {
    this.createTrails();
    parent.nextState();
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

    from = ((RER_quest1)parent.quest_entry).constants.chapter0_geralt_position_scene;
    to = Vector(1561.71, -1925.39, 33.09);
    trail_maker.drawTrail(from, to, 3,,, true, false);

    NLOG("trail 1 drawn");

    from = to;
    to = Vector(1537.1, -1937, 32.8);
    trail_maker.drawTrail(from, to, 3,,, true, false);

    NLOG("trail 2 drawn");

    from = to;
    to = Vector(1513.8, -1928.9, 29.27);
    trail_maker.drawTrail(from, to, 3,,, true, false);

    NLOG("trail 3 drawn");

    from = to;
    to = Vector(1496.7, -1936.32, 26.7);
    trail_maker.drawTrail(from, to, 3,,, true, false);

    NLOG("trail 4 drawn");
  }
}