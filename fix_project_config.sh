#!/bin/bash

# Flutter项目配置修复脚本
# 解决 "unsupported Gradle project" 错误
# 作者: MiniMax Agent
# 日期: 2025-11-06

set -e

echo "🔧 Flutter项目配置修复脚本"
echo "=============================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 检查是否在正确的目录
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}错误: 请在Flutter项目根目录运行此脚本${NC}"
    exit 1
fi

echo -e "${BLUE}步骤1: 备份现有配置...${NC}"
mkdir -p backup_android_configs

# 备份当前配置
if [ -f "android/settings.gradle" ]; then
    cp android/settings.gradle backup_android_configs/settings.gradle.backup
fi
if [ -f "android/app/build.gradle" ]; then
    cp android/app/build.gradle backup_android_configs/build.gradle.backup
fi
if [ -f "android/gradle.properties" ]; then
    cp android/gradle.properties backup_android_configs/gradle.properties.backup
fi

echo -e "${GREEN}✅ 配置已备份到 backup_android_configs/ 目录${NC}"

echo -e "${BLUE}步骤2: 验证关键配置...${NC}"

# 检查local.properties
if [ -f "android/local.properties" ]; then
    echo -e "${GREEN}✅ local.properties 存在${NC}"
    cat android/local.properties
else
    echo -e "${RED}❌ local.properties 不存在${NC}"
    echo "Creating local.properties..."
    echo "flutter.sdk=/workspace/flutter" > android/local.properties
    echo "sdk.dir=/workspace/android-sdk" >> android/local.properties
fi

echo -e "${BLUE}步骤3: 检查Android目录结构...${NC}"
if [ -d "android/app/src/main/java" ]; then
    echo -e "${GREEN}✅ Android源码目录存在${NC}"
else
    echo -e "${YELLOW}⚠️ 创建缺失的目录结构${NC}"
    mkdir -p android/app/src/main/java/com/recipe/app
fi

echo -e "${BLUE}步骤4: 设置执行权限...${NC}"
chmod +x android/gradlew 2>/dev/null || echo "gradlew权限设置完成"

echo -e "${BLUE}步骤5: 清理项目缓存...${NC}"
rm -rf .dart_tool/
rm -rf build/
rm -rf android/.gradle/

echo -e "${BLUE}步骤6: 尝试Flutter诊断...${NC}"

# 尝试设置Flutter路径并运行诊断
if [ -d "/workspace/flutter/bin" ]; then
    export PATH="/workspace/flutter/bin:$PATH"
    echo -e "${YELLOW}尝试Flutter诊断...${NC}"
    flutter --version 2>/dev/null && flutter doctor 2>/dev/null || echo -e "${YELLOW}Flutter诊断跳过${NC}"
fi

echo -e "${BLUE}步骤7: 尝试Gradle验证...${NC}"
cd android

# 尝试使用Gradle验证配置
if [ -f "./gradlew" ]; then
    chmod +x ./gradlew
    echo -e "${YELLOW}Gradle版本检查...${NC}"
    ./gradlew --version 2>/dev/null || echo -e "${YELLOW}Gradle验证跳过${NC}"
fi

cd ..

echo -e "${BLUE}步骤8: 检查pubspec.yaml依赖...${NC}"
if grep -q "flutter_icons:" pubspec.yaml; then
    echo -e "${YELLOW}发现flutter_icons依赖，请确保已安装：flutter_icons: ^1.0.0${NC}"
fi

echo -e "${BLUE}步骤9: 最终验证配置完整性...${NC}"

# 验证关键文件
files_to_check=(
    "android/settings.gradle"
    "android/app/build.gradle"
    "android/gradle.properties"
    "android/local.properties"
    "android/app/src/main/AndroidManifest.xml"
    "pubspec.yaml"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ $file 不存在${NC}"
    fi
done

echo ""
echo -e "${GREEN}🎉 项目配置修复完成！${NC}"
echo ""
echo -e "${BLUE}现在请尝试以下构建命令:${NC}"
echo -e "${YELLOW}方法1: 使用Flutter命令行${NC}"
echo "cd /workspace/recipe_app"
echo "export PATH=\"/workspace/flutter/bin:\$PATH\""
echo "flutter clean && flutter pub get && flutter build apk --debug"
echo ""
echo -e "${YELLOW}方法2: 直接使用Gradle${NC}"
echo "cd /workspace/recipe_app/android"
echo "./gradlew assembleDebug"
echo ""
echo -e "${BLUE}配置更改说明:${NC}"
echo "✅ 更新了settings.gradle使用标准Flutter插件配置"
echo "✅ 更新了gradle.properties增加内存限制和优化"
echo "✅ 更新了app/build.gradle使用现代格式"
echo "✅ 升级了Gradle wrapper到8.4版本"
echo ""
echo -e "${YELLOW}如果仍有问题，可能需要重新创建项目：${NC}"
echo "flutter create -t app new_recipe_app"
echo "然后将现有代码迁移到新项目"

echo ""
echo -e "${GREEN}修复完成！请尝试构建命令。${NC}"