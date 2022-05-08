
/**
 * the mod power is a value in the [0;1] range that indicates how fast
 * the mod should run. This means that at 0.1, the mod will use only 10%
 * of its power (spawning monsters, events, contracts etc...) and will
 * progressively get more aggressive until it reaches 1.
 *
 * The default behaviour for this mod power is to start at 0 the first hour
 * of gameplay and to gain 0.1 (10%) every hour of gameplay until it reaches
 * the cap value of 1.
 */
function RER_getModPower(): float {
  return ClampF(
    GameTimeHours(theGame.CalculateTimePlayed()) / 10,

    0, // minimum of 0,
    1, // maximum of 1
  );
}

/**
 * return if there is enough mod power for the encounter system to be
 * enabled.
 */
functon RER_modPowerIsEncounterSystemEnabled(): bool {
  return RER_getModPower() >= 0.1;
}

function RER_modPowerIsStaticEncounterSystemEnabled(): bool {
  // same as the regular encounters
  return RER_modPowerIsEncounterSystemEnabled();
}

function RER_modPowerIsContractSystemEnabled(): bool {
  return RER_getModPower() >= 0.2;
}

function RER_modPowerIsBountySystemEnabled(): bool {
  return RER_getModPower() >= 0.3;
}

function RER_modPowerIsEventSystemEnabled(): bool {
  return RER_getModPower() >= 0.4;
}