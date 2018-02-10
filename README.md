# LiNRefresh
  参考MJRefresh的一个Swift版本的下拉刷新控件，目前只实现最基本的下拉刷新功能：`LiNRefreshNormalHeader`和`LiNRefreshAutoNormalFooter`
## Screenshot
  ![screenshot](https://github.com/onlylin/LiNRefresh/blob/master/screenshot.gif)
  
## Pull-down
```Swift N
  self.tableView.ln_header = LiNRefreshNormalHeader{
       //refresh code
       self.tableView.ln_header?.endRefreshing()
  }
```
## Pull-up
```Swift
  self.tableView.ln_footer = LiNRefreshAutoNormalFooter{
      //refresh code
      self.tableView.ln_footer?.endRefreshing()
  }
```

### No More Data
```Swift
  self.tableView.ln_footer?.noticeNoMoreData()
```

### Reset No More Data
```Swift
  self.tableView.ln_footer?.resetNoMoreData()
```

## CocoaPods
```Shell
  pod 'LiNRefresh', '~> 1.1.4'
```
