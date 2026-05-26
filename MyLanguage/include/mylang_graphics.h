#ifndef MYLANG_GRAPHICS_H
#define MYLANG_GRAPHICS_H

#include "mylang_def.h"
#include "mylang_window.h"

#ifdef __cplusplus
extern "C" {
#endif

void    set_color(handle win, i32 color);
void    set_bg_color(handle win, i32 color);
i32     get_color(handle win);
void    draw_pixel(handle win, i32 x, i32 y);
void    draw_line(handle win, i32 x1, i32 y1, i32 x2, i32 y2);
void    draw_rect(handle win, i32 x, i32 y, i32 w, i32 h);
void    draw_fill_rect(handle win, i32 x, i32 y, i32 w, i32 h);
void    draw_circle(handle win, i32 cx, i32 cy, i32 r);
void    draw_fill_circle(handle win, i32 cx, i32 cy, i32 r);
void    draw_text(handle win, i32 x, i32 y, cstr text);
void    clear_screen(handle win);

#ifdef __cplusplus
}
#endif

#endif
