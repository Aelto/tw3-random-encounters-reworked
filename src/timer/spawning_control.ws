
enum SpawningControl_Effect {
  Add = 0,
  Multiply = 1,
  Overwrite = 2,
  Sub = 3
}

struct SpawningControl {
  // so we can identify the SpawningControls
  // and eventually remove them by name
  var id: string;
  var is_active: bool;
  var effect_on_lower_controls: SpawningControl_Effect;

  // Like the SpawnRoller the current system uses.
  // we would fill the values the way we want.
  // the first SpawningControl would be filled with
  // the settings values coming from the mod-menu.
  var creatures_chances: array<int>;
}