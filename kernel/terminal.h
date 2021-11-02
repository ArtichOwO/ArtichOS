#ifndef KERNEL_TERMINAL_H
#define KERNEL_TERMINAL_H

#include <stdint.h>

#define MAX_COLS 80
#define MAX_ROWS 25

/* Screen i/o ports */
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

enum video_type {
    VIDEO_TYPE_NONE = 0x00,
    VIDEO_TYPE_COLOUR = 0x20,
    VIDEO_TYPE_MONOCHROME = 0x30,
};

enum video_type get_bios_area_video_type();
uint8_t * get_video_address(enum video_type videoType);
void kprint(char * str, uint8_t attr);
void print_char(char c, uint8_t attr, int row, int col);
int get_cursor_offset();
void set_cursor_offset(int offset);

#endif // KERNEL_TERMINAL_H
