//
//  ViewController.swift
//  3DARKit
//
//  Created by 王鹏华 on 2017/6/13.
//  Copyright © 2017年 Hell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(getFilePath())
        let path = getFilePath()
        
        var filePath = path + "/appInfo.txt"
        var info  = "this is test text"
        
        do{
            try info.write(toFile: filePath, atomically: true, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
        }catch{
            
            print("写入失败")
        }
        
        let fileManager = FileManager.default
        var file: Any?
        
        do{
            let fileList = try fileManager.contentsOfDirectory(atPath: path)
            file = fileList
            
        }catch{
            
            print("读取失败")
        }
        
        print(file ?? String())
        
    }
    
    
    @IBAction func openARFuncation(_ sender: UIButton) {
        
        print("开启AR功能")
        
        let vc = ARViewController.init(nibName: "ARViewController", bundle: nil)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func openGrounpVC(_ sender: Any) {
        
        let vc = GrounpViewController()
        vc.type = ShowType.grounp
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func openRotate(_ sender: Any) {
        
        let vc = GrounpViewController()
        vc.type = ShowType.rotate
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func openMove(_ sender: Any) {
        let vc = GrounpViewController()
        vc.type = ShowType.dynamic
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    func getFilePath() ->String {
        return Bundle.main.path(forResource: "art", ofType: "scnassets")!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
