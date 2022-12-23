import class CRagdoll extends CResource {
    import var windScaler: Float;
    import var densityScaler: Float;
    import var autoStopDelay: Float;
    import var autoStopTime: Float;
    import var autoStopSpeed: Float;
    import var resetDampingAfterStop: Bool;
    import var forceWakeUpOnAttach: Bool;
    import var customDynamicGroup: CPhysicalCollision;
    import var disableConstrainsTwistAxis: Bool;
    import var disableConstrainsSwing1Axis: Bool;
    import var disableConstrainsSwing2Axis: Bool;
    import var jointBounce: Float;
    import var modifyTwistLower: Float;
    import var modifyTwistUpper: Float;
    import var modifySwingY: Float;
    import var modifySwingZ: Float;
    import var projectionIterations: Int32;
}

import struct SSkeletonBone {
    //import var name: StringAnsi;          -- name is reserved keyword
    import var nameAsCName: CName;
    //import var flags: ESkeletonBoneFlags; -- unable to convert ESkeletonBoneFlags to script type
}

import struct SSkeletonTrack {
    //import var name: StringAnsi;          -- name is reserved keyword
    import var nameAsCName: CName;
}

import class CSkeleton extends CResource {
    import var lodBoneNum_1: Int32;
    import var walkSpeed: Float;
    import var slowRunSpeed: Float;
    import var fastRunSpeed: Float;
    import var sprintSpeed: Float;
    import var walkSpeedRel: Float;
    import var slowRunSpeedRel: Float;
    import var fastRunSpeedRel: Float;
    import var sprintSpeedRel: Float;
    //import var poseCompression: ptr:IPoseCompression;
    //import var bboxGenerator: ptr:CPoseBBoxGenerator;
    //import var controlRigDefinition: ptr:TCrDefinition;
    //import var controlRigDefaultPropertySet: ptr:TCrPropertySet;
    //import var skeletonMappers: array:2,0,ptr:CSkeleton2SkeletonMapper;
    //import var controlRigSettings: ptr:CControlRigSettings;
    //import var teleportDetectorData: ptr:CTeleportDetectorData;
    import var lastNonStreamableBoneName: CName;
    import var bones: array<SSkeletonBone>;
    import var tracks: array<SSkeletonTrack>;
    import var parentIndices: array<Int16>;
}

import class CExtAnimEventsFile extends CResource {
    import var requiredSfxTag: CName;
}

import class CSkeletalAnimationSet extends CExtAnimEventsFile {
    //import var animations: array:2,0,ptr:CSkeletalAnimationSetEntry;
    import var extAnimEvents: array<CExtAnimEventsFile>;
    import var skeleton: CSkeleton;
    //import var compressedPoses: array:2,0,ptr:ICompressedPose;
    //import var "Streaming option": SAnimationBufferStreamingOption;   -- blank in varname
    //import var "Number of non-streamable bones": Uint32;              -- blank in varname
}

import class CBehaviorGraph extends CResource {
    //import var defaultStateMachine: ptr:CBehaviorGraphStateMachineNode;
    //import var stateMachines: array:2,0,ptr:CBehaviorGraphStateMachineNode;
    import var sourceDataRemoved: Bool;
    import var customTrackNames: array<CName>;
    import var generateEditorFragments: Bool;
    //import var poseSlots: array:2,0,ptr:CBehaviorGraphPoseSlotNode;
    //import var animSlots: array:2,0,ptr:CBehaviorGraphAnimationBaseSlotNode;
}

import struct SBehaviorGraphInstanceSlot {
    import var instanceName: CName;
    import var graph: CBehaviorGraph;
    import var alwaysOnTopOfStack: Bool;
}

