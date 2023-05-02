//
//  Scene.swift
//  ARSpriteKit
//
//  Created by Charles Long on 4/29/23.
//

import ARKit
import CoreLocation

class LandNavScene: SCNScene, CLLocationManagerDelegate {
    var viewController: ARViewController?
    let locationManager = CLLocationManager()
//    let checkpointMarkersLabel = SKLabelNode(text: "Checkpoint Markers")
//    let numberOfCheckpointMarkers = SKLabelNode(text: "0")
    var creationTime : TimeInterval = 0
//    var checkpointMarkersCount = 0 {
//        didSet{
//            self.numberOfCheckpointMarkers.text = "\(checkpointMarkersCount)"
//        }
//    }
  
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }

    override init() {
        super.init()
      
//        checkpointMarkersLabel.fontSize = 20
//        checkpointMarkersLabel.fontName = "DevanagariSangamMN-Bold"
//        checkpointMarkersLabel.color = .white
//        checkpointMarkersLabel.position = CGPoint(x: 100, y: 50)
//
//        let checkpointMarkersNode = SCNNode2D(with: checkpointMarkersLabel)
//        checkpointMarkersNode.position = SCNVector3(-5, 10, -15)
//        rootNode.addChildNode(checkpointMarkersNode)
//
//        numberOfCheckpointMarkers.fontSize = 30
//        numberOfCheckpointMarkers.fontName = "DevanagariSangamMN-Bold"
//        numberOfCheckpointMarkers.color = .white
//        numberOfCheckpointMarkers.position = CGPoint(x: 40, y: 10)
//
//        let numberOfCheckpointMarkersNode = SCNNode2D(with: numberOfCheckpointMarkers)
//        numberOfCheckpointMarkersNode.position = SCNVector3(-15, -5, -15)
//        rootNode.addChildNode(numberOfCheckpointMarkersNode)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
      
        delay(0.5) {
          guard let viewController = self.viewController else {
            return
          }
          for checkpoint in viewController.checkpoints {
            self.createCheckpointMarkerAnchor(checkpoint: checkpoint)
          }
        }
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func getUserLocation() -> CLLocation? {
        guard let location = locationManager.location else {
            return nil
        }
        return location
    }
    
    func createCheckpointMarkerAnchor(checkpoint: CheckpointStruct) {
        guard let sceneView = self.viewController?.sceneView as? ARSCNView else {
            return
        }

        guard let userLocation = getUserLocation() else {
            return
        }

        let delta_x = (userLocation.coordinate.longitude - checkpoint.coordinate.longitude) * cos(checkpoint.coordinate.latitude)
        let delta_z = (userLocation.coordinate.latitude - checkpoint.coordinate.latitude)
        let delta_y = userLocation.altitude - checkpoint.altitude
        let delta_x_meters = delta_x * 111320
        let delta_z_meters = delta_z * 111320
        let direction = simd_float4(Float(delta_x_meters), Float(delta_y), Float(delta_z_meters), 0)

        var translation = matrix_identity_float4x4
        translation.columns.3.x = direction.x
        translation.columns.3.y = direction.y
        translation.columns.3.z = direction.z

        let anchor = ARAnchor(name: checkpoint.checkpointText, transform: translation)
    
        sceneView.session.add(anchor: anchor)

//        checkpointMarkersCount += 1
    }
}
