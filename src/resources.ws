
class RE_Resources {
  public var blood_splats : array<string>;

  function load_resources() {
    this.load_blood_splats();
  }

  private function load_blood_splats() {
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_big.w2ent");  
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium.w2ent");    
    blood_splats.PushBack("quests\prologue\quest_files\living_world\entities\clues\blood\lw_clue_blood_splat_medium_2.w2ent");  
    blood_splats.PushBack("living_world\treasure_hunting\th1003_lynx\entities\generic_clue_blood_splat.w2ent");
  }

                  //////////////////////
                  // PUBLIC FUNCTIONS //
                  //////////////////////

  public latent function getBloodSplatsResources(): array<RER_TrailMakerTrack> {
    var i: int;
    var output: array<RER_TrailMakerTrack>;

    for (i = 0; i < this.blood_splats.Size(); i += 1) {
      output.PushBack(
        RER_TrailMakerTrack(
          (CEntityTemplate)LoadResourceAsync(
            this.blood_splats[i],
            true
          )
        )
      );
    }

    return output;
  }

  public latent function getCorpsesResources(): array<RER_TrailMakerTrack> {
    var corpse_resources: array<RER_TrailMakerTrack>;

    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_01.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_03.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_05.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_06.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_02_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_03_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_04_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_05_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_06_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_07_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_08_nml_villager.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_01_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_02_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_03_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_04_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_05_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_06_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_07_novigrad.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_01_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_02_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_03_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_04_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_05_nml_woman.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_01.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_02.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_03.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_01.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_02.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_03.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_04.w2ent", true)));
    corpse_resources.PushBack(RER_TrailMakerTrack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_05.w2ent", true)));

    return corpse_resources;
  }

  public latent function getPortalResource(): CEntityTemplate {
    var entity_template: CEntityTemplate;

    entity_template = (CEntityTemplate)LoadResourceAsync( "gameplay\interactive_objects\rift\rift.w2ent", true);
    
    return entity_template;
  }
}

function isHeartOfStoneActive(): bool {
  return theGame.GetDLCManager().IsEP1Available() && theGame.GetDLCManager().IsEP1Enabled();
}

function isBloodAndWineActive(): bool {
  return theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled();
}
