//
//  LNRefreshFooter.swift
//  LNRefreshExample
//
//  Created by 林洁 on 2018/2/7.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

public class LiNRefreshFooter: LiNRefreshComponent {

    override public var isHidden: Bool {
        didSet {
            
        }
    }
    
    //MARK: - 初始化
    init(_ refresh:@escaping LNRefreshComponentRefreshingClosure){
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.refreshingClosure = refresh
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 覆盖父类的方法
    override func prepare() {
        super.prepare()
        
        //设置高度
        self.ln_h = CGFloat(LiNRefreshFooterHeight)
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil {
            //监听scrollView的数据变化
            if (self.scrollView is UITableView) || (self.scrollView is UICollectionView) {
                //TODO data change
                self.scrollView?.ln_reloadDataClosure = { (totalCount: Int) -> Void in
                    self.isHidden = (totalCount == 0)
                }
            }
        }
    }
    
    
    //MARK: - 公共方法
    func endRefreshingWithNoMoreData() -> Void {
        DispatchQueue.main.async {
            self.state = LiNRefreshState.noMoreData
        }
    }
    
    func noticeNoMoreData() -> Void {
        self.endRefreshingWithNoMoreData()
    }
    
    func resetNoMoreData() -> Void {
        DispatchQueue.main.async {
            self.state = LiNRefreshState.idel
        }
    }
}
