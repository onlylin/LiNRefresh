//
//  MJRefreshStateHeader.swift
//  LNRefreshExample
//
//  Created by 林洁 on 2018/2/6.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

class LiNRefreshStateHeader: LiNRefreshHeader {
    
    var labelLeftInset: CGFloat = 0
    
    fileprivate var lastUpdatedTimeText: ((_ date: Date) -> String)?

    //MARK: - 懒加载
    lazy var stateTitles: Dictionary = {
        return Dictionary<LiNRefreshState, String>()
    }()
    
    lazy var stateLabel: UILabel = {
        let tmp:UILabel = UILabel.ln_label()
        self.addSubview(tmp)
        return tmp
    }()
    
    lazy var lastUpdatedTimeLabel: UILabel = {
        let tmp:UILabel = UILabel.ln_label()
        self.addSubview(tmp)
        return tmp
    }()
    
    //MARK: - 公共方法
    func setTitle(_ title: String?, forState state: LiNRefreshState) -> Void {
        if let tmp = title {
            self.stateTitles[state] = tmp
            self.stateLabel.text = self.stateTitles[self.state!]
        }
    }
    
    //MARK: - key的处理
    override var lastUpdatedTimeKey: String
    {
        didSet {
            //如果label隐藏了，就不需要处理了
            if self.lastUpdatedTimeLabel.isHidden {
                return
            }
            
            let lastUpdatedTime: Date? =  UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
            if self.lastUpdatedTimeText != nil {
                self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText!(lastUpdatedTime!)
                return
            }
            
            if (lastUpdatedTime != nil) {
                //获得年月日
                let calendar: Calendar = Calendar.current
                let unitFlags = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute] as Set
                
                let cmp1: DateComponents = calendar.dateComponents(unitFlags, from: lastUpdatedTime!)
                let cmp2: DateComponents = calendar.dateComponents(unitFlags, from: Date())
                
                //日期格式化
                let formatter: DateFormatter = DateFormatter()
                var isToday: Bool = false
                if cmp1.day == cmp2.day { //今天
                    formatter.dateFormat = " HH:mm"
                    isToday = true
                } else if cmp1.year == cmp2.year { //今年
                    formatter.dateFormat = "MM-dd HH:mm"
                } else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                let time: String = formatter.string(from: lastUpdatedTime!)
                
                //显示日期
                self.lastUpdatedTimeLabel.text = Bundle.localizedString(forKey: LiNRefreshHeaderLastTimeText) + (isToday ? Bundle.localizedString(forKey: LiNRefreshHeaderDateTodayText) : "") + time
            } else {
                self.lastUpdatedTimeLabel.text = Bundle.localizedString(forKey: LiNRefreshHeaderLastTimeText) + Bundle.localizedString(forKey: LiNRefreshHeaderNoneLastDateText)
            }
        }
    }
    
//    func setLastUpdatedTimeKey(key: String) -> Void {
//
//    }
    
    //MARK: - 覆盖父类的方法
    override func prepare() {
        super.prepare()
        
        //初始化边距
        self.labelLeftInset = CGFloat(LiNRefreshLabelLeftInset)
        
        //初始化文字
        self.setTitle(Bundle.localizedString(forKey: LiNRefreshHeaderIdleText), forState: LiNRefreshState.idel)
        self.setTitle(Bundle.localizedString(forKey: LiNRefreshHeaderPullingText), forState: LiNRefreshState.pulling)
        self.setTitle(Bundle.localizedString(forKey: LiNRefreshHeaderRefreshingText), forState: LiNRefreshState.refreshing)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if self.stateLabel.isHidden {
            return
        }
        
        let noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0
        
        if self.lastUpdatedTimeLabel.isHidden {
            //状态
            if noConstrainsOnStatusLabel {
                self.stateLabel.frame = self.bounds
            }
        } else {
            let stateLabelHeight = self.ln_h * 0.5
            //状态
            if noConstrainsOnStatusLabel {
                self.stateLabel.ln_x = 0
                self.stateLabel.ln_y = 0
                self.stateLabel.ln_w = self.ln_w
                self.stateLabel.ln_h = stateLabelHeight
            }
            
            //更新时间
            if self.lastUpdatedTimeLabel.constraints.count == 0 {
                self.lastUpdatedTimeLabel.ln_x = 0
                self.lastUpdatedTimeLabel.ln_y = stateLabelHeight
                self.lastUpdatedTimeLabel.ln_w = self.ln_w
                self.lastUpdatedTimeLabel.ln_h = self.ln_h - self.lastUpdatedTimeLabel.ln_y
            }
        }
    }
    
    //MARK: - 重写父类的属性
    override var state: LiNRefreshState?
    {
        didSet {
            if oldValue == state {
                return
            }
            //设置文字状态
            self.stateLabel.text = self.stateTitles[state!]
            
            //重新设置key(重新显示时间)
            self.lastUpdatedTimeKey = super.lastUpdatedTimeKey
        }
    }
    
//    override func setState(_ state: LNRefreshState) {
//        //检查刷新状态
//        let oldState: LNRefreshState = self.state!
//        if state == oldState {
//            return
//        }
//        super.setState(state)
//
//        //设置文字状态
//        self.stateLabel.text = self.stateTitles[state]
//
//        //重新设置key(重新显示时间)
//        self.lastUpdatedTimeKey = self.lastUpdatedTimeKey
//    }
    

}
