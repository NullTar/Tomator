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

## Overview
Have you ever heard of Pomodoro? It's a great technique to help you keep track of time and stay on task during your studies or work. Read more about it on <a href="https://en.wikipedia.org/wiki/Pomodoro_Technique">Wikipedia</a>.

TomatoBar is world's neatest Pomodoro timer for the macOS menu bar. All the essential features are here - configurable
work and rest intervals, optional sounds, discreet actionable notifications, global hotkey.

TomatoBar is fully sandboxed with no entitlements.

Download the latest release <a href="https://github.com/ivoronin/TomatoBar/releases/latest/">here</a> or install using Homebrew:
```
$ brew install --cask tomatobar
```

If the app doesn't start, install using the `--no-quarantine` flag:
```
$ brew install --cask --no-quarantine tomatobar
```

## Integration with other tools
### Event log
TomatoBar logs state transitions in JSON format to `~/Library/Containers/com.github.ivoronin.TomatoBar/Data/Library/Caches/TomatoBar.log`. Use this data to analyze your productivity and enrich other data sources.
### Starting and stopping the timer
TomatoBar can be controlled using `tomatobar://` URLs. To start or stop the timer from the command line, use `open tomatobar://startStop`.

## Older versions
Touch bar integration and older macOS versions (earlier than Big Sur) are supported by TomatoBar versions prior to 3.0

## Licenses
 - Timer sounds are licensed from buddhabeats

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
