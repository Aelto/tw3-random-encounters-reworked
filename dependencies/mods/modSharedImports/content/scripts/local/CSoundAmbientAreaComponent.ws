import class CSoftTriggerAreaComponent extends CTriggerAreaComponent {
    import var outerClippingAreaTags: TagList;
    //import var outerIncludedChannels: ETriggerChannel;    -- unable to convert ETriggerChannel to script type
    //import var outerExcludedChannels: ETriggerChannel;    -- unable to convert ETriggerChannel to script type
    import var invertPenetrationFraction: Bool;
}

import struct SReverbDefinition {
    import var reverbName: StringAnsi;
    import var enabled: Bool;
}

import struct SSoundGameParameterValue {
    import var gameParameterName: StringAnsi;
    import var gameParameterValue: Float;
}

import struct SSoundParameterCullSettings {
    import var gameParameterName: StringAnsi;
    import var gameParameterCullValue: Float;
    import var invertCullCheck: Bool;
}

import struct SSoundAmbientDynamicSoundEvents {
    import var eventName: StringAnsi;
    import var repeatTime: Float;
    import var repeatTimeVariance: Float;
    import var triggerOnActivation: Bool;
}

import class CSoundAmbientAreaComponent extends CSoftTriggerAreaComponent {
    import var soundEvents: StringAnsi;
    import var reverb: SReverbDefinition;
    import var customEventOnEnter: StringAnsi;
    import var soundEventsOnEnter: array<StringAnsi>;
    import var soundEventsOnExit: array<StringAnsi>;
    import var enterExitEventsUsePosition: Bool;
    import var intensityParameter: Float;
    import var intensityParameterFadeTime: Float;
    import var maxDistance: Float;
    import var maxDistanceVertical: Float;
    import var banksDependency: array<CName>;
    import var occlusionEnabled: Bool;
    import var outerListnerReverbRatio: Float;
    import var priorityParameterMusic: Bool;
    import var parameterEnteringTime: Float;
    import var parameterEnteringCurve: ESoundParameterCurveType;
    import var parameterExitingTime: Float;
    import var parameterExitingCurve: ESoundParameterCurveType;
    import var useListernerDistance: Bool;
    import var isGate: Bool;
    import var gatewayRotation: Float;
    import var isWalla: Bool;
    import var wallaSoundEvents: array<StringAnsi>;
    import var wallaEmitterSpread: Float;
    import var wallaOmniFactor: Float;
    import var wallaMinDistance: Float;
    import var wallaMaxDistance: Float;
    import var wallaBoxExtention: Float;
    import var wallaRotation: Float;
    import var wallaAfraidRetriggerTime: Float;
    import var wallaAfraidDecreaseRate: Float;
    import var parameters: array<SSoundGameParameterValue>;
    import var parameterCulling: array<SSoundParameterCullSettings>;
    import var fitWaterShore: Bool;
    import var waterGridCellCount: Uint32;
    import var waterLevelOffset: Float;
    import var fitFoliage: Bool;
    import var foliageMaxDistance: Float;
    import var foliageStepNeighbors: Uint32;
    import var foliageVitalAreaRadius: Float;
    import var foliageVitalAreaPoints: Uint32;
    import var dynamicParameters: array<ESoundAmbientDynamicParameter>;
    import var dynamicEvents: array<SSoundAmbientDynamicSoundEvents>;
}
