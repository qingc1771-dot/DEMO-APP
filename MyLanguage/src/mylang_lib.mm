#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#include "mylang_lib.h"
#include <cstdio>
#include <cstring>
#include <cmath>

// ============== 全局数据 ==============
static NSWindow* g_window = nil;
static NSView* g_view = nil;
static NSBitmapImageRep* g_bitmap = nil;
static uint32_t* g_pixels = nil;
static int g_width = 0;
static int g_height = 0;
static uint32_t g_currentColor = RGB_BLACK;
static uint32_t g_currentBgColor = RGB_WHITE;
static bool g_running = true;
static bool g_needsRedraw = true;

// ============== 自定义 View ==============
@interface MyLangView : NSView
@end

@implementation MyLangView

- (void)drawRect:(NSRect)dirtyRect {
    if (g_bitmap) {
        [g_bitmap drawAtPoint:NSZeroPoint];
    }
}

- (BOOL)isFlipped {
    return YES;  // 让坐标原点在左上角
}

@end

// ============== 窗口代理 ==============
@interface MyLangDelegate : NSObject <NSWindowDelegate>
@end

@implementation MyLangDelegate
- (void)windowWillClose:(NSNotification*)notification {
    g_running = false;
}
@end

// ============== 绘图函数（像素操作）==============
static void updatePixel(int x, int y, uint32_t color) {
    if (x >= 0 && x < g_width && y >= 0 && y < g_height && g_pixels) {
        g_pixels[y * g_width + x] = color;
    }
}

static void redrawWindow() {
    if (g_needsRedraw && g_bitmap && g_view) {
        [g_bitmap release];
        g_bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                            pixelsWide:g_width
                                                            pixelsHigh:g_height
                                                         bitsPerSample:8
                                                       samplesPerPixel:4
                                                              hasAlpha:YES
                                                              isPlanar:NO
                                                        colorSpaceName:NSDeviceRGBColorSpace
                                                          bitmapFormat:0
                                                           bytesPerRow:g_width * 4
                                                          bitsPerPixel:32];
        g_pixels = (uint32_t*)[g_bitmap bitmapData];
        
        // 先填充背景色
        for (int i = 0; i < g_width * g_height; i++) {
            g_pixels[i] = g_currentBgColor;
        }
        
        g_needsRedraw = false;
    }
    [g_view setNeedsDisplay:YES];
}

// ============== 库初始化 ==============
void mylang_init(void) {
    [NSApplication sharedApplication];
}

void mylang_quit(void) {
    if (g_window) {
        [g_window close];
        g_window = nil;
    }
    g_view = nil;
    g_bitmap = nil;
    g_pixels = nil;
    g_running = false;
}

cstr mylang_version(void) {
    return "MyLanguage v1.0 (Mac Cocoa)";
}

cstr mylang_platform(void) {
    return "macOS (Native Cocoa)";
}

void mylang_delay(i32 ms) {
    usleep(ms * 1000);
}

// ============== IO 实现 ==============
handle file_open(cstr path, cstr mode) {
    FILE* f = fopen(path, mode);
    return (handle)f;
}

i32 file_read(handle f, void* buf, u32 len) {
    if (!f) return -1;
    return (i32)fread(buf, 1, len, (FILE*)f);
}

void file_write(handle f, const void* buf, u32 len) {
    if (!f) return;
    fwrite(buf, 1, len, (FILE*)f);
}

void file_close(handle f) {
    if (f) fclose((FILE*)f);
}

void print(cstr text) {
    if (text) printf("%s", text);
}

void println(cstr text) {
    if (text) printf("%s\n", text);
    else printf("\n");
}

void print_int(i32 num) {
    printf("%d", num);
}

void print_float(f32 num) {
    printf("%f", num);
}

// ============== 窗口实现 ==============
handle window_create(cstr title, i32 w, i32 h) {
    g_width = w;
    g_height = h;
    g_needsRedraw = true;
    
    NSRect frame = NSMakeRect(0, 0, w, h);
    
    g_window = [[NSWindow alloc] initWithContentRect:frame
                                           styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable
                                             backing:NSBackingStoreBuffered
                                               defer:NO];
    [g_window setTitle:[NSString stringWithUTF8String:title]];
    [g_window setBackgroundColor:[NSColor whiteColor]];
    
    MyLangView* view = [[MyLangView alloc] initWithFrame:frame];
    g_view = view;
    [g_window setContentView:view];
    
    MyLangDelegate* delegate = [[MyLangDelegate alloc] init];
    [g_window setDelegate:delegate];
    
    redrawWindow();
    
    return (handle)g_window;
}

void window_destroy(handle win) {
    mylang_quit();
}

void window_show(handle win) {
    if (g_window) {
        [g_window makeKeyAndOrderFront:nil];
    }
}

void window_hide(handle win) {
    if (g_window) {
        [g_window orderOut:nil];
    }
}

void window_set_title(handle win, cstr title) {
    if (g_window) {
        [g_window setTitle:[NSString stringWithUTF8String:title]];
    }
}

i32 window_get_width(handle win) {
    return g_width;
}

i32 window_get_height(handle win) {
    return g_height;
}

void window_redraw(handle win) {
    redrawWindow();
}

void window_loop(handle win) {
    while (g_running) {
        @autoreleasepool {
            NSEvent* event = [NSApp nextEventMatchingMask:NSEventMaskAny
                                                untilDate:[NSDate distantPast]
                                                   inMode:NSDefaultRunLoopMode
                                                  dequeue:YES];
            if (event) {
                [NSApp sendEvent:event];
            } else {
                usleep(10000);
            }
        }
    }
}

void window_quit(handle win) {
    g_running = false;
}

// ============== 绘图实现 ==============
void set_color(handle win, i32 color) {
    g_currentColor = (uint32_t)color;
}

void set_bg_color(handle win, i32 color) {
    g_currentBgColor = (uint32_t)color;
    g_needsRedraw = true;
}

i32 get_color(handle win) {
    return (i32)g_currentColor;
}

void draw_pixel(handle win, i32 x, i32 y) {
    updatePixel(x, y, g_currentColor);
    redrawWindow();
}

void draw_line(handle win, i32 x1, i32 y1, i32 x2, i32 y2) {
    int dx = abs(x2 - x1);
    int dy = abs(y2 - y1);
    int sx = (x1 < x2) ? 1 : -1;
    int sy = (y1 < y2) ? 1 : -1;
    int err = dx - dy;
    
    while (true) {
        updatePixel(x1, y1, g_currentColor);
        if (x1 == x2 && y1 == y2) break;
        int e2 = 2 * err;
        if (e2 > -dy) { err -= dy; x1 += sx; }
        if (e2 < dx) { err += dx; y1 += sy; }
    }
    redrawWindow();
}

void draw_rect(handle win, i32 x, i32 y, i32 w, i32 h) {
    draw_line(win, x, y, x + w, y);
    draw_line(win, x + w, y, x + w, y + h);
    draw_line(win, x + w, y + h, x, y + h);
    draw_line(win, x, y + h, x, y);
}

void draw_fill_rect(handle win, i32 x, i32 y, i32 w, i32 h) {
    for (int i = 0; i < h; i++) {
        draw_line(win, x, y + i, x + w, y + i);
    }
}

void draw_circle(handle win, i32 cx, i32 cy, i32 r) {
    int x = r - 1;
    int y = 0;
    int dx = 1;
    int dy = 1;
    int err = dx - (r << 1);
    
    while (x >= y) {
        updatePixel(cx + x, cy + y, g_currentColor);
        updatePixel(cx + y, cy + x, g_currentColor);
        updatePixel(cx - y, cy + x, g_currentColor);
        updatePixel(cx - x, cy + y, g_currentColor);
        updatePixel(cx - x, cy - y, g_currentColor);
        updatePixel(cx - y, cy - x, g_currentColor);
        updatePixel(cx + y, cy - x, g_currentColor);
        updatePixel(cx + x, cy - y, g_currentColor);
        
        if (err <= 0) {
            y++;
            err += dy;
            dy += 2;
        }
        if (err > 0) {
            x--;
            dx += 2;
            err += dx - (r << 1);
        }
    }
    redrawWindow();
}

void draw_fill_circle(handle win, i32 cx, i32 cy, i32 r) {
    for (int y = -r; y <= r; y++) {
        int x = (int)sqrt(r * r - y * y);
        draw_line(win, cx - x, cy + y, cx + x, cy + y);
    }
}

void draw_text(handle win, i32 x, i32 y, cstr text) {
    // Mac 原生文字渲染（简化版）
    if (g_window && g_view && text) {
        NSString* str = [NSString stringWithUTF8String:text];
        NSDictionary* attrs = @{
            NSFontAttributeName: [NSFont systemFontOfSize:14],
            NSForegroundColorAttributeName: [NSColor colorWithCalibratedRed:((g_currentColor >> 16) & 0xFF)/255.0
                                                                       green:((g_currentColor >> 8) & 0xFF)/255.0
                                                                        blue:(g_currentColor & 0xFF)/255.0
                                                                       alpha:1.0]
        };
        [str drawAtPoint:NSMakePoint(x, y) withAttributes:attrs];
        redrawWindow();
    }
}

void clear_screen(handle win) {
    g_needsRedraw = true;
    redrawWindow();
}
