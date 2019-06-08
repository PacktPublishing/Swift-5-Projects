//
//  PhotoARSceneViewController.swift
//  ARSocialPhotoApp
//
//  Created by sergio on 08/06/2019.
//  Copyright © 2019 PacktPublishing. All rights reserved.
//

import UIKit
import ARKit

class PhotoARSceneViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        
        sceneView.delegate = self
        sceneView.antialiasingMode = .multisampling4X
        sceneView.session.run(configuration)
        
        #if DEBUG
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        sceneView.showsStatistics = true
        #endif
        
        //-- configure lighting
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

}

extension PhotoARSceneViewController : ARSCNViewDelegate {

}
