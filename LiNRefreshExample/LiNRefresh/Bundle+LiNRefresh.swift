//
//  Bundle+LNRefresh.swift
//  LNRefreshExample
//
//  Created by 林洁 on 2018/2/6.
//  Copyright © 2018年 lin. All rights reserved.
//

import UIKit

extension Bundle {
    
    static var refreshBundle: Bundle{
        return Bundle.init(path: Bundle.main.path(forResource: "LiNRefresh", ofType: "bundle")!)!
    }
    
    static var arrowImage: UIImage{
        return (UIImage.init(contentsOfFile: self.refreshBundle.path(forResource: "arrow@2x", ofType: "png")!)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))!
    }
    
    class func localizedString(forKey key: String) -> String {
        return self.localizedString(forKey: key, value: nil)
    }
    
    class func localizedString(forKey key: String, value: String?) -> String {
        var language = Locale.preferredLanguages.first!
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        if language.hasPrefix("en") {
            language = "en"
        } else if language.hasPrefix("zh") {
            language = "zh-Hans"
        } else {
            language = "en"
        }
        
        let bundle = Bundle.init(path: self.refreshBundle.path(forResource: language, ofType: "lproj")!)
        let v = bundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: v, table: nil)
    }
}
