#include "screen.h"
#include "port.h"
#include "../stdlib/stdlib.h"

char * detectvideotype() {
    char * video_memory_addr;

    char temp = (*(volatile unsigned short*)0x410 )&0x30; // Packed bit flags for detected hardware
    if (temp == 0x30 ) { // Check if the read data is 0x30 ,which is for mono card 
        video_memory_addr = (char *) 0xb0000; // mono card
    } else if (temp == 0x00 || 0x20 ) {
        video_memory_addr = (char *) 0xb8000; // colour card
    }

    return video_memory_addr;
}

void kprint(char * str, char attr) {
    for (char c = *str; c; c=*++str) {
        print_char(c, -1, -1, attr);
    }
}

int print_char(char c, int col, int row, char attr) {
    char * video_memory_addr = detectvideotype();

    /* Error control: print a red 'E' if the coords aren't right */
    if (col >= MAX_COLS || row >= MAX_ROWS) {
        video_memory_addr[2*(MAX_COLS)*(MAX_ROWS)-2] = 'E';
        video_memory_addr[2*(MAX_COLS)*(MAX_ROWS)-1] = RED_ON_WHITE;
        return get_offset(col, row);
    }

    int offset;
    if (col >= 0 && row >= 0) offset = get_offset(col, row);
    else offset = get_cursor_offset();

    if (c == '\n') {
        row = get_offset_row(offset);
        offset = get_offset(0, row+1);
    } else if (c == 0x08) { /* Backspace */
        video_memory_addr[offset] = ' ';
        video_memory_addr[offset+1] = attr;
    } else {
        video_memory_addr[offset] = c;
        video_memory_addr[offset+1] = attr;
        offset += 2;
    }

    /* Check if the offset is over screen size and scroll */
    if (offset >= MAX_ROWS * MAX_COLS * 2) {
        for (int i = 1; i < MAX_ROWS; i++) 
            std::memcpy((char *)(get_offset(0, i) + video_memory_addr),
                        (char *)(get_offset(0, i-1) + video_memory_addr),
                        MAX_COLS * 2);

        /* Blank last line */
        char * last_line = (char *) (get_offset(0, MAX_ROWS-1) + (unsigned char *) video_memory_addr);
        for (int i = 0; i < MAX_COLS * 2; i++) last_line[i] = 0;

        offset -= 2 * MAX_COLS;
    }

    set_cursor_offset(offset);
    return offset;
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

void clear_screen() {
    int screen_size = MAX_COLS * MAX_ROWS;
    char * screen = detectvideotype();

    for (int i = 0; i < screen_size; i++) {
        screen[i*2] = ' ';
        screen[i*2+1] = WHITE_ON_BLACK;
    }

    set_cursor_offset(get_offset(0, 0));
}

int get_offset(int col, int row) { return 2 * (row * MAX_COLS + col); }
int get_offset_row(int offset) { return offset / (2 * MAX_COLS); }
int get_offset_col(int offset) { return (offset - (get_offset_row(offset)*2*MAX_COLS))/2; }
