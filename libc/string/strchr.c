#include <string.h>

char * strchr(const char * str, char searchedChar) {
    for (char c = *str; c; c=*++str) {
        if (c == searchedChar) {
            return str;
        }
    }

    return NULL;
}
