#ifndef MYLANG_LIB_H
#define MYLANG_LIB_H

#include "mylang_def.h"
#include "mylang_io.h"
#include "mylang_window.h"
#include "mylang_graphics.h"

#ifdef __cplusplus
extern "C" {
#endif

void    mylang_init(void);
void    mylang_quit(void);
cstr    mylang_version(void);
cstr    mylang_platform(void);
void    mylang_delay(i32 ms);

#ifdef __cplusplus
}
#endif

#endif
