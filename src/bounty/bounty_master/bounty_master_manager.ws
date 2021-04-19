
statemachine class RER_BountyMasterManager {

  var bounty_master_entity: CEntity;

  var last_talking_time: float;

  var bounty_manager: RER_BountyManager;

  var picked_seed: int;

  public latent function init(bounty_manager: RER_BountyManager) {
    this.bounty_manager = bounty_manager;
    this.spawnBountyMaster();
    this.GotoState('Waiting');
  }

  public latent function spawnBountyMaster() {
    var valid_positions: array<Vector>;
    var template: CEntityTemplate;
    var position_index: int;
    var template_path: string;
    var map_pin: SU_MapPin;

    this.bounty_master_entity = theGame.GetEntityByTag('RER_bounty_master');

    template_path = "quests\secondary_npcs\graden.w2ent";

    // every hour of playtime it changes the index in the valid positions
    valid_positions = this.getBountyMasterValidPositions();
    position_index = (int)RandNoiseF(
      GameTimeHours(theGame.CalculateTimePlayed()),
      valid_positions.Size()
    ) % valid_positions.Size(); // the % is just in case

    if (position_index < 0 || position_index > valid_positions.Size() - 1) {
      position_index = (int)RandNoiseF(thePlayer.GetLevel(), valid_positions.Size() - 1) % valid_positions.Size();
    }

    if (position_index < 0 || position_index > valid_positions.Size() - 1) {
      position_index = 0;
    }

    // the bounty master already exist
    if (this.bounty_master_entity) {
      NLOG("bounty master exists, template = " + StrAfterFirst(this.bounty_master_entity.ToString(), "::"));

      // not the same template as the one asked, we kill the current bounty master

      if (StrAfterFirst(this.bounty_master_entity.ToString(), "::") != template_path) {
        NLOG("bounty master wrong template");
        // ((CActor)this.bounty_master_entity).Kill('RER');
        this.bounty_master_entity.Destroy();
        delete this.bounty_master_entity;
      }
      else {
        // teleport the bounty master at the current position based on the current playtime
        bounty_master_entity.Teleport(valid_positions[position_index]);
      }

    }
    
    if (!this.bounty_master_entity) {
      NLOG("bounty master doesn't exist");

      template = (CEntityTemplate)LoadResourceAsync(template_path, true);

      this.bounty_master_entity = theGame.CreateEntity(
        template,
        valid_positions[position_index],
        thePlayer.GetWorldRotation(),,,,
        PM_Persist
      );

      this.bounty_master_entity.AddTag('RER_bounty_master');
    }

    SU_removeCustomPinByTag("RER_bounty_master");

    if (theGame.GetInGameConfigWrapper()
        .GetVarValue('RERoptionalFeatures', 'RERmarkersBountyHunting')) {

      map_pin = new SU_MapPin in thePlayer;
      map_pin.tag = "RER_bounty_master";
      map_pin.position = valid_positions[position_index];
      map_pin.description = GetLocStringByKey("rer_mappin_bounty_master_description");
      map_pin.label = GetLocStringByKey("rer_mappin_bounty_master_title");
      map_pin.type = "QuestGiverChapter";
      map_pin.radius = 5;
      map_pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

      thePlayer.addCustomPin(map_pin);

      NLOG("bounty master placed at " + VecToString(valid_positions[position_index]));
    }

  }

  public function getBountyMasterValidPositions(): array<Vector> {
    var area: EAreaName;
    var area_string: string;
    var output: array<Vector>;

    area = theGame.GetCommonMapManager().GetCurrentArea();

    switch (area) {
      case AN_Prologue_Village:
      case AN_Prologue_Village_Winter:
        // Nilfgaardian garrison
        output.PushBack(Vector(-371.5, 372.5, 1.9));

        // Ransacked village
        output.PushBack(Vector(491.3, -64.7, 8.9));

        // Woeson Bridge - white orchard blacksmith
        output.PushBack(Vector(11.5, -24.9, 2.3));
        
        break;

      case AN_Skellige_ArdSkellig:
        // Holmstein port
        output.PushBack(Vector(-297.9, -1049, 6));

        // Holmstein port
        output.PushBack(Vector(-36, 619, 2));

        // Urialla harbor
        output.PushBack(Vector(1488, 1907, 4.7));
        break;

      case AN_Kaer_Morhen:
        // Crows perch
        output.PushBack(Vector(-91, -22.8, 146));
        break;

      case AN_NMLandNovigrad:
      case AN_Velen:
        // Blackbough
        output.PushBack(Vector(-186, 187, 7.6));

        // Crows perch
        output.PushBack(Vector(175, 7, 13.8));

        // Nilfgaardian camp
        output.PushBack(Vector(2321, -881, 16.1));

        // Novigrad - gregory bridge
        output.PushBack(Vector(691, 2025, 33.4));

        // Novigrad - portside gate
        output.PushBack(Vector(543, 1669, 4.12));

        // Novigrad - rosemary and thyme
        output.PushBack(Vector(707.6, 1751.2, 4.3));

        // Oxenfurt - novigrad gate
        output.PushBack(Vector(1758, 1049, 6.8));

        // Oxenfurt - western gate
        output.PushBack(Vector(1714.3, 918, 14));

        // Upper mill
          output.PushBack(Vector(2497, 2497, 2.8));
        break;

      default:
        area_string = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

        if (area_string == "bob") {
          // Beauclair port
          output.PushBack(Vector(-229, -1184, 3.7));

          // Castel vineyard
          output.PushBack(Vector(-745, -321, 29.4));

          // Cockatrice inn
          output.PushBack(Vector(-148.6, -635.4, 11.4));

          // Tourney grounds
          output.PushBack(Vector(-490.4, -954.3, 61.2));
        }
        else {
          // the real default
        }

        break;
    }

    return output;
  }

  public function bountySeedSelected(seed: int) {
    this.picked_seed = seed;

    this.GotoState('CreateBounty');
  }

}