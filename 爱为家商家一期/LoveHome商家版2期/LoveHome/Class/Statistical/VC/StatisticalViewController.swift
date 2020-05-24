//
//  StatisticalViewController.swift
//  LoveHome
//
//  Created by MRH-MAC on 15/11/13.
//  Copyright © 2015年 卡莱博尔. All rights reserved.
//

import UIKit

class StatisticalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private lazy var myTbaleView :UITableView! = {
        
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "testCell")
        return tableView
    }()
    var dataSource : [AnyObject]!
    var dic : [String:Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.view.addSubview(self.myTbaleView)

        // Do any additional setup after loading the view.
    }
    
    func setUpDB()
    {
        dataSource = [1,2,3]
        dataSource.append("123123")
        

        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("testCell")!
        cell.detailTextLabel?.text = String(format: "%ld", arguments: [indexPath.row])
        
        return cell

    }
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        // 点击的themeCell,美辑cell
//        if tableView === albumTableView {
//            let theme = self.themes!.list![indexPath.row]
//            let themeVC = ThemeViewController()
//            themeVC.themeModel = theme
//            navigationController?.pushViewController(themeVC, animated: true)
//            
//        } else { // 点击的美天TableView里的美辑cell
//            
//            let event = self.everyDays!.list![indexPath.section]
//            if indexPath.row == 1 {
//                let themeVC = ThemeViewController()
//                themeVC.themeModel = event.themes?.last
//                navigationController!.pushViewController(themeVC, animated: true)
//                
//            } else { // 点击的美天的cell
//                let eventVC = EventViewController()
//                let event = self.everyDays!.list![indexPath.section]
//                eventVC.model = event.events![indexPath.row]
//                navigationController!.pushViewController(eventVC, animated: true)
//            }
//        }
//    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
