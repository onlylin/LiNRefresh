//
//  LNRefreshNormalHeader.swift
//  LNRefreshExample
//
//  Created by 林洁 on 2018/2/6.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

class LiNRefreshNormalHeader: LiNRefreshStateHeader {
    
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle?
    {
        didSet {
            self.setNeedsLayout()
        }
    }

    //MARK: - 懒加载
    lazy var arrowView: UIImageView = {
        let tmp = UIImageView.init(image: Bundle.arrowImage)
        self.addSubview(tmp)
        return tmp
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let tmp = UIActivityIndicatorView.init(activityIndicatorStyle: self.activityIndicatorViewStyle!)
        tmp.hidesWhenStopped = true
        self.addSubview(tmp)
        return tmp
    }()
    
    //MARK: - 重写父类的方法
    override func prepare() {
        super.prepare()
        
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        //箭头的中心点
        var arrowCenterX = self.ln_w * 0.5
        if !self.stateLabel.isHidden {
            let stateWidth = self.stateLabel.ln_textWidth
            var timeWidth: CGFloat = 0
            if !self.lastUpdatedTimeLabel.isHidden {
                timeWidth = self.lastUpdatedTimeLabel.ln_textWidth
            }
            let textWidth: CGFloat = max(stateWidth, timeWidth)
            arrowCenterX -= textWidth / 2 + self.labelLeftInset
        }
        let arrowCenterY = self.ln_h * 0.5
        let arrowCenter = CGPoint.init(x: arrowCenterX, y: arrowCenterY)
        
        //箭头
        if self.arrowView.constraints.count == 0 {
            self.arrowView.ln_size = self.arrowView.image!.size
            self.arrowView.center = arrowCenter
        }
        
        //圈圈
        if self.loadingView.constraints.count == 0 {
            self.loadingView.center = arrowCenter
        }
        
        self.arrowView.tintColor = self.stateLabel.textColor
    }
    
    //MARK: - 重写父类的属性
    override var state: LiNRefreshState?
        {
        didSet {
            if oldValue == state {
                return
            }
            if state == LiNRefreshState.idel {
                if oldValue == LiNRefreshState.refreshing {
                    self.arrowView.transform = CGAffineTransform.identity
                    
                    UIView.animate(withDuration: LiNRefreshSlowAnimationDuration, animations: {
                        self.loadingView.alpha = 0.0
                    }, completion: { (finished) in
                        //如果执行完动画发现不是idel状态没救直接返回，进去其他状态
                        if self.state != LiNRefreshState.idel {
                            return
                        }
                        
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    })
                } else {
                    self.loadingView.stopAnimating()
                    self.arrowView.isHidden = false
                    UIView.animate(withDuration: LiNRefreshFastAnimationDuration, animations: {
                        self.arrowView.transform = CGAffineTransform.identity
                    })
                }
            } else if state == LiNRefreshState.pulling {
                self.loadingView.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: LiNRefreshFastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransform.init(rotationAngle: CGFloat(0.000001 - .pi))
                })
            } else if state == LiNRefreshState.refreshing {
                self.loadingView.alpha = 1.0
                self.loadingView.startAnimating()
                self.arrowView.isHidden = true
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
//        if state == LNRefreshState.Idle {
//            if oldState == LNRefreshState.Refreshing {
//                self.arrowView.transform = CGAffineTransform.identity
//                
//                UIView.animate(withDuration: LNRefreshSlowAnimationDuration, animations: {
//                    self.loadingView.alpha = 0.0
//                }, completion: { (finished) in
//                    //如果执行完动画发现不是idel状态没救直接返回，进去其他状态
//                    if self.state != LNRefreshState.Idle {
//                        return
//                    }
//                    
//                    self.loadingView.alpha = 1.0
//                    self.loadingView.stopAnimating()
//                    self.arrowView.isHidden = false
//                })
//            } else {
//                self.loadingView.stopAnimating()
//                self.arrowView.isHidden = false
//                UIView.animate(withDuration: LNRefreshFastAnimationDuration, animations: {
//                    self.arrowView.transform = CGAffineTransform.identity
//                })
//            }
//        } else if state == LNRefreshState.Pulling {
//            self.loadingView.stopAnimating()
//            self.arrowView.isHidden = false
//            UIView.animate(withDuration: LNRefreshFastAnimationDuration, animations: {
//                self.arrowView.transform = CGAffineTransform.init(rotationAngle: CGFloat(0.000001 - .pi))
//            })
//        } else if state == LNRefreshState.Refreshing {
//            self.loadingView.alpha = 1.0
//            self.loadingView.startAnimating()
//            self.arrowView.isHidden = true
//        }
//    }

}








