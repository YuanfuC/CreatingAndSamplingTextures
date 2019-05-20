//
//  SharderDefine.swift
//  RenderImageTexture
//
//  Created by ChenYuanfu on 2019/5/20.
//  Copyright © 2019 ChenYuanfu1. All rights reserved.
//

import UIKit

import simd

struct FFVertex {
    let position: vector_float2
    let textureCoordinate: vector_float2
}

enum FFVertexInputIndex:Int {
    case Vertices = 0
    case ViewporSize = 1
}

enum FFTextureIndex:Int
{
   case BaseColor = 0
}
