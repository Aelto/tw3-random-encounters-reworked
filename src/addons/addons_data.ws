
class RER_AddonsData {

  /**
   * Array of an abstract class so add-ons can push their statemachine if they
   * need them to avoid the garbage collection.
   */
  var addons: array<RER_BaseAddon>;

  /**
   * Exception areas for the SharedUtils safe areas functions.
   *
   * Especially useful if a 3rd party mod adds new regions in vanilla maps where
   * RER usually avoids to spawn creatures, but you want to allow spawns there.
   */
  var exception_areas: array<Vector>;
}