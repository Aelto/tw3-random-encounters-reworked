
# Notes
> Custom notes i write for myself to not forget them 😊

- to enable logging use `-debugscripts` flag

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

- npc stances:
  ```
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