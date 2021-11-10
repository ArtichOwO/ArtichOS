#include "terminal.h"
#include "kernel.h"
#include "port.h"
#include "serial.h"
#include <string.h>

enum video_type get_bios_area_video_type() {
    return (enum video_type) (detect_bios_area_hardware() & 0x30);
}

uint8_t * get_video_address(enum video_type videoType) {
    if (videoType != VIDEO_TYPE_NONE) {
        if (videoType == VIDEO_TYPE_COLOUR) {
            return (uint8_t *)0xB8000;
        } else {
            return (uint8_t *)0xB0000;
        }
    } else {
        return 0;
    }
}

int get_offset(int col, int row) { return 2 * (row * MAX_COLS + col); }
int get_offset_row(int offset) { return offset / (2 * MAX_COLS); }
int get_offset_col(int offset) { return (offset - (get_offset_row(offset)*2*MAX_COLS))/2; }

void kprint(char * str, uint8_t attr) {
    kprint_at(str, attr, -1, -1);
}

void kprint_at(char * str, uint8_t attr, int row, int col) {
    if (row >= 0 && col >= 0)
        set_cursor_offset(get_offset(col, row));

    for (char c = *str; c; c=*++str) {
        print_char(c, attr, -1, -1);
        if (c == '\n') {
            write_serial('\r');
        }
        write_serial(c);
    }
}

void print_char(char c, uint8_t attr, int row, int col) {
    uint8_t * video_memory_addr = get_video_address(get_bios_area_video_type());

    /* Error control: print a red 'E' if the coords aren't right */
    if (col >= MAX_COLS || row >= MAX_ROWS) {
        video_memory_addr[2*(MAX_COLS)*(MAX_ROWS)-2] = 'E';
        video_memory_addr[2*(MAX_COLS)*(MAX_ROWS)-1] = 0xf4;
    }

    int offset;
    if (col >= 0 && row >= 0) offset = get_offset(col, row);
    else offset = get_cursor_offset();

    if (c == '\n') {
        row = get_offset_row(offset);
        offset = get_offset(0, row+1);
    } else if (c == 0x08) {
        offset -= 2;
        video_memory_addr[offset] = ' ';
        video_memory_addr[offset+1] = attr;
    } else {
        video_memory_addr[offset] = c;
        video_memory_addr[offset+1] = attr;
        offset += 2;
    }

    if (offset >= MAX_ROWS * MAX_COLS * 2) {
        memmove(video_memory_addr - 2*MAX_COLS,
                video_memory_addr, MAX_COLS*MAX_ROWS*2);

        memset(get_offset(0, MAX_ROWS-1) + video_memory_addr,
               0, MAX_COLS*2);

        offset -= 2 * MAX_COLS;
    }

    set_cursor_offset(offset);
}

void clear_terminal(char c, uint8_t attr) {
    uint8_t * video_memory_addr = get_video_address(get_bios_area_video_type());
    int offset = 0;
    for (unsigned int i = 0; i < MAX_COLS*MAX_ROWS*2; ++i) {
        video_memory_addr[offset] = c;
        video_memory_addr[offset+1] = attr;
        offset += 2;
    }
    set_cursor_offset(0);
}

int get_cursor_offset() {
    /* Use the VGA ports to get the current cursor position
     * 1. Ask for high byte of the cursor offset (data 14)
     * 2. Ask for low byte (data 15)
     */
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8; /* High byte: << 8 */
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    return offset * 2; /* Position * size of character cell */
}

void set_cursor_offset(int offset) {
    /* Similar to get_cursor_offset, but instead of reading we write data */
    offset /= 2;
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (offset & 0xff));
}

void set_cursor_shape(uint16_t cursor_shape) {
    port_byte_out(REG_SCREEN_CTRL, 0x0A);
    port_byte_out(REG_SCREEN_DATA, (cursor_shape >> 8));
    port_byte_out(REG_SCREEN_CTRL, 0x0B);
    port_byte_out(REG_SCREEN_DATA, (cursor_shape & 0xff));
}
