//
//  LNRefreshAutoStateFooter.swift
//  LNRefreshExample
//
//  Created by Lin on 2018/2/8.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

public class LiNRefreshAutoStateFooter: LiNRefreshAutoFooter {
    //文字和圈圈、箭头的距离
    var labelLeftInset: CGFloat?
    //隐藏刷新状态的文字
    var isRefreshingTitleHidden: Bool = false

    //MARK :- 懒加载
    // 显示刷新状态的label
    lazy var stateLabel: UILabel = {
       let tmp = UILabel.ln_label()
        self.addSubview(tmp)
        return tmp
    }()
    
    lazy var stateTitles: Dictionary = {
        return Dictionary<LiNRefreshState, String>()
    }()
    
    
    //MARK: - 公共方法
    func setTitle(title: String, forState state: LiNRefreshState) -> Void {
        self.stateTitles[state] = title
        self.stateLabel.text = self.stateTitles[self.state!]
    }
    
    //MARK: - 私有方法
    @objc private func stateLabelClick() -> Void {
        if self.state == LiNRefreshState.idel {
            self.beginRefreshing()
        }
    }
    
    //MARK: - 覆盖父类的方法
    override func prepare() {
        super.prepare()
        
        //初始化间距
        self.labelLeftInset = CGFloat(LiNRefreshLabelLeftInset)
        
        //初始化stateLabel文字
        self.setTitle(title: Bundle.localizedString(forKey: LiNRefreshAutoFooterIdleText), forState: LiNRefreshState.idel)
        self.setTitle(title: Bundle.localizedString(forKey: LiNRefreshAutoFooterRefreshingText), forState: LiNRefreshState.refreshing)
        self.setTitle(title: Bundle.localizedString(forKey: LiNRefreshAutoFooterNoMoreDataText), forState: LiNRefreshState.noMoreData)
        
        //监听stateLabel
        self.stateLabel.isUserInteractionEnabled = true
        self.stateLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.stateLabelClick)))
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if self.stateLabel.constraints.count == 0 {
            //状态标签
            self.stateLabel.frame = self.bounds
        }
    }
    
    //MARK: - 覆盖父类属性
    override var state: LiNRefreshState? {
        didSet {
            if oldValue == self.state {
                return
            }
            
            if self.isRefreshingTitleHidden && self.state == LiNRefreshState.refreshing {
                self.stateLabel.text = nil
            }else {
                self.stateLabel.text = self.stateTitles[self.state!]
            }
        }
    }

}
