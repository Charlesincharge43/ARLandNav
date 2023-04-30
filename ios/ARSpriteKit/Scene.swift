//
//  Scene.swift
//  ARSpriteKit
//
//  Created by Charles Long on 4/29/23.
//

import SpriteKit
import ARKit
import CoreLocation

class Scene: SKScene, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let checkpointMarkersLabel = SKLabelNode(text: "Checkpoint Markers")
    let numberOfCheckpointMarkers = SKLabelNode(text: "0")
    var creationTime : TimeInterval = 0
    var checkpointMarkersCount = 0 {
        didSet{
            self.numberOfCheckpointMarkers.text = "\(checkpointMarkersCount)"
        }
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
    }
    
    override func update(_ currentTime: TimeInterval) {
      createCheckpointMarkerAnchor()
    }
  
    func getUserLocation() -> CLLocation? {
        guard let location = locationManager.location else {
            print("user location not found")
            return nil
        }
        return location
    }
    
    func createCheckpointMarkerAnchor() {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        if (checkpointMarkersCount > 0) {
            return
        }

        guard let userLocation = getUserLocation() else {
            return
        }
              // 15th and Halsted address (the intersection where I take dog to the park)
              let checkpointMarkerLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(41.861500), longitude: Double(-87.646750)), altitude: userLocation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    
////        // 838 W 15th Place, Chicago address
//        let checkpointMarkerLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(41.861150), longitude: Double(-87.648160)), altitude: userLocation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    
        // 840 W 15th Place, Chicago address (neighbor to the west)
//        let checkpointMarkerLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(41.861150), longitude: Double(-87.648220)), altitude: userLocation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
//        let distanceInMeters = Float(userLocation.distance(from: checkpointMarkerLocation))
    
    // 834 W 15th Place, Chicago address (neighbor to the East)
//        let checkpointMarkerLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(41.861149), longitude: Double(-87.648018)), altitude: userLocation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())

        let delta_x = (userLocation.coordinate.longitude - checkpointMarkerLocation.coordinate.longitude) * cos(checkpointMarkerLocation.coordinate.latitude)
        let delta_z = (userLocation.coordinate.latitude - checkpointMarkerLocation.coordinate.latitude)
        let delta_y = userLocation.altitude - checkpointMarkerLocation.altitude
        let delta_x_meters = delta_x * 111320
        let delta_z_meters = delta_z * 111320
        let direction = simd_float4(Float(delta_x_meters), Float(delta_y), Float(delta_z_meters), 0)

//        print("direction")
//        print(direction)
//        print("distance") // for debuggin
//        print(Float(userLocation.distance(from: checkpointMarkerLocation)))

        var translation = matrix_identity_float4x4
        translation.columns.3.x = direction.x
        translation.columns.3.y = direction.y
        translation.columns.3.z = direction.z

        // Create an anchor
        let anchor = ARAnchor(transform: translation)
    
        // Add the anchor
        sceneView.session.add(anchor: anchor)

        // Increment the counter
        checkpointMarkersCount += 1
    }
}
