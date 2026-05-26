#ifndef MYLANG_IO_H
#define MYLANG_IO_H

#include "mylang_def.h"

#ifdef __cplusplus
extern "C" {
#endif

handle  file_open(cstr path, cstr mode);
i32     file_read(handle f, void* buf, u32 len);
void    file_write(handle f, const void* buf, u32 len);
void    file_close(handle f);
void    print(cstr text);
void    println(cstr text);
void    print_int(i32 num);
void    print_float(f32 num);

#ifdef __cplusplus
}
#endif

#endif
