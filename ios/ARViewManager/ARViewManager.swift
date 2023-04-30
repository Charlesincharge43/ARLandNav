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
  
  @objc(startARView)
  func startARView() -> Void {
    print("Starting AR view")
    DispatchQueue.main.async {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
      viewController.setCheckpoints(checkpointsList: [
        // 15th and Halsted address (the intersection where I take dog to the park)
        CheckpointStruct(isFake: false, checkpointText: "34", coordinate: CLLocationCoordinate2D(latitude: Double(41.861500), longitude: Double(-87.646750)), altitude: 183),
        // 834 W 15th Place, Chicago address (neighbor to the East)
        CheckpointStruct(isFake: false, checkpointText: "33", coordinate: CLLocationCoordinate2D(latitude: Double(41.861149), longitude: Double(-87.648018)), altitude: 183),
        // 838 W 15th Place, Chicago address
        CheckpointStruct(isFake: false, checkpointText: "32", coordinate: CLLocationCoordinate2D(latitude: Double(41.861150), longitude: Double(-87.648160)), altitude: 183),
        // 840 W 15th Place, Chicago address (neighbor to the west)
        CheckpointStruct(isFake: false, checkpointText: "32", coordinate: CLLocationCoordinate2D(latitude: Double(41.861150), longitude: Double(-87.648220)), altitude: 183),
      ])
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
