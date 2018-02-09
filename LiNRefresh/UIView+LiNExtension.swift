//
//  UIView+LNExtension.swift
//  LNRefreshExample
//
//  Created by 林洁 on 2018/2/6.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit


extension UIView {
    
    //控件x轴的偏移量
    var ln_x : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame: CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    //控件y轴的偏移量
    var ln_y : CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame: CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    //控件宽
    var ln_w : CGFloat {
        get {
            return self.frame.width
        }
        set {
            var frame: CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    //控件高
    var ln_h : CGFloat {
        get {
            return self.frame.height
        }
        set {
            var frame: CGRect = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var ln_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame: CGRect = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
}
