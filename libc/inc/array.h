/// @file array.h
/// @brief
/// @copyright (c) 2014-2021 This file is distributed under the MIT License.
/// See LICENSE.md for details.

#pragma once

#ifdef __KERNEL__
#define DECLARE_ARRAY(type, name)                                                 \
    typedef struct arr_##name##_t {                                               \
        const unsigned size;                                                      \
        type *buffer;                                                             \
    } arr_##name##_t;                                                             \
    arr_##name##_t alloc_arr_##name(unsigned len)                                 \
    {                                                                             \
        arr_##name##_t a = { len, len > 0 ? kmalloc(sizeof(type) * len) : NULL }; \
        memset(a.buffer, 0, sizeof(type) * len);                                  \
        return a;                                                                 \
    }                                                                             \
    static inline void free_arr_##name(arr_##name##_t *arr)                       \
    {                                                                             \
        kfree(arr->buffer);                                                       \
    }
#else
#define DECLARE_ARRAY(type, name)                                                \
    typedef struct arr_##name##_t {                                              \
        const unsigned size;                                                     \
        type *buffer;                                                            \
    } arr_##name##_t;                                                            \
    arr_##name##_t alloc_arr_##name(unsigned len)                                \
    {                                                                            \
        arr_##name##_t a = { len, len > 0 ? malloc(sizeof(type) * len) : NULL }; \
        memset(a.buffer, 0, sizeof(type) * len);                                 \
        return a;                                                                \
    }                                                                            \
    static inline void free_arr_##name(arr_##name##_t *arr)                      \
    {                                                                            \
        free(arr->buffer);                                                       \
    }
#endif