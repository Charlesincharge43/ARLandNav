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
    DispatchQueue.main.async {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
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
