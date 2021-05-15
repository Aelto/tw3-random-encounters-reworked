
state EnhancedEdition in RER_PresetManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_PresetManager - state EnhancedEdition");

    this.EnhancedEdition_applySettings();
  }

  entry function EnhancedEdition_applySettings() {
    var wrapper: CInGameConfigWrapper;
    var value: float;

    wrapper = theGame.GetInGameConfigWrapper();

    // first we apply the default presets
    parent.master.settings.resetRERSettings(wrapper);

    // then we change a few things here and there
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushDay', 'Katakans', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushDay', 'Ekimmaras', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushDay', 'Bruxae', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushDay', 'Fleders', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushDay', 'Garkains', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushNight', 'Katakans', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushNight', 'Ekimmaras', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushNight', 'Bruxae', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushNight', 'Fleders', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersAmbushNight', 'Garkains', 0.5);

    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractDay', 'Katakans', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractDay', 'Ekimmaras', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractDay', 'Bruxae', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractDay', 'Fleders', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractDay', 'Garkains', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractNight', 'Katakans', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractNight', 'Ekimmaras', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractNight', 'Bruxae', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractNight', 'Fleders', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersContractNight', 'Garkains', 0.5);

    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntDay', 'Katakans', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntDay', 'Ekimmaras', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntDay', 'Bruxae', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntDay', 'Fleders', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntDay', 'Garkains', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntNight', 'Katakans', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntNight', 'Ekimmaras', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntNight', 'Bruxae', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntNight', 'Fleders', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntNight', 'Garkains', 0.5);

    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundDay', 'Katakans', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundDay', 'Ekimmaras', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundDay', 'Bruxae', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundDay', 'Fleders', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundDay', 'Garkains', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundNight', 'Katakans', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundNight', 'Ekimmaras', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundNight', 'Bruxae', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundNight', 'Fleders', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersHuntingGroundNight', 'Garkains', 0.5);

    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersGeneral', 'customdFrequencyLow', 1.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersGeneral', 'customdFrequencyHigh', 1.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersGeneral', 'customnFrequencyLow', 1.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERencountersGeneral', 'customnFrequencyHigh', 1.5);

    this.wrapperMultiplyFloatValue(wrapper, 'RERevents', 'eventSystemICD', 1.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERevents', 'eventFightNoise', 0.8);
    this.wrapperMultiplyFloatValue(wrapper, 'RERevents', 'eventMeditationAmbush', 0.8);

    this.wrapperMultiplyFloatValue(wrapper, 'RERmonsterCrowns', 'RERcrownsAmbush', 0.1);
    this.wrapperMultiplyFloatValue(wrapper, 'RERmonsterCrowns', 'RERcrownsHunt', 0.1);
    this.wrapperMultiplyFloatValue(wrapper, 'RERmonsterCrowns', 'RERcrownsContract', 0.5);
    this.wrapperMultiplyFloatValue(wrapper, 'RERmonsterCrowns', 'RERcrownsHuntingGround', 0.1);

    this.wrapperMultiplyFloatValue(wrapper, 'RERmonsterTrophies', 'RERtrophyMasterBuyingPrice', 0.5);

    theGame.SaveUserSettings();

    parent.done = true;
  }

  function wrapperMultiplyFloatValue(wrapper: CInGameConfigWrapper, menu: name, value: name, multiplier: float) {
    var fvalue: float;

    fvalue = StringToFloat(wrapper.GetVarValue(menu, value));
    wrapper.SetVarValue(menu, value, fvalue * multiplier);
  }

}
