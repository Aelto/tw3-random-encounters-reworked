
function RERFACT_addNoticeboardEventAt(position: Vector, creature_type: CreatureType) {
  FactsSet('rer_noticeboard_event_at_x', (int)position.X);
  FactsSet('rer_noticeboard_event_at_y', (int)position.Y);
  FactsSet('rer_noticeboard_event_at_z', (int)position.Z);
  FactsSet('rer_noticeboard_event_type', creature_type);
}

function RERFACT_hasNoticeboardEvent(): bool {
  return FactsDoesExist('rer_noticeboard_event_at_x')
      && FactsDoesExist('rer_noticeboard_event_at_y')
      && FactsDoesExist('rer_noticeboard_event_at_z')
      && FactsDoesExist('rer_noticeboard_event_type');
}

function RERFACT_getLatestNoticeboardEvent(out position: Vector, out creature_type: CreatureType): bool {
  if (!RERFACT_hasNoticeboardEvent()) {
    return false;
  }

  position.X = FactsQueryLatestValue('rer_noticeboard_event_at_x');
  position.Y = FactsQueryLatestValue('rer_noticeboard_event_at_y');
  position.Z = FactsQueryLatestValue('rer_noticeboard_event_at_x');
  creature_type = FactsQueryLatestValue('rer_noticeboard_event_type');

  return true;
}

function RERFACT_removeLatestNoticeboardEvent() {
  FactsRemove('rer_noticeboard_event_at_x');
  FactsRemove('rer_noticeboard_event_at_y');
  FactsRemove('rer_noticeboard_event_at_x');
  FactsRemove('rer_noticeboard_event_type');
}