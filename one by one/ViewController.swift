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
    @IBOutlet weak var missButton: UIImageView!
    var areas:[String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = areas[indexPath.row]
        
        //cell.imageView?.frame.height = 20
        cell.imageView?.image = ResizeImage(image: (cell.imageView?.image)!, targetSize: CGSize(width:12, height: 12))
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missButton.transform = CGAffineTransform(scaleX:0,y:0)
        UIView.animate(withDuration:  1){
            self.missButton.transform = CGAffineTransform.identity
        }
        missButton.layer.cornerRadius = 16
        
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
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

