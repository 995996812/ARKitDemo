//
//  ARViewController.swift
//  3DARKit
//
//  Created by 王鹏华 on 2017/6/13.
//  Copyright © 2017年 Hell. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    // #MARK: - lazy
    lazy var arSession: ARSession = {
        ()-> ARSession in
        let tempSession = ARSession()
        
       return tempSession
        
    }()
    
    // #MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
            
        //设置代理
        sceneView.delegate = self
        
        sceneView.session = arSession
        
        sceneView.automaticallyUpdatesLighting = true
        //ARkit统计信息
        sceneView.showsStatistics = true
        
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle("退 出", for: .normal)
        button.addTarget(self, action: #selector(exitCurrentController), for: .touchUpInside)
        self.sceneView.addSubview(button)
    }
    
    @objc func exitCurrentController(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 创建一个追踪设备配置（ARWorldTrackingSessionConfiguration主要负责传感器追踪手机的移动和旋转）
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        // 开始启动ARSession会话（启动AR）
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 暂停ARSession会话
        sceneView.session.pause()
    }
    // #MARK: - 触屏响应方法
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("开启点击屏幕")
        //使用模型创建节点(scn文件是一个基于3D建模的文件,使用3DMax软件可以创建,这里有一个系统默认的3D飞机)
        let scene = SCNScene(named: "art.scnassets/cup/cup.scn")!
        //获取节点
        let shipNode = scene.rootNode.childNode(withName: "cup", recursively: true);
        //配置物体的远近,即调整摄像头的距离
        shipNode?.position = SCNVector3Make(0, -0.5, -1)
        //设置ARKit的场景为Scenekit的当前场景
        sceneView.scene.rootNode.addChildNode(shipNode!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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

/*
 <1> ARKit 框架中中显示3DAR的视图为 ARSCNView 继承于 SceneKit框架中SCNView  SCNView 继承于UIKit的UIView
     所以我们只需要将ARSCNView当作UIView来使用即可,只不过这个SCNView的作用是显示一个3D的场景,ARSCNView的作用也是显示一个3D场景,这个3D场景是用来捕捉到的现实世界的图形构成的
 <2> 同UIView一样,都一样一个会话的Session 为ARSession
     ARKit负责将现实世界转变为一个3D场景-->分为两个环节1.由ARCamera负责捕捉摄像头画面,由ARSession负责搭建3D场景
 <3>每一个虚拟的物体都是一个节点SCNNode,每一个节点构成了一个场景SCNScene,无数个场景构成了3D世界
 
 
 */
