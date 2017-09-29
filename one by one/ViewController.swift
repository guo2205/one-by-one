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
        cell.selectionStyle = UITableViewCellSelectionStyle.none  //取消选中效果
        cell.textLabel?.text = areas[indexPath.row]
        cell.imageView?.image = ResizeImage(image: (cell.imageView?.image)!, targetSize: CGSize(width:12, height: 12))
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //按钮动画
        missButton.transform = CGAffineTransform(scaleX:0,y:0)
        UIView.animate(withDuration:  1){
            self.missButton.transform = CGAffineTransform.identity
        }
        
        //按钮圆角
        missButton.layer.cornerRadius = 16
    
        //添加点击事件
        missButton.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target:self, action:#selector(ViewController.tapClick(sender:)))
        missButton.addGestureRecognizer(tap)
        
        
        //网络请求加载table数据
        let provider = MoyaProvider<netWorkService>()
        provider.request(.list) { (result) in
            switch result {
            case let .success(moyaResponse):
                self.areas.removeAll()
                let json:[String:Any] = try! moyaResponse.mapJSON() as! [String:Any]
                let message = json["message"] as! [String:Any]
                let data = message["data"] as! [[String:Any]]
                for index in 0...data.count - 1 {
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
    
    @objc private func tapClick(sender:UITapGestureRecognizer){
        let alertController = UIAlertController()
        alertController.title = "想小哥哥了，要告诉他么?"
        alertController.message = "piu~piu~piu~"
        let okAction = UIAlertAction(title: "是的", style: UIAlertActionStyle.destructive) {
            (action: UIAlertAction!) -> Void in
            let provider = MoyaProvider<netWorkService>()
            provider.request(.miss) { (result) in
                switch result {
                case .success(_):
                    print("已收到")
                case .failure:
                    print("错误")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "手滑了", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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

