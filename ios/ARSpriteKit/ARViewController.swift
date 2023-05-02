import UIKit
import ARKit
import CoreLocation
import RealityKit

struct CheckpointStruct {
    var isFake: Bool
    var checkpointText: String
    var coordinate: CLLocationCoordinate2D
    var altitude: CLLocationDistance
}

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var checkpoints: [CheckpointStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        let scene = LandNavScene()
        scene.viewController = self
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//  // THREE DIFFERENT WAYS OF RENDERING
//  // #1: Rendering image `checkpointmarker` as a plane
//        guard let checkpointMarkerImg = UIImage(named: "checkpointmarker") else {
//            return nil
//        }
//        let imgMaterial = SCNMaterial()
//        imgMaterial.diffuse.contents = checkpointMarkerImg

//        let plane = SCNPlane(width: 2, height: 2)
//        plane.materials = [imgMaterial]
//        let planeNode = SCNNode(geometry: plane)
//        planeNode.eulerAngles.x = .pi / 2
//      let rotationAnimation = CABasicAnimation(keyPath: "rotation")
//      rotationAnimation.toValue = NSValue(scnVector4: SCNVector4(x: 1, y: 0, z: 0, w: Float.pi * 2))
//      rotationAnimation.duration = 5 // Set the duration of the animation here
//      rotationAnimation.repeatCount = .infinity // Set the repeat count to infinity to make the animation loop
//
//      planeNode.addAnimation(rotationAnimation, forKey: "rotationAnimation")
      // For some reason the plane only shows the image at certain angles/rotations
      // So abandoning that approach for now
      
// ----------
//  // #2: Rendering a slim cylinder and a thin cube, with textures for 2 biggest sides
//  //  using image `checkpointmarkersign` (just the sign without the post part of the sprite)
//      let cylinderHeight: CGFloat = 4.5
//      let cylinderRadius: CGFloat = 0.05
//      let cylinder = SCNCylinder(radius: cylinderRadius, height: cylinderHeight)
//      let cylinderNode = SCNNode(geometry: cylinder)
//      cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
//
//      let signCube = SCNBox(width: 0.6, height: 0.6, length: 0.05, chamferRadius: 0)
//      let signCubeNode = SCNNode(geometry: signCube)
//      signCubeNode.position = SCNVector3(0, Float(cylinderHeight/2 + 0.3), 0)
//
//      let greyImgMaterial = SCNMaterial()
//      greyImgMaterial.diffuse.contents = UIColor.darkGray
//
//      guard let checkpointMarkerImg = UIImage(named: "checkpointmarkersign") else {
//          return nil
//      }
//      let checkpointSignImgMaterial = SCNMaterial()
//      checkpointSignImgMaterial.diffuse.contents = checkpointMarkerImg
//
//
//      signCubeNode.geometry?.materials = [checkpointSignImgMaterial, greyImgMaterial, checkpointSignImgMaterial, greyImgMaterial, greyImgMaterial, greyImgMaterial]
//
//      let signNode = SCNNode()
//      signNode.addChildNode(cylinderNode)
//      signNode.addChildNode(signCubeNode)
//      signNode.position = SCNVector3(0, cylinderHeight/2 + 0.3 - signCube.height/2, 0) // Place the sign in front of the camera and center it at the anchor position
      // ------------------------------------------
//  // #3: Render realityKit model
      
//      let referenceObjectURL = Bundle.main.url(forResource: "checkpointsign", withExtension: "reality")
      guard let checkpointsScene = SCNScene(named: "checkpointsignmodel.usdz", inDirectory: "Models.scnassets")
          else { fatalError("Unable to load scene file.") }
      let sceneNode = checkpointsScene.rootNode
      
      // ------------------------------------------
      // Extra: label node showing some floating 3d words for the checkpoint text
        let labelNode = SCNNode()
        let text = SCNText(string: anchor.name, extrusionDepth: 0)
        text.font = UIFont(name: "HelveticaNeue-Bold", size: 0.2)
        text.firstMaterial?.diffuse.contents = UIColor.black
        labelNode.geometry = text
        labelNode.position = SCNVector3(0.01, Float(4), 0.01)
//      signNode.addChildNode(labelNode)
      // ------------------------------------------
      // Extra: blue box just as reference
      let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
      box.firstMaterial?.diffuse.contents = UIColor.blue
      let boxNode = SCNNode(geometry: box)
        
      
      
      
      
    
      
      
      
      let parentNode = SCNNode()
//        parentNode.addChildNode(signNode)
      parentNode.addChildNode(boxNode)
      parentNode.addChildNode(labelNode)
      parentNode.addChildNode(sceneNode)
      return parentNode
    }
  
  func setCheckpoints(checkpointsList: [CheckpointStruct]) {
    checkpoints = checkpointsList
  }
}
