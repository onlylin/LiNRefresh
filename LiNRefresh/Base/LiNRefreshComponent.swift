//
//  LNRefreshComponent.swift
//  TourQ
//
//  Created by Lin on 2018/2/5.
//  Copyright © 2018年 Lin. All rights reserved.
//

import UIKit


public class LiNRefreshComponent: UIView {
    
    //进入刷新状态的回调
    public typealias LNRefreshComponentRefreshingClosure = () -> Void
    //开始刷新的回调
    public typealias LNRefreshComponentBeginRefreshingClosure = () -> Void
    //刷新结束后的回调
    public typealias LNRefreshComponentEndRefreshingClosure = () -> Void
    
    public var refreshingClosure: LNRefreshComponentRefreshingClosure?
    public var beginRefreshingClosure: LNRefreshComponentBeginRefreshingClosure?
    public var endRefreshingClosure: LNRefreshComponentEndRefreshingClosure?
    
    //父控件
    weak var scrollView: UIScrollView?
    //保存初始位置
    var scrollViewOrginalInset: UIEdgeInsets?
    
    //手势
    var pan: UIPanGestureRecognizer?
    //刷新状态
    var state: LiNRefreshState?
    {
        didSet {
            //            print("LNRefreshComponent")
            // 加入主队列的目的是等state属性设置完毕、设置完文字后再去布局子控件
            DispatchQueue.main.async {
                self.setNeedsLayout()
            }
        }
    }
    
    //设置是否自动切换透明度
    var automaticallyChangeAlpha: Bool = false
    {
        didSet {
            if self.isRefreshing() {
                return
            }
            if automaticallyChangeAlpha {
                self.alpha = self.pullingPercent!
            }else {
                self.alpha = 1.0
            }
        }
    }
    
    //拖拽百分比
    var pullingPercent: CGFloat?
    {
        //根据拖拽百分比设置透明度
        didSet {
            if self.isRefreshing() {
                return
            }
            if self.automaticallyChangeAlpha {
                self.alpha = pullingPercent!
            }
        }
    }
    
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //默认是普通状态
        self.state = LiNRefreshState.idel
        //准备工作
        self.prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() -> Void {
        //基本属性
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth;
        self.backgroundColor = UIColor.clear
    }
    
    override public func layoutSubviews() {
        self.placeSubviews()
        super.layoutSubviews()
    }
    
    override public func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        if self.state == LiNRefreshState.willRefresh {
            //预防view还没显示出来就调用了bgeinRefreshing
            self.state = LiNRefreshState.refreshing
        }
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //如果不是UIScrollView，不做任何事情
        if (newSuperview != nil) && !(newSuperview is UIScrollView) {
            return
        }
        
        //旧的父控件移除监听
        self.removeObservers()
        
        if (newSuperview != nil) {//新的父控件
            
            //保存UIScrollView
            self.scrollView = newSuperview as? UIScrollView
            //设置永远支持垂直弹簧效果
            self.scrollView?.alwaysBounceVertical = true
            //记录UIScrollView最开始的contentInset
            self.scrollViewOrginalInset = scrollView?.ln_inset
            
            //设置宽度
            self.ln_w = self.scrollView!.ln_w
            //设置位置
            self.ln_x = -self.scrollView!.ln_insetLeft
            
            //添加监听
            self.addObservers()
        }
    }
    
    //提供给子类用于设置子视图的方法
    func placeSubviews() -> Void {}
    
    //MARK: - KVO监听
    private func addObservers() -> Void {
        let options: NSKeyValueObservingOptions = [.new, .old]
        
        
        self.scrollView?.addObserver(self, forKeyPath: LiNRefreshKeyPathContentOffset, options:options, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: LiNRefreshKeyPathContentSize, options:options, context: nil)
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: LiNRefreshKeyPathPanState, options:options, context: nil)
    }
    
    private func removeObservers() -> Void {
        self.scrollView?.removeObserver(self, forKeyPath: LiNRefreshKeyPathContentOffset)
        self.scrollView?.removeObserver(self, forKeyPath: LiNRefreshKeyPathContentSize)
        self.scrollView?.removeObserver(self, forKeyPath: LiNRefreshKeyPathPanState)
        self.pan = nil
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //        print("offsetY = \(self.scrollView!.ln_offsetY)")
        
        //遇到这些情况就直接返回
        if !self.isUserInteractionEnabled {
            return
        }
        
        if keyPath == LiNRefreshKeyPathContentSize {
            self.scrollViewContentSizeDidChange(change)
        }
        
        if self.isHidden {
            return
        }
        
        if keyPath == LiNRefreshKeyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change)
        }else if keyPath == LiNRefreshKeyPathPanState {
            self.scrollViewPanStateDidChange(change)
        }
    }
    
    
    /** 当scrollView的contentOffset发生改变的时候调用 */
    func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) -> Void {}
    /** 当scrollView的contentSize发生改变的时候调用 */
    func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) -> Void {}
    /** 当scrollView的拖拽状态发生改变的时候调用 */
    func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) -> Void {}
    
    
    //    func setState(_ state: LNRefreshState) -> Void {
    //
    //        self.state = state
    //
    //        // 加入主队列的目的是等state属性设置完毕、设置完文字后再去布局子控件
    //        DispatchQueue.main.async {
    //            self.setNeedsLayout()
    //        }
    //    }
    
    //MARK: - 进入刷新状态
    func beginRefreshing() -> Void {
        UIView.animate(withDuration: LiNRefreshFastAnimationDuration) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        //只要在刷新就完全显示
        if (self.window != nil) {
            self.state = LiNRefreshState.refreshing
            //            self.setState(LNRefreshState.Refreshing)
        }else {
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if self.state != LiNRefreshState.refreshing {
                self.state = LiNRefreshState.willRefresh
                //                self.setState(LNRefreshState.WillRefresh)
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                self.setNeedsDisplay()
            }
        }
    }
    
    //MARK: - 结束刷新状态
    public func endRefreshing() -> Void {
        DispatchQueue.main.async {
            self.state = LiNRefreshState.idel
        }
    }
    
    //MARK: - 是否正在刷新
    func isRefreshing() -> Bool {
        return self.state == LiNRefreshState.refreshing || self.state == LiNRefreshState.willRefresh
    }
}


//MARK: - 刷新的文本控件
extension UILabel {
    
    class func ln_label() -> UILabel {
        let label = self.init()
        label.font = LiNRefreshLabelFont
        label.textColor = LiNRefreshLabelTextColor
        label.autoresizingMask = UIViewAutoresizing.flexibleWidth
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        return label
    }
    
    var ln_textWidth: CGFloat
    {
        get {
            var stringWidth: CGFloat = 0
            //        var size: CGSize? = CGSize(width:CGFloat(MAXFLOAT), height:CGFloat(MAXFLOAT))
            if  (self.text != nil) && (self.text!.count > 0){
                
                stringWidth = self.text!.size(withAttributes: [NSAttributedStringKey.font : self.font]).width
            }
            return stringWidth
        }
    }
    
}

