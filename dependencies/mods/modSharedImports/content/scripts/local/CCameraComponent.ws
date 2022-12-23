import struct SCustomClippingPlanes {
    import var nearPlaneDistance: Float;
    import var farPlaneDistance: Float;
}

import class CCameraComponent extends CSpriteComponent {
    import var fov: Float;
    import var nearPlane: ENearPlaneDistance;
    import var farPlane: EFarPlaneDistance;
    import var customClippingPlanes: SCustomClippingPlanes;
    import var aspect: Float;
    import var lockAspect: Bool;
    import var defaultCamera: Bool;
}
