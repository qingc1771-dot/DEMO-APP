# MyLanguage - 轻量级 C 语言图形库 for macOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS-blue.svg)]()

MyLanguage 是一个简单易用的 C 语言图形库，基于 macOS Cocoa 原生框架，适合学习图形编程、快速原型开发。

## ✨ 特性

- 🖥️ 原生 Cocoa 窗口，无依赖
- 🎨 基础绘图：点、线、矩形、圆、文字
- 📁 文件 IO 与控制台输出
- 🎯 简单 API，易于上手
- ⚡ 像素级绘图控制

## 🚀 快速开始

```c
#include "mylang_lib.h"

int main() {
    mylang_init();
    
    handle win = window_create("Hello", 640, 480);
    set_bg_color(win, RGB_WHITE);
    clear_screen(win);
    
    set_color(win, RGB_RED);
    draw_text(win, 100, 100, "Hello MyLanguage!");
    
    window_show(win);
    window_loop(win);
    mylang_quit();
    
    return 0;
}

🔨 编译运行
bash
cd src
clang++ -framework Cocoa -framework QuartzCore \
    main.c mylang_lib.mm -o mylang
./mylang
📚 文档
	•	API 参考手册
	•	快速入门指南
	•	示例代码
📦 函数速查


类别
主要函数
窗口
window_create, window_show, window_loop
绘图
draw_line, draw_rect, draw_circle, draw_text
颜色
set_color, set_bg_color, RGB()
输出
print, println, print_int
文件
file_open, file_read, file_write
⚠️ 注意事项
	•	仅支持 macOS（Cocoa 框架）
	•	仅支持单窗口
	•	坐标原点在左上角
