<div align="center">
<img src="https://github.com/NullTar/Tomator/blob/da5f0f00c80f1715f8e84e4dad9750cff9743d73/Sources/Assets.xcassets/AppIcon.appiconset/icon_512x512%402x.png" width="128" height="128"/>
</div>


<h1 align="center">Tomator</h1>


## Overview
<img src="https://github.com/NullTar/Tomator/blob/da5f0f00c80f1715f8e84e4dad9750cff9743d73/Assets/popover_default.png"
  alt="popover_default"
	width="30%"
	align=right
/>

Have you ever heard of the Pomodoro technique? This is a great to help you keep track of time and stay focused while studying or working. Learn more on <a href="https://en.wikipedia.org/wiki/Pomodoro_Technique">Wikipedia</a>.

Tomator is the Pomodoro timer on the MacOS menu bar.

### 语言
中文: [ReadMe](https://github.com/NullTar/Tomator)

#### Feature
<img src="https://github.com/NullTar/Tomator/blob/da5f0f00c80f1715f8e84e4dad9750cff9743d73/Assets/popover_all.png"
  alt="popover_all"
  width="30%"
  align=right
/>

- menu bar popover, does not take up desktop space
- configurable work and rest intervals
- support mandatory rest and short breaks
- customize sound prompts and notifications
- statistics to track your work habits (MacOS 13.0+ required)
- sandboxed without any permissions
- dark and light modes
- custom color, background
- set specific schedule times to enable
- low resource usage, minimal impact on system performance

## Screenshots
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

## Download and install
1. Link to [GitHub Releases Page](https://github.com/NullTar/Tomator/releases)
2. Download the latest version of the `Tomator.dmg` file
3. After loading file, drag `tomatator.app` to the applications folder

## Requirement
- MacOS 13.0 or later (statistics feature requires MacOS 13.0+)
- Older versions support MacOS 12.0, but do not include statistics

## Privacy
The App does not collect any user's personal information, nor does it use personal information for third-party services, and the App is not connected to the Internet.

## Acknowledgments
Thanks to developers for their contributions
-  [wersling](https://github.com/wersling)
-  [ivoronin](https://github.com/ivoronin)

## Licence
 - Timer sound from buddhabeats
 - menu bar icon: [美味的食物](https://www.iconfont.cn/collections/detail?spm=a313x.user_detail.i1.dc64b3430.38913a81T5pE7r&cid=2134)[Banada](https://www.iconfont.cn/user/detail?spm=a313x.user_detail.i1.dcc7d6115.2d753a81ofaC89&userViewType=collections&uid=32838&nid=Gk16MkNV0bM0)

## Authorization
Please do not use this repository source code for any commercial purposes, this app is never charged, always updated! For details please see [LICENSE](https://creativecommons.org/licenses/by-nc/4.0/)

## Development

### Release

The project includes two release scripts that simplify the process of building and publishing the application：

1. `release.sh` - build, sign, and package applications
   ```bash
   # use MARKETING_VERSION from Xcode project
   ./release.sh
   
   # appoint version
   ./release.sh 1.0.1
   ```
   The script will generate the following files in the `./build` directory：
   - Tomator.app - application
   - Tomator.dmg - dmg
   - Tomator.zip - zip
   
   The version number is obtained from the `MARKETING_VERSION` attribute in the Xcode project file, rather than Info.plist. If no version number is specified, the script automatically retrieves the current version from the project.pbxproj file.
   
   The script automatically increments `CURRENT_PROJECT_VERSION` 'in the project.pbxproj file by 1 to identify the build versions

2. `github-release.sh` - create, build and upload to GitHub release
   ```bash
   # use MARKETING_VERSION from Xcode project
   ./github-release.sh
   
   # appoint version
   ./github-release.sh 1.0.1
   ```
   Before running this script, make sure that `release.sh` has been executed and that the GitHub CLI is installed. This script also gets the version number from the project.pbxproj file if no version parameter is specified.

## Integration
### Event log
Tomator records state log in JSON format to `~/Library/Containers/cn.null.tomator/Data/Library/Caches/Tomator.log`. Use this data to analyze your productivity and enrich other data sources.
### Start and stop the timer
Tomator can be controlled using the  `tomator://` URL. o start or stop the timer from the command line, use `open tomator://startStop`.
