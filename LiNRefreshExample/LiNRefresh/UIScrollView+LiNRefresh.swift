//
//  UITableView+LNRefresh.swift
//  TourQ
//
//  Created by 林洁 on 2018/2/5.
//  Copyright © 2018年 Lin. All rights reserved.
//

import UIKit

private var LiNRefreshReloadDataEventKey = "\0"
private var LiNRefreshHeaderKey = "\0"
private var LiNRefreshFooterKey = "\0"

protocol Swizzling : class {
    static func swizzle()
}

class SwizzlingExecute {
    
    static func execute(){
        /*
         *  public func objc_getClassList(_ buffer: AutoreleasingUnsafeMutablePointer<Swift.AnyClass?>!, _ bufferCount: Int32) -> Int32
         *  该函数是获取已注册的类, 传入两个参数
         *  第一个参数buffer: 已分配好空间的数组
         *  第二个参数bufferCount: 数组中存放元素的个数
         *  返回值是注册的类的总数
         *  当参数bufferCount的值小于注册类的总数, 获取到的注册类的集合的任意子集
         *  第一个参数为nil时将会获取到当前注册的所有的类, 此时可存放元素的个数为0, 返回自为当前所有类的总数
         */
        let typeCount = Int(objc_getClassList(nil, 0))
        //存放class的已分配好的空间的数组指针
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        //存放class的已分配好的空间的可选数组指针
        let autoreleaseintTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleaseintTypes, Int32(typeCount))  //获取所有的类
        for index in 0..<typeCount {
            (types[index] as? Swizzling.Type)?.swizzle()
        }
        types.deallocate(capacity: typeCount)
    }
    
}

//执行单例
extension UIApplication {
    
    private static let runOnce: Void = {
        //使用金泰属性以保证只调用一次（该属性是个方法）
        SwizzlingExecute.execute()
        UITableView.swizzle()
        UICollectionView.swizzle()
    }()
    
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}

extension NSObject {
    
    //定义方法交换的类方法
    class func exchangeInstanceMethod(method1: Selector, method2: Selector) {
        method_exchangeImplementations(class_getInstanceMethod(self, method1)!, class_getInstanceMethod(self, method2)!)
    }
    
    class func exchangeClassMethod(method1: Selector, method2: Selector) {
        method_exchangeImplementations(class_getClassMethod(self, method1)!, class_getClassMethod(self, method2)!)
    }
    
}

extension UIScrollView {
    
    typealias ReloadDataClosure = (_ count: Int) -> Void
    
    //MARK : - Header
    public var ln_header : LiNRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &LiNRefreshHeaderKey) as? LiNRefreshHeader
        }
        set {
            if newValue != self.ln_header {
                //删除旧的，添加新的
                self.ln_header?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                
                //存储新的
                self.willChangeValue(forKey: "ln_header") //KVO
                objc_setAssociatedObject(self, &LiNRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "ln_header") //KVO
            }
        }
    }
    
    //MARK: - Footer
    public var ln_footer : LiNRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &LiNRefreshFooterKey) as? LiNRefreshFooter
        }
        set {
            if newValue != self.ln_footer {
                //删除旧的，添加新的
                self.ln_footer?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                
                //存储新的
                self.willChangeValue(forKey: "ln_footer")   //KVO
                objc_setAssociatedObject(self, &LiNRefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "ln_footer")    //KVO
            }
        }
    }
    
    var ln_reloadDataClosure: ReloadDataClosure? {
        get {
            return objc_getAssociatedObject(self, &LiNRefreshReloadDataEventKey) as? ReloadDataClosure
        }
        set {
            self.willChangeValue(forKey: "ln_reloadDataEvent")  //KVO
            objc_setAssociatedObject(self, &LiNRefreshReloadDataEventKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.didChangeValue(forKey: "ln_reloadDataEvent")   //KVO
        }
    }
    
    var ln_totalDataCount: Int? {
        get {
            var totalCount = 0
            if self is UITableView {
                let tableView: UITableView = self as! UITableView
                
                var section = 0
                while section < tableView.numberOfSections {
                    totalCount += tableView.numberOfRows(inSection: section)
                    section += 1
                }
            } else if self is UICollectionView {
                let collectionView = self as! UICollectionView
                
                var section = 0
                while section < collectionView.numberOfSections {
                    totalCount += collectionView.numberOfItems(inSection: section)
                    section += 1
                }
            }
            return totalCount
        }
    }
}


extension UITableView: Swizzling{
    
    static func swizzle() {
        self.exchangeInstanceMethod(method1: #selector(self.reloadData), method2: #selector(self.ln_reloadData))
        print("方法交换了")
    }
    
    @objc func ln_reloadData() -> Void {
        print("UITableView reloadData method")
        self.ln_reloadData()
        
        self.ln_reloadDataClosure!(self.ln_totalDataCount!)
    }
    
}

extension UICollectionView: Swizzling {
    
    static func swizzle() {
        self.exchangeInstanceMethod(method1: #selector(self.reloadData), method2: #selector(self.ln_reloadData))
    }
    
    @objc func ln_reloadData() -> Void {
        self.ln_reloadData()
        
        self.ln_reloadDataClosure?(self.ln_totalDataCount!)
    }
}
