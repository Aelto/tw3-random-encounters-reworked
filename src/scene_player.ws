

enum RER_CameraTargetType {
  // when you want the camera to target a node, the node can move
  RER_CameraTargetType_NODE = 0,

  // when you want the camera to target a static position
  RER_CameraTargetType_STATIC = 1,

  // when you want the camera to target a bone component, it can move
  RER_CameraTargetType_BONE = 3
}

enum RER_CameraPositionType {
  // the position will be absolute positions
  RER_CameraPositionType_ABSOLUTE = 0,

  // the position will be relative to the camera's current position.
  RER_CameraPositionType_RELATIVE = 1,

}

struct RER_CameraScene {
  // where the camera is placed
  var position_type: RER_CameraPositionType;
  var position: Vector;

  // where the camera is looking
  var look_at_target_type: RER_CameraTargetType;
  var look_at_target_node: CNode;
  var look_at_target_static: Vector;
  var look_at_target_bone: CAnimatedComponent;

  // where the camera is focused
  var focus_on_target_type: RER_CameraTargetType;
  var focus_on_target_node: CNode;
  var focus_on_target_static: Vector;
  var focus_on_target_bone: CAnimatedComponent;

  var duration: float;

  // if set to a value greater than 0 the player will first rotate and move
  // the camera before playing the scene.
  var blend_time: float;
}

latent function playCameraScenes(scenes: array<RER_CameraScene>) {
  var i: int;
  var current_scene: RER_CameraScene;

  for (i = 0; i < scenes.Size(); i += 1) {
    current_scene = scenes[i];

    playCameraScene(scene);
  }
}

latent function playCameraScene(scene: RER_CameraScene) {
  switch (scene.position_type) {
    case RER_CameraPositionType_ABSOLUTE:
      theCamera.Teleport(scene.position);
      break;

    case RER_CameraPositionType_RELATIVE:
      theCamera.Teleport(theCamera.GetCameraPosition() + scene.position);
      break;
  }

  // TODO: not sure the blend_time that is passed as the activation_time is
  // really blending. If it's simply a delay, then implement the blending myself.
  // look at the function function below

  switch (scene.look_at_target_type) {
    case RER_CameraTargetType_BONE:
      theCamera.LookAtBone(scene.look_at_target_bone, scene.duration, scene.blend_time);
      break;

    case RER_CameraTargetType_STATIC:
      theCamera.LookAtStatic(scene.look_at_target_static, scene.duration, scene.blend_time);
      break;

    case RER_CameraTargetType_NODE:
      theCamera.LookAt(scene.look_at_target_node, scene.duration, scene.blend_time);
      break;
  }

  switch (scene.focus_on_target_type) {
    case RER_CameraTargetType_BONE:
      theCamera.FocusOnBone(scene.focus_on_target_bone, scene.duration, scene.blend_time);
      break;

    case RER_CameraTargetType_STATIC:
      theCamera.FocusOnStatic(scene.focus_on_target_static, scene.duration, scene.blend_time);
      break;

    case RER_CameraTargetType_NODE:
      theCamera.FocusOn(scene.focus_on_target_node, scene.duration, scene.blend_time);
      break;
  }

  if (scene.duration > 0) {
    Sleep(duration);
  }
}

latent function blendCamera() {
  // if needed, look at how it's done in `slideCamera.ws`

  // there is also `W3SlideToTargetComponent`
}