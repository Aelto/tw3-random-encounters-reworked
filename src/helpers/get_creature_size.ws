
function getCreatureHeight(entity: CActor): float {
  return ((CMovingPhysicalAgentComponent)entity.GetMovingAgentComponent())
    .GetCapsuleHeight();
}