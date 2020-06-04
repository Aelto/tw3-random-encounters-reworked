

- `addTimer` signature in `entity.ws`
  ```js
  import final function AddTimer( timerName : name, period : float, optional repeats : bool /* false */, optional scatter : bool /* false */, optional group : ETickGroup /* Main */, optional saveable : bool /* false */, optional overrideExisting : bool /* true */ ) : int;
  ```


- to enable logging use `-debugscripts` flag