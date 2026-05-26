#ifndef MYLANG_WINDOW_H
#define MYLANG_WINDOW_H

#include "mylang_def.h"

#ifdef __cplusplus
extern "C" {
#endif

handle  window_create(cstr title, i32 w, i32 h);
void    window_destroy(handle win);
void    window_show(handle win);
void    window_hide(handle win);
void    window_set_title(handle win, cstr title);
i32     window_get_width(handle win);
i32     window_get_height(handle win);
void    window_loop(handle win);
void    window_quit(handle win);
void    window_redraw(handle win);

#ifdef __cplusplus
}
#endif

#endif
