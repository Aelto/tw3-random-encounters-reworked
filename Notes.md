

- `addTimer` signature in `entity.ws`
  ```js
  import final function AddTimer( timerName : name, period : float, optional repeats : bool /* false */, optional scatter : bool /* false */, optional group : ETickGroup /* Main */, optional saveable : bool /* false */, optional overrideExisting : bool /* true */ ) : int;
  ```

- to enable logging use `-debugscripts` flag

- `tmp_templates.ws` has useful spawning functions

- in `btTaskSpawnMultipleEntitiesAttack.ws`
  ```js
  if( spawnOnGround )
  {
    theGame.GetWorld().StaticTrace( l_spawnPos + Vector(0,0,5), l_spawnPos - Vector(0,0,5), l_spawnPos, l_normal );
  }
  ```

- spawning blood spills
  ```js
  public final function CreateBloodSpill()
	{
		var bloodTemplate : CEntityTemplate;
	
		bloodTemplate = (CEntityTemplate)LoadResource("blood_0" + RandRange(4));
		theGame.CreateEntity(bloodTemplate, GetWorldPosition() + VecRingRand(0, 0.5) , EulerAngles(0, RandF() * 360, 0));
	}
  ```