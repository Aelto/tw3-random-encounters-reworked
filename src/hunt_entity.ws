
// class RandomEncountersEntity extends CEntity {
//   // an invisible entity used to bait the entity
//   var bait_entity: CEntity;

//   // control whether the entity goes towards bait
//   // or the player
//   var go_towards_bait: bool;
//   default go_towards_bait = false;

//   private var this_entity: CEntity;
//   private var this_actor: CActor;
//   private var this_newnpc: CNewNPC;

//   // entry point when creating an entity who will
//   // follow a bait and leave tracks behind her.
//   // more suited for: `EncounterType_HUNT`
//   public function startWithBait(actor: CActor, newnpc: CNewNPC, this_entity: CEntity, bait_entity: CEntity) {
//     this.bait_entity = bait_entity;
//     this.go_towards_bait = true;

//     ((CNewNPC)this.bait_entity).SetGameplayVisibility(false);
//     ((CNewNPC)this.bait_entity).SetVisibility(false);		
//     ((CActor)this.bait_entity).EnableCharacterCollisions(false);
//     ((CActor)this.bait_entity).EnableDynamicCollisions(false);
//     ((CActor)this.bait_entity).EnableStaticCollisions(false);
//     ((CActor)this.bait_entity).SetImmortalityMode(AIM_Immortal, AIC_Default);

//     this.startWithoutBait(actor, newnpc, this_entity);
//   }

//   // entry point when creating an entity who will
//   // directly target the player.
//   // more suited for: `EncounterType_DEFAULT`
//   public function startWithoutBait(actor: CActor, newnpc: CNewNPC, this_entity: CEntity) {
//     this.actor = actor;
//     this.newnpc = newnpc;
//     this.this_entity = this_entity;


//   }

//   private function clean() {
//     bait_entity.Destroy();
//     RemoveTimer('mainInterval');
//   }
// }

class RandomEncountersHuntEntity extends CEntity {
  // an invisible entity used to bait the HuntEntity
  private var bait_entity: CEntity;
  
  private var this_entity: CEntity;
  private var this_actor: CActor;
  private var this_newnpc: CNewNPC;

  event OnSpawned( spawnData : SEntitySpawnData ){
		super.OnSpawned(spawnData);

    LogChannel('modRandomEncounters', "dummy onspawned");
	}

  public function setBaitEntity(entity: CEntity, actor: CActor, newnpc: CNewNPC, this_entity: CEntity) {
    this.bait_entity = entity;
    this.this_actor = actor;
    this.this_newnpc = newnpc;
    this.this_entity = this_entity;

    ((CNewNPC)entity).SetGameplayVisibility(false);
    ((CNewNPC)entity).SetVisibility(false);		
    ((CActor)entity).EnableCharacterCollisions(false);
    ((CActor)entity).EnableDynamicCollisions(false);
    ((CActor)entity).EnableStaticCollisions(false);
    ((CActor)entity).SetImmortalityMode(AIM_Immortal, AIC_Default);

    this.CreateAttachment(this.this_entity);

    LogChannel('modRandomEncounters', "set bait entity");

    AddTimer('mainInterval', 2, true);
  }

  timer function mainInterval(optional dt : float, optional id : Int32) {
    var distance_from_player: float;
    var distance_from_bait: float;
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;

    distance_from_player = VecDistance(
      this.GetWorldPosition(),
      thePlayer.GetWorldPosition()
    );

    distance_from_bait = VecDistance(
      this.GetWorldPosition(),
      this.bait_entity.GetWorldPosition()
    );

    LogChannel('modRandomEncounters', "distance from player : " + distance_from_player);
    LogChannel('modRandomEncounters', "distance from bait : " + distance_from_bait);


    if (distance_from_player > 200) {
      this.this_actor.Kill('RandomEncounters', true);
      this.clean();
    }

    if (distance_from_player < 20) {
      this.clean();
      this.this_newnpc.NoticeActor(thePlayer);

      // this.this_actor
      //   .GetMovingAgentComponent()
      //   .SetGameplayRelativeMoveSpeed(-1);
    }
    else {
      this.this_actor
        .GetMovingAgentComponent()
        .SetGameplayRelativeMoveSpeed(1);

      this.this_newnpc.NoticeActor((CActor)this.bait_entity);

      if (distance_from_bait < 5) {
        new_bait_position = this.GetWorldPosition() + VecConeRand(this.GetHeading(), 50, 17, 17);
        new_bait_rotation = this.GetWorldRotation();
        new_bait_rotation.Yaw += RandRange(-20,20);
        
        this.bait_entity.TeleportWithRotation(
          new_bait_position,
          new_bait_rotation
        );
      }
    }  
  }

  

  private function clean() {
    bait_entity.Destroy();
    RemoveTimer('mainInterval');
  }
}