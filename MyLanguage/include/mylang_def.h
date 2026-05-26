#ifndef MYLANG_DEF_H
#define MYLANG_DEF_H

#include <stdint.h>

typedef int8_t      i8;
typedef uint8_t     u8;
typedef int16_t     i16;
typedef uint16_t    u16;
typedef int32_t     i32;
typedef uint32_t    u32;
typedef int64_t     i64;
typedef uint64_t    u64;
typedef float       f32;
typedef double      f64;

typedef void*       handle;
typedef char*       str;
typedef const char* cstr;

#define null         ((void*)0)

// 颜色定义（RGB 格式）
#define RGB(r,g,b)   ((r << 16) | (g << 8) | b)
#define RGB_RED      RGB(255,0,0)
#define RGB_GREEN    RGB(0,255,0)
#define RGB_BLUE     RGB(0,0,255)
#define RGB_BLACK    RGB(0,0,0)
#define RGB_WHITE    RGB(255,255,255)
#define RGB_YELLOW   RGB(255,255,0)

#endif
