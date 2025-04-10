<div align="center">
<img src="https://github.com/NullTar/Tomator/blob/da5f0f00c80f1715f8e84e4dad9750cff9743d73/Sources/Assets.xcassets/AppIcon.appiconset/icon_512x512%402x.png" width="128" height="128"/>
</div>


<h1 align="center">Tomator</h1>


## 概述
<img src="https://github.com/NullTar/Tomator/blob/da5f0f00c80f1715f8e84e4dad9750cff9743d73/Assets/popover_default.png"
  alt="popover_default"
	width="30%"
	align=right
/>

你听说过番茄工作法吗？这是一种很棒的技术，可以帮助你在学习或工作期间跟踪时间并保持专注。在<a href="https://en.wikipedia.org/wiki/Pomodoro_Technique">维基百科</a>上了解更多信息。

Tomator 是 MacOS 菜单栏上的番茄钟计时器。

### Language
English: [ReadMe](https://github.com/NullTar/Tomator/blob/dfa00adad91cedf94322b907dde0a0803ef01322/README_ENGLISH.md)

#### 基本功能
<img src="https://github.com/NullTar/Tomator/blob/da5f0f00c80f1715f8e84e4dad9750cff9743d73/Assets/popover_all.png"
  alt="popover_all"
  width="30%"
  align=right
/>

- 简洁的菜单栏界面，不占用桌面空间
- 可配置的工作和休息间隔
- 支持强制休息、小憩休息
- 可选的声音提示和通知
- 统计功能，追踪您的工作习惯 (需要MacOS 13.0+)
- 完全沙盒化，无需任何特殊权限
- 支持深色模式和浅色模式
- 自定义颜色、背景
- 设置特定的时间表时间启用
- 低资源占用，对系统性能影响极小

## 截图
<p align="center">
    <img 					src="https://github.com/NullTar/Tomator/blob/da5f0f00c80f1715f8e84e4dad9750cff9743d73/Assets/stats.png"
  alt="stats"
  width="45%"
/>
    <img src="https://github.com/NullTar/Tomator/blob/7ec029811739781ecce856033beb59ac2293151f/Assets/forceWindow.png"
width="45%"
alt="forceWindow"
/>
</p>

<p align="center">
    <img src="https://github.com/NullTar/Tomator/blob/da5f0f00c80f1715f8e84e4dad9750cff9743d73/Assets/setting.png"
width="45%"
alt="setting"
/>
</p>

## 下载安装
1. 访问 [GitHub Releases 页面](https://github.com/NullTar/Tomator/releases)
2. 下载最新版本的 `Tomator.dmg` 文件
3. 解压后将 `Tomator.app` 拖到应用程序文件夹中

## 系统要求
- MacOS 13.0 或更高版本 (统计功能需要MacOS 13.0+)
- 较旧的版本支持 MacOS 12.0，但不包含统计功能

## 隐私 Privacy
应用不会收集任何用户的个人信息，也不会将个人信息用于第三方，应用不联网。

The App does not collect any user's personal information, nor does it use personal information for third-party services, and the App is not connected to the Internet.

## 感谢
感谢以下开发人员的贡献
-  [wersling](https://github.com/wersling)
-  [ivoronin](https://github.com/ivoronin)

## 许可证
 - 计时器音效授权自 buddhabeats
 - 菜单栏图标: [美味的食物](https://www.iconfont.cn/collections/detail?spm=a313x.user_detail.i1.dc64b3430.38913a81T5pE7r&cid=2134), 作者[Banada](https://www.iconfont.cn/user/detail?spm=a313x.user_detail.i1.dcc7d6115.2d753a81ofaC89&userViewType=collections&uid=32838&nid=Gk16MkNV0bM0)

## 授权
请不要将此存储库源代码用于任何商业目的，此应用程序从不收费，始终更新！详情请参阅 [许可证](https://creativecommons.org/licenses/by-nc/4.0/)

Please do not use this repository source code for any commercial purposes, this app is never charged, always updated! For details please see [LICENSE](https://creativecommons.org/licenses/by-nc/4.0/)

## 开发

### 发布流程

项目包含两个发布脚本，简化了应用的构建和发布过程：

1. `release.sh` - 构建、签名和打包应用
   ```bash
   # 使用Xcode项目中的MARKETING_VERSION
   ./release.sh
   
   # 指定版本号
   ./release.sh 1.0.1
   ```
   脚本将在`./build`目录中生成以下文件：
   - Tomator.app - 应用程序
   - Tomator.dmg - 磁盘镜像
   - Tomator.zip - 压缩包
   
   版本号从Xcode项目文件中的`MARKETING_VERSION`属性获取，而不是从Info.plist中获取。如果未指定版本号，脚本会自动从project.pbxproj文件中获取当前版本。
   
   脚本会自动将project.pbxproj文件中的`CURRENT_PROJECT_VERSION`递增1，用于标识构建版本。

2. `github-release.sh` - 创建GitHub发布并上传构建文件
   ```bash
   # 使用Xcode项目中的MARKETING_VERSION
   ./github-release.sh
   
   # 指定版本号
   ./github-release.sh 1.0.1
   ```
   运行此脚本前，请确保已经执行了`release.sh`，且安装了GitHub CLI。此脚本同样会从project.pbxproj文件中获取版本号，如果没有指定版本参数。

## 与其他工具集成
### 事件日志
Tomator 以 JSON 格式将状态转换记录到 `~/Library/Containers/cn.null.tomator/Data/Library/Caches/Tomator.log`。使用这些数据分析你的生产力并丰富其他数据源。
### 启动和停止计时器
Tomator 可以通过 `tomator://` URL 控制。要从命令行启动或停止计时器，使用 `open tomator://startStop`。
