//
//  Scene.swift
//  ARSpriteKit
//
//  Created by Esteban Herrera on 7/4/17.
//  Copyright © 2017 Esteban Herrera. All rights reserved.
//

import SpriteKit
import ARKit
import CoreLocation

class Scene: SKScene, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
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
      
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    override func update(_ currentTime: TimeInterval) {
      createGhostAnchor()
    }
  
    func getUserLocation() -> CLLocation? {
        guard let location = locationManager.location else {
            print("user location not found")
            return nil
        }
        return location
    }
    
    func createGhostAnchor() {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        if (ghostCount > 0) {
            return
        }
        if (sceneView.session.currentFrame == nil) {
            print("current Frame doesnt exist, skipping3")
            return
        }

        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }

        guard let userLocation = getUserLocation() else {
            return
        }
              // 15th and Halsted address (the intersection where I take dog to the park)
//              let ghostLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(41.861500), longitude: Double(-87.646750)), altitude: userLocation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    
////        // 838 W 15th Place, Chicago address
//        let ghostLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(41.861150), longitude: Double(-87.648160)), altitude: userLocation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    
        // 840 W 15th Place, Chicago address (neighbor to the west)
//        let ghostLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(41.861150), longitude: Double(-87.648220)), altitude: userLocation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
//        let distanceInMeters = Float(userLocation.distance(from: ghostLocation))
    
    // 834 W 15th Place, Chicago address (neighbor to the East)
        let ghostLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(41.861149), longitude: Double(-87.648018)), altitude: userLocation.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())

        let delta_x = (userLocation.coordinate.longitude - ghostLocation.coordinate.longitude) * cos(ghostLocation.coordinate.latitude)
        let delta_z = (userLocation.coordinate.latitude - ghostLocation.coordinate.latitude)
        let delta_y = userLocation.altitude - ghostLocation.altitude
        let delta_x_meters = delta_x * 111320
        let delta_z_meters = delta_z * 111320
        let direction = simd_float4(Float(delta_x_meters), Float(delta_y), Float(delta_z_meters), 0)

//        print("direction")
//        print(direction)

        var translation = matrix_identity_float4x4
        translation.columns.3.x = direction.x
        translation.columns.3.y = direction.y
        translation.columns.3.z = direction.z

        // Create an anchor
        let anchor = ARAnchor(transform: translation)
    
        // Add the anchor
        sceneView.session.add(anchor: anchor)

        // Increment the counter
        ghostCount += 1
    }
}
