
# Notes
> Custom notes i write for myself to not forget them 😊

- to enable logging use `-debugscripts` flag

- ideas for Event reaction:
  - maybe higher chance for some creatures to spawn if you're injured. As they are attracted to the blood. by Czartchonn on discord
  - looting chests, bandits attacking you. by Czartchonn on discord
  - fighting makes noise, it can attract creatures
  - bodies attract necrophages

- `quests\generic_quests\scenes\mh_taking_trophy_no_dialogue.w2scene` for the trophy scene

- spawning blood spills
  ```js
  public final function CreateBloodSpill()
	{
		var bloodTemplate : CEntityTemplate;
	
		bloodTemplate = (CEntityTemplate)LoadResource("blood_0" + RandRange(4));
		theGame.CreateEntity(bloodTemplate, GetWorldPosition() + VecRingRand(0, 0.5) , EulerAngles(0, RandF() * 360, 0));
	}
  ```

- find entities around the player
  ```js
    var entities : array<CGameplayEntity>;
		FindGameplayEntitiesInSphere( entities, thePlayer.GetWorldPosition(), 10, 1,, FLAG_ExcludePlayer,, 'W3FastTravelEntity' ); // 'W3NoticeBoard' for noticeboards
  ```

- i think it doesn't work in skellige
  ```js
  public function TestIsInSettlement() : bool
	{
		var ents : array<CEntity>;
		var trigger : CTriggerAreaComponent;
		var i : int;
		
		theGame.GetEntitiesByTag('settlement', ents);
		
		for(i=0; i<ents.Size(); i+=1)
		{
			trigger = (CTriggerAreaComponent)(ents[i].GetComponentByClassName('CTriggerAreaComponent'));
			if(trigger.TestEntityOverlap(this))
				return true;
		}
		
		return false;
	}
  ```

- function for the trophy cutscene:
  ```js
  latent quest function SetupTrophySceneQuest( monsterTag : name, offset : float)
  {
    var witcher : W3PlayerWitcher;
    var monster : CNewNPC;
    var newPosition	 : Vector;
    var playerPosition	 : Vector;
    var Position : Vector;
    var Rotation : EulerAngles;	
    var placementNode  : CNode;
    var placementNodes  : array<CNode>;
    var z : float;
    var curDistance : float;
    var minDistance : float;
    
    var i : int;

    witcher = GetWitcherPlayer();

    if( witcher )
    {
      playerPosition = thePlayer.GetWorldPosition();
      
      theGame.GetNodesByTag( 'mh_trophy_safe_placement_point', placementNodes );
      
      if( placementNodes.Size() > 0 )
      {
        for(i=0; i < placementNodes.Size(); i += 1 ) 
        {
          curDistance = VecDistance2D( placementNodes[i].GetWorldPosition(), playerPosition );
          
          if( minDistance == 0.0f || curDistance  <= minDistance )
          {
            minDistance = curDistance;
            placementNode = placementNodes[i];
          }
        }
        
        
        newPosition = placementNode.GetWorldPosition();
        
        if( theGame.GetWorld().NavigationFindSafeSpot( newPosition, 1.0, 6.0, newPosition ) )
        {
          if ( theGame.GetWorld().NavigationComputeZ(newPosition, newPosition.Z - 5.0, newPosition.Z + 5.0, z) )
          {
            newPosition.Z = z;
            if ( !theGame.GetWorld().NavigationFindSafeSpot( newPosition, 1.0, 6.0, newPosition ) )
              return;
          }
          
          witcher.TeleportWithRotation(newPosition, placementNode.GetWorldRotation() );
          
          Sleep(0.3f);
          
          monster = (CNewNPC) theGame.GetEntityByTag( monsterTag );
          
          if( monster )
          {
            if( offset == 0.0 )
              offset = 2.0;
            
            Position = witcher.GetWorldPosition();
            Rotation = witcher.GetWorldRotation();
            
            newPosition = Vector(Position.X, Position.Y, Position.Z) + witcher.GetHeadingVector() * offset;
            
            if ( theGame.GetWorld().NavigationComputeZ(newPosition, newPosition.Z - 5.0, newPosition.Z + 5.0, z) )
            {
              newPosition.Z = z;
              if ( !theGame.GetWorld().NavigationFindSafeSpot( newPosition, 1.0, 6.0, newPosition ) )
                return;
            }
            
            monster.TeleportWithRotation(newPosition, EulerNeg(Rotation, EulerAngles(0.0,-90.0,0.0) ) );
            Sleep(0.3f);
          }	
          
        }
        
      }
    }
  }
  ```

- function adding all trophies
  ```js
  //adds all trophy items to the player's inventory
  exec function addtrophies()
  {
    thePlayer.inv.AddAnItem('Nekkers Trophy',1);
    thePlayer.inv.AddAnItem('Werewolf Trophy',1);
    thePlayer.inv.AddAnItem('q002_griffin_trophy',1);
    thePlayer.inv.AddAnItem('Drowned Dead Trophy',1);
    thePlayer.inv.AddAnItem('mh101_cockatrice_trophy',1);
    thePlayer.inv.AddAnItem('mh102_arachas_trophy',1);
    thePlayer.inv.AddAnItem('mh103_nightwraith_trophy',1);
    thePlayer.inv.AddAnItem('mh104_ekimma_trophy',1);
    thePlayer.inv.AddAnItem('mh105_wyvern_trophy',1);
    thePlayer.inv.AddAnItem('mh106_gravehag_trophy',1);
    thePlayer.inv.AddAnItem('mh107_czart_trophy',1);
    thePlayer.inv.AddAnItem('mh108_fogling_trophy',1);
    thePlayer.inv.AddAnItem('mh201_cave_troll_trophy',1);
    thePlayer.inv.AddAnItem('mh202_nekker_warrior_trophy',1);
    thePlayer.inv.AddAnItem('mh203_drowned_dead_trophy',1);
    thePlayer.inv.AddAnItem('mh204_leshy_trophy',1);
    thePlayer.inv.AddAnItem('mh205_leshy_trophy',1);
    thePlayer.inv.AddAnItem('mh206_fiend_trophy',1);
    thePlayer.inv.AddAnItem('mh207_wraith_trophy',1);
    thePlayer.inv.AddAnItem('mh208_forktail_trophy',1);
    thePlayer.inv.AddAnItem('mh209_fogling_trophy',1);
    thePlayer.inv.AddAnItem('mh210_lamia_trophy',1);
    thePlayer.inv.AddAnItem('mh211_bies_trophy',1);
    thePlayer.inv.AddAnItem('mh212_erynie_trophy',1);
    thePlayer.inv.AddAnItem('mq1024_water_hag_trophy',1);
    thePlayer.inv.AddAnItem('mq1051_wyvern_trophy',1);
    thePlayer.inv.AddAnItem('q202_ice_giant_trophy',1);
    thePlayer.inv.AddAnItem('mh301_gryphon_trophy',1);
    thePlayer.inv.AddAnItem('mh302_leshy_trophy',1);
    thePlayer.inv.AddAnItem('mh303_succubus_trophy',1);
    thePlayer.inv.AddAnItem('mh304_katakan_trophy',1);
    thePlayer.inv.AddAnItem('mh305_doppler_trophy',1);
    thePlayer.inv.AddAnItem('mh306_dao_trophy',1);
    thePlayer.inv.AddAnItem('mh308_noonwraith_trophy',1);
    thePlayer.inv.AddAnItem('sq108_griffin_trophy',1);
    thePlayer.inv.AddAnItem('mq0003_noonwraith_trophy',1);
    
    theGame.RequestMenuWithBackground( 'InventoryMenu', 'CommonMenu' );
  }
  ```

-
  ```js
  		//1) some non-quest items might dynamically have 'Quest' tag added so first we remove all items that 
		//currently have Quest tag
		inv.RemoveItemByTag('Quest', -1);
		horseInventory.RemoveItemByTag('Quest', -1);

		//2) some quest items might lose 'Quest' tag during the course of the game so we need to check their 
		//XML definitions rather than actual items in inventory
		questItems = theGame.GetDefinitionsManager().GetItemsWithTag('Quest');
		for(i=0; i<questItems.Size(); i+=1)
		{
			inv.RemoveItemByName(questItems[i], -1);
			horseInventory.RemoveItemByName(questItems[i], -1);
		}
  ```

- npc stances:
  ```js
  enum ENpcStance
  {
    NS_Normal,
    NS_Strafe,
    NS_Retreat,
    NS_Guarded,
    NS_Wounded,
    NS_Fly,
    NS_Swim,
  }
  ```

- file `bTaskChangeAltitude.ws` has good example for controlling the gryphon flight

- npc: ReactToBeingHit

-
  ```js
    event OnAnimEvent_SlideAway( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
    {
      var ticket 				: SMovementAdjustmentRequestTicket;
      var movementAdjustor	: CMovementAdjustor;
      var slidePos 			: Vector;
      var slideDuration		: float;
      
      movementAdjustor = GetMovingAgentComponent().GetMovementAdjustor();
      movementAdjustor.CancelByName( 'SlideAway' );
      
      ticket = movementAdjustor.CreateNewRequest( 'SlideAway' );
      slidePos = GetWorldPosition() + ( VecNormalize2D( GetWorldPosition() - thePlayer.GetWorldPosition() ) * 0.75 );
      
      if( theGame.GetWorld().NavigationLineTest( GetWorldPosition(), slidePos, GetRadius(), false, true ) ) 
      {
        slideDuration = VecDistance2D( GetWorldPosition(), slidePos ) / 35;
        
        movementAdjustor.Continuous( ticket );
        movementAdjustor.AdjustmentDuration( ticket, slideDuration );
        movementAdjustor.AdjustLocationVertically( ticket, true );
        movementAdjustor.BlendIn( ticket, 0.25 );
        movementAdjustor.SlideTo( ticket, slidePos );
        movementAdjustor.RotateTowards( ticket, GetTarget() );
      }

      return true;	
    }
  ```

```js
	function OnGroundContact()
	{
		var owner 	: CNewNPC = GetNPC();
		var mac 	: CMovingPhysicalAgentComponent;
		owner.SetBehaviorVariable( 'GroundContact', 1.0 );		
		
		mac = ((CMovingPhysicalAgentComponent)owner.GetMovingAgentComponent());
		owner.ChangeStance( NS_Wounded );
		mac.SetAnimatedMovement( false );
		owner.EnablePhysicalMovement( false );
		mac.SnapToNavigableSpace( true );
	}
```

## RER spawning system and events
> The goal is to make a new system controlling when and which creatures will spawn.

I imagine an array of struct 
```rs
array<SpawningControl>
```
where `SpawningControl` is something like this:
```rs

// a custom value used in the SpawningControl we
// can disable by setting `ignore_it` to `true`.
// it allows us the change only specific values.
struct NullableControlValue {
  ignore_it: bool;
  value: int;
}

struct SpawningControl {
  // so we can identify the SpawningControls
  // and eventually remove them by name
  name: string;

  effect_on_lower_controls: Add|Multiply|Overwrite;

  minimum_spawning_delay: NullableControlValue;
  maximum_spawning_delay: NullableControlValue;

  // some creatures cannot appear in some areas
  // drowners not appearing in high mountains for ex.
  is_near_water: NullableControlValue; // from 0 to 100
  is_near_forest: NullableControlValue; // from 0 to 100
  is_near_corpse: NullableControlValue; // from 0 to 100

  // Like the SpawnRoller the current system uses
  // we would fill the values the way we want.
  // the first SpawningControl would be filled with
  // the settings values coming from the mod-menu.
  creatures_chances: ...;

}
```

This way we add a `SpawningControl` to the array and it changes the values from the previous `SpawningControl`s by
adding a number, multiplying the current values or completely overwriting them (great for disabling a creature).