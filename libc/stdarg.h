/*
 * https://stackoverflow.com/questions/32291808/how-to-implement-stdarg-in-c
 */

#ifndef LIBC_STDARG_H
#define LIBC_STDARG_H

typedef char * va_list;
#define va_start(ap, parmn) (void)((ap) = (char *)(&(parmn) + 1))
#define va_end(ap) (void)((ap) = 0)
#define va_arg(ap, type) \
    (((type *)((ap) = ((ap) + sizeof(type))))[-1])

#endif // LIBC_STDARG_H
