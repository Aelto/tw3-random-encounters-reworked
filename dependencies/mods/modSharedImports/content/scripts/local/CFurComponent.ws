import struct SFurVisualizers {
    import var drawRenderHairs: Bool;
    import var visualizeBones: Bool;
    import var visualizeCapsules: Bool;
    import var visualizeGuideHairs: Bool;
    import var visualizeControlVertices: Bool;
    import var visualizeBoundingBox: Bool;
    import var colorizeMode: EHairColorizeMode;
    import var visualizeCullSphere: Bool;
    import var visualizeDiffuseBone: Bool;
    import var visualizeFrames: Bool;
    import var visualizeGrowthMesh: Bool;
    import var visualizeHairInteractions: Bool;
    import var visualizeHairSkips: Uint32;
    import var visualizeLocalPos: Bool;
    import var visualizePinConstraints: Bool;
    import var visualizeShadingNormals: Bool;
    import var visualizeSkinnedGuideHairs: Bool;
    import var visualizeStiffnessBone: Bool;
}

import struct SFurSimulation {
    import var simulate: Bool;
    import var massScale: Float;
    import var damping: Float;
    import var friction: Float;
    import var backStopRadius: Float;
    import var inertiaScale: Float;
    import var inertiaLimit: Float;
    import var useCollision: Bool;
    import var windScaler: Float;
    import var windNoise: Float;
    import var gravityDir: Vector;
}

import struct SFurVolume {
    import var density: Float;
    import var densityTex: CBitmapTexture;
    import var densityTexChannel: EHairTextureChannel;
    import var usePixelDensity: Bool;
    import var lengthNoise: Float;
    import var lengthScale: Float;
    import var lengthTex: CBitmapTexture;
    import var lengthTexChannel: EHairTextureChannel;
}

import struct SFurStrandWidth {
    import var width: Float;
    import var widthRootScale: Float;
    import var widthTipScale: Float;
    import var rootWidthTex: CBitmapTexture;
    import var rootWidthTexChannel: EHairTextureChannel;
    import var tipWidthTex: CBitmapTexture;
    import var tipWidthTexChannel: EHairTextureChannel;
    import var widthNoise: Float;
}

import struct SFurStiffness {
    import var stiffness: Float;
    import var stiffnessStrength: Float;
    import var stiffnessTex: CBitmapTexture;
    import var stiffnessTexChannel: EHairTextureChannel;
    import var interactionStiffness: Float;
    import var pinStiffness: Float;
    import var rootStiffness: Float;
    import var rootStiffnessTex: CBitmapTexture;
    import var rootStiffnessTexChannel: EHairTextureChannel;
    import var stiffnessDamping: Float;
    import var tipStiffness: Float;
    import var bendStiffness: Float;
    import var stiffnessBoneEnable: Bool;
    import var stiffnessBoneIndex: Uint32;
    import var stiffnessBoneAxis: Uint32;
    import var stiffnessStartDistance: Float;
    import var stiffnessEndDistance: Float;
    import var stiffnessBoneCurve: Vector;
    import var stiffnessCurve: Vector;
    import var stiffnessStrengthCurve: Vector;
    import var stiffnessDampingCurve: Vector;
    import var bendStiffnessCurve: Vector;
    import var interactionStiffnessCurve: Vector;
}

import struct SFurClumping {
    import var clumpScale: Float;
    import var clumpScaleTex: CBitmapTexture;
    import var clumpScaleTexChannel: EHairTextureChannel;
    import var clumpRoundness: Float;
    import var clumpRoundnessTex: CBitmapTexture;
    import var clumpRoundnessTexChannel: EHairTextureChannel;
    import var clumpNoise: Float;
    import var clumpNoiseTex: CBitmapTexture;
    import var clumpNoiseTexChannel: EHairTextureChannel;
    import var clumpNumSubclumps: Uint32;
}

import struct SFurWaveness {
    import var waveScale: Float;
    import var waveScaleTex: CBitmapTexture;
    import var waveScaleTexChannel: EHairTextureChannel;
    import var waveScaleNoise: Float;
    import var waveFreq: Float;
    import var waveFreqTex: CBitmapTexture;
    import var waveFreqTexChannel: EHairTextureChannel;
    import var waveFreqNoise: Float;
    import var waveRootStraighten: Float;
    import var waveStrand: Float;
    import var waveClump: Float;
}

import struct SFurPhysicalMaterials {
    import var simulation: SFurSimulation;
    import var volume: SFurVolume;
    import var strandWidth: SFurStrandWidth;
    import var stiffness: SFurStiffness;
    import var clumping: SFurClumping;
    import var waveness: SFurWaveness;
}

import struct SFurCulling {
    import var useViewfrustrumCulling: Bool;
    import var useBackfaceCulling: Bool;
    import var backfaceCullingThreshold: Float;
}

import struct SFurDistanceLOD {
    import var enableDistanceLOD: Bool;
    import var distanceLODStart: Float;
    import var distanceLODEnd: Float;
    import var distanceLODFadeStart: Float;
    import var distanceLODWidth: Float;
    import var distanceLODDensity: Float;
}

import struct SFurDetailLOD {
    import var enableDetailLOD: Bool;
    import var detailLODStart: Float;
    import var detailLODEnd: Float;
    import var detailLODWidth: Float;
    import var detailLODDensity: Float;
}

import struct SFurLevelOfDetail {
    import var enableLOD: Bool;
    import var culling: SFurCulling;
    import var distanceLOD: SFurDistanceLOD;
    import var detailLOD: SFurDetailLOD;
    import var priority: Uint32;
}

import struct SFurColor {
    import var rootAlphaFalloff: Float;
    import var rootColor: Color;
    import var rootColorTex: CBitmapTexture;
    import var tipColor: Color;
    import var tipColorTex: CBitmapTexture;
    import var rootTipColorWeight: Float;
    import var rootTipColorFalloff: Float;
    import var strandTex: CBitmapTexture;
    import var strandBlendMode: EHairStrandBlendModeType;
    import var strandBlendScale: Float;
    import var textureBrightness: Float;
    import var ambientEnvScale: Float;
}

import struct SFurDiffuse {
    import var diffuseBlend: Float;
    import var diffuseScale: Float;
    import var diffuseHairNormalWeight: Float;
    import var diffuseBoneIndex: Uint32;
    import var diffuseBoneLocalPos: Vector;
    import var diffuseNoiseScale: Float;
    import var diffuseNoiseFreqU: Float;
    import var diffuseNoiseFreqV: Float;
    import var diffuseNoiseGain: Float;
}

import struct SFurSpecular {
    import var specularColor: Color;
    import var specularTex: CBitmapTexture;
    import var specularPrimary: Float;
    import var specularPowerPrimary: Float;
    import var specularPrimaryBreakup: Float;
    import var specularSecondary: Float;
    import var specularPowerSecondary: Float;
    import var specularSecondaryOffset: Float;
    import var specularNoiseScale: Float;
    import var specularEnvScale: Float;
}

import struct SFurGlint {
    import var glintStrength: Float;
    import var glintCount: Float;
    import var glintExponent: Float;
}

import struct SFurShadow {
    import var shadowSigma: Float;
    import var shadowDensityScale: Float;
    import var castShadows: Bool;
    import var receiveShadows: Bool;
}

import struct SFurGraphicalMaterials {
    import var color: SFurColor;
    import var diffuse: SFurDiffuse;
    import var specular: SFurSpecular;
    import var glint: SFurGlint;
    import var shadow: SFurShadow;
}

import struct SFurMaterialSet {
    import var useWetness: Bool;
    import var physicalMaterials: SFurPhysicalMaterials;
    import var graphicalMaterials: SFurGraphicalMaterials;
}

import class CFurMeshResource extends CMeshTypeResource {
    import var positions: array<Vector>;
    import var uvs: array<Vector2>;
    import var endIndices: array<Uint32>;
    import var faceIndices: array<Uint32>;
    import var boneIndices: array<Vector>;
    import var boneWeights: array<Vector>;
    import var boneCount: Uint32;
    import var boneNames: array<CName>;
    import var boneRigMatrices: array<Matrix>;
    import var boneParents: array<Int32>;
    import var bindPoses: array<Matrix>;
    import var boneSphereLocalPosArray: array<Vector>;
    import var boneSphereIndexArray: array<Uint32>;
    import var boneSphereRadiusArray: array<Float>;
    import var boneCapsuleIndices: array<Uint32>;
    import var boneVertexEpsilons: array<Float>;
    import var pinConstraintsLocalPosArray: array<Vector>;
    import var pinConstraintsIndexArray: array<Uint32>;
    import var pinConstraintsRadiusArray: array<Float>;
    import var splineMultiplier: Uint32;
    import var visualizers: SFurVisualizers;
    import var physicalMaterials: SFurPhysicalMaterials;
    import var graphicalMaterials: SFurGraphicalMaterials;
    import var levelOfDetail: SFurLevelOfDetail;
    import var materialWeight: Float;
    import var materialSets: SFurMaterialSet;
    import var importUnitsScale: Float;
}

import struct SMeshSoundInfo {
    import var soundTypeIdentification: CName;
    import var soundSizeIdentification: CName;
    import var soundBoneMappingInfo: CName;
}

import class CFurComponent extends CMeshComponent {
    import var tags: TagList;
    import var transform: EngineTransform;
    //import var transformParent: ptr:CHardAttachment;
    import var guid: CGUID;
    //import var name: String;                      name is reserved keyword
    import var forceLODLevel: Int32;
    import var forceAutoHideDistance: Uint16;
    import var shadowImportanceBias: EMeshShadowImportanceBias;
    import var defaultEffectParams: Vector;
    import var defaultEffectColor: Color;
    import var mesh: CMesh;
    import var furMesh: CFurMeshResource;
}
