//
//  Scene.swift
//  ARSpriteKit
//
//  Created by Charles Long on 4/29/23.
//

import SpriteKit
import ARKit
import CoreLocation

class LandNavScene: SKScene, CLLocationManagerDelegate {
    var viewController: ViewController?
    let locationManager = CLLocationManager()
    let checkpointMarkersLabel = SKLabelNode(text: "Checkpoint Markers")
    let numberOfCheckpointMarkers = SKLabelNode(text: "0")
    var creationTime : TimeInterval = 0
    var checkpointMarkersCount = 0 {
        didSet{
            self.numberOfCheckpointMarkers.text = "\(checkpointMarkersCount)"
        }
    }
  
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }

    override func didMove(to view: SKView) {
        checkpointMarkersLabel.fontSize = 20
        checkpointMarkersLabel.fontName = "DevanagariSangamMN-Bold"
        checkpointMarkersLabel.color = .white
        checkpointMarkersLabel.position = CGPoint(x: 100, y: 50)
        addChild(checkpointMarkersLabel)
        
        numberOfCheckpointMarkers.fontSize = 30
        numberOfCheckpointMarkers.fontName = "DevanagariSangamMN-Bold"
        numberOfCheckpointMarkers.color = .white
        numberOfCheckpointMarkers.position = CGPoint(x: 40, y: 10)
        addChild(numberOfCheckpointMarkers)
      
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
      
        // TODO: This is a hacky way to create anchor after everything mostly likely ready..
        // Make this better later
        delay(0.5) {
          guard let viewController = self.viewController else {
            print("ViewController is not defined")
            return
          }
          for checkpoint in viewController.checkpoints {
            print("inserting checkpoint")
            print(checkpoint)
            self.createCheckpointMarkerAnchor(checkpoint: checkpoint)
          }
          
        }
    }
    
//    override func update(_ currentTime: TimeInterval) {
//      createCheckpointMarkerAnchor()
//    }
  
    func getUserLocation() -> CLLocation? {
        guard let location = locationManager.location else {
            print("user location not found")
            return nil
        }
        return location
    }
    
  func createCheckpointMarkerAnchor(checkpoint: CheckpointStruct) {
        print("Creating checkpoint marker anchor")
        guard let sceneView = self.view as? ARSKView else {
            print("Scene View is not defined")
            return
        }

        guard let userLocation = getUserLocation() else {
            print("User Location not defined")
            return
        }

        let delta_x = (userLocation.coordinate.longitude - checkpoint.coordinate.longitude) * cos(checkpoint.coordinate.latitude)
        let delta_z = (userLocation.coordinate.latitude - checkpoint.coordinate.latitude)
        let delta_y = userLocation.altitude - checkpoint.altitude
        let delta_x_meters = delta_x * 111320
        let delta_z_meters = delta_z * 111320
        let direction = simd_float4(Float(delta_x_meters), Float(delta_y), Float(delta_z_meters), 0)

//        print("direction")
//        print(direction)
//        print("distance") // for debugging
//        print(Float(userLocation.distance(from: CLLocation(coordinate: CLLocationCoordinate2D(latitude: checkpoint.coordinate.latitude, longitude: checkpoint.coordinate.longitude), altitude: checkpoint.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date()))))

        var translation = matrix_identity_float4x4
        translation.columns.3.x = direction.x
        translation.columns.3.y = direction.y
        translation.columns.3.z = direction.z

        // Create an anchor
        let anchor = ARAnchor(name: checkpoint.checkpointText, transform: translation)
    
        // Add the anchor
        sceneView.session.add(anchor: anchor)

        // Increment the counter
        checkpointMarkersCount += 1
    }
}
