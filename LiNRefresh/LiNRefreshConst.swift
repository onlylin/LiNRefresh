//
//  LNRefreshConst.swift
//  LNRefreshExample
//
//  Created by Lin on 2018/2/6.
//  Copyright © 2018年 lin. All rights reserved.
//

import Foundation
import UIKit


let LiNRefreshLabelLeftInset = 25.0
let LiNRefreshFastAnimationDuration = 0.25
let LiNRefreshSlowAnimationDuration = 0.4
let LiNRefreshHeaderHeight = 54.0
let LiNRefreshFooterHeight = 44.0


let LiNRefreshKeyPathContentOffset = "contentOffset"
let LiNRefreshKeyPathContentInset = "contentInset"
let LiNRefreshKeyPathContentSize = "contentSize"
let LiNRefreshKeyPathPanState = "state"

let LiNRefreshHeaderLastUpdatedTimeKey = "LiNRefreshHeaderLastUpdatedTimeKey"

let LiNRefreshHeaderIdleText = "LiNRefreshHeaderIdleText"
let LiNRefreshHeaderPullingText = "LiNRefreshHeaderPullingText"
let LiNRefreshHeaderRefreshingText = "LiNRefreshHeaderRefreshingText"

let LiNRefreshAutoFooterIdleText = "LiNRefreshAutoFooterIdleText"
let LiNRefreshAutoFooterRefreshingText = "LiNRefreshAutoFooterRefreshingText"
let LiNRefreshAutoFooterNoMoreDataText = "LiNRefreshAutoFooterNoMoreDataText"

let LiNRefreshHeaderLastTimeText = "LiNRefreshHeaderLastTimeText"
let LiNRefreshHeaderDateTodayText = "LiNRefreshHeaderDateTodayText"
let LiNRefreshHeaderNoneLastDateText = "LiNRefreshHeaderNoneLastDateText"


let LiNRefreshLabelFont = {() -> UIFont in return UIFont.boldSystemFont(ofSize: 14)}()
let LiNRefreshColor = {(r: CGFloat,g: CGFloat,b: CGFloat) -> UIColor in return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)}
let LiNRefreshLabelTextColor = {() -> UIColor in return LiNRefreshColor(90,90,90)}()



