import class CEnvironmentDefinition extends CResource {
    import var envParams: CAreaEnvironmentParams;
}

import struct SSimplexTreeStruct {
    //import var parent: Int32; // parent is reserved keyword
    import var positiveStruct: Int32;
    import var negativeStruct: Int32;
    import var positiveID: Int32;
    import var negativeID: Int32;
    import var normalX: Float;
    import var normalY: Float;
    import var offset: Float;
}
import class CResourceSimplexTree extends CResource {
    import var nodes: array<SSimplexTreeStruct>;
}
import class CUmbraScene extends CResource {
    import var distanceMultiplier: Float;
    import var localUmbraOccThresholdMul: CResourceSimplexTree;
}

import struct CWorldShadowConfig {
    import var numCascades: Int32;
    import var cascadeRange1: Float;
    import var cascadeRange2: Float;
    import var cascadeRange3: Float;
    import var cascadeRange4: Float;
    import var cascadeFilterSize1: Float;
    import var cascadeFilterSize2: Float;
    import var cascadeFilterSize3: Float;
    import var cascadeFilterSize4: Float;
    import var shadowEdgeFade1: Float;
    import var shadowEdgeFade2: Float;
    import var shadowEdgeFade3: Float;
    import var shadowEdgeFade4: Float;
    import var shadowBiasOffsetSlopeMul: Float;
    import var shadowBiasOffsetConst: Float;
    import var shadowBiasOffsetConstCascade1: Float;
    import var shadowBiasOffsetConstCascade2: Float;
    import var shadowBiasOffsetConstCascade3: Float;
    import var shadowBiasOffsetConstCascade4: Float;
    import var shadowBiasCascadeMultiplier: Float;
    import var speedTreeShadowFilterSize1: Float;
    import var speedTreeShadowFilterSize2: Float;
    import var speedTreeShadowFilterSize3: Float;
    import var speedTreeShadowFilterSize4: Float;
    import var speedTreeShadowGradient: Float;
    import var hiResShadowBiasOffsetSlopeMul: Float;
    import var hiResShadowBiasOffsetConst: Float;
    import var hiResShadowTexelRadius: Float;
    import var useTerrainShadows: Bool;
    import var terrainShadowsDistance: Float;
    import var terrainShadowsFadeRange: Float;
    import var terrainShadowsBaseSmoothing: Float;
    import var terrainShadowsTerrainDistanceSoftness: Float;
    import var terrainShadowsMeshDistanceSoftness: Float;
    import var terrainMeshShadowDistance: Float;
    import var terrainMeshShadowFadeRange: Float;
}

import class CSourceTexture extends CResource {
    import var width: Uint32;
    import var height: Uint32;
    import var pitch: Uint32;
    import var format: ETextureRawFormat;
}

import class CBitmapTexture extends ITexture {
    import var width: Uint32;
    import var height: Uint32;
    import var format: ETextureRawFormat;
    import var compression: ETextureCompression;
    import var sourceData: CSourceTexture;
    import var textureGroup: CName;
    import var pcDownscaleBias: Int32;
    import var xboneDownscaleBias: Int32;
    import var ps4DownscaleBias: Int32;
    import var residentMipIndex: Uint8;
    import var textureCacheKey: Uint32;
}

import class CCubeTexture extends CResource {}

import struct SSimpleCurvePoint {
    import var value: Vector;
    import var time: Float;
}

import struct SCurveDataEntry {
    import var me: Float;
    import var ntrolPoint: Vector;
    import var lue: Float;
    import var rveTypeL: Uint16;
    import var rveTypeR: Uint16;
}

import struct SSimpleCurve {
    import var CurveType: ESimpleCurveType;
    import var ScalarEditScale: Float;
    import var ScalarEditOrigin: Float;
    import var dataCurveValues: array<SCurveDataEntry>;
    import var dataBaseType: ECurveBaseType;
}

import struct CGlobalLightingTrajectory {
    import var yawDegrees: Float;
    import var yawDegreesSunOffset: Float;
    import var yawDegreesMoonOffset: Float;
    import var sunCurveShiftFactor: Float;
    import var moonCurveShiftFactor: Float;
    import var sunSqueeze: Float;
    import var moonSqueeze: Float;
    import var sunHeight: SSimpleCurve;
    import var moonHeight: SSimpleCurve;
    import var lightHeight: SSimpleCurve;
    import var lightDirChoice: SSimpleCurve;
    import var skyDayAmount: SSimpleCurve;
    import var moonShaftsBeginHour: Float;
    import var moonShaftsEndHour: Float;
}

import struct CEnvParametricBalanceParameters {
    import var saturation: SSimpleCurve;
    import var color: SSimpleCurve;
}

import struct CEnvFinalColorBalanceParameters {
    import var activated: Bool;
    import var activatedBalanceMap: Bool;
    import var activatedParametricBalance: Bool;
    import var vignetteWeights: SSimpleCurve;
    import var vignetteColor: SSimpleCurve;
    import var vignetteOpacity: SSimpleCurve;
    import var chromaticAberrationSize: SSimpleCurve;
    import var balanceMapLerp: SSimpleCurve;
    import var balanceMapAmount: SSimpleCurve;
    //import var balanceMap0: soft:CBitmapTexture;
    //import var balanceMap1: soft:CBitmapTexture;
    import var balancePostBrightness: SSimpleCurve;
    import var levelsShadows: SSimpleCurve;
    import var levelsMidtones: SSimpleCurve;
    import var levelsHighlights: SSimpleCurve;
    import var midtoneRangeMin: SSimpleCurve;
    import var midtoneRangeMax: SSimpleCurve;
    import var midtoneMarginMin: SSimpleCurve;
    import var midtoneMarginMax: SSimpleCurve;
    import var parametricBalanceLow: CEnvParametricBalanceParameters;
    import var parametricBalanceMid: CEnvParametricBalanceParameters;
    import var parametricBalanceHigh: CEnvParametricBalanceParameters;
}
import struct CEnvSharpenParameters {
    import var activated: Bool;
    import var sharpenNear: SSimpleCurve;
    import var sharpenFar: SSimpleCurve;
    import var distanceNear: SSimpleCurve;
    import var distanceFar: SSimpleCurve;
    import var lumFilterOffset: SSimpleCurve;
    import var lumFilterRange: SSimpleCurve;
}
import struct CEnvPaintEffectParameters {
    import var activated: Bool;
    import var amount: SSimpleCurve;
}

import struct CEnvNVSSAOParameters {
    import var activated: Bool;
    import var radius: SSimpleCurve;
    import var bias: SSimpleCurve;
    import var detailStrength: SSimpleCurve;
    import var coarseStrength: SSimpleCurve;
    import var powerExponent: SSimpleCurve;
    import var blurSharpness: SSimpleCurve;
    import var valueClamp: SSimpleCurve;
    import var ssaoColor: SSimpleCurve;
    import var nonAmbientInfluence: SSimpleCurve;
    import var translucencyInfluence: SSimpleCurve;
}
import struct CEnvMSSSAOParameters {
    import var activated: Bool;
    import var noiseFilterTolerance: SSimpleCurve;
    import var blurTolerance: SSimpleCurve;
    import var upsampleTolerance: SSimpleCurve;
    import var rejectionFalloff: SSimpleCurve;
    import var combineResolutionsBeforeBlur: Bool;
    import var combineResolutionsWithMul: Bool;
    import var hierarchyDepth: SSimpleCurve;
    import var normalAOMultiply: SSimpleCurve;
    import var normalToDepthBrightnessEqualiser: SSimpleCurve;
    import var normalBackProjectionTolerance: SSimpleCurve;
}
import struct CEnvAmbientProbesGenParameters {
    import var activated: Bool;
    import var colorAmbient: SSimpleCurve;
    import var colorSceneAdd: SSimpleCurve;
    import var colorSkyTop: SSimpleCurve;
    import var colorSkyHorizon: SSimpleCurve;
    import var skyShape: SSimpleCurve;
}
import struct CEnvReflectionProbesGenParameters {
    import var activated: Bool;
    import var colorAmbient: SSimpleCurve;
    import var colorSceneMul: SSimpleCurve;
    import var colorSceneAdd: SSimpleCurve;
    import var colorSkyMul: SSimpleCurve;
    import var colorSkyAdd: SSimpleCurve;
    import var remapOffset: SSimpleCurve;
    import var remapStrength: SSimpleCurve;
    import var remapClamp: SSimpleCurve;
}
import struct CEnvGlobalLightParameters {
    import var activated: Bool;
    import var activatedGlobalLightActivated: Bool;
    import var globalLightActivated: Float;
    import var activatedActivatedFactorLightDir: Bool;
    import var activatedFactorLightDir: Float;
    import var sunColor: SSimpleCurve;
    import var sunColorLightSide: SSimpleCurve;
    import var sunColorLightOppositeSide: SSimpleCurve;
    import var sunColorCenterArea: SSimpleCurve;
    import var sunColorSidesMargin: SSimpleCurve;
    import var sunColorBottomHeight: SSimpleCurve;
    import var sunColorTopHeight: SSimpleCurve;
    import var forcedLightDirAnglesYaw: SSimpleCurve;
    import var forcedLightDirAnglesPitch: SSimpleCurve;
    import var forcedLightDirAnglesRoll: SSimpleCurve;
    import var forcedSunDirAnglesYaw: SSimpleCurve;
    import var forcedSunDirAnglesPitch: SSimpleCurve;
    import var forcedSunDirAnglesRoll: SSimpleCurve;
    import var forcedMoonDirAnglesYaw: SSimpleCurve;
    import var forcedMoonDirAnglesPitch: SSimpleCurve;
    import var forcedMoonDirAnglesRoll: SSimpleCurve;
    import var translucencyViewDependency: SSimpleCurve;
    import var translucencyBaseFlatness: SSimpleCurve;
    import var translucencyFlatBrightness: SSimpleCurve;
    import var translucencyGainBrightness: SSimpleCurve;
    import var translucencyFresnelScaleLight: SSimpleCurve;
    import var translucencyFresnelScaleReflection: SSimpleCurve;
    import var envProbeBaseLightingAmbient: CEnvAmbientProbesGenParameters;
    import var envProbeBaseLightingReflection: CEnvReflectionProbesGenParameters;
    import var charactersLightingBoostAmbientLight: SSimpleCurve;
    import var charactersLightingBoostAmbientShadow: SSimpleCurve;
    import var charactersLightingBoostReflectionLight: SSimpleCurve;
    import var charactersLightingBoostReflectionShadow: SSimpleCurve;
    import var charactersEyeBlicksColor: SSimpleCurve;
    import var charactersEyeBlicksShadowedScale: SSimpleCurve;
    import var envProbeAmbientScaleLight: SSimpleCurve;
    import var envProbeAmbientScaleShadow: SSimpleCurve;
    import var envProbeReflectionScaleLight: SSimpleCurve;
    import var envProbeReflectionScaleShadow: SSimpleCurve;
    import var envProbeDistantScaleFactor: SSimpleCurve;
}
import struct CEnvInteriorFallbackParameters {
    import var activated: Bool;
    import var colorAmbientMul: SSimpleCurve;
    import var colorReflectionLow: SSimpleCurve;
    import var colorReflectionMiddle: SSimpleCurve;
    import var colorReflectionHigh: SSimpleCurve;
}
import struct CEnvSpeedTreeRandomColorParameters {
    import var luminanceWeights: SSimpleCurve;
    import var randomColor0: SSimpleCurve;
    import var saturation0: SSimpleCurve;
    import var randomColor1: SSimpleCurve;
    import var saturation1: SSimpleCurve;
    import var randomColor2: SSimpleCurve;
    import var saturation2: SSimpleCurve;
}
import struct CEnvSpeedTreeParameters {
    import var activated: Bool;
    import var diffuse: SSimpleCurve;
    import var specularScale: SSimpleCurve;
    import var translucencyScale: SSimpleCurve;
    import var ambientOcclusionScale: SSimpleCurve;
    import var billboardsColor: SSimpleCurve;
    import var billboardsTranslucency: SSimpleCurve;
    import var randomColorsTrees: CEnvSpeedTreeRandomColorParameters;
    import var randomColorsBranches: CEnvSpeedTreeRandomColorParameters;
    import var randomColorsGrass: CEnvSpeedTreeRandomColorParameters;
    import var randomColorsFallback: SSimpleCurve;
    import var pigmentBrightness: SSimpleCurve;
    import var pigmentFloodStartDist: SSimpleCurve;
    import var pigmentFloodRange: SSimpleCurve;
    import var billboardsLightBleed: SSimpleCurve;
}
import struct CEnvToneMappingCurveParameters {
    import var shoulderStrength: SSimpleCurve;
    import var linearStrength: SSimpleCurve;
    import var linearAngle: SSimpleCurve;
    import var toeStrength: SSimpleCurve;
    import var toeNumerator: SSimpleCurve;
    import var toeDenominator: SSimpleCurve;
}

import struct CEnvToneMappingParameters {
    import var activated: Bool;
    import var skyLuminanceCustomValue: SSimpleCurve;
    import var skyLuminanceCustomAmount: SSimpleCurve;
    import var luminanceLimitShape: SSimpleCurve;
    import var luminanceLimitMin: SSimpleCurve;
    import var luminanceLimitMax: SSimpleCurve;
    import var rejectThreshold: SSimpleCurve;
    import var rejectSmoothExtent: SSimpleCurve;
    import var newToneMapCurveParameters: CEnvToneMappingCurveParameters;
    import var newToneMapWhitepoint: SSimpleCurve;
    import var newToneMapPostScale: SSimpleCurve;
    import var exposureScale: SSimpleCurve;
    import var postScale: SSimpleCurve;
}
import struct CEnvBloomNewParameters {
    import var activated: Bool;
    import var brightPassWeights: SSimpleCurve;
    import var color: SSimpleCurve;
    import var dirtColor: SSimpleCurve;
    import var threshold: SSimpleCurve;
    import var thresholdRange: SSimpleCurve;
    import var brightnessMax: SSimpleCurve;
    import var shaftsColor: SSimpleCurve;
    import var shaftsRadius: SSimpleCurve;
    import var shaftsShapeExp: SSimpleCurve;
    import var shaftsShapeInvSquare: SSimpleCurve;
    import var shaftsThreshold: SSimpleCurve;
    import var shaftsThresholdRange: SSimpleCurve;
}
import struct CEnvGlobalFogParameters {
    import var fogActivated: Bool;
    import var fogAppearDistance: SSimpleCurve;
    import var fogAppearRange: SSimpleCurve;
    import var fogColorFront: SSimpleCurve;
    import var fogColorMiddle: SSimpleCurve;
    import var fogColorBack: SSimpleCurve;
    import var fogDensity: SSimpleCurve;
    import var fogFinalExp: SSimpleCurve;
    import var fogDistClamp: SSimpleCurve;
    import var fogVertOffset: SSimpleCurve;
    import var fogVertDensity: SSimpleCurve;
    import var fogVertDensityLightFront: SSimpleCurve;
    import var fogVertDensityLightBack: SSimpleCurve;
    import var fogSkyDensityScale: SSimpleCurve;
    import var fogCloudsDensityScale: SSimpleCurve;
    import var fogSkyVertDensityLightFrontScale: SSimpleCurve;
    import var fogSkyVertDensityLightBackScale: SSimpleCurve;
    import var fogVertDensityRimRange: SSimpleCurve;
    import var fogCustomColor: SSimpleCurve;
    import var fogCustomColorStart: SSimpleCurve;
    import var fogCustomColorRange: SSimpleCurve;
    import var fogCustomAmountScale: SSimpleCurve;
    import var fogCustomAmountScaleStart: SSimpleCurve;
    import var fogCustomAmountScaleRange: SSimpleCurve;
    import var aerialColorFront: SSimpleCurve;
    import var aerialColorMiddle: SSimpleCurve;
    import var aerialColorBack: SSimpleCurve;
    import var aerialFinalExp: SSimpleCurve;
    import var ssaoImpactClamp: SSimpleCurve;
    import var ssaoImpactNearValue: SSimpleCurve;
    import var ssaoImpactFarValue: SSimpleCurve;
    import var ssaoImpactNearDistance: SSimpleCurve;
    import var ssaoImpactFarDistance: SSimpleCurve;
    import var distantLightsIntensityScale: SSimpleCurve;
}
import struct CEnvGlobalSkyParameters {
    import var activated: Bool;
    import var activatedActivateFactor: Bool;
    import var activateFactor: Float;
    import var skyColor: SSimpleCurve;
    import var skyColorHorizon: SSimpleCurve;
    import var horizonVerticalAttenuation: SSimpleCurve;
    import var sunColorSky: SSimpleCurve;
    import var sunColorSkyBrightness: SSimpleCurve;
    import var sunAreaSkySize: SSimpleCurve;
    import var sunColorHorizon: SSimpleCurve;
    import var sunColorHorizonHorizontalScale: SSimpleCurve;
    import var sunBackHorizonColor: SSimpleCurve;
    import var sunInfluence: SSimpleCurve;
    import var moonColorSky: SSimpleCurve;
    import var moonColorSkyBrightness: SSimpleCurve;
    import var moonAreaSkySize: SSimpleCurve;
    import var moonColorHorizon: SSimpleCurve;
    import var moonColorHorizonHorizontalScale: SSimpleCurve;
    import var moonBackHorizonColor: SSimpleCurve;
    import var moonInfluence: SSimpleCurve;
    import var globalSkyBrightness: SSimpleCurve;
    import var skyGIInfluence: SSimpleCurve;
    import var skyGISaturationCoef: SSimpleCurve;
    import var skyGIBrighthessCoef: SSimpleCurve;
    import var globalLightGIInfluence: SSimpleCurve;
}
import struct CEnvDepthOfFieldParameters {
    import var activated: Bool;
    import var nearBlurDist: SSimpleCurve;
    import var nearFocusDist: SSimpleCurve;
    import var farFocusDist: SSimpleCurve;
    import var farBlurDist: SSimpleCurve;
    import var intensity: SSimpleCurve;
    import var activatedSkyThreshold: Bool;
    import var skyThreshold: Float;
    import var activatedSkyRange: Bool;
    import var skyRange: Float;
}

import struct CEnvDistanceRangeParameters {
    import var activated: Bool;
    import var distance: SSimpleCurve;
    import var range: SSimpleCurve;
}

import struct CEnvColorModTransparencyParameters {
    import var activated: Bool;
    import var commonFarDist: SSimpleCurve;
    import var filterNearColor: SSimpleCurve;
    import var filterFarColor: SSimpleCurve;
    import var contrastNearStrength: SSimpleCurve;
    import var contrastFarStrength: SSimpleCurve;
    import var autoHideCustom0: CEnvDistanceRangeParameters;
    import var autoHideCustom1: CEnvDistanceRangeParameters;
    import var autoHideCustom2: CEnvDistanceRangeParameters;
    import var autoHideCustom3: CEnvDistanceRangeParameters;
}

import struct CEnvShadowsParameters {
    import var activatedAutoHide: Bool;
    import var autoHideBoxSizeMin: SSimpleCurve;
    import var autoHideBoxSizeMax: SSimpleCurve;
    import var autoHideBoxCompMaxX: SSimpleCurve;
    import var autoHideBoxCompMaxY: SSimpleCurve;
    import var autoHideBoxCompMaxZ: SSimpleCurve;
    import var autoHideDistScale: SSimpleCurve;
}
import struct CEnvWaterParameters {
    import var activated: Bool;
    import var waterFlowIntensity: SSimpleCurve;
    import var underwaterBrightness: SSimpleCurve;
    import var underWaterFogIntensity: SSimpleCurve;
    import var waterColor: SSimpleCurve;
    import var underWaterColor: SSimpleCurve;
    import var waterFresnel: SSimpleCurve;
    import var waterCaustics: SSimpleCurve;
    import var waterFoamIntensity: SSimpleCurve;
    import var waterAmbientScale: SSimpleCurve;
    import var waterDiffuseScale: SSimpleCurve;
}
import struct CEnvColorGroupsParameters {
    import var activated: Bool;
    import var defaultGroup: SSimpleCurve;
    import var lightsDefault: SSimpleCurve;
    import var lightsDawn: SSimpleCurve;
    import var lightsNoon: SSimpleCurve;
    import var lightsEvening: SSimpleCurve;
    import var lightsNight: SSimpleCurve;
    import var fxDefault: SSimpleCurve;
    import var fxFire: SSimpleCurve;
    import var fxFireFlares: SSimpleCurve;
    import var fxFireLight: SSimpleCurve;
    import var fxSmoke: SSimpleCurve;
    import var fxSmokeExplosion: SSimpleCurve;
    import var fxSky: SSimpleCurve;
    import var fxSkyAlpha: SSimpleCurve;
    import var fxSkyNight: SSimpleCurve;
    import var fxSkyNightAlpha: SSimpleCurve;
    import var fxSkyDawn: SSimpleCurve;
    import var fxSkyDawnAlpha: SSimpleCurve;
    import var fxSkyNoon: SSimpleCurve;
    import var fxSkyNoonAlpha: SSimpleCurve;
    import var fxSkySunset: SSimpleCurve;
    import var fxSkySunsetAlpha: SSimpleCurve;
    import var fxSkyRain: SSimpleCurve;
    import var fxSkyRainAlpha: SSimpleCurve;
    import var mainCloudsMiddle: SSimpleCurve;
    import var mainCloudsMiddleAlpha: SSimpleCurve;
    import var mainCloudsFront: SSimpleCurve;
    import var mainCloudsFrontAlpha: SSimpleCurve;
    import var mainCloudsBack: SSimpleCurve;
    import var mainCloudsBackAlpha: SSimpleCurve;
    import var mainCloudsRim: SSimpleCurve;
    import var mainCloudsRimAlpha: SSimpleCurve;
    import var backgroundCloudsFront: SSimpleCurve;
    import var backgroundCloudsFrontAlpha: SSimpleCurve;
    import var backgroundCloudsBack: SSimpleCurve;
    import var backgroundCloudsBackAlpha: SSimpleCurve;
    import var backgroundHazeFront: SSimpleCurve;
    import var backgroundHazeFrontAlpha: SSimpleCurve;
    import var backgroundHazeBack: SSimpleCurve;
    import var backgroundHazeBackAlpha: SSimpleCurve;
    import var fxBlood: SSimpleCurve;
    import var fxWater: SSimpleCurve;
    import var fxFog: SSimpleCurve;
    import var fxTrails: SSimpleCurve;
    import var fxScreenParticles: SSimpleCurve;
    import var fxLightShaft: SSimpleCurve;
    import var fxLightShaftSun: SSimpleCurve;
    import var fxLightShaftInteriorDawn: SSimpleCurve;
    import var fxLightShaftSpotlightDawn: SSimpleCurve;
    import var fxLightShaftReflectionLightDawn: SSimpleCurve;
    import var fxLightShaftInteriorNoon: SSimpleCurve;
    import var fxLightShaftSpotlightNoon: SSimpleCurve;
    import var fxLightShaftReflectionLightNoon: SSimpleCurve;
    import var fxLightShaftInteriorEvening: SSimpleCurve;
    import var fxLightShaftSpotlightEvening: SSimpleCurve;
    import var fxLightShaftReflectionLightEvening: SSimpleCurve;
    import var fxLightShaftInteriorNight: SSimpleCurve;
    import var fxLightShaftSpotlightNight: SSimpleCurve;
    import var fxLightShaftReflectionLightNight: SSimpleCurve;
    import var activatedCustom0: Bool;
    import var customGroup0: SSimpleCurve;
    import var activatedCustom1: Bool;
    import var customGroup1: SSimpleCurve;
    import var activatedCustom2: Bool;
    import var customGroup2: SSimpleCurve;
}
import struct CEnvFlareColorParameters {
    import var activated: Bool;
    import var color0: SSimpleCurve;
    import var opacity0: SSimpleCurve;
    import var color1: SSimpleCurve;
    import var opacity1: SSimpleCurve;
    import var color2: SSimpleCurve;
    import var opacity2: SSimpleCurve;
    import var color3: SSimpleCurve;
    import var opacity3: SSimpleCurve;
}
import struct CEnvFlareColorGroupsParameters {
    import var activated: Bool;
    //import var default: CEnvFlareColorParameters; // default is reserved keyword
    import var custom0: CEnvFlareColorParameters;
    import var custom1: CEnvFlareColorParameters;
    import var custom2: CEnvFlareColorParameters;
}
import struct CEnvSunAndMoonParameters {
    import var activated: Bool;
    import var sunSize: SSimpleCurve;
    import var sunColor: SSimpleCurve;
    import var sunFlareSize: SSimpleCurve;
    import var sunFlareColor: CEnvFlareColorParameters;
    import var moonSize: SSimpleCurve;
    import var moonColor: SSimpleCurve;
    import var moonFlareSize: SSimpleCurve;
    import var moonFlareColor: CEnvFlareColorParameters;
}
import struct CEnvWindParameters {
    import var activated: Bool;
    import var windStrengthOverride: SSimpleCurve;
    import var cloudsVelocityOverride: SSimpleCurve;
}
import struct CEnvGameplayEffectsParameters {
    import var activated: Bool;
    import var catEffectBrightnessMultiply: SSimpleCurve;
    import var behaviorAnimationMultiplier: SSimpleCurve;
    import var specularityMultiplier: SSimpleCurve;
    import var glossinessMultiplier: SSimpleCurve;
}
import struct CEnvMotionBlurParameters {
    import var activated: Bool;
    import var strength: SSimpleCurve;
}
import struct CEnvCameraLightParameters {
    import var activated: Bool;
    import var color: SSimpleCurve;
    import var attenuation: SSimpleCurve;
    import var radius: SSimpleCurve;
    import var offsetFront: SSimpleCurve;
    import var offsetRight: SSimpleCurve;
    import var offsetUp: SSimpleCurve;
}
import struct CEnvCameraLightsSetupParameters {
    import var activated: Bool;
    import var gameplayLight0: CEnvCameraLightParameters;
    import var gameplayLight1: CEnvCameraLightParameters;
    import var sceneLight0: CEnvCameraLightParameters;
    import var sceneLight1: CEnvCameraLightParameters;
    import var dialogLight0: CEnvCameraLightParameters;
    import var dialogLight1: CEnvCameraLightParameters;
    import var interiorLight0: CEnvCameraLightParameters;
    import var interiorLight1: CEnvCameraLightParameters;
    import var playerInInteriorLightsScale: SSimpleCurve;
    import var sceneLightColorInterior0: SSimpleCurve;
    import var sceneLightColorInterior1: SSimpleCurve;
    import var cameraLightsNonCharacterScale: SSimpleCurve;
}
import struct CEnvDialogLightParameters {
    import var activated: Bool;
    import var lightColor: SSimpleCurve;
    import var lightColor2: SSimpleCurve;
    import var lightColor3: SSimpleCurve;
}

import struct CAreaEnvironmentParams {
    import var m_finalColorBalance: CEnvFinalColorBalanceParameters;
    import var m_sharpen: CEnvSharpenParameters;
    import var m_paintEffect: CEnvPaintEffectParameters;
    import var m_ssaoNV: CEnvNVSSAOParameters;
    import var m_ssaoMS: CEnvMSSSAOParameters;
    import var m_globalLight: CEnvGlobalLightParameters;
    import var m_interiorFallback: CEnvInteriorFallbackParameters;
    import var m_speedTree: CEnvSpeedTreeParameters;
    import var m_toneMapping: CEnvToneMappingParameters;
    import var m_bloomNew: CEnvBloomNewParameters;
    import var m_globalFog: CEnvGlobalFogParameters;
    import var m_sky: CEnvGlobalSkyParameters;
    import var m_depthOfField: CEnvDepthOfFieldParameters;
    import var m_colorModTransparency: CEnvColorModTransparencyParameters;
    import var m_shadows: CEnvShadowsParameters;
    import var m_water: CEnvWaterParameters;
    import var m_colorGroups: CEnvColorGroupsParameters;
    import var m_flareColorGroups: CEnvFlareColorGroupsParameters;
    import var m_sunAndMoonParams: CEnvSunAndMoonParameters;
    import var m_windParams: CEnvWindParameters;
    import var m_gameplayEffects: CEnvGameplayEffectsParameters;
    import var m_motionBlur: CEnvMotionBlurParameters;
    import var m_cameraLightsSetup: CEnvCameraLightsSetupParameters;
    import var m_dialogLightParams: CEnvDialogLightParameters;
}

import struct SGlobalSpeedTreeParameters {
    import var alphaScalar3d: Float;
    import var alphaScalarGrassNear: Float;
    import var alphaScalarGrass: Float;
    import var alphaScalarGrassDistNear: Float;
    import var alphaScalarGrassDistFar: Float;
    import var alphaScalarBillboards: Float;
    import var billboardsGrainBias: Float;
    import var billboardsGrainAlbedoScale: Float;
    import var billboardsGrainNormalScale: Float;
    import var billboardsGrainClipScale: Float;
    import var billboardsGrainClipBias: Float;
    import var billboardsGrainClipDamping: Float;
    import var grassNormalsVariation: Float;
}

import class IMaterial extends CResource {}

import class CMeshTypeResource extends CResource {
    import var materials: array<IMaterial>;
    import var boundingBox: Box;
    import var autoHideDistance: Float;
    import var isTwoSided: Bool;
}

import class ICollisionShape extends CObject {
    import var pose: Matrix;
    import var densityScaler: Float;
}
import class CCollisionMesh extends CResource {
    //import var shapes: array:2,0,ptr:ICollisionShape;
    import var occlusionAttenuation: Float;
    import var occlusionDiagonalLimit: Float;
    import var swimmingRotationAxis: Int32;
}
import struct SMeshChunkPacked {
    import var vertexType: EMeshVertexType;
    import var materialID: Uint32;
    import var numBonesPerVertex: Uint8;
    import var numVertices: Uint32;
    import var numIndices: Uint32;
    import var firstVertex: Uint32;
    import var firstIndex: Uint32;
    //import var renderMask: EMeshChunkRenderMask; cannot be imported
    import var useForShadowmesh: Bool;
}
import struct SMeshCookedData {
    import var collisionInitPositionOffset: Vector;
    import var dropOffset: Vector;
    import var bonePositions: array<Vector>;
    import var renderLODs: array<Float>;
    import var renderChunks: array<Uint8>;
    import var renderBuffer: DeferredDataBuffer;
    import var quantizationScale: Vector;
    import var quantizationOffset: Vector;
    import var vertexBufferSize: Uint32;
    import var indexBufferSize: Uint32;
    import var indexBufferOffset: Uint32;
    import var blasLODsOffsets: array<Uint32>;
    import var blasBuffer: DeferredDataBuffer;
}
import class CMesh extends CMeshTypeResource {
    import var collisionMesh: CCollisionMesh;
    import var useExtraStreams: Bool;
    import var generalizedMeshRadius: Float;
    import var mergeInGlobalShadowMesh: Bool;
    import var isOccluder: Bool;
    import var smallestHoleOverride: Float;
    import var chunks: array<SMeshChunkPacked>;
    import var rawVertices: DeferredDataBuffer;
    import var rawIndices: DeferredDataBuffer;
    import var isStatic: Bool;
    import var entityProxy: Bool;
    import var cookedData: SMeshCookedData;
    //import var soundInfo: ptr:SMeshSoundInfo;
    import var internalVersion: Uint8;
    import var chunksBuffer: DeferredDataBuffer;

}
import class CMaterialInstance extends IMaterial {
    import var baseMaterial: IMaterial;
    import var enableMask: Bool;
}
import struct SWorldSkyboxParameters {
    import var sunMesh: CMesh;
    import var sunMaterial: CMaterialInstance;
    import var moonMesh: CMesh;
    import var moonMaterial: CMaterialInstance;
    import var skyboxMesh: CMesh;
    import var skyboxMaterial: CMaterialInstance;
    import var cloudsMesh: CMesh;
    import var cloudsMaterial: CMaterialInstance;
}

import struct SLensFlareElementParameters {
    import var material: CMaterialInstance;
    import var isConstRadius: Bool;
    import var isAligned: Bool;
    import var centerFadeStart: Float;
    import var centerFadeRange: Float;
    import var colorGroupParamsIndex: Uint32;
    import var alpha: Float;
    import var size: Float;
    import var aspect: Float;
    import var shift: Float;
    import var pivot: Float;
    import var color: Color;
}

import struct SLensFlareParameters {
    import var nearDistance: Float;
    import var nearRange: Float;
    import var farDistance: Float;
    import var farRange: Float;
    import var elements: array<SLensFlareElementParameters>;
}

import struct SLensFlareGroupsParameters {
    //import var default: SLensFlareParameters; // default is reserved keyword
    import var sun: SLensFlareParameters;
    import var moon: SLensFlareParameters;
    import var custom0: SLensFlareParameters;
    import var custom1: SLensFlareParameters;
    import var custom2: SLensFlareParameters;
    import var custom3: SLensFlareParameters;
    import var custom4: SLensFlareParameters;
    import var custom5: SLensFlareParameters;
}

import struct CTextureArrayEntry {
    //import var m_texture: soft:CBitmapTexture;
}
import class CTextureArray extends CResource {
    import var bitmaps: array<CTextureArrayEntry>;
    import var textureGroup: CName;
}

import struct SWorldMotionBlurSettings {
    import var isPostTonemapping: Bool;
    import var distanceNear: Float;
    import var distanceRange: Float;
    import var strengthNear: Float;
    import var strengthFar: Float;
    import var fullBlendOverPixels: Float;
    import var standoutDistanceNear: Float;
    import var standoutDistanceRange: Float;
    import var standoutAmountNear: Float;
    import var standoutAmountFar: Float;
    import var sharpenAmount: Float;
}

import struct SWorldRenderSettings {
    import var cameraNearPlane: Float;
    import var cameraFarPlane: Float;
    import var ssaoBlurEnable: Bool;
    import var ssaoNormalsEnable: Bool;
    import var envProbeSecondAmbientFilterSize: Float;
    import var fakeCloudsShadowSize: Float;
    import var fakeCloudsShadowSpeed: Float;
    import var fakeCloudsShadowTexture: CTextureArray;
    import var bloomLevelsRange: Uint32;
    import var bloomLevelsOffset: Uint32;
    import var bloomScaleConst: Float;
    import var bloomDownscaleDivBase: Float;
    import var bloomDownscaleDivExp: Float;
    import var bloomLevelScale0: Float;
    import var bloomLevelScale1: Float;
    import var bloomLevelScale2: Float;
    import var bloomLevelScale3: Float;
    import var bloomLevelScale4: Float;
    import var bloomLevelScale5: Float;
    import var bloomLevelScale6: Float;
    import var bloomLevelScale7: Float;
    import var bloomPrecision: Float;
    import var shaftsLevelIndex: Uint32;
    import var shaftsIntensity: Float;
    import var shaftsThresholdsScale: Float;
    import var fresnelScaleLights: Float;
    import var fresnelScaleEnvProbes: Float;
    import var fresnelRoughnessShape: Float;
    import var interiorDimmerAmbientLevel: Float;
    import var interiorVolumeSmoothExtent: Float;
    import var interiorVolumeSmoothRemovalRange: Float;
    import var interiorVolumesFadeStartDist: Float;
    import var interiorVolumesFadeRange: Float;
    import var interiorVolumesFadeEncodeRange: Float;
    import var distantLightStartDistance: Float;
    import var distantLightFadeDistance: Float;
    import var globalFlaresTransparencyThreshold: Float;
    import var globalFlaresTransparencyRange: Float;
    import var motionBlurSettings: SWorldMotionBlurSettings;
    import var chromaticAberrationStart: Float;
    import var chromaticAberrationRange: Float;
    import var interiorFallbackReflectionThresholdLow: Float;
    import var interiorFallbackReflectionThresholdHigh: Float;
    import var interiorFallbackReflectionBlendLow: Float;
    import var interiorFallbackReflectionBlendHigh: Float;
    import var enableEnvProbeLights: Bool;
}

import struct SWorldEnvironmentParameters {
    import var vignetteTexture: CBitmapTexture;
    import var cameraDirtTexture: CBitmapTexture;
    import var interiorFallbackAmbientTexture: CCubeTexture;
    import var interiorFallbackReflectionTexture: CCubeTexture;
    import var cameraDirtNumVerticalTiles: Float;
    import var globalLightingTrajectory: CGlobalLightingTrajectory;
    import var toneMappingAdaptationSpeedUp: Float;
    import var toneMappingAdaptationSpeedDown: Float;
    import var environmentDefinition: CEnvironmentDefinition;
    import var scenesEnvironmentDefinition: CEnvironmentDefinition;
    import var speedTreeParameters: SGlobalSpeedTreeParameters;
    import var weatherTemplate: C2dArray;
    import var disableWaterShaders: Bool;
    import var skybox: SWorldSkyboxParameters;
    import var lensFlare: SLensFlareGroupsParameters;
    import var renderSettings: SWorldRenderSettings;
    import var localWindDampers: CResourceSimplexTree;
    import var localWaterVisibility: CResourceSimplexTree;
}

import class CCookedExplorations extends CResource {}
import class CWayPointsCollectionsSet extends CResource {}

import class CGameWorld extends CWorld {
    import var startupCameraPosition: Vector;
    import var startupCameraRotation: EulerAngles;
    //import var terrainClipMap: ptr:CClipMap;
    import var newLayerGroupFormat: Bool;
    import var hasEmbeddedLayerInfos: Bool;
    import var initialyHidenLayerGroups: C2dArray;
    import var umbraScene: CUmbraScene;
    //import var globalWater: ptr:CGlobalWater;
    //import var pathLib: ptr:CPathLibWorld;
    import var worldDimensions: Float;
    import var shadowConfig: CWorldShadowConfig;
    import var environmentParameters: SWorldEnvironmentParameters;
    import var soundBanksDependency: array<CName>;
    import var soundEventsOnAttach: array<StringAnsi>;
    import var soundEventsOnDetach: array<StringAnsi>;
    //import var foliageScene: ptr:CFoliageScene;
    import var playGoChunks: array<CName>;
    import var minimapsPath: String;
    import var hubmapsPath: String;
    //import var mergedGeometry: ptr:CMergedWorldGeometry;
    import var cookedExplorations: CCookedExplorations;
    import var cookedWaypoints: CWayPointsCollectionsSet;
}
