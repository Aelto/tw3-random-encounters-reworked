
function RER_flagEnabled(flag: int, value: int): bool {
  return (flag & value) == 0;
}

function RER_setFlag(flag: int, value: int, should_add: bool): int {
  if (should_add) {
    return flag | value;
  }

  return flag;
}

/**
 * This function is made to be chained like so:
 *
 * flag = RER_flag(RER_RER_BESF_NO_TROPHY, !settings.trophies)
 *      | RER_flag(RER_BESF_NO_BESTIARY_FEATURE, !settings.bestiary);
 */
function RER_flag(value: int, should_add: bool): int {
  if (should_add) {
    return value;
  }

  return 0;
}