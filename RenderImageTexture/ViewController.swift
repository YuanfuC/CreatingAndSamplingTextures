//
//  ViewController.swift
//  RenderImageTexture
//
//  Created by ChenYuanfu on 2019/5/18.
//  Copyright © 2019 ChenYuanfu All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    var mtkRView:MTKView?
    var renderer:ImageRenderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mtkRView = self.view as? MTKView
        
        mtkRView!.device = MTLCreateSystemDefaultDevice()
        
        renderer = ImageRenderer.init(mtkRView!)
        
        renderer!.mtkView(mtkRView!, drawableSizeWillChange: mtkRView!.drawableSize)
        
        mtkRView!.delegate = renderer!
        
    }


}

