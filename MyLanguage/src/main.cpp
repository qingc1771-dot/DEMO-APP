#include "mylang_lib.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    (void)argc;
    (void)argv;
    
    printf("========================================\n");
    printf("   MyLanguage %s\n", mylang_version());
    printf("   平台: %s\n", mylang_platform());
    printf("========================================\n\n");
    
    mylang_init();
    
    handle win = window_create("MyLanguage 窗口", 800, 600);
    
    if (!win) {
        println("窗口创建失败！");
        return 1;
    }
    
    println("窗口创建成功！");
    
    set_bg_color(win, RGB_WHITE);
    clear_screen(win);
    
    set_color(win, RGB_RED);
    draw_line(win, 50, 50, 300, 200);
    
    set_color(win, RGB_BLUE);
    draw_rect(win, 100, 100, 200, 150);
    
    set_color(win, RGB_GREEN);
    draw_fill_rect(win, 350, 100, 150, 100);
    
    set_color(win, RGB_YELLOW);
    draw_circle(win, 550, 300, 80);
    
    set_color(win, RGB_BLACK);
    draw_text(win, 200, 500, "Hello from MyLanguage!");
    
    window_redraw(win);
    window_show(win);
    
    println("窗口已显示，关闭窗口退出...");
    
    window_loop(win);
    
    mylang_quit();
    println("程序结束");
    
    return 0;
}
