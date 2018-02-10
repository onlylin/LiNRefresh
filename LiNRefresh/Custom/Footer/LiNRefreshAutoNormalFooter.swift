//
//  LNRefreshAutoNormalFooter.swift
//  LNRefreshExample
//
//  Created by Lin on 2018/2/8.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

public class LiNRefreshAutoNormalFooter: LiNRefreshAutoStateFooter {
    
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle?
    {
        didSet {
            self.setNeedsLayout()
        }
    }

    //MARK: - 懒加载
    lazy var loadingView: UIActivityIndicatorView = {
        let tmp = UIActivityIndicatorView.init(activityIndicatorStyle: self.activityIndicatorViewStyle!)
        tmp.hidesWhenStopped = true
        self.addSubview(tmp)
        return tmp
    }()
    
    
    //MARK: - 覆盖父类的方法
    override func prepare() {
        super.prepare()
        
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if self.loadingView.constraints.count == 0{
            //圈圈
            var loadingCenterX: CGFloat = self.ln_w * 0.5
            if !self.isRefreshingTitleHidden {
                loadingCenterX -= self.stateLabel.ln_textWidth * 0.5 + self.labelLeftInset!
            }
            let loadingCenterY = self.ln_h * 0.5
            self.loadingView.center = CGPoint.init(x: loadingCenterX, y: loadingCenterY)
        }
    }
    
    //MARK: - 覆盖父类的属性
    override var state: LiNRefreshState? {
        didSet {
            if oldValue == self.state {
                return
            }
            
            //根据状态做事情
            if self.state == LiNRefreshState.noMoreData || self.state == LiNRefreshState.idel {
                self.loadingView.stopAnimating()
            } else if self.state == LiNRefreshState.refreshing {
                self.loadingView.startAnimating()
            }
        }
    }

}
