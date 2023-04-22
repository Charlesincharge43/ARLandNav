// SwiftModuleTest.swift

@objc(SwiftModuleTest)
class SwiftModuleTest: NSObject {

 @objc(addEvent:location:date:)
 func addEvent(_ name: String, location: String, date: NSNumber) -> Void {
   // Date is ready to use!
   print ("loo loo loo ive got some apples")
 }

 @objc
 func constantsToExport() -> [String: Any]! {
   return ["someKey": "someValue"]
 }

}
