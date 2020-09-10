
# Notes
> Custom notes i write for myself to not forget them 😊

- to enable logging use `-debugscripts` flag

- ideas for Event reaction:
  - maybe higher chance for some creatures to spawn if you're injured. As they are attracted to the blood. by Czartchonn on discord
  - looting chests, bandits attacking you. by Czartchonn on discord
  - fighting makes noise, it can attract creatures
  - bodies attract necrophages
  - adding more creatures to groups of vanilla creatures


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

