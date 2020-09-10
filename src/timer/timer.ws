
//#region SpawningControl


//#endregion EventsListener


class RER_EventsManager extends CEntity {

  //#region spawn_controls
  private var spawn_controls: array<SpawningControl>;
  private var cached_spawn_control: SpawningControl;

  // add a new spawning control into the list and returns its index
  public function addSpawningControl(spawn_control: SpawningControl): int {
    this.spawn_controls.PushBack(spawn_control);

    return this.spawn_controls.Size() - 1;
  }

  private function updateCachedSpawnControl() {
    var i: int;
    var j: int;
    var current_spawn_control: SpawningControl;

    for (i = 0; i < this.spawn_controls.Size(); i += 1) {
      current_spawn_control = this.spawn_controls[i];

      if (current_spawn_control.effect_on_lower_controls == Overwrite) {
        for (j = 0; j < current_spawn_control.creatures_chances.Size(); j += 1) {
          this.cached_spawn_control.creatures_chances[j] = current_spawn_control.creatures_chances[j];
        }
      }

      else if (current_spawn_control.effect_on_lower_controls == Add) {
        for (j = 0; j < current_spawn_control.creatures_chances.Size(); j += 1) {
          this.cached_spawn_control.creatures_chances[j] += current_spawn_control.creatures_chances[j];
        }
      }

      else if (current_spawn_control.effect_on_lower_controls == Multiply) {
        for (j = 0; j < current_spawn_control.creatures_chances.Size(); j += 1) {
          this.cached_spawn_control.creatures_chances[j] *= current_spawn_control.creatures_chances[j];
        }
      }

      else if (current_spawn_control.effect_on_lower_controls == Sub) {
        for (j = 0; j < current_spawn_control.creatures_chances.Size(); j += 1) {
          this.cached_spawn_control.creatures_chances[j] -= current_spawn_control.creatures_chances[j];
        }
      }
    }
  }

  public function changeSpawnControlActiveState(control_name: string, enabled: bool) {
    var i: int;
    var current_spawn_control: SpawningControl;

    for (i = 0; i < this.spawn_controls.Size(); i += 1) {
      current_spawn_control = this.spawn_controls[i];

      if (current_spawn_control.control_name != control_name) {
        continue;
      }

      current_spawn_control.is_active = enabled;
    }
  }

  public function updateSpawnControlData(control_name: string, effect: SpawningControl_Effect, chances: array<int>) {
    var i: int;
    var current_spawn_control: SpawningControl;

    for (i = 0; i < this.spawn_controls.Size(); i += 1) {
      current_spawn_control = this.spawn_controls[i];

      if (current_spawn_control.control_name != control_name) {
        continue;
      }

      current_spawn_control.effect_on_lower_controls = effect;
      current_spawn_control.creatures_chances = chances;
    }
  }
  //#endregion spawn_controls

  //#region listeners
  private var listeners: array<RER_EventsListener>
  //#endregion listeners

  public function init(settings: RE_Settings) {
    var default_spawn_control: SpawningControl;

    default_spawn_control = new SpawningControl;
    default_spawn_control.is_active = true;
    default_spawn_control.name = "__default__";

    // TODO: make it work for day & night.
    // a new property for the night maybe?
    default_spawn_control.creatures_chances = settings.creatures_chances_day;

    this.addSpawningControl(default_spawn_control);
  }

  public function start() {
    this.GotoState('Waiting');
  }

  timer function intervalFunction(optional delta: float, optional id: Int32) {
    this.GotoState('ListeningForEvents');
  }
}

