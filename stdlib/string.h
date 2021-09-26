#ifndef STD_STRING_H
#define STD_STRING_H

void itoa(int n, char str[]);
void itox(unsigned int i, char * str);
void reverse(char s[]);
int strlen(char s[]);
void backspace(char s[]);
void append(char s[], char n);
int strcmp(char s1[], char s2[]);
void memcpy(char * source, char * dest, int nbytes);
void memset(unsigned char * dest, unsigned char val, unsigned long len);

#endif // STD_STRING_H
