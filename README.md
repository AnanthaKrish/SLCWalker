# SLCWalker

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) [![CocoaPods compatible](https://img.shields.io/cocoapods/v/SLCWalkersvg?style=flat)](https://cocoapods.org/pods/SLCWalker) [![License: MIT](https://img.shields.io/cocoapods/l/SLCWalker.svg?style=flat)](http://opensource.org/licenses/MIT)

链式方式加载动画,以下功能以MARK为分类作划分.
本项目会长期维护更新.
1.  MAKE分类,全部是以中心点为依据的动画.

![Alt text](https://github.com/WeiKunChao/SLCWalker/raw/master/screenShort/Make.gif).

2. TAKE分类,全部以边界点为依据.(此时暂时repeat参数是无效的,待后续处理).

![Alt text](https://github.com/WeiKunChao/SLCWalker/raw/master/screenShort/Take.gif).

3. MOVE分类,相对移动 (以中心点为依据).

![Alt text](https://github.com/WeiKunChao/SLCWalker/raw/master/screenShort/Move.gif).

4. ADD分类,相对移动(以边界为依据).

![Alt text](https://github.com/WeiKunChao/SLCWalker/raw/master/screenShort/Add.gif).

5. 通用是适用于所有类型的动画样式.

![Alt text](https://github.com/WeiKunChao/SLCWalker/raw/master/screenShort/Path.gif).

6. 不使用then参数,同时使用多个动画如makeWith(20).animate(1).makeHeight(20).animate(1) 会同时作用; 使用then参数时如makeWith(20).animate(1).then.makeHeight(20).animate(1) 会在动画widtha完成后再进行动画height.
7. TRANSITION 转场动画.

![Alt text](https://github.com/WeiKunChao/SLCWalker/raw/master/screenShort/Transition.gif).

注: 如果没有特殊注释,则表示参数适用于所有类型.

## 使用.

```
 pod 'SLCWalker'
 
```
1. 对于调用顺序有简单要求, 以make,take,move或者add等开始,以animate结束(对于collectionView或者tableView是以reloadDataWithDancer结束),其他在中间无特殊顺序要求. 例如:
```swift

self.view.moveX(-100).easeLiner.delay(2).reverses(YES).animate(2);

collectionView.makeScale(0.01).itemDuration(2).itemDelay(0.1).spring.reloadDataWithDancer();
```

UIView和CALayer同样适用.

OC和Demo请移步[SLCDancer](https://github.com/WeiKunChao/SLCDancer).使用方法完全相同.

## 版本
1.0.5 初次确定版本.
1.0.6 增加UICollectionView和UITableView动画.



