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
      let cylinderHeight: CGFloat = 4.2
      let cylinderRadius: CGFloat = 0.05
      let cylinder = SCNCylinder(radius: cylinderRadius, height: cylinderHeight)
      let cylinderNode = SCNNode(geometry: cylinder)
      cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown

      let signCube = SCNBox(width: 0.6, height: 0.6, length: 0.05, chamferRadius: 0)
      let signCubeNode = SCNNode(geometry: signCube)
      signCubeNode.position = SCNVector3(0, Float(cylinderHeight/2 + 0.3), 0)

      let greyImgMaterial = SCNMaterial()
      greyImgMaterial.diffuse.contents = UIColor.darkGray

      guard let checkpointMarkerImg = UIImage(named: "checkpointmarkersign") else {
          return nil
      }
      let checkpointSignImgMaterial = SCNMaterial()
      checkpointSignImgMaterial.diffuse.contents = checkpointMarkerImg


      signCubeNode.geometry?.materials = [checkpointSignImgMaterial, greyImgMaterial, checkpointSignImgMaterial, greyImgMaterial, greyImgMaterial, greyImgMaterial]
      
      // 2 label nodes for the signs
      let labelNode1 = SCNNode()
      let text = SCNText(string: anchor.name, extrusionDepth: 0.01)
      text.font = UIFont(name: "HelveticaNeue-Bold", size: 0.2)
      text.firstMaterial?.diffuse.contents = UIColor.black
      labelNode1.geometry = text
      labelNode1.position = SCNVector3(0.01, Float(1.5), 0.03)
      
      let labelNode2 = SCNNode()
      labelNode2.geometry = text
      labelNode2.position = SCNVector3(0.01, Float(1.5), -0.03)
      labelNode2.scale = SCNVector3(-1, 1, 1)

      let signNode = SCNNode()
      signNode.addChildNode(cylinderNode)
      signNode.addChildNode(signCubeNode)
      signNode.addChildNode(labelNode1)
      signNode.addChildNode(labelNode2)
      signNode.position = SCNVector3(0, cylinderHeight/2 - 0.3 + signCube.height/2, 0)
      // Get the camera node
      let cameraNode = sceneView.pointOfView
      if cameraNode != nil {
        let anchorPos = SCNVector3Make(
          anchor.transform.columns.3.x,
          anchor.transform.columns.3.y,
          anchor.transform.columns.3.z
        )

        // Get the position of the camera node in world coordinates
        let cameraPosition = cameraNode!.worldPosition
        // Calculate the vector pointing from the camera node to the node
        let vectorToNode = SCNVector3(x: anchorPos.x - cameraPosition.x,
                                      y: anchorPos.y - cameraPosition.y,
                                      z: anchorPos.z - cameraPosition.z)
        // Calculate the rotation needed to face the node
        let rotationMatrix = SCNMatrix4MakeRotation(-atan2(vectorToNode.x, vectorToNode.z), 0, 1, 0)

        // Calculate the rotation needed to face the node
        let rotationAngle = atan2(vectorToNode.x, vectorToNode.z)
        let rotation = SCNVector4(x: 0, y: 1, z: 0, w: rotationAngle)

        // Set the rotation of the node
        signNode.rotation = rotation
      }

      let parentNode = SCNNode()
      parentNode.addChildNode(signNode)
      return parentNode
    }
  
  func setCheckpoints(checkpointsList: [CheckpointStruct]) {
    checkpoints = checkpointsList
  }
}
