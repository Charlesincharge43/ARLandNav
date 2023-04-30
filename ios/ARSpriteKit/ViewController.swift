//
//  ViewController.swift
//  ARSpriteKit
//
//  Created by Esteban Herrera on 7/4/17.
//  Copyright © 2017 Esteban Herrera. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        let scene = Scene(size: sceneView.bounds.size)
        scene.scaleMode = .resizeFill
        sceneView.presentScene(scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        //configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let ghostId = randomInt(min: 1, max: 6)
                
        let node1 = SKSpriteNode(imageNamed: "ghost\(ghostId)")
        node1.name = "ghost"
        
      
        let node2 = SKSpriteNode(imageNamed: "Checkpoint")
        node2.position.x = 400
        node2.position.y = 400
        node2.name = "checkpoint-label-image"
        node2.size = CGSize(width: 600, height: 600)
        let parent = SKNode()
        parent.addChild(node1)
        parent.addChild(node2)
      return parent
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
  
//  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//    print("TESTING")
//    guard let ghostNode = node.childNodes.first else {
//                return
//            }
//
//            // Get the distance from the camera to the ghost
//            let cameraPosition = renderer.pointOfView?.simdPosition ?? simd_float3.zero
//            let ghostPosition = ghostNode.simdPosition
//            let distance = simd_distance(cameraPosition, ghostPosition)
//
//            // Set the ghost node's scale based on the distance
//            let maxDistance: Float = 2.0 // Adjust as necessary
//            let minScale: Float = 0.5 // Adjust as necessary
//            let maxScale: Float = 1.0 // Adjust as necessary
//            let scale = 1 - min(max(distance - 1, 0), maxDistance) / maxDistance * (maxScale - minScale) + minScale
//            ghostNode.scale = SCNVector3(x: scale * 20, y: scale * 20, z: scale * 20)
//      }
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    print("TESTING")
    guard let ghostNode = node.childNodes.first else {
                return
            }

            // Get the distance from the camera to the ghost
            let cameraPosition = renderer.pointOfView?.simdPosition ?? simd_float3.zero
            let ghostPosition = ghostNode.simdPosition
            let distance = simd_distance(cameraPosition, ghostPosition)

            // Set the ghost node's scale based on the distance
            let maxDistance: Float = 2.0 // Adjust as necessary
            let minScale: Float = 0.5 // Adjust as necessary
            let maxScale: Float = 1.0 // Adjust as necessary
            let scale = 1 - min(max(distance - 1, 0), maxDistance) / maxDistance * (maxScale - minScale) + minScale
            ghostNode.scale = SCNVector3(x: scale * 20, y: scale * 20, z: scale * 20)
      }
}
