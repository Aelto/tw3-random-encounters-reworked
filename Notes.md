
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