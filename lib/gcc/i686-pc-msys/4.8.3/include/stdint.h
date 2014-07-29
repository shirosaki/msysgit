#ifndef _GCC_WRAP_STDINT_H
#if __STDC_HOSTED__
# if defined __cplusplus && __cplusplus >= 201103L
#  undef __STDC_LIMIT_MACROS
#  define __STDC_LIMIT_MACROS
#  undef __STDC_CONSTANT_MACROS
#  define __STDC_CONSTANT_MACROS
# endif
# include <sys/types.h>
# ifndef uint8_t
   typedef unsigned char uint8_t;
#  define _UINT8_T
# endif
# ifndef uint16_t
   typedef unsigned short uint16_t;
#  define _UINT16_T
# endif
# ifndef uint32_t
   typedef unsigned int uint32_t;
#  define _UINT32_T
# endif
# ifndef uint64_t
   typedef unsigned long long uint64_t;
#  define _UINT64_T
#  define UINT64_C
# endif
# ifndef uintptr_t
   typedef uint32_t uintptr_t;
#  define __uintptr_t_defined
# endif
# ifndef intptr_t
   typedef int32_t intptr_t;
#  define __intptr_t_defined
# endif

  /* Define int_least types */
# ifndef int_least8_t
  typedef char       int_least8_t;
# endif
# ifndef int_least16_t
  typedef short      int_least16_t;
# endif
# ifndef int_least32_t
  typedef int        int_least32_t;
# endif
# ifndef int_least64_t
  typedef long long  int_least64_t;
# endif

# ifndef uint_least8_t
  typedef unsigned char        uint_least8_t;
# endif
# ifndef uint_least16_t
  typedef unsigned short       uint_least16_t;
# endif
# ifndef uint_least32_t
  typedef unsigned int         uint_least32_t;
# endif
# ifndef uint_least64_t
  typedef unsigned long long   uint_least64_t;
# endif

  /* Define int_fast types.  short is often slow */
# ifndef int_fast8_t
  typedef char       int_fast8_t;
# endif
# ifndef int_fast16_t
  typedef int        int_fast16_t;
# endif
# ifndef int_fast32_t
  typedef int        int_fast32_t;
# endif
# ifndef int_fast64_t
  typedef long long  int_fast64_t;
# endif

# ifndef uint_fast8_t
  typedef unsigned char        uint_fast8_t;
# endif
# ifndef uint_fast16_t
  typedef unsigned int         uint_fast16_t;
# endif
# ifndef uint_fast32_t
  typedef unsigned int         uint_fast32_t;
# endif
# ifndef uint_fast64_t
  typedef unsigned long long   uint_fast64_t;
# endif

  /* Define intmax. */
# ifndef intmax_t
  typedef int64_t  intmax_t;
# endif
# ifndef uintmax_t
  typedef uint64_t uintmax_t;
# endif
#else
# include "stdint-gcc.h"
#endif
#define _GCC_WRAP_STDINT_H
#endif
