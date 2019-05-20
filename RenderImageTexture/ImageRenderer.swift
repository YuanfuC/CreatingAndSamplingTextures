//
//  ImageRenderer.swift
//  RenderImageTexture
//
//  Created by ChenYuanfu on 2019/5/18.
//  Copyright © 2019 ChenYuanfu All rights reserved.
//

import UIKit
import MetalKit
import simd

class ImageRenderer: NSObject {
    
    let device: MTLDevice
    let texture: MTLTexture
    let commandQueue: MTLCommandQueue
    let vertextBuffer :MTLBuffer
    var viewPort:vector_uint2 = vector_uint2(x: 0, y: 0);
    let numberOfVertice:Int
    let pipelineState:MTLRenderPipelineState

    
    static func loadTexutre(_ device:MTLDevice) ->MTLTexture {
        let loader = MTKTextureLoader.init(device: device)
        let url = Bundle.main.url(forResource: "test_antialiseing", withExtension: "jpe")!
        let texture = try! loader.newTexture(URL: url, options: nil)
        return texture
    }
    
     init(_ mtkView: MTKView) {
        self.device = mtkView.device!
        texture = UIImage.loadImageTexutre(self.device)
      //  let a = VertexInputIndexViewPortSize;
        let vertices:[FFVertex] = [
            FFVertex(position: vector_float2(x:  250, y: -250), textureCoordinate:vector_float2(x: 1.0, y: 1.0)),
            FFVertex(position: vector_float2(x: -250, y: -250), textureCoordinate:vector_float2(x: 0.0, y: 1.0)),
            FFVertex(position: vector_float2(x: -250, y:  250), textureCoordinate:vector_float2(x: 0.0, y: 0.0)),
            
            FFVertex(position: vector_float2(x:  250, y: -250), textureCoordinate:vector_float2(x: 1.0, y: 1.0)),
            FFVertex(position: vector_float2(x: -250, y:  250), textureCoordinate:vector_float2(x: 0.0, y: 0.0)),
            FFVertex(position: vector_float2(x:  250, y:  250), textureCoordinate:vector_float2(x: 1.0, y: 0.0))
        ]
        
        numberOfVertice = vertices.count
        vertextBuffer = self.device.makeBuffer(bytes: vertices, length: MemoryLayout<FFVertex>.stride * numberOfVertice, options: .storageModeShared)!
        
        let defaultLibrary = self.device.makeDefaultLibrary()
        
        let vertexFunction = defaultLibrary?.makeFunction(name: "vertexShader")
        let fragmentFunction = defaultLibrary?.makeFunction(name: "samplingShader")
        
        let piplineDescriptor = MTLRenderPipelineDescriptor.init()
        piplineDescriptor.label = "Texturing Pipline"
        piplineDescriptor.vertexFunction = vertexFunction!
        piplineDescriptor.fragmentFunction = fragmentFunction!
        piplineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        
        pipelineState = try!self.device.makeRenderPipelineState(descriptor: piplineDescriptor)
        commandQueue = self.device.makeCommandQueue()!

    }
    
}

extension ImageRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewPort.x = UInt32(size.width)
        viewPort.y = UInt32(size.height)
    }
    
    func draw(in view: MTKView) {
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        let renderDescriptor = view.currentRenderPassDescriptor!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDescriptor)!
        renderEncoder.label = "RenderCC encoder"
        renderEncoder.setViewport(MTLViewport.init(originX: 0.0, originY: 0.0, width: Double(self.viewPort.x), height: Double(self.viewPort.y), znear: -1.0, zfar: 1.0))
        renderEncoder.setRenderPipelineState(self.pipelineState)
        
        renderEncoder.setVertexBuffer(self.vertextBuffer, offset: 0, index: FFVertexInputIndex.Vertices.rawValue)
        
        renderEncoder.setVertexBytes(&self.viewPort, length: MemoryLayout<vector_uint2>.stride, index: FFVertexInputIndex.ViewporSize.rawValue)
        
        renderEncoder.setFragmentTexture(self.texture, index: FFTextureIndex.BaseColor.rawValue)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.numberOfVertice)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        
        commandBuffer.commit()
    }
}

extension UIImage  {
    static func loadImageTexutre(_ device:MTLDevice) ->MTLTexture {
        let loader = MTKTextureLoader.init(device: device)
        let url = Bundle.main.url(forResource: "test_antialiseing", withExtension: "jpg")!
        let texture = try! loader.newTexture(URL: url, options: nil)
        return texture
    }
}
