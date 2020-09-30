
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

  public latent function getBloodSplatsResources(): array<CEntityTemplate> {
    var i: int;
    var output: array<CEntityTemplate>;

    for (i = 0; i < this.blood_splats.Size(); i += 1) {
      output.PushBack(
        (CEntityTemplate)LoadResourceAsync(
          this.blood_splats[i],
          true
        )
      );
    }

    return output;
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
