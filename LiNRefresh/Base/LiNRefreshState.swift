//
//  LNRefreshState.swift
//  TourQ
//
//  Created by Lin on 2018/2/5.
//  Copyright © 2018年 Lin. All rights reserved.
//

import Foundation


enum LiNRefreshState : Int {
    //闲置状态
    case idel
    //松开就可以进入刷新状态
    case pulling
    //即将进入刷新状态
    case willRefresh
    //正在刷新中
    case refreshing
    //所有数据加载完毕，没有更多数据了
    case noMoreData
}
