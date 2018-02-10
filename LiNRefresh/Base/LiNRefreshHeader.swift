//
//  LNRefreshHeader.swift
//  TourQ
//
//  Created by Lin on 2018/2/5.
//  Copyright © 2018年 Lin. All rights reserved.
//

import UIKit

public class LiNRefreshHeader: LiNRefreshComponent {
    
    fileprivate var insetTopDelta: CGFloat = 0
    
    //用来存储上一次刷新的时间
    var lastUpdatedTimeKey: String = LiNRefreshHeaderLastUpdatedTimeKey
    //忽略多少scrollView的contentInset的top
    fileprivate var ignoredScrollViewContentInsetTop: CGFloat = 0
    {
        didSet {
            self.ln_y = self.ln_h - ignoredScrollViewContentInsetTop
        }
    }
    
    
    //MARK: - 初始化方法
    public init(refresh:@escaping LNRefreshComponentRefreshingClosure) {
        super.init(frame: CGRect.init(x: 0, y: 0, width:0, height: 0))
        self.refreshingClosure = refresh
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 覆盖父类方法
    override func prepare() {
        super.prepare()
        //设置最后一次更新的时间的key
        self.lastUpdatedTimeKey = LiNRefreshHeaderLastUpdatedTimeKey
        
        //设置高度
        self.ln_h = CGFloat(LiNRefreshHeaderHeight)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        //设置y值（当自己的高度发生变化了，肯定要重新调整y值，所以放到placeSubviews方法中设置y值）
        self.ln_y = -self.ln_h - self.ignoredScrollViewContentInsetTop
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        //在刷新的refreshing状态
        if self.state == LiNRefreshState.refreshing {
            //暂时保留
            if self.window == nil {
                return
            }
            
            // sectionheader停留解决
            var insetTop: CGFloat = -self.scrollView!.ln_offsetY > self.scrollViewOrginalInset!.top ? -self.scrollView!.ln_offsetY : self.scrollViewOrginalInset!.top
            insetTop = insetTop > self.ln_h + self.scrollViewOrginalInset!.top ? self.ln_h + self.scrollViewOrginalInset!.top : insetTop
            self.scrollView?.ln_insetTop = insetTop
            
            self.insetTopDelta = self.scrollViewOrginalInset!.top - insetTop
            return
        }
        
        //跳转到下一个控制器时，contentInset可能会变
        self.scrollViewOrginalInset = self.scrollView?.ln_inset
        
        //当前的contentOffset
        let offsetY: CGFloat = self.scrollView!.ln_offsetY
        // 头部控件刚好出现的offsetY
        let happenOffsetY: CGFloat = -self.scrollViewOrginalInset!.top
        
        
        //如果是向上滚动到看不见头部控件，直接返回
        if offsetY > happenOffsetY {
            return
        }
        
        //普通 和 即将刷新 的临界点
        let normal2pullingOffsetY: CGFloat = happenOffsetY - self.ln_h
        let pullingPercent: CGFloat = (happenOffsetY - offsetY) / self.ln_h
        
        //如果正在拖拽
        if self.scrollView!.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == LiNRefreshState.idel && offsetY < normal2pullingOffsetY {
                //转为即将刷新状态
//                self.setState(LNRefreshState.Pulling)
                self.state = LiNRefreshState.pulling
            } else if self.state == LiNRefreshState.pulling && offsetY >= normal2pullingOffsetY {
                //转为普通状态
//                self.setState(LNRefreshState.Idle)
                self.state = LiNRefreshState.idel
            }
        } else if self.state == LiNRefreshState.pulling {   //即将刷新 && 手松开
            //开始刷新
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    //MARK: - 重写父类的属性
    override var state: LiNRefreshState?
    {
        didSet {
            //检查刷新状态
            if oldValue == state {
                return
            }
            //普通状态下
            if state == LiNRefreshState.idel {
                if oldValue != LiNRefreshState.refreshing {
                    return
                }
                
                //保存刷新时间
                UserDefaults.standard.set(Date(), forKey: self.lastUpdatedTimeKey)
                UserDefaults.standard.synchronize()
                
                //恢复inset和offset
                UIView.animate(withDuration: LiNRefreshSlowAnimationDuration, animations: {
                    self.scrollView?.ln_insetTop += self.insetTopDelta
                    
                    //自动调整透明度
                    if self.automaticallyChangeAlpha {
                        self.alpha = 0.0
                    }
                }, completion: { (finished) in
                    self.pullingPercent = 0.0
                    
                    //调用结束刷新事件
                    self.endRefreshingClosure?()
                })
            }else if state == LiNRefreshState.refreshing {
                //刷新状态下
                DispatchQueue.main.async {
                    UIView.animate(withDuration: LiNRefreshFastAnimationDuration, animations: {
                        let top: CGFloat = self.scrollViewOrginalInset!.top + self.ln_h
                        //增加滚动区域top
                        self.scrollView?.ln_insetTop = top
                        //设置滚动位置
                        var offset: CGPoint = self.scrollView!.contentOffset
                        offset.y = -top
                        self.scrollView?.setContentOffset(offset, animated: false)
                    }, completion: { (finished) in
                        self.refreshingClosure?()
                    })
                }
            }
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
//        //普通状态下
//        if state == LNRefreshState.Idle {
//            if oldState != LNRefreshState.Refreshing {
//                return
//            }
//
//            //保存刷新时间
//            UserDefaults.standard.set(Date(), forKey: self.lastUpdatedTimeKey)
//            UserDefaults.standard.synchronize()
//
//            //恢复inset和offset
//            UIView.animate(withDuration: LNRefreshSlowAnimationDuration, animations: {
//                self.scrollView?.ln_insetLeft += self.insetTopDelta
//
//                //自动调整透明度
//                if self.automaticallyChangeAlpha {
//                    self.alpha = 0.0
//                }
//            }, completion: { (finished) in
//                self.pullingPercent = 0.0
//
//                //调用结束刷新事件
//                self.endRefreshingEvent?()
//            })
//        }else if state == LNRefreshState.Refreshing {
//            //刷新状态下
//            DispatchQueue.main.async {
//                UIView.animate(withDuration: LNRefreshFastAnimationDuration, animations: {
//                    let top: CGFloat = self.scrollViewOrginalInset!.top + self.ln_h
//                    //增加滚动区域top
//                    self.scrollView?.ln_insetTop = top
//                    //设置滚动位置
//                    var offset: CGPoint = self.scrollView!.contentOffset
//                    offset.y = -top
//                    self.scrollView?.setContentOffset(offset, animated: false)
//                }, completion: { (finished) in
//                    self.excuteRefreshingEvent()
//                })
//            }
//        }
//    }
    
    //MARK: - 公共方法
    func lastUpdateTime() -> Date {
        return UserDefaults.standard.object(forKey: self.lastUpdatedTimeKey) as! Date
    }
}
