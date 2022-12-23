import struct SLightFlickering {
    import var positionOffset: Float;
    import var flickerStrength: Float;
    import var flickerPeriod: Float;
}

import class CLightComponent extends CSpriteComponent {
    import var isEnabled: Bool;
    import var shadowCastingMode: ELightShadowCastingMode;
    import var shadowFadeDistance: Float;
    import var shadowFadeRange: Float;
    import var shadowBlendFactor: Float;
    import var radius: Float;
    import var brightness: Float;
    import var attenuation: Float;
    import var color: Color;
    import var envColorGroup: EEnvColorGroup;
    import var autoHideDistance: Float;
    import var autoHideRange: Float;
    import var lightFlickering: SLightFlickering;
    import var allowDistantFade: Bool;
    //import var lightUsageMask: ELightUsageMask; -- Unable to convert type ELightUsageMask to script type
}

import class CPointLightComponent extends CLightComponent {
    import var cacheStaticShadows: Bool;
    //import var dynamicShadowsFaceMask: ELightCubeSides; -- Unable to convert type ELightCubeSides to script type
}

import class CSpotLightComponent extends CLightComponent {
    import var innerAngle: Float;
    import var outerAngle: Float;
    import var softness: Float;
    import var projectionTexture: CBitmapTexture;
    import var projectionTextureAngle: Float;
    import var projectionTexureUBias: Float;
    import var projectionTexureVBias: Float;
}
