#!/bin/bash

# TomatoBar GitHub发布辅助脚本
# 用法: ./github-release.sh [版本号]
# 注意: 构建版本号(CURRENT_PROJECT_VERSION)已在 release.sh 中自动递增，此脚本不会再次递增

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 项目配置
PROJECT_NAME="TomatoBar.xcodeproj"

# 从project.pbxproj获取版本号
get_marketing_version() {
    PBXPROJ_PATH="$PROJECT_NAME/project.pbxproj"
    if [ -f "$PBXPROJ_PATH" ]; then
        VERSION=$(grep -m 1 "MARKETING_VERSION =" "$PBXPROJ_PATH" | sed 's/.*MARKETING_VERSION = \(.*\);/\1/')
        echo "$VERSION"
    else
        echo "无法找到项目文件: $PBXPROJ_PATH"
        exit 1
    fi
}

# 检查是否安装了gh CLI
if ! command -v gh &> /dev/null; then
    echo -e "${RED}错误: 未安装GitHub CLI (gh)${NC}"
    echo -e "${YELLOW}请安装GitHub CLI: https://cli.github.com/${NC}"
    exit 1
fi

# 检查是否有版本号参数
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}警告: 未提供版本号，将使用Xcode项目中的MARKETING_VERSION${NC}"
    VERSION=$(get_marketing_version)
    echo -e "${BLUE}从项目文件获取的版本号: $VERSION${NC}"
else
    VERSION=$1
    echo -e "${BLUE}使用提供的版本号: $VERSION${NC}"
fi

# 确认版本号前缀
if [[ $VERSION != v* ]]; then
    VERSION="v$VERSION"
fi

echo -e "${BLUE}=== 准备创建GitHub发布 $VERSION ===${NC}"

BUILD_DIR="./build"
DMG_FILE="$BUILD_DIR/TomatoBar.dmg"
ZIP_FILE="$BUILD_DIR/TomatoBar.zip"

# 检查构建文件是否存在
if [ ! -f "$DMG_FILE" ] || [ ! -f "$ZIP_FILE" ]; then
    echo -e "${RED}错误: 找不到构建文件${NC}"
    echo -e "${YELLOW}请先运行 ./release.sh 脚本${NC}"
    exit 1
fi

# 创建发布说明模板
RELEASE_NOTES_FILE="release_notes.md"
cat > "$RELEASE_NOTES_FILE" << EOF
# TomatoBar $VERSION 发布说明

## 新特性
- 

## 改进
- 

## 修复
- 

## 下载
- [TomatoBar.dmg](https://github.com/wingstone/TomatoBar/releases/download/$VERSION/TomatoBar.dmg)
- [TomatoBar.zip](https://github.com/wingstone/TomatoBar/releases/download/$VERSION/TomatoBar.zip)
EOF

echo -e "${GREEN}创建了发布说明模板: $RELEASE_NOTES_FILE${NC}"
echo -e "${YELLOW}请编辑发布说明，完成后按任意键继续...${NC}"
read -n 1 -s

echo "继续..."
# 检查Git标签
git fetch --tags
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo -e "${YELLOW}标签 $VERSION 已存在${NC}"
else
    echo -e "${BLUE}创建标签 $VERSION${NC}"
    git tag -a "$VERSION" -m "TomatoBar $VERSION"
    git push origin "$VERSION"
    echo -e "${GREEN}标签已推送到远程仓库${NC}"
fi

# 创建GitHub发布
echo -e "${BLUE}创建GitHub发布...${NC}"
gh repo set-default wersling/TomatoBar
gh release create "$VERSION" \
    --title "TomatoBar $VERSION" \
    --notes-file "$RELEASE_NOTES_FILE" \
    "$DMG_FILE" "$ZIP_FILE"

echo -e "${GREEN}=== GitHub发布已完成! ===${NC}"
echo -e "${GREEN}发布地址: https://github.com/wersling/TomatoBar/releases/tag/$VERSION${NC}"

# 清理临时文件
rm "$RELEASE_NOTES_FILE" 