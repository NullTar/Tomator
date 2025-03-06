<p align="center">
<img src="https://raw.githubusercontent.com/wersling/TomatoBar/main/Sources/Assets.xcassets/AppIcon.appiconset/icon_128x128%402x.png" width="128" height="128"/>
<p>
 
<h1 align="center">TomatoBar</h1>
<p align="center">
<img src="https://img.shields.io/github/actions/workflow/status/ivoronin/TomatoBar/main.yml?branch=main"/> <img src="https://img.shields.io/github/downloads/ivoronin/TomatoBar/total"/> <img src="https://img.shields.io/github/v/release/ivoronin/TomatoBar?display_name=tag"/> <img src="https://img.shields.io/homebrew/cask/v/tomatobar"/>
</p>



## 概述
<img
  src="https://github.com/wersling/TomatoBar/raw/main/screenshot.png?raw=true"
  alt="Screenshot"
  width="35%"
  align="right"
/>
你听说过番茄工作法吗？这是一种很棒的技术，可以帮助你在学习或工作期间跟踪时间并保持专注。在<a href="https://en.wikipedia.org/wiki/Pomodoro_Technique">维基百科</a>上了解更多信息。

TomatoBar 是 macOS 菜单栏上最简洁的番茄钟计时器。
#### 包含所有基本功能
- 简洁的菜单栏界面，不占用桌面空间
- 可配置的工作和休息间隔，支持强制休息
- 可选的声音提示和通知
- 统计功能，追踪您的工作习惯（需要macOS 13.0+）
- 完全沙盒化，无需任何特殊权限
- 支持深色模式和浅色模式
- 低资源占用，对系统性能影响极小

## 下载安装
1. 访问 [GitHub Releases 页面](https://github.com/wersling/TomatoBar/releases)
2. 下载最新版本的 `TomatoBar.dmg` 文件
3. 解压后将 TomatoBar.app 拖到应用程序文件夹中


## 系统要求
- macOS 13.0 或更高版本 (统计功能需要macOS 13.0+)
- 较旧的版本支持macOS 12.0，但不包含统计功能

## 许可证
 - 计时器音效授权自 buddhabeats

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
   - TomatoBar.app - 应用程序
   - TomatoBar.dmg - 磁盘镜像
   - TomatoBar.zip - 压缩包
   
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
TomatoBar 以 JSON 格式将状态转换记录到 `~/Library/Containers/cn.wersling.TomatoBar/Data/Library/Caches/TomatoBar.log`。使用这些数据分析你的生产力并丰富其他数据源。
### 启动和停止计时器
TomatoBar 可以通过 `tomatobar://` URL 控制。要从命令行启动或停止计时器，使用 `open tomatobar://startStop`。