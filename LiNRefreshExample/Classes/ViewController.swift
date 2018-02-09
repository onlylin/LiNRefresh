//
//  ViewController.swift
//  LNRefreshExample
//
//  Created by 林洁 on 2018/2/7.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView: UITableView = {
        let tmpTableView = UITableView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style:UITableViewStyle.plain)
        return tmpTableView
    }()
    
    var dataArray: Array<Int> = []
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.dataArray = self.initArray()
        
        self.title = "LiNRefresh"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    
        self.tableView.ln_header = LiNRefreshNormalHeader{
            self.count = 0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                self.dataArray = self.initArray()
                self.tableView.ln_header?.endRefreshing()
                self.tableView.reloadData()
            })
            self.tableView.ln_footer?.resetNoMoreData()
        }
        
        self.tableView.ln_footer = LiNRefreshAutoNormalFooter{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                for _ in 1...5 {
                    self.dataArray.append(Int(arc4random()))
                }
                self.tableView.reloadData()
                
                if self.count > 0 {
                    self.tableView.ln_footer?.noticeNoMoreData()
                }else {
                    self.tableView.ln_footer?.endRefreshing()
                }
                self.count += 1
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initArray() -> Array<Int> {
        var tmp: Array<Int> = []
        for _ in 1...10 {
            tmp.append(Int(arc4random()))
        }
        return tmp
    }
    
    //MARK: - UITableView Delegate And DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cellId")
        }
        cell?.textLabel?.text = String(self.dataArray[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "测试标题"
    }
    
    
}

