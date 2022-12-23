import class CApexResource extends CMeshTypeResource {
    import var apexBinaryAsset: array<Uint8>;
    import var apexMaterialNames: array<String>;
    import var shadowDistance: Float;
}

import class CClothComponent extends CMeshTypeComponent {
    import var resource: CApexResource;
    //import var "dispacher selection" Type="EDispatcherSelection;  -- blank in var name
    import var recomputeNormals: Bool;
    import var correctSimulationNormals: Bool;
    import var slowStart: Bool;
    import var useStiffSolver: Bool;
    import var pressure: Float;
    //import var "lodWeights.maxDistance": Float;                   -- dot in var name
    //import var "lodWeights.distanceWeight": Float;                -- dot in var name
    //import var "lodWeights.bias": Float;                          -- dot in var name
    //import var "lodWeights.benefitsBias": Float;                  -- dot in var name
    import var maxDistanceBlendTime: Float;
    import var uvChannelForTangentUpdate: Uint32;
    //import var "maxDistanceScale.Multipliable": Bool;             -- dot in var name
    //import var "maxDistanceScale.Scale": Float;                   -- dot in var name
    import var collisionResponseCoefficient: Float;
    import var allowAdaptiveTargetFrequency: Bool;
    import var windScaler: Float;
    import var triggeringCollisionGroupNames: array<CName>;
    import var triggerType: ETriggerShape;
    import var triggerDimensions: Vector;
    //import var "triggerLocalOffset.V[ 3 ]" Type="Vector;          -- dot in var name
    import var shadowDistanceOverride: Float;

    import final function SetSimulated( value : bool );
    import final function SetMaxDistanceScale( scale : float );
    import final function SetFrozen( frozen : bool );
}
