
// the trail maker is class used to create trails of blood or tracks on the
// ground. It handles cases where you must draw a trail from point A to point B,
// or simple cases where you only need one track at a specific location.
//
// It has optimizations where it can draw only 25% of the asked tracks to keep
// performances when drawing GPU heavy trails with fogs. This using a ratio
// where we can say only draw 0.25 or 0.50, etc...
class RER_TrailMaker {

  // tells how many are skipped when drawing a trail. If it is set at `1` then
  // it will draw every track, if set at `2` it will draw every 2 tracks.
  private var trail_ratio: int;
  default trail_ratio = 1;

  private var trail_ratio_index: int;
  default trail_ratio_index = 1;

  public function setTrailRatio(ratio: int) {
    this.trail_ratio = ratio;
    this.trail_ratio_index = 1;
  }

  // an array containing entities for the tracks when
  // using the functions to add a track on the ground
  // it adds one to the array, unless we reached the maximum
  // number of tracks. At this moment we come back to 0 and
  // start using the tracks_index and set tracks_looped  
  // to true to tell we have already reached the maximum once.
  // And now instead of creating a new track Entity we simply
  // move the old one at tracks_index.
  private var tracks_entities: array<CEntity>;
  private var tracks_index: int;
  private var tracks_looped: bool;
  default tracks_looped = false;
  
  private var tracks_maximum: int;
  default tracks_maximum = 200;

  public function setTracksMaximum(maximum: int) {
    this.tracks_maximum = maximum;
  }

  private var track_resources: array<CEntityTemplate>;
  private var track_resources_size: int;

  public setTrackResources(resources: array<CEntityTemplate>) {
    this.track_resources.Clear();
    this.track_resources = resources;
    this.track_resources_size = this.track_resources.Size();
  }

  private function getRandomTrackResource(): CEntityTemplate {
    if (track_resources_size == 1) {
      return this.track_resources[0];
    }

    return this.track_resources[RandRange(this.track_resources_size)];
  }

  public function init(ratio: int, maximum: int, resources: array<CEntityTemplate>) {
    this.setTrailRatio(ratio);
    this.setTracksMaximum(maximum);
    this.setTrackResources(resources);
  }

  public function addTrackHere(position: Vector, optional heading: EulerAngles) {
    var new_entity: CEntity;

    if (!this.tracks_looped) {
      new_entity = theGame.CreateEntity(
        this.track_resource,
        position,
        heading
      );

      this.tracks_entities.PushBack(new_entity);

      if (this.tracks_entities.Size() == this.tracks_maximum) {
        this.tracks_looped = true;
      }

      return;
    }

    this.tracks_entities[this.tracks_index]
      .TeleportWithRotation(position, RotRand(0, 360));

    this.tracks_index = (this.tracks_index + 1) % this.tracks_maximum;
  }

  // `use_failsage` stops the trail if it drew more than `this.tracks_maximum`
  // tracks. It can be useful if the trail is too long, to avoid a crash
  public latent function drawTrail(
    from: Vector,
    to: Vector,
    destination_radius: float,

    /* set both trails_details parameters or none at all */
    optional trail_details_maker: TrailDetailsMaker,
    optional trail_details_chances: float,

    optional use_failsafe: bool) {

    var current_track_position: Vector;
    var current_track_heading: float;
    var current_track_translation: Vector;
    var distance_to_final_point: float;
    var final_point_radius: float;
    var number_of_tracks_created: int;
    var i: int;

    number_of_tracks_created = 0;
    final_point_radius = destination_radius * destination_radius;
    current_track_position = from;

    do {
      current_track_translation = VecConeRand(
        VecHeading(to - current_track_position),
        60, // 60 degrees randomness
        1,
        2
      );

      current_track_heading = VecHeading(current_track_translation);

      current_track_position += current_track_translation;

      FixZAxis(current_track_position);

      distance_to_final_point = VecDistanceSquared(current_track_position, to);

      this.addTrackHere(
        current_track_position,
        VecToRotation(to - current_track_position)
      );

      number_of_tracks_created += 1;

      if (use_failsafe && number_of_tracks_created >= this.tracks_maximum) {
        break;
      }

      // small chance to add a corpse near the tracks
      if (trail_details_chances > 0 && RandRange(100) < trail_details_chances) {
        trail_details_maker.placeDetailsHere(current_track_position);
      }

    } while (distance_to_final_point > final_point_radius);
  }

}

// the `TrailDetailsMaker` is a class used by the `TrailMaker` class when
// drawing a trail. It is an abstract class with only one method:
//  ```
//    placeDetailsHere(position: Vector)
//  ```
// when drawing a trail there is a chance we add small details among the tracks
// such as corpses, blood around the tracks, a creature, etc... This is what
//  this class is for.
//
// So how should we use it? We create a new class that extends this one and we
// override the method(s). Then when we use the `TrailMaker::drawTrail` we pass
// this new class we just created and that's it.
abstract class RER_TrailDetailsMaker {
  
  // override it
  public latent function placeDetailsHere(position: Vector) {}

}


class RER_CorpseAndBloodTrailDetailsMaker extends RER_TrailDetailsMaker {
  
  // because it creates corpses and blood spills, we must set these to members
  // before using this DetailsMaker
  public var corpse_maker: RER_TrailMaker;
  public var blood_maker: RER_TrailMaker;

  public latent function placeDetailsHere(position: Vector) {
    var number_of_blood_spills: int;
    var current_clue_position: Vector;
    var i: int;

    current_clue_position = position;

    FixZAxis(current_clue_position);

    this
      .corpse_maker
      .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));

    number_of_blood_spills = RandRange(10, 5);

    for (i = 0; i < number_of_blood_spills; i += 1) {
      current_clue_position = position + VecRingRand(0, 1.5);

      FixZAxis(current_clue_position);

      parent
        .blood_maker
        .addTrackHere(current_clue_position, VecToRotation(VecRingRand(1, 2)));
    }
  }

}