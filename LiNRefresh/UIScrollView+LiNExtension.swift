//
//  UIScrollView+LNExtension.swift
//  LNRefreshExample
//
//  Created by Lin on 2018/2/6.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    var ln_inset : UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.adjustedContentInset
            }
            return self.contentInset
        }
    }
    
    var ln_insetTop : CGFloat {
        get {
            return self.ln_inset.top
        }
        set {
            var inset: UIEdgeInsets = self.contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
    }
    
    var ln_insetBottom : CGFloat {
        get {
            return self.ln_inset.bottom
        }
        set {
            var inset: UIEdgeInsets = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
    }
    
    var ln_insetLeft : CGFloat {
        get {
            return self.ln_inset.left
        }
        set {
            var inset: UIEdgeInsets = self.contentInset
            inset.left = newValue
            if #available(iOS 11.0, *) {
                inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
            }
            self.contentInset = inset
        }
    }
    
    var ln_insetRight : CGFloat {
        get {
            return self.ln_inset.right
        }
        set {
            var inset: UIEdgeInsets = self.contentInset
            inset.right = newValue
            if #available(iOS 11.0, *) {
                inset.right -= (self.adjustedContentInset.right - self.contentInset.right)
            }
            self.contentInset = inset
        }
    }
    
    var ln_offsetX : CGFloat {
        get {
            return self.contentOffset.x
        }
        set {
            var offset: CGPoint = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
    }
    
    var ln_offsetY : CGFloat {
        get {
            return self.contentOffset.y
        }
        set {
            var offset: CGPoint = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
    }
    
    var ln_contentWidth : CGFloat {
        get {
            return self.contentSize.width
        }
        set {
            var size: CGSize = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
    }
    
    var ln_contentHeight : CGFloat {
        get {
            return self.contentSize.height
        }
        set {
            var size: CGSize = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
    }
    
}
