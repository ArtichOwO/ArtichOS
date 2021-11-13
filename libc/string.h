/*
 * https://wiki.osdev.org/Meaty_Skeleton#libc_and_libk
 */

#ifndef LIBC_STRING_H
#define LIBC_STRING_H

#include <stddef.h>

int memcmp(const void *, const void *, size_t);
void * memcpy(void *, const void *, size_t);
void * memmove(void *, const void *, size_t);
void * memset(void *, int, size_t);
size_t strlen(const char *);
char * strrev(char *);
char * strchr(const char *, char);

#endif // LIBC_STRING_H
