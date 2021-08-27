#include "mem.h"

namespace std {
    void memcpy(char * source, char * dest, int nbytes) {
        for (int i = 0; i < nbytes; i++) {
            *(dest + i) = *(source + i);
        }
    }

    void memset(unsigned char * dest, unsigned char val, unsigned long len) {
        unsigned char * temp = dest;
        for ( ; len != 0; len--) *temp++ = val;
    }
}
