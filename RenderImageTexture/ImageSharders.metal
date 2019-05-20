//
//  ImageSharders.metal
//  RenderImageTexture
//
//  Created by ChenYuanfu on 2019/5/18.
//  Copyright © 2019 ChenYuanfu. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>


using namespace metal;

typedef struct {
    vector_float2 position;
    vector_float2 textureCoordinate;
} FFVertex;

typedef enum FFVertexInputIndex{
    FFVertexInputIndexVertices = 0,
    FFVertexInputIndexViewportSize = 1,
} FFVertexInputIndex;
    
typedef enum FFTextureIndex
{
    FFTextureIndexBaseColor = 0,
} FFTextureIndex;

typedef struct {
    float4 position [[position]];
    float2 textureCoordinate;
} FFRasterizerData;

vertex FFRasterizerData
vertexShader(uint vertexID [[vertex_id]],
             constant FFVertex *vertexArray [[ buffer(FFVertexInputIndexVertices)]],
             constant vector_uint2 * viewportSizePointer [[ buffer(FFVertexInputIndexViewportSize) ]]){

    FFRasterizerData out;
    
    float2 pixelSpacePosition =  vertexArray[vertexID].position.xy;
    float2 viewportSize = float2(*viewportSizePointer);
    
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition/(viewportSize/2.0);
    
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    
    return out;
}
    
fragment float4 samplingShader(FFRasterizerData in [[ stage_in ]],
                               texture2d<half> colorTexutre [[ texture(FFTextureIndexBaseColor)]]) {
    constexpr sampler textureSampler(mag_filter ::linear,
                                     min_filter :: linear);
    
    const half4 colorSample = colorTexutre.sample(textureSampler, in.textureCoordinate);
    
    return float4(colorSample);
}
