# LNRefresh
  参考MJRefresh
## 截图
  ![screenshot](https://github.com/onlylin/LNRefresh/blob/master/screenshot.gif)
  
## 下拉刷新
```Swift 
  self.tableView.ln_header = LNRefreshNormalHeader{
       //refresh code
  }
```
## 上拉下载更多
```Swift
  self.tableView.ln_footer = LNRefreshAutoNormalFooter{
      //refresh code          
  }
```
