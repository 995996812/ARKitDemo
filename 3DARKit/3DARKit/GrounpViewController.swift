//
//  GrounpViewController.swift
//  3DARKit
//
//  Created by 王鹏华 on 2017/6/15.
//  Copyright © 2017年 Hell. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum ShowType {
    case grounp
    case rotate
    case dynamic
}

class GrounpViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate{
    // MARK: - 懒加载
    // 配置追踪会话环境
    public var type: ShowType?
    
    lazy var sessionConfig :ARSessionConfiguration = {
        ()-> ARSessionConfiguration in
        //1. 创建世界追踪会话配置(使用ARWorldTrackingSessionConfiguration效果会更加好),需要A9芯片的支持
        let tempConfig: ARWorldTrackingSessionConfiguration = ARWorldTrackingSessionConfiguration()
        //2. 设置追踪方向
        tempConfig.planeDetection = .horizontal
        //3. 调整灯光为自适应
        tempConfig.isLightEstimationEnabled = true
        
        return tempConfig
    }()
    
    //拍摄会话
    lazy var arSession: ARSession = {
        ()-> ARSession in
        let tempSession: ARSession = ARSession()
        tempSession.delegate = self
        return tempSession
    }()
    
    //AR视图
    lazy var arSCNView: ARSCNView = {
       ()-> ARSCNView in
        let tempView: ARSCNView = ARSCNView(frame: self.view.bounds)
        //设置代理  捕捉平地会在代理回调中
        tempView.delegate = self
        //设置视图会话
        tempView.session = self.arSession
        //自动刷新灯光
        tempView.automaticallyUpdatesLighting = true
        
        return tempView;
    }()
    
    var planeNode: SCNNode?
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 44, height: 44))
        
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitle("退 出", for: .normal)
        button.addTarget(self, action: #selector(exitCurrentController), for: .touchUpInside)
        self.arSCNView.addSubview(button)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 1.将AR视图添加到当前视图
        self.view.addSubview(self.arSCNView)
        // 2.开启AR会话
        self.arSession.run(self.sessionConfig)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // #MARK: - 交互式方法
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if type == ShowType.dynamic {//让物体跟随相机移动
            
//            let scene: SCNScene = SCNScene(named: "art.scnassets/lamp/lamp.scn")!
//
//            self.planeNode = scene.rootNode.childNodes[0]
//
//            //模型过大,缩放一下模型
//            self.planeNode!.scale = SCNVector3Make(0.5, 0.5, 0.5)
//            self.planeNode!.position = SCNVector3Make(0, -15, -15)
//            //因为根节点是由多个子节点所组成的,所以缩放模型的时候子节点的大小也要跟着缩放,否则上面的改动会无效
//            for node: SCNNode in self.planeNode!.childNodes{
//
//                node.scale = SCNVector3Make(0.5, 0.5, 0.5)
//                node.position = SCNVector3Make(0, -15, -15)
//            }
//
//            self.planeNode?.position = SCNVector3Make(0, 0, -25)
//
//            self.arSCNView.scene.rootNode.addChildNode(self.planeNode!)
//
//            //旋转的核心动画
//            let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
//            //设置旋转周期
//            rotationAnimation.duration = 30
//            //设置旋转角度为绕Y轴一周
//            rotationAnimation.toValue = SCNVector4Make(0, 1, 0, .pi * 2)
//            //无限循环
//            rotationAnimation.repeatCount = .greatestFiniteMagnitude
//            //开始旋转
//            self.planeNode!.addAnimation(rotationAnimation, forKey: "moon rotation around earth")
            let scene = SCNScene(named: "art.scnassets/lamp/lamp.scn")
            
            let lampNode = scene?.rootNode.childNodes[0]
            
            self.planeNode = lampNode
            
            self.planeNode?.position = SCNVector3Make(0, -0.5, -1)
            //将空节点添加到相机的根节点
            self.arSCNView.scene.rootNode.addChildNode(lampNode!)
            
            //旋转的核心动画
            let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
            //设置旋转周期
            rotationAnimation.duration = 30
            //设置旋转角度为绕Y轴一周
            rotationAnimation.toValue = SCNVector4Make(0, 1, 0, .pi * 2)
            //无限循环
            rotationAnimation.repeatCount = .greatestFiniteMagnitude
            //开始旋转
            lampNode!.addAnimation(rotationAnimation, forKey: "moon rotation around earth")
        }
        
        if type == ShowType.rotate {
            let scene = SCNScene(named: "art.scnassets/lamp/lamp.scn")
            
            let lampNode = scene?.rootNode.childNodes[0]
            
            self.planeNode = lampNode
            
            self.planeNode?.position = SCNVector3Make(0, 0, -1)
            //创建一个空节点
            let node1 = SCNNode()
            //空节点的位置与相机的节点位置一致
            node1.position = self.arSCNView.scene.rootNode.position
            //将空节点添加到相机的根节点
            self.arSCNView.scene.rootNode.addChildNode(node1)
            
            node1.addChildNode(lampNode!)
            
            //旋转的核心动画
            let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "rotation")
            //设置旋转周期
            rotationAnimation.duration = 30
            //设置旋转角度为绕Y轴一周
            rotationAnimation.toValue = SCNVector4Make(0, 1, 0, .pi * 2)
            //无限循环
            rotationAnimation.repeatCount = .greatestFiniteMagnitude
            //开始旋转
            node1.addAnimation(rotationAnimation, forKey: "moon rotation around earth")
        }
    }
    
    @objc func exitCurrentController(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension GrounpViewController{
    
    // #MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if type != ShowType.grounp || type == nil {
            
            return
        }
        
        if anchor.isMember(of: ARPlaneAnchor.self){//捕捉到平地
            print("捕捉到平地")
            
            //获取捕捉到平地锚点
            let planeAnchor: ARPlaneAnchor = anchor as! ARPlaneAnchor
            
            //创建一个3D物体模型
            let plane = SCNBox(width: CGFloat(planeAnchor.extent.x * 0.3), height: 0, length: CGFloat(planeAnchor.extent.x * 0.3), chamferRadius: 0)
            //渲染模型
            plane.firstMaterial?.diffuse.contents = UIColor.green
            //创建基于3D物体模型的节点
            let planeNode = SCNNode(geometry: plane)
            //设置节点位置为普主导平地的锚点的中心位置
            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            node.addChildNode(planeNode)
            
            //当捕捉到平地时,2s之后开始在平地上添加一个3D模型
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                
                let scene = SCNScene(named: "art.scnassets/vase/vase.scn")
                
                let vaseNode = scene?.rootNode.childNodes[0]
                
                vaseNode?.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
                
                node.addChildNode(vaseNode!)
            })
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
        print("刷新中")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        print("节点更新")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
        print("节点移除")
    }
    
}

extension GrounpViewController{
    // #MARK: - ARSessionDelegate
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if type != ShowType.dynamic {
            return
        }
        /*CGFloat(frame.camera.transform.columns[3].x),frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z
         */
        if (self.planeNode != nil) {
            
            
//        let aaaa: SCNVector4 = SCNVector4(frame.camera.transform.columns[3])
//        self.planeNode!.position =
            
        }
        
        print("相机移动")
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
        print("添加锚点")
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        print("刷新锚点")
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        
        print("移除锚点")
    }
    
}

