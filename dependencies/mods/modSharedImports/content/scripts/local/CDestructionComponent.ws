import struct SMultiCurve {
    import var type: ECurveType;
    import var color: Color;
    import var showFlags: EShowFlags;
    import var positionInterpolationMode: ECurveInterpolationMode;
    import var positionManualMode: ECurveManualMode;
    import var rotationInterpolationMode: ECurveInterpolationMode;
    import var totalTime: Float;
    import var automaticPositionInterpolationSmoothness: Float;
    import var automaticRotationInterpolationSmoothness: Float;
    import var enableConsistentNumberOfControlPoints: Bool;
    import var enableAutomaticTimeByDistanceRecalculation: Bool;
    import var enableAutomaticTimeRecalculation: Bool;
    import var enableAutomaticRotationFromDirectionRecalculation: Bool;
    import var curves: array<SCurveData>;
    import var leftTangents: array<Vector>;
    import var rightTangents: array<Vector>;
    import var easeParams: array<SCurveEaseParam>;
    import var translationRelativeMode: ECurveRelativeMode;
    import var rotationRelativeMode: ECurveRelativeMode;
    import var scaleRelativeMode: ECurveRelativeMode;
    import var initialParentTransform: EngineTransform;
    import var hasInitialParentTransform: Bool;
}

import struct SDropPhysicsCurves {
    import var trajectory: SMultiCurve;
    import var rotation: SMultiCurve;
}

import class CDropPhysicsSetup extends CObject {
    //import var name: CName;                       -- name is reserved keyword
    //import var particles: soft:CParticleSystem;
    import var curves: array<SDropPhysicsCurves>;
}

import struct SBoneIndiceMapping {
    import var startingIndex: Uint32;
    import var endingIndex: Uint32;
    import var chunkIndex: Uint32;
    import var boneIndex: Uint32;
}

import class CPhysicsDestructionResource extends CMesh {
    import var boneIndicesMapping: array<SBoneIndiceMapping>;
    import var finalIndices: array<Uint16>;
    import var chunkNumber: Uint32;
}

import class CDestructionSystemComponent extends CDrawableComponent {
    import var m_resource: CApexResource;
    import var targetEntityCollisionScriptName: CName;
    import var parentEntityCollisionScriptEventName: CName;
    //import var "parameters.m_materials": array<CMaterialGraph>;   -- dot in var name
    import var m_physicalCollisionType: CPhysicalCollision;
    import var m_fracturedPhysicalCollisionType: CPhysicalCollision;
    //import var "dispacher selection" Type="EDispatcherSelection   -- blank in var name
    import var dynamic: Bool;
    import var supportDepth: Uint32;
    import var useAssetDefinedSupport: Bool;
    import var debrisDepth: Int32;
    import var essentialDepth: Uint32;
    import var debrisTimeout: Bool;
    import var debrisLifetimeMin: Float;
    import var debrisLifetimeMax: Float;
    import var debrisMaxSeparation: Bool;
    import var debrisMaxSeparationMin: Float;
    import var debrisMaxSeparationMax: Float;
    import var fadeOutTime: Float;
    import var minimumFractureDepth: Uint32;
    import var preset: EDestructionPreset;
    import var debrisDestructionProbability: Float;
    import var crumbleSmallestChunks: Bool;
    import var accumulateDamage: Bool;
    import var damageCap: Float;
    import var damageThreshold: Float;
    import var damageToRadius: Float;
    import var forceToDamage: Float;
    import var fractureImpulseScale: Float;
    import var impactDamageDefaultDepth: Int32;
    import var impactVelocityThreshold: Float;
    import var materialStrength: Float;
    import var maxChunkSpeed: Float;
    import var useWorldSupport: Bool;
    import var useHardSleeping: Bool;
    import var useStressSolver: Bool;
    import var stressSolverTimeDelay: Float;
    import var stressSolverMassThreshold: Float;
    import var sleepVelocityFrameDecayConstant: Float;
    //import var eventOnDestruction: array:2,0,ptr:IPerformableAction
    import var pathLibCollisionType: EPathLibCollision;
    import var disableObstacleOnDestruction: Bool;
    import var shadowDistanceOverride: Float;

    import final function ApplyForce();
    import final function ApplyDamageAtPoint();
    import final function ApplyRadiusDamage();

    import final function GetFractureRatio() : float;
    import final function ApplyFracture() : bool;
    import final function IsDestroyed() : bool;
    import final function IsObstacleDisabled() : bool;


    public function GetObjectBoundingVolume( out box : Box ) : bool
    {

        box = GetBoundingBox();
        if ( box.Min != box.Max )
        {
            return true;
        }

        return GetPhysicalObjectBoundingVolume( box );
    }
}

import class CDestructionComponent extends CMeshTypeComponent {
    import var m_baseResource: CPhysicsDestructionResource;
    import var m_fracturedResource: CPhysicsDestructionResource;
    //import var "parameters.m_pose": Matrix;                   -- dot in var name
    import var m_physicalCollisionType: CPhysicalCollision;
    import var m_fracturedPhysicalCollisionType: CPhysicalCollision;
    import var dynamic: Bool;
    import var kinematic: Bool;
    import var debrisTimeout: Bool;
    import var debrisTimeoutMin: Float;
    import var debrisTimeoutMax: Float;
    import var initialBaseVelocity: Vector;
    import var hasInitialFractureVelocity: Bool;
    import var maxVelocity: Float;
    import var maxAngularFractureVelocity: Float;
    import var debrisMaxSeparationDistance: Float;
    import var simulationDistance: Float;
    import var fadeOutTime: Float;
    import var forceToDamage: Float;
    import var damageThreshold: Float;
    import var damageEndurance: Float;
    import var accumulateDamage: Bool;
    import var useWorldSupport: Bool;
    import var fractureSoundEvent: StringAnsi;
    import var fxName: CName;
    //import var eventOnDestruction: array:2,0,ptr:IPerformableAction;
    import var pathLibCollisionType: EPathLibCollision;
    import var disableObstacleOnDestruction: Bool;

    import final function ApplyFracture() : bool;
    import final function IsDestroyed() : bool;
    import final function IsObstacleDisabled() : bool;

    public function GetObjectBoundingVolume( out box : Box ) : bool
    {

        box = GetBoundingBox();
        if ( box.Min != box.Max )
        {
            return true;
        }

        return GetPhysicalObjectBoundingVolume( box );
    }
}
