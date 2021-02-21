
// class RER_CameraDataInterface {
//   latent function loop(camera: RER_StaticCamera) {}
// }

// class RER_CameraDataMoveToPositionLookAtPosition extends RER_CameraDataInterface {
//   // edit these two variables 
//   public var camera_position_goal: Vector;
//   public var camera_target: Vector;
  
//   // or extend the class and override this method if your target is a moving target
//   function getCameraTarget() {
//     return this.camera_target;
//   }

//   private var camera_position: Vector;
//   private var camera_rotation: EulerAngles;
//   private var camera_rotation_goal: EulerAngles;

//   latent function loop(camera: RER_StaticCamera) {
//     var distance_to_position: Vector;

//     this.camera_position = theCamera.GetCameraPosition();
//     this.camera_rotation = theCamera.GetCameraRotation();

//     distance_to_position = VecDistanceSquared(
//       this.camera_position,
//       this.camera_position_goal
//     );

//     while (distance_to_position > 1) {
//       // we get the mean value between both entities
//       this.camera_target = this.getCameraTarget();

//       this.camera_position += (this.camera_position_goal - this.camera_position) * 0.01;

//       this.camera_rotation_goal = VecToRotation(this.camera_target + Vector(0, 0, 1) - this.camera_position);
//       this.camera_rotation_goal.Pitch *= -1;

//       this.camera_rotation.Roll += AngleNormalize180(this.camera_rotation_goal.Roll - this.camera_rotation.Roll) * 0.01;
//       this.camera_rotation.Yaw += AngleNormalize180(this.camera_rotation_goal.Yaw - this.camera_rotation.Yaw) * 0.01;
//       this.camera_rotation.Pitch += AngleNormalize180(this.camera_rotation_goal.Pitch - this.camera_rotation.Pitch) * 0.01;

//       this.camera.TeleportWithRotation(this.camera_position, this.camera_rotation);

//       distance_to_position = VecDistanceSquared(
//         this.camera_position,
//         this.camera_position_goal
//       );
//     }
//   }
// }

// // Here the camera looks in the direction it's going.
// class RER_CameraDataMoveToPoint extends RER_CameraDataInterface {
//   // edit the variable
//   public var camera_position_goal: Vector;

//   private var camera_position: Vector;
//   private var camera_rotation: EulerAngles;
//   private var camera_rotation_goal: EulerAngles;
//   private var camera_target: Vector;

//   latent function loop(camera: RER_StaticCamera) {
//     var distance_to_position: Vector;

//     this.camera_position = theCamera.GetCameraPosition();
//     this.camera_rotation = theCamera.GetCameraRotation();

//     distance_to_position = VecDistanceSquared(
//       this.camera_position,
//       this.camera_position_goal
//     );

//     while (distance_to_position > 1) {
//       // we get the mean value between both entities
//       this.camera_target = this.getCameraTarget();

//       this.camera_position += (this.camera_position_goal - this.camera_position) * 0.01;

//       this.camera_rotation_goal = VecToRotation(this.camera_target + Vector(0, 0, 1) - this.camera_position);
//       this.camera_rotation_goal.Pitch *= -1;

//       this.camera_rotation.Roll += AngleNormalize180(this.camera_rotation_goal.Roll - this.camera_rotation.Roll) * 0.01;
//       this.camera_rotation.Yaw += AngleNormalize180(this.camera_rotation_goal.Yaw - this.camera_rotation.Yaw) * 0.01;
//       this.camera_rotation.Pitch += AngleNormalize180(this.camera_rotation_goal.Pitch - this.camera_rotation.Pitch) * 0.01;

//       this.camera.TeleportWithRotation(this.camera_position, this.camera_rotation);

//       distance_to_position = VecDistanceSquared(
//         this.camera_position,
//         this.camera_position_goal
//       );
//     }
//   }
// }


// class RER_CameraManager extends CEntity {
//   private var camera: RER_StaticCamera;

//   latent function spawnCameraEntity() {
//     this.camera = RER_getStaticCamera();

//     this.camera_position = theCamera.GetCameraPosition();
//     this.camera_rotation = theCamera.GetCameraRotation();
//     this.camera_position_goal = camera_position;
//     this.camera_rotation_goal = camera_rotation;

//   }

//   latent public function init(scenes: array<RER_CameraDataInterface>) {
//     this.spawnCameraEntity();
//     this.mainLoop();
//   }

//   latent function mainLoop() {
//     this.camera.deactivationDuration = 1.5;
//     this.camera.activationDuration = 1.5;
//     this.camera.Run();

//     while (true) {
//       this.updateCamera();

//       SleepOneFrame();
//     }

//     this.camera.Stop();
//   }

  
//   function updateCamera() {

    
//   }
// }

