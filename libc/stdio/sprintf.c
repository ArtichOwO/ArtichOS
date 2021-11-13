/*
 * https://koor.fr/C/cstdarg/va_arg.wp
 */

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

int sprintf(char * buffer, const char * format, ...) {
    va_list parametersInfos;
    va_start(parametersInfos, format);

    char currentChar;
    int currentIndex = 0;
    char tempBuffer[32] = {0};

    while((currentChar = *format) != '\0') {
        format++;
        if (currentChar != '%') {
            buffer[currentIndex++] = currentChar;
            continue;
        }

        switch(*format++) {
            case 'd':
            {
                char * integerValue = itoa((int) va_arg(parametersInfos, int), tempBuffer, 10);
                for (char c = *integerValue; c; c=*++integerValue) {
                    buffer[currentIndex++] = c;
                }
            }
                break;
            case 'x':
            {
                char * integerValue = itoa((int) va_arg(parametersInfos, int), tempBuffer, 16);
                for (char c = *integerValue; c; c=*++integerValue) {
                    buffer[currentIndex++] = c;
                }
            }
                break;
            case 'b':
            {
                char * integerValue = itoa((int) va_arg(parametersInfos, int), tempBuffer, 2);
                for (char c = *integerValue; c; c=*++integerValue) {
                    buffer[currentIndex++] = c;
                }
            }
                break;
            case 's':
            {
                const char * string = (const char *) va_arg( parametersInfos, const char * );
                for (char c = *string; c; c=*++string) {
                    buffer[currentIndex++] = c;
                }
            }
                break;
            default:
                (void)va_arg(parametersInfos, const char *);
                buffer[currentIndex++] = '\x13';
        }
    }

    buffer[currentIndex++] = '\0';

    va_end(parametersInfos);
    return strlen(buffer);
}
