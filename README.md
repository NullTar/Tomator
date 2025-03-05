<p align="center">
<img src="https://raw.githubusercontent.com/ivoronin/TomatoBar/main/TomatoBar/Assets.xcassets/AppIcon.appiconset/icon_128x128%402x.png" width="128" height="128"/>
<p>
 
<h1 align="center">TomatoBar</h1>
<p align="center">
<img src="https://img.shields.io/github/actions/workflow/status/ivoronin/TomatoBar/main.yml?branch=main"/> <img src="https://img.shields.io/github/downloads/ivoronin/TomatoBar/total"/> <img src="https://img.shields.io/github/v/release/ivoronin/TomatoBar?display_name=tag"/> <img src="https://img.shields.io/homebrew/cask/v/tomatobar"/>
</p>

<img
  src="https://github.com/ivoronin/TomatoBar/raw/main/screenshot.png?raw=true"
  alt="Screenshot"
  width="50%"
  align="right"
/>

## 概述
你听说过番茄工作法吗？这是一种很棒的技术，可以帮助你在学习或工作期间跟踪时间并保持专注。在<a href="https://en.wikipedia.org/wiki/Pomodoro_Technique">维基百科</a>上了解更多信息。

TomatoBar 是 macOS 菜单栏上最简洁的番茄钟计时器。它包含所有基本功能 - 可配置的工作和休息间隔、可选的声音提示、不引人注目的可操作通知以及全局热键。

TomatoBar 完全沙盒化，无需任何授权。

## 系统要求
- macOS 13.0 或更高版本 (统计功能需要macOS 13.0+)
- 较旧的版本支持macOS 12.0，但不包含统计功能

## 开发者信息
TomatoBar 现在支持 Swift Package Manager (SPM)。开发者可以通过以下方式构建项目：

```bash
# 克隆仓库
git clone https://github.com/ivoronin/TomatoBar.git
cd TomatoBar

# 使用Swift Package Manager构建
swift build
```

## 与其他工具集成
### 事件日志
TomatoBar 以 JSON 格式将状态转换记录到 `~/Library/Containers/com.github.ivoronin.TomatoBar/Data/Library/Caches/TomatoBar.log`。使用这些数据分析你的生产力并丰富其他数据源。
### 启动和停止计时器
TomatoBar 可以通过 `tomatobar://` URL 控制。要从命令行启动或停止计时器，使用 `open tomatobar://startStop`。

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
