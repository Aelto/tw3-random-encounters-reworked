
function shouldAbortCreatureSpawn(settings: RE_Settings, rExtra: CModRExtra, bestiary: RER_Bestiary): bool {
  var current_state: CName;
  var is_meditating: bool;
  var current_zone: EREZone;


  current_state = thePlayer.GetCurrentStateName();
  is_meditating = current_state == 'Meditation' && current_state == 'MeditationWaiting';
  current_zone = rExtra.getCustomZone(thePlayer.GetWorldPosition());

  return is_meditating 
      || current_zone == REZ_NOSPAWN
      
      || current_zone == REZ_CITY
      && !settings.allow_big_city_spawns

      || isPlayerBusy()

      || rExtra.isPlayerInSettlement()
      && !bestiary.doesAllowCitySpawns();
}
