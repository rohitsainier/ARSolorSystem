//
//  ViewController.swift
//  SolorSystem
//
//  Created by Rohit Saini on 23/07/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        createSolorSystem()
    }
    
    func createSolorSystem(){
        //parent Node
        let parentNode = SCNNode()
        parentNode.position.z = -10
        
        
        //planets
        let mercury = Planet(name: "mercury", radius: 0.14, rotation: 32.degreesToRadians, color: .orange, sunDistance: 1.3)
        let venus = Planet(name: "venus", radius: 0.35, rotation: 10.degreesToRadians, color: .cyan, sunDistance: 2)
        let earth = Planet(name: "earth", radius: 0.5, rotation: 18.degreesToRadians, color: .blue, sunDistance: 7)
        let saturn = Planet(name: "saturn", radius: 1, rotation: 12.degreesToRadians, color: .brown, sunDistance: 12)
      
        
        let planets = [mercury, venus, earth, saturn]
        for planet in planets{
            parentNode.addChildNode(createNode(from: planet))
        }
        
        //lights
        let light = SCNLight()
        light.type = .omni
        parentNode.light = light
        
        
        //stars
        let stars = SCNParticleSystem(named: "stars.scnp", inDirectory: nil)!
        parentNode.addParticleSystem(stars)
        
        //sun
        let sun = SCNParticleSystem(named: "sun.scnp", inDirectory: nil)!
        parentNode.addParticleSystem(sun)
        
        
        sceneView.scene.rootNode.addChildNode(parentNode)
    }
    
    
    func createNode(from planet : Planet) -> SCNNode {
        
        let parentNode = SCNNode()
        let rotateAction = SCNAction.rotateBy(x: 0, y: planet.rotation, z: 0, duration: 1)
        parentNode.runAction(.repeatForever(rotateAction))
        let sphereGeometry = SCNSphere(radius: planet.radius)
        sphereGeometry.firstMaterial?.diffuse.contents = planet.color
        let planetNode = SCNNode(geometry: sphereGeometry)
        planetNode.position.z = -planet.sunDistance
        planetNode.name = planet.name
        parentNode.addChildNode(planetNode)
        
        if planet.name == "saturn" {
            let ringGeometry = SCNTube(innerRadius: 1.2, outerRadius: 1.8, height: 0.05)
            ringGeometry.firstMaterial?.diffuse.contents = UIColor.darkGray
            let ringNode = SCNNode(geometry: ringGeometry)
            ringNode.eulerAngles.x = Float(10.degreesToRadians)
            planetNode.addChildNode(ringNode)
        }
        if planet.name == "earth"{
            //moon rotating around the earth
            let moon = Planet(name: "moon", radius: 0.4, rotation: 40.degreesToRadians, color: .white, sunDistance: 1)
            let rotateAction = SCNAction.rotateBy(x: 0, y: moon.rotation, z: 0, duration: 1)
            planetNode.runAction(.repeatForever(rotateAction))
            let sphereGeometry = SCNSphere(radius: moon.radius)
            sphereGeometry.firstMaterial?.diffuse.contents = moon.color
            let moonNode = SCNNode(geometry: sphereGeometry)
            moonNode.position.z = -moon.sunDistance
            moonNode.name = moon.name
            planetNode.addChildNode(moonNode)
        }
        
        
        return parentNode
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
