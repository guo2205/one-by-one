//
//  LogController.swift
//  one by one
//
//  Created by 郭凌峰 on 2017/10/5.
//  Copyright © 2017年 郭凌峰. All rights reserved.
//
import UIKit
import Moya
import SwiftDate

class LogController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    var listData:[String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cell.selectionStyle = UITableViewCellSelectionStyle.none  //取消选中效果
        cell.textLabel?.text = listData[indexPath.row]
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = false
        //设置侧滑返回手势操作
        let target = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let pan = UIPanGestureRecognizer(target:target,
                                         action:Selector(("handleNavigationTransition:")))
        pan.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(pan)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        
        let provider = MoyaProvider<netWorkService>()
        provider.request(.signlist) { (result) in
            switch result {
                case let .success(moyaResponse):
                    self.listData.removeAll()
                    let rome = Region(tz: TimeZoneName.europeRome, cal: CalendarName.gregorian, loc: LocaleName.italian)
                    let json:[String:Any] = try! moyaResponse.mapJSON() as! [String:Any]
                    let message = json["message"] as! [String:Any]
                    let data = message["data"] as! [[String:Any]]
                    for index in 0...data.count - 1 {
                        let item = data[index]
                        //2017-09-30T03:45:09.000Z
                        let time = item["ctime"] as! String
                        let date_custom = try! DateInRegion(string: time, format: .custom("yyyy-MM-dd'T'HH:mm:ss'.000Z'") , fromRegion: rome)
                        self.listData.append(date_custom.string(custom:"yyyy-MM-dd HH:mm:ss"))
                    }
                    self.tableView.reloadData()
                case .failure:
                    print("错误")
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 {
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
