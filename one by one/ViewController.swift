//
//  ViewController.swift
//  one by one
//
//  Created by 郭凌峰 on 2017/9/18.
//  Copyright © 2017年 郭凌峰. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var areas:[String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = areas[indexPath.row]
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let provider = MoyaProvider<netWorkService>()
        provider.request(.list) { (result) in
            switch result {
            case let .success(moyaResponse):
                self.areas.removeAll()
                let json:[String:Any] = try! moyaResponse.mapJSON() as! [String:Any]
                let message = json["message"] as! [String:Any]
                let data = message["data"] as! [[String:Any]]
                for index in 0...data.count - 1{
                    let item = data[index]
                    let text = item["text"]
                    self.areas.append(text as! String)
                }
                self.tableView.reloadData()
            case .failure:
                print("错误")
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

