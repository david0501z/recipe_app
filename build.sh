#!/bin/bash

# Flutter菜谱应用构建脚本
# 使用中国镜像源构建Release版本APK
# 作者: MiniMax Agent
# 日期: 2025-11-06

echo "🍳 Flutter菜谱应用 - 构建脚本启动"
echo "=================================="

# 设置中国镜像源环境变量
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 添加Flutter到PATH (请根据实际路径调整)
export PATH="/workspace/flutter/bin:$PATH"

# 切换到项目目录
cd /workspace/recipe_app || {
    echo "❌ 错误: 无法进入项目目录 /workspace/recipe_app"
    exit 1
}

echo "📍 当前目录: $(pwd)"

# 检查Flutter是否可用
echo "🔍 检查Flutter环境..."
flutter --version || {
    echo "❌ 错误: Flutter不可用，请检查安装"
    exit 1
}

echo ""
echo "📦 步骤1: 获取项目依赖..."
flutter pub get || {
    echo "❌ 错误: 依赖获取失败"
    exit 1
}

echo ""
echo "🔍 步骤2: 运行代码分析..."
flutter analyze || {
    echo "❌ 错误: 代码分析发现问题"
    exit 1
}

echo ""
echo "🏗️ 步骤3: 构建Release版本APK..."
flutter build apk --release || {
    echo "❌ 错误: APK构建失败"
    exit 1
}

echo ""
echo "✅ 构建完成！"
echo "=================================="

# 检查APK文件
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    echo "🎉 APK文件已生成: $APK_PATH"
    echo "📊 文件大小: $(du -h "$APK_PATH" | cut -f1)"
    echo "📱 可以安装到Android设备上进行测试"
else
    echo "⚠️ 警告: 未找到预期的APK文件"
fi

echo ""
echo "🏁 构建脚本执行完成！"
echo ""
echo "💡 提示:"
echo "   - 如需构建iOS版本，请运行: flutter build ios --release"
echo "   - 如需调试版本，请运行: flutter build apk --debug"
echo "   - 生成的APK文件位于: build/app/outputs/flutter-apk/"