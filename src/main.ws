class CRandomEncounterInitializer extends CEntityMod {
  default modName = 'Random Encounters';
  default modAuthor = "erxv";
  default modUrl = "http://www.nexusmods.com/witcher3/mods/785?";
  default modVersion = '1.31';

  default logLevel = MLOG_DEBUG;

  default template = "dlc\modtemplates\randomencounterdlc\data\re_initializer.w2ent";
}


function modCreate_RandomEncounters() : CMod {
  return new CRandomEncounterInitializer in thePlayer;
}

statemachine class CRandomEncounters extends CEntity {
  private	var rExtra: CModRExtra;
  private var settings: RE_Settings;
  private var resources: RE_Resources;

  private var ticks_before_spawn: int;

  event OnSpawned(spawn_data: SEntitySpawnData) {
    var ents: array<CEntity>;

    LogChannel('modRandomEncounters', "RandomEncounter spawned");

    theGame.GetEntitiesByTag('RandomEncounterTag', ents);

    if (ents.Size() > 1) {
      this.Destroy();
    }
    else {
      this.AddTag('RandomEncounterTag');

      theInput.RegisterListener(this, 'OnRefreshSettings', 'RefreshRESetting');
      theInput.RegisterListener(this, 'OnSpawnMonster', 'RandomEncounter');

      super.OnSpawned(spawn_data);

      rExtra = new CModRExtra in this;
      settings = new RE_Settings in this;
      resources = new RE_Resources in this;

      this.initiateRandomEncounters();
    }
  }

  event OnRefreshSettings(action: SInputAction) {
    if (IsPressed(action)) {
      this.settings.loadXMLSettingsAndShowNotification();
    }
  }

  event OnSpawnMonster(action: SInputAction) {
    LogChannel('modRandomEncounters', "on spawn event");
  }

  private function initiateRandomEncounters() {
    this.settings.loadXMLSettings();
    this.resources.load_resources();

    this.ticks_before_spawn = this.calculateRandomTicksBeforeSpawn();

    AddTimer('onceReady', 3.0, false);
    AddTimer('randomEncounterTick', 1.0, true);
  }

  timer function onceReady(optional delta: float, optional id: Int32) {
    displayRandomEncounterEnabledNotification();
  }

  timer function randomEncounterTick(optional delta: float, optional id: Int32) {
    if (this.ticks_before_spawn < 0) {
      // adding a timer to avoid spending too much time in this
      // supposedly quick function.
      this.ticks_before_spawn = this.calculateRandomTicksBeforeSpawn();

      AddTimer('triggerCreaturesSpawn', 0.1, false);
    }

    this.ticks_before_spawn -= 1;
  }

  private function calculateRandomTicksBeforeSpawn(): int {
    if (this.settings.customFrequency) {
      if (theGame.envMgr.IsNight()) {
        return RandRange(this.settings.customNightMin, this.settings.customNightMax);
      }

      return RandRange(this.settings.customDayMin, this.settings.customDayMax);
    }
    
    if (theGame.envMgr.IsNight()) {
      switch (this.settings.chanceNight) {
        case 1:
          return RandRange(1400, 3200);
          break;
        
        case 2:
          return RandRange(800, 1600);
          break;

        case 3:
          return RandRange(500, 900);
          break;
      }

      return 99999;
    }

    switch (this.settings.chanceDay) {
      case 1:
        return RandRange(1400, 3900);
        break;

      case 2:
        return RandRange(800, 1800);
        break;

      case 3:
        return RandRange(500, 1100);
        break;
    }

    return 99999;
  }

  timer function triggerCreaturesSpawn(optional delta: float, optional id: Int32) {
    var picked_entity_type: int;
    
    if (this.shouldAbortCreatureSpawn()) {
      // spawn should have occured, but was cancelled due to
      // reasons.
      // make it so the next attempt will come a bit faster
      this.ticks_before_spawn = this.ticks_before_spawn / 3;

      return;
    }

    picked_entity_type = this.getRandomEntityTypeWithSettings();

    this.trySpawnHuman();

    switch (picked_entity_type) {
      case ET_GROUND:
        LogChannel('modRandomEncounters', "spawning type ET_GROUND ");
        break;

      case ET_FLYING:
        LogChannel('modRandomEncounters', "spawning type ET_FLYING ");
        break;

      case ET_HUMAN:
        LogChannel('modRandomEncounters', "spawning type ET_HUMAN ");
        break;

      case ET_GROUP:
        LogChannel('modRandomEncounters', "spawning type ET_GROUP ");
        break;

      case ET_WILDHUNT:
        LogChannel('modRandomEncounters', "spawning type ET_WILDHUNT ");
        break;

      case ET_NONE:
        // do nothing when no EntityType was available
        // this is here for reminding me this case exists.
        break;
    }
  }

  private function shouldAbortCreatureSpawn(): bool {
    var current_state: CName;
    var is_meditating: bool;
    var current_zone: EREZone;


    current_state = thePlayer.GetCurrentStateName();
    is_meditating = current_state == 'Meditation' && current_state == 'MeditationWaiting';
    current_zone = this.rExtra.getCustomZone(thePlayer.GetWorldPosition());

    return is_meditating 
        || thePlayer.IsInInterior()
        || thePlayer.IsInCombat()
        || thePlayer.IsUsingBoat()
        || thePlayer.IsInFistFightMiniGame()
        || thePlayer.IsSwimming()
        || thePlayer.IsInNonGameplayCutscene()
        || thePlayer.IsInGameplayScene()
        || theGame.IsDialogOrCutscenePlaying()
        || theGame.IsCurrentlyPlayingNonGameplayScene()
        || theGame.IsFading()
        || theGame.IsBlackscreen()
        || current_zone == REZ_CITY 
        && !this.settings.cityBruxa 
        && !this.settings.citySpawn;
  }

  private function getRandomEntityTypeWithSettings(): EEncounterType {
    var choice : array<EEncounterType>;

    if (theGame.envMgr.IsNight()) {
      choice = this.getRandomEntityTypeForNight();
    }
    else {
      choice = this.getRandomEntityTypeForDay();
    }

    if (choice.Size() < 1) {
      return ET_NONE;
    }

    return choice[RandRange(choice.Size())];
  }

  private function getRandomEntityTypeForNight(): array<EEncounterType> {
    var choice: array<EEncounterType>;
    var i: int;

    for (i = 0; i < this.settings.isGroundActiveN; i += 1) {
      choice.PushBack(ET_GROUND);
    }

    // TODO: add inForest factor, maybe 0.5?
    for (i = 0; i < this.settings.isFlyingActiveN; i += 1) {
      choice.PushBack(ET_FLYING);
    }

    for (i = 0; i < this.settings.isHumanActiveN; i += 1) {
      choice.PushBack(ET_HUMAN);
    }

    for (i = 0; i < this.settings.isGroupActiveN; i += 1) {
      choice.PushBack(ET_GROUP);
    }

    for (i = 0; i < this.settings.isWildHuntActiveN; i += 1) {
      choice.PushBack(ET_WILDHUNT);
    }

    return choice;
  }

  private function getRandomEntityTypeForDay(): array<EEncounterType> {
    var choice: array<EEncounterType>;
    var i: int;

    for (i = 0; i < this.settings.isGroundActiveD; i += 1) {
      choice.PushBack(ET_GROUND);
    }

    // TODO: add inForest factor, maybe 0.5?
    for (i = 0; i < this.settings.isFlyingActiveD; i += 1) {
      choice.PushBack(ET_FLYING);
    }

    for (i = 0; i < this.settings.isHumanActiveD; i += 1) {
      choice.PushBack(ET_HUMAN);
    }

    for (i = 0; i < this.settings.isGroupActiveD; i += 1) {
      choice.PushBack(ET_GROUP);
    }

    for (i = 0; i < this.settings.isWildHuntActiveD; i += 1) {
      choice.PushBack(ET_WILDHUNT);
    }

    return choice;
  }

  private function trySpawnHuman(): bool {
    var human_template: CEntityTemplate;
    var number_of_humans: int;
    var picked_human_type: EHumanType;
    var initial_human_position: Vector;
    var template_human_array: array<SEnemyTemplate>;

    if (!this.getInitialHumanPosition(initial_human_position, 15)) {
      // could net get a proper initial position
      return false;
    }

    picked_human_type = this.rExtra.getRandomHumanTypeByCurrentArea();
    
    template_human_array = this.resources.copy_template_list(
      this.resources.getHumanResourcesByHumanType(picked_human_type)
    );

    number_of_humans = RandRange(
      4 + this.settings.selectedDifficulty,
      6 + this.settings.selectedDifficulty
    );

    this.spawnGroupOfEntities(template_human_array, number_of_humans, initial_human_position);

    return true;
  }

  private function spawnGroupOfEntities(entities_templates: array<SEnemyTemplate>, total_number_of_entities: int, initial_entity_position: Vector) {
    var current_entity_template: SEnemyTemplate;
    var current_entity_position: Vector;
    var selected_template_to_increment: int;
    var i: int;

    LogChannel('modRandomEncounters', "spawning total of " + total_number_of_entities + " entities");

    // randomly increase the entity count for each type of template
    // based on the maximum of entities this entity template allows
    while (total_number_of_entities > 0) {
      selected_template_to_increment = RandRange(entities_templates.Size());

      LogChannel('modRandomEncounters', "selected template: " + selected_template_to_increment);

      if (entities_templates[selected_template_to_increment].max > -1
       && entities_templates[selected_template_to_increment].count >= entities_templates[selected_template_to_increment].max) {
        continue;
      }

      entities_templates[selected_template_to_increment].count += 1;

      total_number_of_entities -= 1;
    }

    for (i = 0; i < entities_templates.Size(); i += 1) {
      current_entity_template = entities_templates[i];

      if (current_entity_template.count > 0) {
        this.spawnEntities(
          (CEntityTemplate)LoadResource(current_entity_template.template, true),
          initial_entity_position,
          current_entity_template.count
        );
      }
    }
  }

  protected function ObtainTemplateForEnemy( tempArray : array<SEnemyTemplate> ) : string
  {
    var i : int;
    var _tempArray : array<SEnemyTemplate>;
    var _templateid : int;
    var _template : SEnemyTemplate;

    for (i = 0; i < tempArray.Size(); i += 1)
    {
      if (tempArray[i].max < 0 || tempArray[i].count < tempArray[i].max)
      {
        _tempArray.PushBack(tempArray[i]);
      }
    }

    _templateid = RandRange(_tempArray.Size());
    _template = _tempArray[_templateid];

    for (i = 0; i < tempArray.Size(); i += 1)
    {
      if (tempArray[i] == _template)
      {
        tempArray[i].count += 1;
        break;
      }
    }

    return _template.template;
  }

  private function spawnEntities(entity_template: CEntityTemplate, initial_position: Vector, optional quantity: int) {
    var ent: CEntity;
    var player, pos_fin, normal: Vector;
    var rot: EulerAngles;
    var i, sign: int;
    var s, r, x, y: float;
    var createEntityHelper: CCreateEntityHelper;

    // entity_template = (CEntityTemplate)LoadResource("characters\npc_entities\monsters\wolf_white_lvl2.w2ent", true);
    // entity_template = (CEntityTemplate)LoadResource("gameplay\templates\characters\presets\inquisition\inq_1h_sword_t2.w2ent", true);
    
    quantity = Max(quantity, 1);

    LogChannel('modRandomEncounters', "spawning " + quantity + " entities");
	
    rot = thePlayer.GetWorldRotation();	

    //const values used in the loop
    pos_fin.Z = initial_position.Z;			//final spawn pos
    s = quantity / 0.2;			//maintain a constant density of 0.2 unit per m2
    r = SqrtF(s/Pi());

    for (i = 0; i < quantity; i += 1) {
      x = RandF() * r;			//add random value within range to X
		  y = RandF() * (r - x);		//add random value to Y so that the point is within the disk

      if(RandRange(2))					//randomly select the sign for misplacement
        sign = 1;
      else
        sign = -1;
        
      pos_fin.X = initial_position.X + sign * x;	//final X pos
      
      if(RandRange(2))					//randomly select the sign for misplacement
        sign = 1;
      else
        sign = -1;
        
      pos_fin.Y = initial_position.Y + sign * y;	//final Y pos

      theGame.GetWorld().StaticTrace( pos_fin + Vector(0,0,3), pos_fin - Vector(0,0,3), pos_fin, normal);

      createEntityHelper = new CCreateEntityHelper in this;
      createEntityHelper.SetPostAttachedCallback( this, 'onEntitySpawned' );
      theGame.CreateEntityAsync(createEntityHelper, entity_template, pos_fin, rot, true, false, false, PM_DontPersist);

      LogChannel('modRandomEncounters', "spawning entity at " + pos_fin.X + " " + pos_fin.Y + " " + pos_fin.Z);
    }
  }

  function onEntitySpawned(entity: CEntity) {
    var summon: CNewNPC;
    LogChannel('modRandomEncounters', "1 entity spawned");
    

    summon = ( CNewNPC ) entity;

    summon.SetLevel(GetWitcherPlayer().GetLevel());
    summon.NoticeActor(thePlayer);
    summon.SetTemporaryAttitudeGroup('hostile_to_player', AGP_Default);
  }

  private function getInitialHumanPosition(out initial_pos: Vector, optional distance: float) : bool {
    var collision_normal: Vector;
    var camera_direction: Vector;
    var player_position: Vector;

    camera_direction = theCamera.GetCameraDirection();

    if (distance == 0.0) {
      distance = 3.0; // meters
    }

    camera_direction.X *= -distance;
    camera_direction.Y *= -distance;

    player_position = thePlayer.GetWorldPosition();

    initial_pos = player_position + camera_direction;
    initial_pos.Z = player_position.Z;

    return theGame
      .GetWorld()
      .StaticTrace(
        initial_pos + 5,// Vector(0,0,5),
        initial_pos - 5,//Vector(0,0,5),
        initial_pos,
        collision_normal
      );

    // var i: int;
    // var pos: Vector;
    // var z: float;

    // for (i = 0; i < 30; i += 1) {
    //   pos = thePlayer.GetWorldPosition() + VecConeRand(theCamera.GetCameraHeading(), -170, -20, -25);

    //   FixZAxis(pos);

    //   if (!this.canSpawnEnt(pos)) {
    //     return false;
    //   }

    //   initial_pos = pos;

    //   return true;
    // }
  }

  protected function PrepareEnemyTemplate(arr: array<SEnemyTemplate>) {
    var i: int;

    for (i = 0; i < arr.Size(); i += 1) {
      arr[i].count = 0;
    }
  }

  public function canSpawnEnt(pos : Vector) : bool {
    var template : CEntityTemplate;
    var rot : EulerAngles;
    var canSpawn : bool;
    var ract : CActor;
    var currentArea : string;
    var inSettlement : bool;

    canSpawn = false;

    template = (CEntityTemplate)LoadResource( "characters\npc_entities\animals\hare.w2ent", true );	
    ract = (CActor)theGame.CreateEntity(template, pos, rot);
    
    ((CNewNPC)ract).SetGameplayVisibility(false);
    ((CNewNPC)ract).SetVisibility(false);		
    
    ract.EnableCharacterCollisions(false);
    ract.EnableDynamicCollisions(false);
    ract.EnableStaticCollisions(false);
    ract.SetImmortalityMode(AIM_Invulnerable, AIC_Default);

    inSettlement = ract.TestIsInSettlement();

    if (!inSettlement
      && pos.Z >= theGame.GetWorld().GetWaterLevel(pos, true)
      && !((CNewNPC)ract).IsInInterior()) {

      canSpawn = true;
    }

    ract.Destroy();

    return canSpawn;
  }

}

function FixZAxis(out pos : Vector) {
    var world : CWorld;
    var z : float;

    world = theGame.GetWorld();

    if (world.NavigationComputeZ(pos, pos.Z - 128, pos.Z + 128, z)) {
      pos.Z = z;
    }

    if (world.PhysicsCorrectZ(pos, z)) {
      pos.Z = z;
    }
}