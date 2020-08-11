
latent function spawnEntities(entity_template: CEntityTemplate, initial_position: Vector, optional quantity: int, optional density: float): array<RandomEncountersReworkedEntity> {
  var ent: CEntity;
  var player, pos_fin, normal: Vector;
  var rot: EulerAngles;
  var i, sign: int;
  var s, r, x, y: float;
  var createEntityHelper: CCreateEntityHelper;
  var created_entities: array<RandomEncountersReworkedEntity>;
  var current_rer_entity: RandomEncountersReworkedEntity;
  var rer_entity_template: CEntityTemplate;
  var created_entity: CEntity;
  
  quantity = Max(quantity, 1);

  if (density == 0) {
    density = 0.2;
  }

  LogChannel('modRandomEncounters', "spawning " + quantity + " entities");

  rot = thePlayer.GetWorldRotation();  

  //const values used in the loop
  pos_fin.Z = initial_position.Z;
  s = quantity / density; // maintain a constant density of `density` unit per m2
  r = SqrtF(s/Pi());

  createEntityHelper = new CCreateEntityHelper;
  // createEntityHelper.SetPostAttachedCallback(this, 'onEntitySpawned');

  rer_entity_template = (CEntityTemplate)LoadResourceAsync("dlc\modtemplates\randomencounterreworkeddlc\data\rer_default_entity.w2ent", true);

  for (i = 0; i < quantity; i += 1) {
    x = RandF() * r;        // add random value within range to X
    y = RandF() * (r - x);  // add random value to Y so that the point is within the disk

    if(RandRange(2))        // randomly select the sign for misplacement
      sign = 1;
    else
      sign = -1;
      
    pos_fin.X = initial_position.X + sign * x;  //final X pos
    
    if(RandRange(2))        // randomly select the sign for misplacement
      sign = 1;
    else
      sign = -1;
      
    pos_fin.Y = initial_position.Y + sign * y;  //final Y pos

    // return false means it could not find ground position
    // in this case, take the default position
    // if return true, then pos_fin is updated with the correct position
    if (!getGroundPosition(pos_fin)) {
      pos_fin = initial_position;
    }

    createEntityHelper.Reset();

    LogChannel('modRandomEncounters', "spawning entity at " + pos_fin.X + " " + pos_fin.Y + " " + pos_fin.Z);


    current_rer_entity = (RandomEncountersReworkedEntity)theGame.CreateEntity(
      rer_entity_template,
      initial_position,
      thePlayer.GetWorldRotation()
    );

    created_entity = theGame.CreateEntity(
      entity_template,
      pos_fin,
      rot
    );

    current_rer_entity.attach(
      (CActor)created_entity,
      (CNewNPC)created_entity,
      created_entity
    );

    created_entities.PushBack(current_rer_entity);
  }

  return created_entities;
}
