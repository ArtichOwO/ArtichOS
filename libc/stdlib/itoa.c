/*
 * https://www.geeksforgeeks.org/implement-itoa/
 */

#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

char * itoa(int n, char * buffer, int radix) {
    int i = 0;
    bool isNegative = false;

    if (n == 0) {
        buffer = "0";
        return buffer;
    }

    if (n < 0 && radix == 10) {
        isNegative = true;
        n = -n;
    }

    while (n != 0) {
        int rem = n % radix;
        buffer[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0';
        n = n / radix;
    }

    if (isNegative)
        buffer[i++] = '-';

    return strrev(buffer);
}
