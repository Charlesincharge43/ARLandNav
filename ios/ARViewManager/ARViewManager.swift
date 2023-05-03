//
//  ARViewManager.swift
//  ARLandNav

import CoreLocation

@objc(ARViewManager)
class ARViewManager: NSObject {

  @objc(addEvent:location:date:)
  func addEvent(_ name: String, location: String, date: NSNumber) -> Void {
   // Date is ready to use!
   print ("loo loo loo ive got some apples2222")
  }
  
  @objc(startARView:)
  func startARView(checkpoints: NSArray) -> Void {
    DispatchQueue.main.async {
      var checkpointsList: [CheckpointStruct] = []
      // Convert each dictionary to a CheckpointStruct object
      for dict in checkpoints {
        guard let checkpointDict = dict as? [String: Any],
              let isFake = checkpointDict["isFake"] as? Bool,
              let checkpointText = checkpointDict["checkpointText"] as? String,
              let latitude = checkpointDict["latitude"] as? Double,
              let longitude = checkpointDict["longitude"] as? Double,
              let altitude = checkpointDict["altitude"] as? Double else {
          continue
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let checkpoint = CheckpointStruct(isFake: isFake, checkpointText: checkpointText, coordinate: coordinate, altitude: altitude)
        checkpointsList.append(checkpoint)
      }
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ARViewController
      viewController.setCheckpoints(checkpointsList: checkpointsList)
      UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
  }

  @objc(stopARView)
  func stopARView() -> Void {
    print("Stopped AR view")
    DispatchQueue.main.async {
      guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
        return
      }
      
      rootViewController.dismiss(animated: true, completion: nil)
    }
  }
}
