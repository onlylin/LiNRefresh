# LiNRefresh
  参考MJRefresh
## 截图
  ![screenshot](https://github.com/onlylin/LiNRefresh/blob/master/screenshot.gif)
  
## 下拉刷新
```Swift 
  self.tableView.ln_header = LiNRefreshNormalHeader{
       //refresh code
  }
```
## 上拉下载更多
```Swift
  self.tableView.ln_footer = LiNRefreshAutoNormalFooter{
      //refresh code          
  }
```

## CocoaPods
```Shell
  pod 'LiNRefresh', '~> 1.1.3'
```
