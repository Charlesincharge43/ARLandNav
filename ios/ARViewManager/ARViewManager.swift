//
//  ARViewManager.swift
//  ARLandNav

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
    // Code to start the AR view would go here
  }

  @objc(stopARView)
  func stopARView() -> Void {
    print("Stopped AR view")
    // Code to stop the AR view would go here
  }
}
