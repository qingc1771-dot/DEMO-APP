#!/bin/bash

echo "========================================="
echo "   MyLanguage - Mac 原生版"
echo "========================================="

echo "🔨 编译中..."

clang++ -std=c++17 \
    -framework Cocoa \
    -framework QuartzCore \
    src/mylang_lib.mm \
    src/main.cpp \
    -o mylang \
    -I./include

if [ $? -eq 0 ]; then
    echo "✅ 编译成功!"
    echo ""
    echo "运行: ./mylang"
    echo ""
    ./mylang
else
    echo "❌ 编译失败"
fi
