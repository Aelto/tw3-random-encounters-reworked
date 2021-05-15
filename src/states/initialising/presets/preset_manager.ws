
statemachine class RER_PresetManager {
  public var done: bool;
  public var master: CRandomEncounters;

  public function getPresetList(): array<RER_Preset> {
    var output: array<RER_Preset>;

    output.PushBack(RER_Preset(
      "rer_dialog_preset_vanilla",
      'Vanilla'
    ));

    output.PushBack(RER_Preset(
      "rer_dialog_preset_enhanced_edition",
      'EnhancedEdition'
    ));

    output.PushBack(RER_Preset(
      "rer_dialog_preset_exit_do_nothing",
      'Exit'
    ));

    return output;
  }

  public function getChoiceList(): array<SSceneChoice> {
    var presets: array<RER_Preset>;
    var choices: array<SSceneChoice>;
    var i: int;

    presets = this.getPresetList();

    for (i = 0; i < presets.Size(); i += 1) {
      choices.PushBack(SSceneChoice(
        GetLocStringByKey(presets[i].dialog_string_key),
        false,
        false,
        false,
        DialogAction_GAME_DAGGER,
        presets[i].state_name
      ));
    }

    return choices;
  }
}

struct RER_Preset {
  var dialog_string_key: string;
  var state_name: name;
}