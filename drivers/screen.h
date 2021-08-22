#ifndef DRIVERS_SCREEN_H
#define DRIVERS_SCREEN_H

#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

/* Screen i/o ports */
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

char * detectvideotype();
void kprint(char * str, char attr = WHITE_ON_BLACK);
int print_char(char c, int col = -1, int row = -1, char attr = WHITE_ON_BLACK);
int get_cursor_offset();
void set_cursor_offset(int offset);
void clear_screen();

int get_offset(int col, int row);
int get_offset_row(int offset);
int get_offset_col(int offset);

#endif // DRIVERS_SCREEN_H
