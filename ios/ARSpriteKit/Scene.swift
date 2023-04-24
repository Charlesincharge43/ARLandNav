//
//  Scene.swift
//  ARSpriteKit
//
//  Created by Esteban Herrera on 7/4/17.
//  Copyright © 2017 Esteban Herrera. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
        
    let ghostsLabel = SKLabelNode(text: "Ghosts")
    let numberOfGhostsLabel = SKLabelNode(text: "0")
    var creationTime : TimeInterval = 0
    var ghostCount = 0 {
        didSet{
            self.numberOfGhostsLabel.text = "\(ghostCount)"
        }
    }
    
    let killSound = SKAction.playSoundFileNamed("ghost", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        ghostsLabel.fontSize = 20
        ghostsLabel.fontName = "DevanagariSangamMN-Bold"
        ghostsLabel.color = .white
        ghostsLabel.position = CGPoint(x: 40, y: 50)
        addChild(ghostsLabel)
        
        numberOfGhostsLabel.fontSize = 30
        numberOfGhostsLabel.fontName = "DevanagariSangamMN-Bold"
        numberOfGhostsLabel.color = .white
        numberOfGhostsLabel.position = CGPoint(x: 40, y: 10)
        addChild(numberOfGhostsLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
      createGhostAnchor()
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
  func createGhostAnchor() {
      guard let sceneView = self.view as? ARSKView else {
          return
      }
      if (ghostCount > 0) {
          return
      }
      if (sceneView.session.currentFrame == nil) {
        print("current Frame doesnt exist, skipping")
        return
      }

      // Define 360º in radians
      let _360degrees = 2.0 * Float.pi
      
      // Create a rotation matrix in the X-axis
      let rotateX = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 1, 0, 0))
      
      // Create a rotation matrix in the Y-axis
      let rotateY = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 0, 1, 0))
      
      // Combine both rotation matrices
      let rotation = simd_mul(rotateX, rotateY)
      
      // Create a translation matrix in the Z-axis with a value between 1 and 2 meters
      var translation = matrix_identity_float4x4
      translation.columns.3.z = -1 - randomFloat(min: 0.0, max: 1.0)
      
      // Set the distance of the ghost from the user
      let distance: Float = 1.5 // 5 feet = 1.5 meters
      let userPosition = sceneView.session.currentFrame?.camera.transform.columns.3
      let direction = simd_float4(0, 0, -distance, 0)
      let positionRelativeToCamera = simd_mul(sceneView.session.currentFrame?.camera.transform ?? matrix_identity_float4x4, direction)
      let ghostPosition = simd_float4(userPosition!.x, userPosition!.y, userPosition!.z, 1) + positionRelativeToCamera
      
      // Set the position of the ghost anchor
      translation.columns.3.x = ghostPosition.x
      translation.columns.3.y = ghostPosition.y
      translation.columns.3.z = ghostPosition.z
      
      // Combine the rotation and translation matrices
      let transform = simd_mul(rotation, translation)
      
      // Create an anchor
      let anchor = ARAnchor(transform: transform)
      
      // Add the anchor
      sceneView.session.add(anchor: anchor)
      
      // Increment the counter
      ghostCount += 1
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
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
          ghostNode.scale = SCNVector3(x: scale, y: scale, z: scale)
    }
}
