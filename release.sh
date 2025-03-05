#!/bin/bash

# TomatoBar应用发布脚本
# 用法: ./release.sh [版本号]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 项目配置
APP_NAME="TomatoBar"
PROJECT_NAME="TomatoBar.xcodeproj"
SCHEME_NAME="TomatoBar"
BUILD_DIR="./build"
ARCHIVE_PATH="$BUILD_DIR/$APP_NAME.xcarchive"
EXPORT_DIR="$BUILD_DIR/Export"
DMG_NAME="$APP_NAME.dmg"
ZIP_NAME="$APP_NAME.zip"

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

# 检查是否有版本号参数
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}警告: 未提供版本号，将使用Xcode项目中的MARKETING_VERSION${NC}"
    VERSION=$(get_marketing_version)
    echo -e "${BLUE}从项目文件获取的版本号: $VERSION${NC}"
else
    VERSION=$1
    echo -e "${BLUE}使用提供的版本号: $VERSION${NC}"
    # 如果手动指定了版本号，暂时不更新项目文件中的版本号
    # 需要在Xcode中手动更新MARKETING_VERSION
    echo -e "${YELLOW}注意: 请在Xcode中更新项目的MARKETING_VERSION以保持一致性${NC}"
fi

# 创建构建目录
mkdir -p "$BUILD_DIR"
mkdir -p "$EXPORT_DIR"

echo -e "${BLUE}=== 开始构建和发布 $APP_NAME $VERSION ===${NC}"

# 清理构建目录
echo -e "${BLUE}清理旧构建...${NC}"
xcodebuild clean -project "$PROJECT_NAME" -scheme "$SCHEME_NAME" || { echo -e "${RED}清理失败!${NC}"; exit 1; }

# 构建归档
echo -e "${BLUE}构建和归档应用...${NC}"
xcodebuild archive -project "$PROJECT_NAME" -scheme "$SCHEME_NAME" -archivePath "$ARCHIVE_PATH" || { echo -e "${RED}归档失败!${NC}"; exit 1; }

# 导出应用
echo -e "${BLUE}导出应用...${NC}"
xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH" -exportOptionsPlist "export_options.plist" -exportPath "$EXPORT_DIR" || { echo -e "${RED}导出失败!${NC}"; exit 1; }

APP_PATH="$EXPORT_DIR/$APP_NAME.app"

# 创建DMG包
echo -e "${BLUE}创建DMG包...${NC}"
hdiutil create -volname "$APP_NAME" -srcfolder "$APP_PATH" -ov -format UDZO "$BUILD_DIR/$DMG_NAME" || { echo -e "${RED}创建DMG失败!${NC}"; exit 1; }

# 创建ZIP包
echo -e "${BLUE}创建ZIP包...${NC}"
cd "$EXPORT_DIR" || { echo -e "${RED}无法进入导出目录!${NC}"; exit 1; }
zip -r "../$ZIP_NAME" "$APP_NAME.app" || { echo -e "${RED}创建ZIP失败!${NC}"; exit 1; }
cd - || { echo -e "${RED}无法返回原始目录!${NC}"; exit 1; }

# 计算文件签名
DMG_CHECKSUM=$(shasum -a 256 "$BUILD_DIR/$DMG_NAME" | awk '{print $1}')
ZIP_CHECKSUM=$(shasum -a 256 "$BUILD_DIR/$ZIP_NAME" | awk '{print $1}')

echo -e "${GREEN}=== 构建完成! ===${NC}"
echo -e "${GREEN}应用版本: $VERSION${NC}"
echo -e "${GREEN}DMG包: $BUILD_DIR/$DMG_NAME${NC}"
echo -e "${GREEN}DMG签名: $DMG_CHECKSUM${NC}"
echo -e "${GREEN}ZIP包: $BUILD_DIR/$ZIP_NAME${NC}"
echo -e "${GREEN}ZIP签名: $ZIP_CHECKSUM${NC}"

# 可选: 公证应用
# 取消注释以下部分来启用公证
# echo -e "${BLUE}公证应用...${NC}"
# xcrun notarytool submit "$BUILD_DIR/$ZIP_NAME" --keychain-profile "AC_PASSWORD" --wait

echo -e "${YELLOW}您可能还需要执行以下操作:${NC}"
echo -e "${YELLOW}1. 提交代码并创建一个新的Git标签:${NC}"
echo -e "   git tag -a v$VERSION -m \"$APP_NAME $VERSION\""
echo -e "   git push origin v$VERSION"
echo -e "${YELLOW}2. 在GitHub上创建一个新版本并上传构建成果${NC}"
echo -e "${YELLOW}3. 更新应用的下载页面和发布说明${NC}" 